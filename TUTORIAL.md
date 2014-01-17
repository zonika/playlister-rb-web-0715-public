# Playlister Tutorial

Before I even get started trying to make the specs pass, I want to get my environment all set up. Since I see that there are three spec files that each check a particular class, I want to make sure I have the .rb files set up for all three classes. I already have an `artist.rb` file, so I'm going to go ahead and make `genre.rb` and `song.rb` files and put them in the `lib` directory. This is a convenient place for us to keep all of our models.

The next thing I want to do is make sure all my files are getting included correctly. I have this convenient `spec/spec_helper.rb` file which will get run when my specs are run, so it'll be a good idea to get everything required at the top of that file.

Now, I could just type:

```ruby
require_relative '../lib/artist'
require_relative '../lib/song'
require_relative '../lib/genre'
```

but a better pattern to get into the habit of doing is to create an `environment.rb` file and put those in there. So, let's create `environment.rb` and put it in the root of my project directory. And at the top of that file, write:

```ruby
require_relative '../lib/artist'
require_relative '../lib/genre'
require_relative '../lib/song'
```

Now, I want my `spec/spec_helper.rb` file to require my environment. So, I'll open it up and add:

```ruby
require_relative '../environment'
```

(Notice that I'm not adding `.rb` to the end of the file names in my require_relative statements. It's not required, and generally un-Ruby-like.)

And finally, we need to require our spec_helper at the top of each of the spec files. So at the top of `spec/artist_spec.rb`, `spec/genre_spec.rb`, and `spec/song_spec.rb` add the line:

```ruby
require_relative './spec_helper'
```

Now, why is this a good idea to have this extra `environment.rb` file? Well, what happens if I want to run my program without running the specs? All of my files need to know about one another, and it'd be a pain in the butt to have to require two separate files at the top of each one. Now, all I'd have to do, is add one line:

```ruby
require_relative '../environment'
```

to the top of my model files, and I'd be good to go!

Ok. Now I can go ahead and take a look at my tests. What's the best way to do this? Yep, to just type `rspec` into my terminal.

Phew! That's a whole lotta red! But that's ok. The whole point of Test Driven Development is to write tests for my code, watch them fail, and then create my program by incrementally making them pass, one my one.

So let's look at the first test and see why it failed.

`uninitialized constant Artist`.

Ok, that's easy enough to fix. I don't have an artist class anywhere. So I'm going to define one. In `lib/artist.rb` I'm going to add these lines of code:

```ruby
class Artist

end
```

And now I'll run the tests again. Look at that! The first test is green! Awesome. Let's look at the second test.

`undefined method 'name=' for #<Artist:0x...>`

So this seems like it's complaining that my Artist class doesn't have a method to assign a name. I can fix this a number of ways, but my first inclination is to give my Artist class an `attr_accessor`. When I do that, I get two awesome methods for free: a setter and a getter, or a writer and a reader. So if I add:

```ruby
attr_accessor :name
```

to the top of my Artist class, I'm getting the following two methods for free:

```ruby
def name=(name)
  @name = name
end

def name
  @name
end
```

Let's add that and run the tests again.

Boom! It passes. And the next error tells me that I don't have a `song=` method. How can I fix that? Yep, I need to add another `attr_accessor`. So my Artist class should now look like:

```ruby
class Artist
  attr_accessor :name, :songs

end
```

Hmm...my next error looks kind of familiar. I don't seem to have initialized a constant called `Song`. How do I fix this? I need to define the Song class in `lib/song.rb`.

```ruby
# lib/song.rb
class Song

end
```

Ok, now I get an error that there is an undefined method called `add_song` for my Artist class. This doesn't seem like an attr_accessor to me, so I think I'm going to have to go ahead and define an instance method on my Artist class. Let's do that:

```ruby
# lib/artist.rb
class Artist

  attr_accessor :name, :songs

  def add_song
  end

end
```

Now, I realize I've made a little mistake. My add_song method should take an argument. I know this because I got the error: `wrong number of arguments (1 for 0)`. And this actually makes sense. If I'm going to call a method `add_song`, I probably need to tell it which song I'm talking about.

So in `lib/artist.rb`, I'll update my `add_song` method so that it looks like this:

```ruby
def add_song(song)
end
```

I just ran my tests again, and this is kind of confusing. I get the error: `undefined method 'include?' for nil:NilClass` and it seems to be coming from line 27 in `spec/artist_spec.rb`. That's kind of weird, though. I never defined an `include?` method. Let's jump over to that place in the code and see what's going on.

