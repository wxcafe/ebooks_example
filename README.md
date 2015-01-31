# ebooks_example

As requested, this is the
[twitter_ebooks](https://github.com/mispy/twitter_ebooks) app which I use to run
my bots. It tweets one guaranteed tweet every 2h, always responds to
interactions, and has some small unprompted interaction probability based on
keyword matching.
Now updated to twitter_ebooks 3.0

## Usage

```bash
git clone https://github.com/wxcafe/ebooks_example.git
cd ebooks_example
bundle install
ebooks archive username corpus/username.json
ebooks consume corpus/username.json
```

Populate bots.rb with your auth details, the bot username and model name, then:

```bash
cd base
docker build --rm -t ebooks_base .
cd ..
docker build --rm -t bots .
docker run -d bots
```
The idea of having two docker containers for this is that it allows you to
update the base system every month or so, and update the bots more regularly.

Or alternatively, if you don't want to use it as a docker container:
`ebooks start`

Also runs as a Heroku app! See the [twitter_ebooks](https://github.com/mispy/twitter_ebooks) README for more information.

### THIS IS A FORK FROM [twitter_ebooks](https://github.com/mispy/twitter_ebooks). 
