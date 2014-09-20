#!/usr/bin/env ruby

require 'twitter_ebooks'
include Ebooks

CONSUMER_KEY = ""
CONSUMER_SECRET = ""
OAUTH_TOKEN = ""
OAUTH_TOKEN_SECRET = ""

ROBOT_ID = 'ebooks' # Avoid infinite reply chains
TWITTER_USERNAME = "example_ebooks" # Ebooks account username
TEXT_MODEL_NAME = "example" # This should be the name of the text model

DELAY = 2..10 # Simulated human reply delay range in seconds
BLACKLIST = ['horse_ebooks'] # Users to avoid interaction with
SPECIAL_WORDS = ['ebooks', 'bot', 'bots', 'clone', 'singularity', 'world domination']

# Track who we've randomly interacted with globally
$have_talked = {}

class GenBot
  def initialize(bot, modelname)
    @bot = bot
    @model = nil

    bot.consumer_key = CONSUMER_KEY
    bot.consumer_secret = CONSUMER_SECRET

    bot.on_startup do
      @model = Model.load("model/#{modelname}.model")
      @top100 = @model.keywords.top(100).map(&:to_s).map(&:downcase)
      @top50 = @model.keywords.top(20).map(&:to_s).map(&:downcase)
    end

    bot.on_message do |dm|
      bot.delay DELAY do
        bot.reply dm, @model.make_response(dm[:text])
      end
    end

    bot.on_follow do |user|
      bot.delay DELAY do
        bot.follow user[:screen_name]
      end
    end

    bot.on_mention do |tweet, meta|
      # Avoid infinite reply chains (very small chance of crosstalk)
        next if tweet[:user][:screen_name].include?(ROBOT_ID) && rand > 0.05
		next if tweet[:user][:name].include?(ROBOT_ID) && rand > 0.05

      tokens = NLP.tokenize(tweet[:text])

      very_interesting = tokens.find_all { |t| @top50.include?(t.downcase) }.length > 2
      special = tokens.find { |t| SPECIAL_WORDS.include?(t) }

      if very_interesting || special
        favorite(tweet)
      end

      reply(tweet, meta)
    end

    bot.on_timeline do |tweet, meta|
      next if tweet[:retweeted_status] || tweet[:text].start_with?('RT')
      next if BLACKLIST.include?(tweet[:user][:screen_name]) ||
        BLACKLIST.include?(tweet[:user][:name])

      tokens = NLP.tokenize(tweet[:text])

      # We calculate unprompted interaction probability by how well a
      # tweet matches our keywords
      interesting = tokens.find { |t| @top100.include?(t.downcase) }
      very_interesting = tokens.find_all { |t| @top50.include?(t.downcase) }.length > 2
      special = tokens.find { |t| SPECIAL_WORDS.include?(t.downcase) }

      if special
        favorite(tweet)
        favd = true # Mark this tweet as favorited

        bot.delay DELAY do
          begin
            bot.follow tweet[:user][:screen_name]
          rescue
            @bot.log "Follow failed, ignoring..."
          end
        end
      end

      # Any given user will receive at most one random interaction per day
      # (barring special cases)
      next if $have_talked[tweet[:user][:screen_name]]
      $have_talked[tweet[:user][:screen_name]] = true

      if very_interesting || special 
        favorite(tweet) if (rand < 0.5 && !favd) # Don't fav the tweet if we did earlier
        retweet(tweet) if rand < 0.1
        reply(tweet, meta) if rand < 0.1
      elsif very_interesting && special # The tweet has already been faved earlier
        retweet(tweet) if rand < 0.3
        reply(tweet, meta) if rand < 0.3
      elsif interesting
        favorite(tweet) if rand < 0.1
        reply(tweet, meta) if rand < 0.05
      end
    end

    # Schedule a main tweet every 2 hours
    bot.scheduler.every '2h' do
      begin
        bot.tweet @model.make_statement
      rescue
        @bot.log "Tweet failed, ignoring..."
      end 
    end
    # Empty the list of people the bot has talked to today
    bot.scheduler.every '24h' do
      $have_talked = {}
    end
  end

  def reply(tweet, meta)
    #@bot.log "Replying to @#{tweet[:user][:screen_name]}: #{tweet[:text]}"
    resp = meta[:reply_prefix] + @model.make_response(meta[:mentionless], 140 - meta[:reply_prefix].length)
    @bot.delay DELAY do
      begin
        @bot.reply tweet, resp
      rescue
        @bot.log "Reply failed, ignoring..."
      end
    end
  end

  def favorite(tweet)
    @bot.log "Favoriting @#{tweet[:user][:screen_name]}: #{tweet[:text]}"
    @bot.delay DELAY do
      begin
        @bot.twitter.favorite(tweet[:id])
      rescue
        @bot.log "Favorite failed, ignoring..."
      end
    end
  end

  def retweet(tweet)
    @bot.log "Retweeting @#{tweet[:user][:screen_name]}: #{tweet[:text]}"
    @bot.delay DELAY do
      begin
        @bot.twitter.retweet(tweet[:id])
      rescue
        @bot.log "Retweet failed, ignoring..."
      end
    end
  end
end

def make_bot(bot, modelname)
  GenBot.new(bot, modelname)
end

Ebooks::Bot.new(TWITTER_USERNAME) do |bot|
  bot.oauth_token = OAUTH_TOKEN
  bot.oauth_token_secret = OAUTH_TOKEN_SECRET

  make_bot(bot, TEXT_MODEL_NAME)
end
