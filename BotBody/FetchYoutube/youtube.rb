class Youtube
  def fetch(url)
    system("rm TempData/out.mp3")
    system("youtube-dl --audio-format mp3 -o TempData/out.mp3 -x #{url}")
  end
end