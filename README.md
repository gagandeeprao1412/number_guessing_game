# Number Guessing Game

A Bash-based number guessing game backed by PostgreSQL.

## Features

- Random secret number between 1 and 1000.
- Username registration and returning-user greetings.
- Tracks games played and the best game by fewest guesses.
- Handles non-integer input.
- Stores users and game results in PostgreSQL.

## Requirements

- Bash
- PostgreSQL
- `psql`

## Run the game

```bash
./number_guess.sh
```

## Database

The `number_guess` database contains:

- `users` — stores usernames.
- `games` — stores completed games and guess counts.
