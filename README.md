---
  tags: oop, domain, tdd
  languages: ruby
  resources: 1
---

# Playlister

### Skills: Object Oriented Programming, Test Driven Development

## Instructions

Fork this repository, clone it, and make the RSpec tests pass.

1. Create a Class for `song`, `artist`, and `genre`. Use an individual file for each class. These files should be placed within a `lib` directory.

2. Implement the code that makes all of the RSpec tests in the `spec` directory pass. Don't forget to require any necessary files!

3. Implement the pending tests (in `spec/song_spec.rb`) and make them pass too.

## Note

When writing and calling the `#genre=(genre)` method for the Song class, keep in mind that the object being passed in is an entire Genre object, not a String representation of the Genre. For example, `#<Genre:0x007fbdca31ed88 @name="rap">`, not `'Rap'`. The same can be applied to all other classes and assignment methods.

