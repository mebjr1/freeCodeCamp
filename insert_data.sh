#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "truncate teams, games")
echo $($PSQL "alter sequence teams_team_id_seq restart with 1")
echo $($PSQL "alter sequence games_game_id_seq restart with 1")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
   then
    # get winner_id
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    # if not found
    if [[ -z $WINNER_ID ]]
      then
      INSERT_TEAM=$($PSQL "insert into teams(name) values('$WINNER')")
      # get new winner_id
      WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    fi
  # get opponent_id
  OPPONENT_ID=$($PSQL "select team_id from teams where name = '$OPPONENT'")
    if [[ -z $OPPONENT_ID ]]
      then
      INSERT_TEAM2=$($PSQL "insert into teams(name) values('$OPPONENT')")
      # get a new opponent_id
      OPPONENT_ID=$($PSQL "select team_id from teams where name = '$OPPONENT'")
    fi
    INSERT_GAMES=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi  
done
