require 'sinatra'
require 'twitter'

helpers do
  def twitter
    @twitter ||= Twitter::REST::Client.new do |config|
      config.consumer_key    = ENV.fetch("TWITTER_CONSUMER_KEY")
      config.consumer_secret = ENV.fetch("TWITTER_CONSUMER_SECRET")
    end
  end
end

get "/tweets.css" do
  content_type "text/css"
  tweets = twitter.search(ENV.fetch("TWITTER_SEARCH_STRING"))
  '
  @media screen and (-webkit-min-device-pixel-ratio: 0) {
      .tweet .copy:before {
         white-space: pre-wrap;
      }
  '
  tweets.take(15).map.with_index do |tweet, i|
  '   
  #tweet-#{i + 1} .avatar {
    background: url("#{tweet.user.profile_image_url}");
  }

  #tweet-#{i + 1} .handle::after {
    content: "@#{tweet.user.screen_name}";
  }

  #tweet-#{i + 1} .copy::before {
    content: "#{tweet.text}";
  }

  #tweet-#{i + 1} .timestamp::after {
    content: "#{tweet.created_at}";
  }
    '
  end
   '
      }
  '
end
