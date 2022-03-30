require 'discordrb'
require 'opus-ruby'
require 'yaml'
require_relative 'FetchYoutube/youtube'
require_relative 'MusicQueue/music_queue'

TOKEN = YAML.load_file('../config.yaml')
youtube = Youtube.new

bot = Discordrb::Commands::CommandBot.new token: TOKEN['token'], prefix: '$'

$pause = false

bot.command(:play) do |event|
  channel = event.user.voice_channel

  next "Сначала зайдите в канал!" unless channel

  bot.voice_connect(channel)
  event.respond "Присоединился к каналу: #{channel.name}"

  $pause = false

  voice_bot = event.voice
  voice_bot.play_file('TempData/zzz.mp3')
  event.respond "Проверка блокировки"
end

bot.command(:pause) do |event|
  event.voice.pause unless $pause
  event.voice.continue if $pause
  $pause = !$pause
  return
end

bot.command(:arg) do |event, arg|
  event.respond arg if arg
end

bot.command(:io) do |event, url|
  channel = event.user.voice_channel

  next "Сначала зайдите в канал!" unless channel

  bot.voice_connect(channel)
  event.respond "Присоединился к каналу: #{channel.name}"

  $pause = false

  youtube.fetch(url)

  voice_bot = event.voice
  #loop { break if open('TempData/out.mp3') }
  voice_bot.play_file('TempData/out.mp3')
end

bot.run