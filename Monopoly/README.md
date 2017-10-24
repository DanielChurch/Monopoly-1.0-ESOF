# Monopoly
[Check it out on github.io!](https://danielchurch.github.io/dart/Monopoly/build/web/)
## Requirements
 - Install Dart version 1.24.2 or greater
   - Any os: From https://www.dartlang.org/
   - Mac (with `brew`): `brew install dart --with-content-shell --with-dartium`
   - Windows (with `chocolatey`): `choco install dart-sdk`, `choco install dartium`
## How to run locally
 - Run `pub get --packages-dir`
 - Run:
   - `pub serve` to serve, then go to `localhost:8080` (to serve from dart)
   - Or `pub build` and go to `build/web` and open `index.html` (to run as html/js page)
## How to run the tests
 - Go to the root directory
 - Run `pub run test -p chrome`
 - You can optionally specify text for the tests to search for, where it will only run tests with that string
   - `pub run test -p chrome -n Banker`
 - To run tests quickly:
   - Serve the app with `pub serve test`
     - Use the `dartdevc` compiler for quickest results
       - `pub serve test --web-compiler=dartdevc`
   - Run the tests `pub run test -p chrome --pub-serve=8080`