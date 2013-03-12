class SongDecorator < Draper::Decorator
  delegate_all
 
  def formatted_duration
    Time.at(model.duration.to_i).gmtime.strftime('%R:%S')
  end
  
  def short_name
  	short_song = []
    [model.artist, model.title].each do |m|
      short_song << (m.length >= 33 ? m[0,33] + "..." : m)
    end
    short_song.join(" - ")
  end
end
