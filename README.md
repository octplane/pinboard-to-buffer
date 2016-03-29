Post never-seen updates on Buffer.

Store seen urls in seen.txt in a human readable format.

```
bundle install
# Your pinboard token, taken from the pinboard website
echo "PINBOARD_TOKEN=user:fullpinboardtoken" >> .env
# create a buffer app and grab its access token
echo "BUFFER_ACCESS_TOKEN=bufferaccesstoken" >> .env
# indicates which profiles to use to post, or run the app without this var to have a look at what's available.
echo "BUFFER_PROFILE_IDS=run the app one without this settings" >> .env
# Filters your pinboard on this tag before buffering this
echo "PINBOARD_TAG_FILTER=myfilteringtag"

ruby main.rb

```

