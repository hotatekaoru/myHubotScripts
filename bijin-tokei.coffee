# Description:
#   Hubot responds current time bijin-tokei URL
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot bijin now - Hubot responds bijin-tokei URL of 'all japan'
#   美人なう - 'hubot bijin now'と同じ。
#   hubot bijin now [local] - Hubot responds bijin-tokei URL of 'local'
#   美人なう、[local] - 'hubot bijin now [local]'と同じ。
#
# Notes:
#   システムのタイムゾーンに関わらず、日本時間の時刻を返す。
#   [local]を日本語で指定することができる。
#   「美人なう(、[local])」は、Hubotに対する呼びかけでなくても反応する。
#   IMEがONの場合に「美人なう、[日本語local]」で入力することを想定している。
#
# Author:
#   kaoru hotate
#   (to use as reference https://github.com/succi0303/hubot-bijin-tokei)
#

# 指定の時間に動かすため、cronを入れる
cronJob = require('cron').CronJob

BASE_URL = 'http://www.bijint.com/assets/pict'
PICT_EXT = 'jpg'
LOCAL_CONVERT_LIST =
  '大阪' : 'osaka'
  '北海道' : 'hokkaido'
  '宮城' : 'sendai'
  '兵庫' : 'kobe'
  '福岡' : 'fukuoka'
  '石川' : 'kanazawa'
  '愛知' : 'nagoya'
  '群馬' : 'gunma'
  '福井' : 'fukui'
  '沖縄' : 'okinawa'
  '熊本' : 'kumamoto'
  '埼玉' : 'saitama'
  '東京' : 'tokyo'
  '静岡' : 'shizuoka'
  '宮崎' : 'miyazaki'
  '岩手' : 'iwate'
  '栃木' : 'tochigi'
  '神奈川' : 'kanagawa'
  '京都' : 'kyoto'
  '岡山' : 'okayama'
  '長崎' : 'nagasaki'
  '秋田' : 'akita'
  '長野' : 'nagano'
  '茨城' : 'ibaraki'
  '佐賀' : 'saga'
  '青森' : 'aomori'
  '香川' : 'kagawa'
  '鹿児島' : 'kagoshima'
  '新潟' : 'niigata'
  '広島' : 'hiroshima'
  '千葉' : 'chiba'
  '奈良' : 'nara'
  '山口' : 'yamaguchi'
  '鳥取' : 'tottori'
  '山梨' : 'yamanashi'
  '美男時計' : 'binan'
  'マッチョ時計 for ラグビー' : 'macho'
  'サーキット時計' : 'cc'
  '美魔女時計' : 'bimajo'
  'キッズ時計' : 'kids'
  'ヘアスタイル時計' : 'hairstyle'
  'Photo studio×キッズ時計' : 'kids-photostudio'
  ' 十勝キッズ時計' : 'http:www.tokachi-kids-tokei.com'
  ' VIVI' : 'http:s.vivi.tvcampustokei'
  'SARA' : 'sara'
  'パナホーム兵庫ファミリー時計' : 'panahome-hyogo'
  ' 北陸新幹線カウントダウン時計' : 'http:www.shinkansen-tokei.com'
  ' ぽちゃカワ時計' : 'http:lafarfa.jppip114471'
  '早稲田スタイル時計' : 'wasedastyle'
  'tv-asahi×bijin-tokei' : 'tv-asahi'
  '花嫁時計' : 'hanayome'
  'F・O・インターナショナル×キッズ時計' : 'kids-fo'
  'メガネ時計' : 'megane'
  ' ジュニア時計' : 'http:jr-tokei.com'
  '美男時計（京都）' : 'binan-kyoto'
  '美男時計（鹿児島）' : 'binan-kagoshima'
  '美男時計 in 韓流ぴあ' : 'binan_hanryupia'
  'BABYDOLL × I LOVE mama ×Primama × キッズ時計' : 'kids-babydoll'
  '美人時計全国2011' : '2011jp'
  '美人時計全国2012' : '2012jp'
  '美人時計全国2013' : '2013jp'
  'Taiwan' : 'taiwan'
  'Thailand' : 'thailand'
  'Hawaii' : 'hawaii'
  'Jakarta' : 'jakarta'

