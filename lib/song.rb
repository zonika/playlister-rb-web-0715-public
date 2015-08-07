# code song here
class Song
  attr_accessor :name, :artist, :genre
  def initialize
    @genre=nil
  end
  def genre=(genre)
    @genre=genre
    genre.songs<<self
  end
  def genre
    @genre
  end

end
