describe "Song" do
  it "can initialize a song" do
     # implement this spec
    expect(Song.new).to be_an_instance_of(Song)
  end

  it "can have a name" do
    song = Song.new
    song.name = "Blank Space"
    expect(song.name).to eq("Blank Space")
  end

  it "can have a genre" do
     # implement this spec
     song=Song.new
     genre=Genre.new
     genre.name="rap"
     song.genre=genre
     expect(song.genre).to eq(genre)
  end

  it "has an artist" do
     # implement this spec
     song=Song.new
     artist=Artist.new
     song.artist=artist
     expect(song.artist).to eq(artist)
  end
end
