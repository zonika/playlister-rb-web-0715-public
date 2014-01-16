class Artist

  attr_accessor :name, :songs, :genres

  def initialize
    @songs = []
    @genres = []
  end

  def add_song(song)
    self.songs << song
    self.genres << song.genre
  end

end