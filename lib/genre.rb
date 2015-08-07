# code genre here
class Genre
  attr_accessor :name, :songs, :artists
  @@all=[]
  def initialize
    @@all<<self
    @songs=[]
    @artists=[]
  end
  def add_artist(artist)
    @artists << artist
    @artists=@artists.uniq
  end
  def self.reset_genres
    @@all=[]
  end
  def self.all
    @@all
  end
  def self.count
    @@all.length
  end
end
