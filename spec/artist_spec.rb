require_relative './spec_helper'

describe "Artist" do

  it "can be initialized" do
    Artist.new.should be_an_instance_of(Artist)
  end

  it "can have a name" do
    artist = Artist.new
    artist.name = "Adele"
    artist.name.should eq("Adele")
  end

  describe "with songs" do

    let(:artist) { Artist.new }
    let(:song) { Song.new }

    it "has songs" do
      artist.songs = []
      artist.songs.should eq([])
    end

    it "can have a song added" do
      artist.add_song(song)
      artist.songs.should include(song)
    end

    it "knows how many songs it has" do
      artist.songs = [song, Song.new]
      artist.songs.count.should eq(2)
    end

  end

  describe "with genres" do

    let(:artist) { Artist.new }

    it "can have genres" do
      song = Song.new
      song.genre = Genre.new.tap { |genre| genre.name = "rap" }
      artist.add_song song
      artist.genres.should include(song.genre)
    end

  end

  describe "Class methods" do

    before(:each) do
      Artist.reset_artists
      @artist = Artist.new
    end

    it "keeps track of the artists that have been created" do
      Artist.all.should include(@artist)
    end

    it "can count how many artists have been created" do
      Artist.count.should eq(1)
    end

    it "can reset the artists that have been created" do
      Artist.reset_artists
      Artist.count.should eq(0)
    end

  end
end
