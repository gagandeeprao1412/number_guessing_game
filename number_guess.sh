#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -X -qAt"

echo "Enter your username:"
read -r USERNAME

# Escape apostrophes before using the username in SQL.
SQL_USERNAME=${USERNAME//\'/\'\'}

USER_ID=$($PSQL -c "SELECT user_id FROM users WHERE username = '$SQL_USERNAME';")

if [[ -n $USER_ID ]]; then
  STATS=$($PSQL -c "SELECT COUNT(*), COALESCE(MIN(number_of_guesses), 0) FROM games WHERE user_id = $USER_ID;")
  GAMES_PLAYED=$(echo "$STATS" | cut -d '|' -f 1)
  BEST_GAME=$(echo "$STATS" | cut -d '|' -f 2)

  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
else
  USER_ID=$($PSQL -c "INSERT INTO users(username) VALUES ('$SQL_USERNAME') RETURNING user_id;")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
fi

SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
NUMBER_OF_GUESSES=0

echo "Guess the secret number between 1 and 1000:"

while read -r GUESS; do
  if [[ ! $GUESS =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
    continue
  fi

  NUMBER_OF_GUESSES=$((NUMBER_OF_GUESSES + 1))

  if (( GUESS == SECRET_NUMBER )); then
    break
  elif (( GUESS > SECRET_NUMBER )); then
    echo "It's lower than that, guess again:"
  else
    echo "It's higher than that, guess again:"
  fi
done

echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"

$PSQL -c "INSERT INTO games(user_id, number_of_guesses) VALUES ($USER_ID, $NUMBER_OF_GUESSES);" > /dev/null
