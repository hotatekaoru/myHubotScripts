# Description:
#   A hubot script for practice for 勉強会
#
# Commands:
#   hubot hello - Return "hello + your name"
#   hubot <someone> love? - Return some words.
#
# Author:
#   Kaoru Hotate

module.exports = (robot) ->

  # "@hubot testhubot hello"とslackで打ち込んだ時に呼ばれる
  # public void robot.respond(void) みたいな感じ
  robot.respond /hello/, (msg) ->

    # msg.send で Slackにメッセージを表示できる
    msg.send "Hello #{msg.message.user.name}!"

    # 日付と時刻を表示する
    # msg.sendが複数ある場合、順番にはならない
    msg.send "It is #{strTime()}."

  ####################################
  # 現在時刻（Date型）を受け取り、
  # 文字列を返却する。
  ####################################
  strTime = () ->
    days = ["日", "月", "火", "水", "木", "金", "土"]
    d = new Date
    year  = d.getFullYear()     # 年（西暦）
    month = d.getMonth() + 1    # 月
    date  = d.getDate()         # 日
    day = days[d.getDay()]      # 曜日

    hour  = d.getHours()        # 時
    min   = d.getMinutes()      # 分
    sec   = d.getSeconds()      # 秒
    return "#{year}年#{month}月#{date}日 #{day}曜日\n#{hour}時#{min}分#{sec}秒"

  # "@hubot love <someone>"が打ち込まれた時に呼ばれる
  # (.+)で任意の1文字以上の文字列
  robot.respond /love (.+)/i, (msg) ->

    # msg.match[1]で、引数に与えた文字列を取得する
    you = msg.match[1].replace("?", "")
    regex = /// (kaoru|Kaoru|hotate|Hotate) ///
    if regex.exec(you)
      msg.send "Off course my darlin! (♡´ω `♡ )"
    else
      msg.send "(･Д ･｀)"