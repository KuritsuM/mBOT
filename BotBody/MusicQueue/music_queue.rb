require 'singleton'
require_relative 'server_queue'

class MusicQueue
  include Singleton

  def initialize
    @servers = Hash.new
  end

  public

  def add_to_queue(server_id, music_url)
    unless @servers[server_id]
      @servers[server_id] = ServerQueue.new
    end

    @servers[server_id].add_track music_url
  end

  def stop(server_id)
    @servers[server_id] = nil
  end

  def pause(server_id)
    @servers[server_id].pause
  end

  def unpause(server_id)
    @servers[server_id].pause
  end

  def is_paused?(server_id)
    @servers[server_id].is_paused?
  end
end