Here's what I see in the spec file:

```ruby
it "can have a song added" do
  artist.add_song(song)
  artist.songs.should include(song)
end
```

So let's see. What's happening here. First, I'm adding a song to my artist using the method we just defined, and then I'm saying that my artist's songs should include the song I just added.

Whoa. That's a lot. Looking a few lines up, I see that `artist` is just a new instance of the Artist class and `song` is just a new instance of the Song class. Ok. That's fine. But this `.should include` business has my wondering: when did I ever actually set my artist's songs? I made an attr_accessor, but when I say `Artist.new`, I'm never actually setting an instance variable. This makes me think that I should probably be doing some work in an `initialize` method.

Let's add that to my artist.

```ruby
class Artist

  attr_accessor :name, :songs

  def initialize
  end

  def add_song(song)
  end

end
```

In my initialize method, I need to set up my `@songs` instance variable. And I'm thinking I should probably set it equal to an empty array. I'm assuming this is the way to go because the variable is plural, and generally that indicates a collection of things. And after all, doesn't an artist have many songs? And many of something is an array, a collection. It's important to continue thinking in metaphors, they are called Models because they are models of something real and should behave like the real thing. An array is a great way to keep track of a collection. I also think this is the case because that `include?` method from my test failure message is a method I'm used to see being called on an array.

```ruby
class Artist

  attr_accessor :name, :songs

  def initialize
    @songs = []
  end

  def add_song(song)
  end

end
```

Ok, let's run the test suite again.

Sweet, error fixed. But now I have a different failure message:

`expected [] to include #<Song:0x...>`

That kind of makes sense, actually. The test called my add_song method, which was supposed to add the song to the artist's `@songs`, but my method doesn't actually do anything yet.

For now, I feel like it's probably sufficient to just add the supplied song into my @songs instance variable like this:

```ruby
def add_song(song)
  self.songs << song
end
```

Nice! That made the test pass. And I see another familiar error. Time to make a Genre class!

```ruby
# lib/genre.rb
class Genre

end
```

Oops, guess I need an attr_accessor too:

```ruby
# lib/genre.rb
class Genre

  attr_accessor :name

end
```

Oh, look at that. It seems my Song class also needs to be aware of Genres. So I'll need to add an attr_accessor for genre there too:

```ruby
# lib/song.rb
class Song

  attr_accessor :genre

end
```

And it looks like I'll need to add the same for my Artist class as well:

```ruby
# lib/artist.rb
class Artist

  attr_accessor :name, :songs, :genres

  # ...

end
```

Aha! This weird `undefined method 'include?' for nil:NilClass`. I know what that means this time. Looks like I need to initialize my genres in the Artist class.

```ruby
# lib/artist.rb
class Artist

  attr_accessor :name, :songs, :genres

  def initialize
    @songs = []
    @genres = []
  end

  # ...
end
```

This error also looks familiar. I feel like I need to add the genre into the @genres instance variable. Let's see what method I'm supposed to write to have that happen.

Here's the test that's failing (from line 41 in `spec/artist_spec.rb`):

```ruby
describe "with genres" do

  let(:artist) { Artist.new }

  it "can have genres" do
    song = Song.new
    song.genre = Genre.new.tap { |genre| genre.name = "rap" }
    artist.add_song song
    artist.genres.should include(song.genre)
  end

end
```

Wait a second. There's no `add_genre` method or anything like that. How the heck am I supposed to let my Artist know about its genre if I never assign it?

In moments like this, it's generally helpful to look at the test, line by line, and figure out what line of code is supposed to be doing the work.

`song = Song.new` seems benign. Let's move on.

`song.genre = ...` also seems unrelated to my artist. This is where I'm adding a genre to the song.

`artist.add_song song` is a method I wrote, so it's not doing that work.

But then on the next line, my artist should know about its genre.

What what what? Somehow, it seems like between the time I add a song to an artist and the very next line, that artist magically knows what genres it has. Could that mean my `add_song` method needs to be doing some more work? The genre *must* be being added there somehow. There's nowhere else it can happen.

Isn't that weird though? Can my artist really know about some other class without ever explicitely being informed about it?

Yeah, sure, why not? I'm setting up some relationships between a few different objects here, and sometimes it's necessary for me, the programmer, to make those relationships happen. Here, it seems like I'm going to have to do that. Somehow I need to "teach" the Artist class that it gets its genre *through* its songs.

So lets look at the `add_song` method again and see if we can make this work:

