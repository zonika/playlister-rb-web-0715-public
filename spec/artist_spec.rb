describe "Artist" do

  it "can be initialized" do
    expect(Artist.new).to be_an_instance_of(Artist)
  end

  it "can have a name" do
    artist = Artist.new
    artist.name = "Adele"
    expect(artist.name).to eq("Adele")
  end

  describe "with songs" do

    let(:artist) { Artist.new }
    let(:song) { Song.new }

    it "has songs" do
      artist.songs = []
      expect(artist.songs).to eq([])
    end

    it "can have a song added" do
      artist.add_song(song)
      expect(artist.songs).to include(song)
    end

    it "knows how many songs it has" do
      artist.songs = [song, Song.new]
      expect(artist.songs.count).to eq(2)
    end

  end

  describe "with genres" do

    let(:artist) { Artist.new }

    it "can have genres" do
      song = Song.new
      song.genre = Genre.new.tap { |genre| genre.name = "rap" }
      artist.add_song song
      expect(artist.genres).to include(song.genre)
    end

  end

  describe "Class methods" do

    it "can reset all artists that have been created" do
      Artist.reset_artists
      expect(Artist.all).to be_empty
    end
    
    before(:each) do
      Artist.reset_artists
      @artist = Artist.new
    end

    it "keeps track of the artists that have been created" do
      expect(Artist.all).to include(@artist)
    end

    it "can count how many artists have been created" do
      expect(Artist.count).to eq(1)
    end

    it "can reset the artists that have been created" do
      Artist.reset_artists
      expect(Artist.count).to eq(0)
    end

  end
end
