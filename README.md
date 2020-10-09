# Lichex
Small app with CLI tasks for tracking [Lichess](https://lichess.org) progress (or lack thereof).

## Usage
Chart a user's progress in a variant or game speed (like `rapid` or `chess960`) with:

     mix chart.$variant $user
 
Summarize a user's last 100 games with:
 
     mix recap $user
     
## Setup
Grab dependencies and compile:

    mix do deps.get, compile

A `LICHESS_API_TOKEN` environment variable _must_ be set at compile time.

I suggest using [direnv](https://direnv.net/) to set your `LICHESS_API_TOKEN` in this project only. The root `.envrc` file is ignored, so there's no risk of committing your token.