```ruby
# lib/artist.rb
class Artist

  # ...

  def add_song(song)
    self.songs << song
    self.genres << song.genre
  end

end
```

That seems like it could do the trick. Since I'm telling the artist about a song (I'm passing it into its add_song method), the artist can now "ask" that song about its genre. Luckily, I have that attr_accessor for genre on the Song class.

Let's run the test suite and see if this works.

And it does. Nice! Let's take a look at the next failure message:

`undefined method 'reset_artists' for Artist:Class`

I can glean two things from this message: first, I need to have a class method that resets the Artists, and second, I apparently need some way of keeping track of all of the Artist instances.

Let's take care of the second of those first.

So I know I want to keep track of every instance of an Artist, but when might I do that? Well, there are only a few moments in the life of an object that I can really do things. One of those moments is when it is instantiated. Maybe, then, I'll want to keep track of a new Artist as soon as it is created.

I can put something in the initialize method to do that.

First, let's create a class variable to keep track of all the Artists. Remember, class variables are variables that are available class wide.

```ruby
# lib/artist.rb
class Artist

  attr_accessor :name, :songs, :genres

  @@artists = []

  def initialize
    @songs = []
    @genres = []
  end

  # ...

end
```

And now, let's modify our initialize method so that whenever a new Artist is instantiated, it adds itself to that array we just made.

```ruby
# lib/artist.rb
class Artist

  attr_accessor :name, :songs, :genres

  @@artists = []

  def initialize
    @songs = []
    @genres = []
    @@artists << self
  end

  # ...

end
```

Now let's tackle that `reset_artists` class method. First, let's go ahead and define it. Remember, class methods are defined a bit differently...they begin with `self.`:

```ruby
# Defining a class method

def self.method_name
end
```

What does this method need to do? Well, we're keeping track of all the Artist instances in an array. So if we empty that array, we've essentially reset our list of Artists. Add this method to the Artist class:

```ruby
# lib/artist.rb

class Artist

  # ...

  def self.reset_artists
    # we could do something like @@artist = [], but we can also use this handy
    # array method instead that empties the array for us

    @@artist.clear
  end

end
```

If we run the specs again, that test passes, and we get a new failure message:

`undefined method 'all' for Artist:Class`

This seems pretty straight forward to fix. We need a class method (`self.all`) that will return that `@@artists` array that we created for the last test.

```ruby
# lib/artist.rb

class Artist

  # ...

  def self.all
    @@artists
  end

end
```

Now this next failure message is an interesting one. It tells us that we don't have a `count` method for our Artist class. It seems like we might have to do something fancy to figure out how many Artists have been instantiated, right?

