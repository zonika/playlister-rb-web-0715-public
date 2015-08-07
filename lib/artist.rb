# code artist here
require 'pry'
class Artist
  attr_accessor :name, :songs, :genres
  @@all=[]
  def initialize
    @@all << self
    @songs=[]
    @genres=[]
  end
  def add_song(song)
    @songs << song
    @genres << song.genre
    if song.genre != nil
      song.genre.add_artist(self)
    end
  end
  def self.reset_artists
    @@all=[]
  end
  def self.count
    @@all.length
  end
  def self.all
    @@all
  end
end
