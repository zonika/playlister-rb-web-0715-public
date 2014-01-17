require_relative './spec_helper.rb'

describe "Genre" do

  it "can initialize a genre" do
    expect(Genre.new).to be_an_instance_of(Genre)
  end

  it "has a name" do
    genre = Genre.new
    genre.name = 'rap'
    expect(genre.name).to eq('rap')
  end

  it "has many songs" do
    genre = Genre.new.tap { |g| g.name = 'rap' }
    3.times do
      song = Song.new
      song.genre = genre
    end
    genre.songs.count.to eq(3)
  end

  it "has many artists" do
    genre = Genre.new
    genre.name = 'rap'

    2.times do
      artist = Artist.new
      song = Song.new.tap { |s| s.genre = genre }
      artist.add_song(song)
    end

    expect(genre.artists.count).to eq(2)
  end

  it "keeps unique artists" do
    genre = Genre.new.tap{|g| g.name = 'rap'}
    artist = Artist.new

    [1,2].each do
      song = Song.new
      song.genre = genre
      artist.add_song(song)
    end
    expect(genre.artists.count).to eq(1)
  end

  describe "Class methods" do

    before(:each) do
      Genre.reset_genres
    end

    it "keeps track of all known genres" do
      expect(Genre.count).to eq(0)
      rap = Genre.new.tap{|g| g.name = 'rap'}
      electronica = Genre.new.tap{|g| g.name = 'electronica'}
      expect(Genre.count).to eq(2)
      expect(Genre.all).to include(rap)
      expect(Genre.all).to include(electronica)
    end

    it "can reset genres" do
      5.times do
        Genre.new
      end
      expect(Genre.count).to eq(5)
      Genre.reset_genres
      expect(Genre.count).to eq(0)
    end

  end
end
