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
  config.consumer_key = 'jghnnB4gHedRSax950VmynouN' 
  config.consumer_secret = '29RlXKOFTKvV67LL8FqYIqk19wcX4rrB0jnIfN9nmaYhkm3gFc'
  config.access_token = '959057681163014144-2gly3YzWzCnZCUK3KuTUTLswGG9TDbD'
  config.access_token_secret = 'OFqQFeIgPOQLSFiVc7Krmw1nYxpEAQPstqTh8ZZeZPR4h' 
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
client.user_timeline("Bitcoin", { count: 10 } ).reverse_each do |timeline|
  if tweet_id2time(client.status(timeline.id).id) > minute_past_time then
    text =  client.status(timeline.id).text
    jp_text = translate(text)
    client.update(jp_text)
  end
end
