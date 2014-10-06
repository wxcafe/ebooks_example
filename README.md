# ebooks_example

As requested, this is the [twitter_ebooks](https://github.com/mispy/twitter_ebooks) app which I use to run most of my own bots. It tweets one guaranteed tweet every 2h, always responds to interactions, and has some small unprompted interaction probability based on keyword matching.

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
./replace.sh
docker build --rm -t whatever_ebooks .
docker run -d ebooks
```

Or alternatively, if you don't want to use it as a docker container:
`./run.rb`

Also runs as a Heroku app! See the [twitter_ebooks](https://github.com/mispy/twitter_ebooks) README for more information.

### THIS IS A FORK FROM [twitter_ebooks](https://github.com/mispy/twitter_ebooks). 
