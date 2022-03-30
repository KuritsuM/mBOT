require 'singleton'
require_relative 'server_queue'

class MusicQueue
  include Singleton

  def initialize
    @servers = Hash.new
  end

  public

  def add_bot(server_id, bot)
    @servers[server_id] = ServerQueue.new bot
  end

  def get_bot(server_id)
    @servers[server_id].bot
  end

  def remove_all_tracks(server_id)
    @servers[server_id].remove_all_tracks
  end

  def add_to_queue(server_id, music_url)
    @servers[server_id].add_track music_url
  end

  def get_next_track(server_id)
    @servers[server_id].get_next_track
  end

  def get_next_track_url(server_id)
    @servers[server_id].get_next_track_url
  end

  def get_current_track_url(server_id)
    @servers[server_id].get_current_track_url
  end

  def get_previous_track_url(server_id)
    @servers[server_id].get_previous_track_url
  end

  def remove_server(server_id)
    @servers[server_id] = nil
  end

  def pause(server_id)
    @servers[server_id].pause
  end

  def unpause(server_id)
    @servers[server_id].unpause
  end

  def paused?(server_id)
    @servers[server_id].paused?
  end

  def bot_on_server?(server_id)
    @servers[server_id] ? true : false
  end
end
