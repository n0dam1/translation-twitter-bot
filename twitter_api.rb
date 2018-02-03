require 'rubygems'
require 'twitter'
require 'pp'

def tweet_id2time(id)
      Time.at(((id.to_i >> 22) + 1288834974657) / 1000.0)
end

client = Twitter::REST::Client.new do |config|
  config.consumer_key = '9Ppo8shVjfKpJPFkgiTeX5zGz'
  config.consumer_secret = 'CmOGIA04fHDvnS2R2RvcXQ6rHpNrX495ZZD1NEChmSOFw2IQAT'
  config.access_token = '959856376921993216-DTcqiGLN6VIgUjMAunP6UX4Vagl5B0g'
  config.access_token_secret = 'aVkFsFqzOMNgJfzLK8x5ZyIYtbZNaAJ3FAXsRKo5JNnfg'
end


# 一分前の時刻を取得
minute_past_time = Time.new - 1 * 60

# 特定ユーザのtimelineを件数(10件)指定して取得
client.user_timeline("pr2jsk", { count: 10 } ).each do |timeline|
  if tweet_id2time(client.status(timeline.id).id) > minute_past_time then
    puts client.status(timeline.id).text
  end
end

'''
# search
client.search("to:qiita", lang: "ja").take(10).each do |tweet|
  pp "tweet.class Twitter::twitter"
  pp tweet.class
  pp "tweet.favorite_count fav数"
  pp tweet.favorite_count
  pp "tweet.filter_level"
  pp tweet.filter_level

  pp "tweet.in_reply_to_screen_name"
  pp tweet.in_reply_to_screen_name
  pp "tweet.in_reply_to_status_id"
  pp tweet.in_reply_to_status_id
  pp "tweet.in_reply_to_user_id"
  pp tweet.in_reply_to_user_id
  pp "tweet.lang"
  pp tweet.lang
  pp "tweet.retweet_count"
  pp tweet.retweet_count
  pp "tweet.source"
  pp tweet.source
  pp "tweet.text #ツイート内容"
  pp tweet.text #ツイート内容
end

#access_tokenを登録したユーザでtweetする
pp client.update("twitter-apiを使ってrubyでツイート！")
'''
