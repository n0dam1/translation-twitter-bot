require 'rubygems'
require 'twitter'
require 'pp'
require 'json'
require 'uri'
require 'net/http'

# idから時間に変換
# 参考url : https://qiita.com/riocampos/items/e5544325211976f2cfc1
def tweet_id2time(id)
    Time.at(((id.to_i >> 22) + 1288834974657) / 1000.0)
end

client = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV['CONSUMER_KEY'] 
  config.consumer_secret = ENV['CONSUMER_SECRET']
  config.access_token = ENV['ACCESS_TOKEN']
  config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
end

def translate(text)
    url = URI.parse('https://www.googleapis.com/language/translate/v2')

    params = {
        q: text,
        target: "ja",
        source: "en",
        key: ENV['GCP_KEY']
    }
    url.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(url)
    JSON.parse(res.body)["data"]["translations"].first["translatedText"]
end

# 10分前の時刻を取得
minute_past_time = Time.new - 1 * 60 * 10

# 特定ユーザのtimelineを件数(10件)指定して取得
client.user_timeline("Bitcoin", { count: 10 } ).reverse_each do |timeline|
  if tweet_id2time(client.status(timeline.id).id) > minute_past_time then
    text =  client.status(timeline.id).text
    jp_text = translate(text)
    client.update(jp_text)
  end
end
