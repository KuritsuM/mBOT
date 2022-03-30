class ServerQueue
  def initialize
    @queue = []
    @track = -1
    @paused = false
  end

  def is_paused?
    @paused
  end

  def pause
    @paused = true
  end

  def unpause
    @paused = false
  end

  def add_to_queue(music_url)
    @queue << music_url
  end

  def get_next_track
    @track += 1

    if @track < @queue.length
      return @queue[@track]
    end

    false
  end

  def get_previous_track
    @track -= 1 if @track > 0
    @queue[@track]
  end

  def add_track(url)
    @queue << url
    nil
  end
end
