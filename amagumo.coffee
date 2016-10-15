# Description:
#   A hubot script return Yahoo Rain-cloud(Amagumo) Radar infomation.
#
# Commands:
#   hubot amagumo home - Returns whather my home
#   hubot amagumo <area> - Returns wheather input area
#
# Author:
#   kaoru hotate
#   (to use as reference https://github.com/asmz/hubot-yahoo-amagumo/blob/master/scripts/amagumo.coffee)

# Yahoo Developer IDを設定してください
# http://developer.yahoo.co.jp/start/
HUBOT_YAHOO_AMAGUMO_APP_ID = "hogehoge"

module.exports = (robot) ->

  robot.respond /ame (.+)/i, (msg) ->
      area = if msg.match[1] == "home" then "豊島区東池袋" else msg.match[1]
      disparea  = if msg.match[1] == "home" then "おうち" else msg.match[1]
      searchWeather area, disparea, msg
    return

searchWeather = (area, disparea, msg) ->
  zoom = "16"
  width = "400"
  height = "400"

  msg.http('http://geo.search.olp.yahooapis.jp/OpenLocalPlatform/V1/geoCoder')
    .query({
      appid: HUBOT_YAHOO_AMAGUMO_APP_ID
      query: area
      results: 1
      output: 'json'
    })
    .get() (err, res, body) ->
      geoinfo = JSON.parse(body)
      unless geoinfo.Feature?
        msg.send "Not match \"#{area}\""
        return

      coordinates = (geoinfo.Feature[0].Geometry.Coordinates).split(",")
      lon = coordinates[0]
      lat = coordinates[1]
      msg.send "#{msg.message.user.name} #{disparea}の天気はこんな感じだよ（
ゝω・）v \n" + getAmagumoRaderUrl lat, lon, zoom, width, height

getAmagumoRaderUrl = (lat, lon, zoom, width, height) ->
  url = "http://map.olp.yahooapis.jp/OpenLocalPlatform/V1/static?appid=" +
        HUBOT_YAHOO_AMAGUMO_APP_ID +
        "&lat=" + lat +
        "&lon=" + lon +
        "&z=" + zoom +
        "&width=" + width +
        "&height=" + height +
        "&overlay=" + "type:rainfall"