Nope! Since we just created this awesome method (it's basically a class-level attr_reader!) that returns an array of all of our Artists, we just need to use the familiar `Array.count` method we know and love! Easy as pie.

```ruby
# lib/artist.rb

class Artist

  # ...

  def self.count
    self.all.count
  end

end
```

We could have just as easily done `@@artists.all.count`, but it's generally more common to call our methods that return values instead. (Why might this be the case? Hint: it has something to do with what might happen if you want to rename a variable later on down the road.)

And now we're back to a familiar failure message!

`undefined method 'songs' for #<Genre:0x...>`

Let's go ahead and add that attr_accessor:

```ruby
# lib/genre.rb
class Genre

  attr_accessor :name, :songs

  # ...

end
```

Look...it's that weird `undefined method `count' for nil:NilClass` failure message again! Let's take a look at the failing test to see what's up. This is from line 21 in `spec/genre_spec.rb`:

```ruby
it "has many songs" do
  genre = Genre.new.tap { |g| g.name = 'rap' }
  3.times do
    song = Song.new
    song.genre = genre
  end
  genre.songs.count.should eq(3)
end
```

This looks really similar to the `add_song` issue we had earlier. But wait...there's no `add_song` method here on the Genre class. Where in the world can a song be getting added to a genre? The first line of the test is just some set up, so it can't be there. The `3.times do` line isn't important to us. The `Song.new` line seems benign as well. So we're left with:

`song.genre = genre`

Huh? So this test is telling me that somehow, when I call `song.genre = genre`, `genre` is also becomming aware of the song it was added to?

Do you know what that means? I need to make some more magic happen when that line is called.

Now, it may not seem like it, but `song.genre = genre` is actually, as we know, syntactic sugar for this:

`song.genre=(genre)`

Which means, we're actually calling a method named `genre=`. Crazy, right? That's one of the methods we get for free when we create an `attr_accessor :genre` on the Song class. But since we need some more stuff to happen in that method, namely we need to let the assigned genre know about the song it was just added to, we need to overwrite that method.

To our Song class, let's add:

```ruby
class Song

  attr_accessor :genre

  def genre=(genre)
  end

end
```

So what do we need this method to do? Well, remember what we did in our `add_song` method? We'll do the same kind of thing here. And, while we're at it, let's change that attr_accessor to an attr_reader, since we're manually writing the writer:

```ruby
class Song

  attr_reader :genre

  def genre=(genre)
    # first, we need to replicate what the attr_accessor was already doing for us:
    # setting our instance variable

    @genre = genre

    # then, we want to add this instance of a song to the genre's collection
    # of songs

    genre.songs << self

  end

end
```

Let's run the tests again to see where we are.

Whoops! We forgot something important. It's something we forgot before. We need to initialize an empty array of songs in the Genre class on initialization of a new instance.

```ruby
class Genre

  attr_accessor :name, :songs

  def initialize
    @songs = []
  end

end
```

Ok, now we're getting somewhere! Let's see what the next failure message is, and check out that line in the test suite:

`undefined method `artists' for #<Genre:0x0...>`

And from line 34 in `spec/genre_spec.rb`:

```ruby
it "has many artists" do
  genre = Genre.new
  genre.name = 'rap'

  2.times do
    artist = Artist.new
    song = Song.new.tap { |s| s.genre = genre }
    artist.add_song(song)
  end

  genre.artists.count.should eq(2)
end
```

Ok. We've got this. First things first. Before even diving into the test, we know from the failure message that we probably need an attr_accessor for artists on the Genre class. And as we've done multiple times now, we should probably go ahead and initialize an empty array for that instance variable as well.

```ruby
class Genre

  attr_accessor :name, :songs, :artists

  def initialize
    @songs = []
    @artists = []
  end

end
```

Nice. That got us to a different failure message. This time, it says:

```bash
Failure/Error: genre.artists.count.should eq(2)
       
   expected: 2
        got: 0
```

Let's look back at that test again:

```ruby
it "has many artists" do
  genre = Genre.new
  genre.name = 'rap'

  2.times do
    artist = Artist.new
    song = Song.new.tap { |s| s.genre = genre }
    artist.add_song(song)
  end

  genre.artists.count.should eq(2)
end
```

It looks like our genre isn't being made aware of the artists it has. So where in this test might that be happening? Let's skip the first few lines, as those just look like setup. In fact, I'm seeing a pretty similar pattern here. There's a bunch of setup, then this `add_song` method is called, and then magically, the test is expecting the genre to know about some new artists.

This *must* mean that within that add_song method, the genre is learning about its artists. In other words, a genre is being informed about its artists through those artists songs. We're going to have to add some code to the add_song method. In `lib/artist.rb`:

```ruby
# lib/artist.rb
class Artist

  # ...

  def add_song(song)
    self.songs << song
    self.genres << song.genre

    # the genre is learning about this artist through the song
    song.genre.artists << self
  end

  # ...

end
```

Nice, that made the test pass! But, boo! An earlier test has started failing again. What?

```bash
1) Artist with songs can have a song added
   Failure/Error: artist.add_song(song)
   NoMethodError:
    undefined method `artists' for nil:NilClass
   # ./lib/artist.rb:16:in `add_song'
   # ./spec/artist_spec.rb:26:in `block (3 levels) in <top (required)>'
```

Well that's weird. Let's take a look at line 26 in `spec/artist_spec.rb`:

```ruby
it "can have a song added" do
  artist.add_song(song)
  artist.songs.should include(song)
end
```

And what's changed since we made that test pass earlier? Well, that line of code we just added, of course!

`song.genre.artists << self`

And we're getting an error that says `undefined method 'artists' for nil:NilClass`. Hmm, that must mean that `song.genre` is evaluating to nil for some reason.

Aha! Look at the setup before this failing test:

```ruby
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

# ...
```

The song we're using to test with has no genre assigned to it! We should probably account for that in our code. So let's alter the `add_song` method slightly to account for the case when a song exists without a genre attached to it. All we need to do is check to see that `song.genre` actually exists. If it does, all's good and we can go ahead and add the artist to that genre's list of artists. If no genre exists, we just won't do that step:

```ruby
# lib/artist.rb

class Artist

  # ...

  def add_song(song)
    self.songs << song
    self.genres << song.genre
    song.genre.artists << self if song.genre
  end

  # ...

end
```

There we go! That old test is passing again. The next failing test is the one that checks to make sure each genre keeps only unique artists. This makes sense from a usability standpoint. An artist generally does their thing in one or two genres, and it'd be really annoying to, say, list the same artist once for each of their songs when calling `genre.artists`. Aside from checking to see if a song has a genre now, we also need to check and see if a given artist already exists in a genre's collection of artists before adding to it.

```ruby
# lib/artist.rb

class Artist

  # ...

  def add_song(song)
    self.songs << song
    self.genres << song.genre
    song.genre.artists << self if song.genre && !song.genre.artists.include?(self)
  end

  # ...

end
```

Let's see, let's see. What's next? Oh, another one of those reset methods. This time, it's on the Genre class. We'll do exactly what we did with the Artist class:

```ruby
# lib/genre.rb
class Genre

  attr_accessor :name, :songs, :artists

  @@genres = []

  def initialize
    @songs = []
    @artists = []
    @@genres << self
  end

  def self.reset_genres
    @@genres.clear
  end

end
```

And the next failure message says we need to write that `self.count` method as well:

```ruby
# lib/genre.rb
class Genre

  # ...

  def self.count
    # We should probably write a method that returns @@genres
    @@genres.count
  end

end
```

And, yay! The next failure message tells us that, indeed, we need to write a method that returns @@genres:

```ruby
# lib/genre.rb
class Genre

  # ...

  def self.count
    self.all.count
  end

  def self.all
    @@genres
  end

end
```

Would you look at that?! All of our specs pass now! But what's this pending business? If we open up `spec/song_spec.rb` it looks like we need to write some tests ourselves. Luckily, these should follow the pattern we've been dealing with this whole time.

Let's look at the first one:

```ruby
# spec/song_spec.rb

it "can initialize a song" do
  pending #implement this spec
end
```

Well, I kind of remember seeing one really, really similar to that pass very early on. And looking back in my terminal, I see that indeed, the first test in artist_spec was almost identical. So let's copy that test and make it work here:

```ruby
# spec/artist_spec.rb

it "can be initialized" do
  expect(Artist.new).to be_an_instance_of(Artist)
end
```

This seems easy enough. In `spec/song_spec.rb` lets write this:

```ruby
# spec/song_spec.rb

it "can initialize a song" do
  expect(Song.new).to be_an_instance_of(Song)
end
```

This second test looks familiar too. Let's copy the second test from `spec/artist_spec.rb` and alter it:

```ruby
# spec/song_spec.rb

# ...

it "can have a name" do
  song = Song.new
  song.name = "Yellow Submarine"
  expect(song.name).to eq("Yellow Submarine")
end
```

Whoa! Look at that! That test we just wrote failed! Guess we never added an attr_accessor for name. Let's do that now:

```ruby
# lib/song.rb
class Song

  attr_reader :genre
  attr_accessor :name

  # ...

end
```

Crisis averted. Ok, let's write the next test. We want to test that a song can have a genre:

```ruby
# spec/song_spec.rb

# ...

it "can have a genre" do
  song = Song.new
  genre = Genre.new.tap { |genre| genre.name = "blues" }
  song.genre = genre
  expect(song.genre.name).to eq("blues")
end
```

And finally, our last test! It can have an artist. Let's test this using our `add_song` method on the Artist class to make sure that method works properly (even though, technically, it's already being tested):

```ruby
# spec/song_spec.rb

# ...

it "has an artist" do
  artist = Artist.new.tap { |artist| artist.name = "Amos Lee" }
  song = Song.new.tap { |song| song.name = "Sweet Pea" }
  artist.add_song(song)
  expect(song.artist).to eq(artist)
end
```

And that one fails. We don't have an attr_accessor for artist either! Let's add it:

```ruby
# lib/song.rb
class Song

  attr_reader :genre
  attr_accessor :name, :artist

  # ...

end
```

Interesting. The test still fails. And you know what? It looks like it's because we're never actually telling the song about its artist when it's added using the `add_song` method! Looks like that method has one more job:

```ruby
# lib/artist.rb
class Artist

  # ...

  def add_song(song)
    self.songs << song
    song.artist = self
    self.genres << song.genre
    song.genre.artists << self if song.genre && !song.genre.artists.include?(self)
  end

  # ...

end
```

And there we go! We have successfully created Artist, Genre, and Song classes that interact with one another, tested those interactions, and even extended our test suite by writing tests of our own.
