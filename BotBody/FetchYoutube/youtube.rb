class Youtube
  def fetch(url)
    system("youtube-dl --audio-format mp3 -o TempData/#{url}.mp3 -x #{url}")
    "TempData/#{url}.mp3"
  end

  def delete_file(url)
    system("rm TempData/#{url}.mp3")
  end
end