# Dateオブジェクトを受け取り、日本時間の時・分のオブジェクトを返す。
nowTime = (date) ->
  t = date.getUTCHours() + 9
  if t < 24
    h = t
  else
    h = t % 24
  m = date.getMinutes()
  time = {
    hours: h
    minutes: m
  }
  return time

# Dateオブジェクトを受け取り、日本時間の時刻を"HH時MM分"の形式で返す。
strTime = (date) ->
  time = nowTime(date)
  hh = ('0' + time.hours).slice(-2)
  mm = ('0' + time.minutes).slice(-2)
  return "#{hh}時#{mm}分"

# Dateオブジェクトを受け取り、日本時間の時刻を"HHMM"の形式で返す。
hhmmTime = (date) ->
  time = nowTime(date)
  hh = ('0' + time.hours).slice(-2)
  mm = ('0' + time.minutes).slice(-2)
  return hh + mm

# 文字列と変換リストを受け取り、文字列がリストに該当する場合、文字列を変換し
て返す。
convertLocal = (local, conv_list) ->
  if local of conv_list
    local = conv_list[local]
  return local

# ランダムな日時を返却する。
randomHHMM = () ->
  hour = Math.floor(Math.random() * 23).toString()
  min = Math.floor(Math.random() * 59).toString()
  return fillzero(hour) + fillzero(min)

fillzero = (str) ->
  str = if str.length == 1 then "0" + str else str
  return str

module.exports = (robot) ->
  robot.respond /bijin\s+now$/i, (msg) ->
    date = new Date
    message = "現在の時刻は#{strTime(date)}です。[全国版]"
    image_url = "#{BASE_URL}/jp/pc/#{hhmmTime(date)}.#{PICT_EXT}"
    msg.send "#{message}\n#{image_url}"

  robot.hear /美人なう$/, (msg) ->
    date = new Date
    localSignature = 'jp'
    message = "現在の時刻は#{strTime(date)}です。[全国版]"
    image_url = "#{BASE_URL}/#{localSignature}/pc/#{hhmmTime(date)}.#{PICT_EXT}"
    msg.send "#{message}\n#{image_url}"

  robot.respond /bijin\s+now\s+(.+)$/i, (msg) ->
    date = new Date
    localSignature = convertLocal(msg.match[1], LOCAL_CONVERT_LIST)
    message = "現在の時刻は#{strTime(date)}です。[地域版: #{localSignature}]"
    image_url = "#{BASE_URL}/#{localSignature}/pc/#{hhmmTime(date)}.#{PICT_EXT}"
    msg.send "#{message}\n#{image_url}"

  robot.hear /美人なう、(.+)$/, (msg) ->
    date = new Date
    localSignature = convertLocal(msg.match[1], LOCAL_CONVERT_LIST)
    message = "現在の時刻は#{strTime(date)}です。[地域版: #{localSignature}]"
    image_url = "#{BASE_URL}/#{localSignature}/pc/#{hhmmTime(date)}.#{PICT_EXT}"
    msg.send "#{message}\n#{image_url}"

  new cronJob('0 0 18 * * *', () ->
    date = new Date
    localSignature = 'jp'
    image_url = "#{BASE_URL}/#{localSignature}/pc/#{randomHHMM()}.#{PICT_EXT}"
    message = "#{strTime(date)}だよ。残業しないで早く帰ろうよ。"
    msg.send "#{message}\n#{image_url}"
  ).start()

  new cronJob('0 0 19-24 * * *', () ->
    date = new Date
    localSignature = 'jp'
    image_url = "#{BASE_URL}/#{localSignature}/pc/#{randomHHMM()}.#{PICT_EXT}"
    message = "#{strTime(date)}だよ。今日も1日お疲れ様。"
    robot.send {room: "#mybot"}, "#{message}\n#{image_url}"
  ).start()