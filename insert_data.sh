#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
 
$PSQL "TRUNCATE TABLE games, teams RESTART IDENTITY;"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
    TEAM_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    TEAM_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    if [[ $WINNER != 'winner' ]]
    then
        if [[ -z $TEAM_WINNER_ID ]] 
        then
            $PSQL "INSERT INTO teams(name) VALUES('$WINNER');"
        fi
        if [[ -z $TEAM_OPPONENT_ID ]] 
        then
            $PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');"
        fi
    fi

    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")

    $PSQL "INSERT INTO games(year, round, winner_id,opponent_id,winner_goals,opponent_goals) VALUES ($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$W_GOALS,$O_GOALS);"

done