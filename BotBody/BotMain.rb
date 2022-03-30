require 'discordrb'
require 'opus-ruby'
require 'yaml'
require_relative 'FetchYoutube/youtube'
require_relative 'MusicQueue/music_queue'

TOKEN = YAML.load_file('../config.yaml')
youtube = Youtube.new
bot = Discordrb::Commands::CommandBot.new token: TOKEN['token'], prefix: '$'
$music_queue = MusicQueue.instance

bot.command(:play) do |event, url|
  channel = event.user.voice_channel
  server_id = event.user.server.id

  "Сначала зайдите в канал!" unless channel

  bot.voice_connect channel

  if $music_queue.bot_on_server? server_id
    event.respond "Добавил трек в очередь."
  else
    event.respond "Присоединился к каналу: #{channel.name}"
  end

  if $music_queue.bot_on_server? server_id
    $music_queue.add_to_queue server_id, url
    return
  end

  $music_queue.add_bot server_id, event.voice
  $music_queue.add_to_queue server_id, url

  next_track = $music_queue.get_next_track(server_id)
  while next_track
    youtube.delete_file next_track
    track_name = youtube.fetch next_track

    $music_queue.get_bot(server_id).play_file track_name
    next_track = $music_queue.get_next_track(server_id)
  end
  disconnect_bot server_id
  'Это был последний трек'
end

bot.command(:pause) do |event|
  server_id = event.user.server.id
  voice_bot = $music_queue.get_bot(server_id)

  if $music_queue.paused? server_id
    $music_queue.unpause server_id
    voice_bot.continue
    return "Продолжил воспроизведение трека."
  else
    $music_queue.pause server_id
    voice_bot.pause
    return "Приостановил воспроизведение трека."
  end
end

bot.command(:skip) do |event|
  channel = event.user.voice_channel
  server_id = event.user.server.id

  if $music_queue.bot_on_server? server_id
    voice_bot = $music_queue.get_bot server_id
    voice_bot.stop_playing voice_bot.playing?

    $music_queue.get_current_track_url(server_id) ? 'Принял, ставлю следующий трек!' : 'Это был последний трек.'
  else
    "Бот и так ничего не играет!"
  end
end

bot.command(:stop) do |event|
  server_id = event.user.server.id
  $music_queue.remove_all_tracks server_id

  voice_bot = $music_queue.get_bot server_id
  voice_bot.stop_playing voice_bot.playing?

  return
end

def disconnect_bot(server_id)
  $music_queue.get_bot(server_id).destroy
  $music_queue.remove_server server_id
end

bot.run
