# Description:
#   電車遅延情報をSlackに投稿する
#
# Commands:
#   hubot train < kaoru | yuri | all > - Return train info
#
# Author:
#   Kaoru Hotate

cheerio = require 'cheerio-httpcli'
cronJob = require('cron').CronJob

module.exports = (robot) ->

  searchAllTrain = (msg) ->
    # send HTTP request
    baseUrl = 'http://transit.loco.yahoo.co.jp/traininfo/gc/13/'
    cheerio.fetch baseUrl, (err, $, res) ->
      if $('.elmTblLstLine.trouble').find('a').length == 0
        msg.send "事故や遅延情報はありません"
        return
      $('.elmTblLstLine.trouble a').each ->
        url = $(this).attr('href')
        cheerio.fetch url, (err, $, res) ->
          title = "◎ #{$('h1').text()} #{$('.subText').text()}"
          result = ""
          $('.trouble').each ->
            trouble = $(this).text().trim()
            result += "- " + trouble + "\r\n"
          msg.send "#{title}\r\n#{result}"

  robot.respond /train (.+)/i, (msg) ->
    target = msg.match[1]
    # 有楽町線
    metro_yu = 'http://transit.yahoo.co.jp/traininfo/detail/137/0/'
    # 京浜東北線
    jr_kt = 'http://transit.yahoo.co.jp/traininfo/detail/22/0/'
    # 山手線
    jr_ym = 'http://transit.yahoo.co.jp/traininfo/detail/21/0/'
    # 埼京線
    jr_sk = 'http://transit.yahoo.co.jp/traininfo/detail/50/0/'
    # 湘南新宿ライン
    jr_ss = 'http://transit.yahoo.co.jp/traininfo/detail/25/0/'
    # 京王線
    keio = 'http://transit.yahoo.co.jp/traininfo/detail/102/0/'

    if target == "kaoru"
      searchTrain(metro_yu, msg)
      searchTrain(jr_kt, msg)
      searchTrain(keio, msg)
    else if target == "yuri"
      searchTrain(jr_ym, msg)
      searchTrain(jr_sk, msg)
      searchTrain(jr_ss, msg)
    else if target == "all"
      searchAllTrain(msg)
    else
      msg.send "#{target}は検索できないよ。Σ (￣ロ￣|||)"

  searchTrain = (url, msg) ->
    cheerio.fetch url, (err, $, res) ->
      title = "#{$('h1').text()}"
      if $('.icnNormalLarge').length
        msg.send "#{title}は遅れてないよ。━ ━ (´･ω ･`)━ ━ "
      else
        info = $('.trouble p').text()
        msg.send "#{title}は遅れているみたい。♪ へ(´д ｀へ)♪ (ノ´ д ｀)ノ♪ \n#{info}"

  new cronJob('0 0 7 * * 1-5', () ->
    # 有楽町線
    metro_yu = 'http://transit.yahoo.co.jp/traininfo/detail/137/0/'
    # 京浜東北線
    jr_kt = 'http://transit.yahoo.co.jp/traininfo/detail/22/0/'
    searchTrainCron(metro_yu)
    searchTrainCron(jr_kt)
  ).start()

  new cronJob('0 0 8 * * 1,3,5', () ->
    # 山手線
    jr_ym = 'http://transit.yahoo.co.jp/traininfo/detail/21/0/'
    # 埼京線
    jr_sk = 'http://transit.yahoo.co.jp/traininfo/detail/50/0/'
    # 湘南新宿ライン
    jr_ss = 'http://transit.yahoo.co.jp/traininfo/detail/25/0/'

    searchTrainCron(jr_ym)
    searchTrainCron(jr_sk)
    searchTrainCron(jr_ss)
  ).start()

  searchTrainCron = (url) ->
    cheerio.fetch url, (err, $, res) ->
      if $('.icnNormalLarge').length
        title = "#{$('h1').text()}"
        robot.send {room: "#mybot"}, "#{title}は遅れてないよ。━ ━ (´･ω ･`)━ ━ "
      else
        info = $('.trouble p').text()
        robot.send {room: "#mybot"}, "#{title}は遅れているみたい。♪ へ(´д ｀へ)♪ (ノ´ д ｀)ノ♪ \n#{info}"