# SRT file Time Shift

A few years ago I wrote a hack-ish script in Ruby to shift time in SRT subtitles.

The original script (it's a bit ugly with unnecessary metaprogramming and not clear Time manipulation) is here:

* https://github.com/akitaonrails/Shift-Subtitle/

The goal of this new version in Crystal was to:

1. assess how easy it would be to port a Ruby script to Crystal (Time's API is different, so this was a bit difficult at first, but not an obstacle)
2. assess how fast it could be compared to the Ruby version.

This is the time it takes for the Ruby script to shift a normal movie-length SRT file:

    0,13s user 0,02s system 98% cpu 0,158 total

This Crystal version performs like this for the same input file:

    0,02s user 0,00s system 106% cpu 0,020 total

It's not a particularly expensive operation, but more than 6x as fast is a very good start.

## Installation

You can compile the binary like this:

    crystal build src/cr_subtitle_shift.cr --release

## Usage

Once compiled you can time shift your SRT files like this:

    ./cr_subtitle_shift -o add -t 02,100 movie_subtitle.srt movie_subtitle_shifted.srt

## Development

You can run the available specs like this:

    crystal specs

## Contributing

1. Fork it ( https://github.com/akitaonrails/cr_subtitle_shift/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [AkitaOnRails](https://github.com/akitaonrails) - creator, maintainer
