require 'rubygems'
require 'twitter'
require 'pp'
require 'json'
require 'uri'
require 'net/http'

def tweet_id2time(id)
    Time.at(((id.to_i >> 22) + 1288834974657) / 1000.0)
end

client = Twitter::REST::Client.new do |config|
  config.consumer_key = 'jghnnB4gHedRSax950VmynouN' #'9Ppo8shVjfKpJPFkgiTeX5zGz'
  config.consumer_secret = '29RlXKOFTKvV67LL8FqYIqk19wcX4rrB0jnIfN9nmaYhkm3gFc' #'CmOGIA04fHDvnS2R2RvcXQ6rHpNrX495ZZD1NEChmSOFw2IQAT'
  config.access_token = '959057681163014144-2gly3YzWzCnZCUK3KuTUTLswGG9TDbD' #'959856376921993216-DTcqiGLN6VIgUjMAunP6UX4Vagl5B0g'
  config.access_token_secret = 'OFqQFeIgPOQLSFiVc7Krmw1nYxpEAQPstqTh8ZZeZPR4h' #'aVkFsFqzOMNgJfzLK8x5ZyIYtbZNaAJ3FAXsRKo5JNnfg'
end

def translate(text)
    url = URI.parse('https://www.googleapis.com/language/translate/v2')

    params = {
        q: text,
        target: "ja",
        source: "en",
        key: "AIzaSyDz65XDH_x_8dAsg1ChMSLBnSBvo4G8b2Q"
    }
    url.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(url)
    JSON.parse(res.body)["data"]["translations"].first["translatedText"]
end

# 10分前の時刻を取得
minute_past_time = Time.new - 1 * 60 * 10

# 特定ユーザのtimelineを件数(10件)指定して取得
client.user_timeline("Bitcoin", { count: 10 } ).each do |timeline|
  if tweet_id2time(client.status(timeline.id).id) > minute_past_time then
    text =  client.status(timeline.id).text
    jp_text = translate(text)
    #puts jp_text
    client.update(text)
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
