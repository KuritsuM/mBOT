class ServerQueue
  attr_reader :bot

  def initialize(bot)
    @queue = []
    @track = -1
    @paused = false
    @bot = bot
  end

  def paused?
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
      @queue[@track]
    else
      false
    end
  end

  def get_previous_track
    @track -= 1 if @track > 0
    @queue[@track]
  end

  def get_next_track_url
    ((@track + 1) < @queue.length) ? @queue[@track + 1] : false
  end

  def get_current_track_url
    @track < @queue.length ? @queue[@track] : false
  end

  def get_previous_track_url
    @track >= 1 ? @queue[@track - 1] : @queue[@track]
  end

  def remove_all_tracks
    @track = -1
    @queue = []
  end

  def add_track(url)
    @queue << url
    nil
  end
end
