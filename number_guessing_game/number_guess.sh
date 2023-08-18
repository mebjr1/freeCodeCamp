#!/bin/bash
PSQL="psql -U freecodecamp number_guess -t --no-align -c"

START() {
  echo "Enter your username:"
  read NAME
  U_ID=$($PSQL "select user_id from users where name = '$NAME'")
  if [[ -z $U_ID ]]
    then
      echo "Welcome, $NAME! It looks like this is your first time here."
      ADD_USER=$($PSQL "insert into users(name) values('$NAME')")
      U_ID=$($PSQL "select user_id from users where name = '$NAME'")
  fi
        
    GAMES_PLAYED=$($PSQL "select count(user_id) from games where user_id = '$U_ID'")
    BEST_GAME=$($PSQL "select min(guesses) from games where user_id = '$U_ID'")
    echo "Welcome back, $NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  GUESS  
}

GUESS(){
  S_NUM=$((1 + $RANDOM % 1000))
  TRIES=0
  GUESSES=0
    echo "Guess the secret number between 1 and 1000:"
  while [[ $GUESSES = 0 ]]
    do
      read GUESS
        if [[ ! $GUESS =~ ^[0-9]+$ ]]
          then
            echo "That is not an integer, guess again:"
          elif [[ $S_NUM = $GUESS ]]
            then
              TRIES=$(($TRIES + 1))
              echo "You guessed it in $TRIES tries. The secret number was $S_NUM. Nice job!"
              ADD_GAME=$($PSQL "insert into games(user_id, guesses) values($U_ID, $TRIES)")
              GUESSES=1
          elif [[ $S_NUM -lt $GUESS ]]
            then
              TRIES=$(($TRIES + 1))
              echo "It's lower than that, guess again:"
            else
              TRIES=$(($TRIES + 1))
              echo "It's higher than that, guess again:"
        fi
    done  
}
START