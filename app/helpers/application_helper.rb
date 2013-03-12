module ApplicationHelper
  def temp_file_sending song_name, response
  	tmp_file = Tempfile.new(song_name)
    tmp_file.binmode.write(response)
    send_file(tmp_file.path,:filename => song_name , :type => "audio/mp3")
  end

  def download_audio uri
  	Net::HTTP.get(URI.parse(uri))
  end

  def song_name(*song)
  	if song.length == 2
  	  name, url = song
  	  "#{name}.#{url.split(".").last}"
  	else
  	  "#{song[0].artist} - #{song[0].title}.#{song[0].url.split(".").last}"
  	end
  end
end
