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
def name=
end

def name
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

In my initialize method, I need to set up my `@songs` instance variable. And I'm thinking I should probably set it equal to an empty array. I'm assuming this is the way to go because the variable is plural, and generally that indicates a collection of things. An array is a great way to keep track of a collection. I also think this is the case because that `include?` method from my test failure message is a method I'm used to see being called on an array.

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