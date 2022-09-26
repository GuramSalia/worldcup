#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#insert games.sql data into teams table

echo -e "\n~~ Feeding WorldCup database ~~\n"

echo $($PSQL "TRUNCATE games, teams")
echo -e "\nTruncating Games and Teams tables"

  # loop through games.csv and read 
cat games.csv | while IFS=(',') read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    # chech WINNER_ID AND OPPONENT_id in teams
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name LIKE '$WINNER'")

    # if WINNER not fond
      if [[ -z $WINNER_ID ]]
      then
        #add WINNER to teams
        RESULT_INSERT_WINNER=$($PSQL "INSERT INTO teams (name) VALUES('$WINNER')")

          if [[ $RESULT_INSERT_WINNER == 'INSERT 0 1' ]]
          then
            echo -e "\nInserted team: $WINNER into teams table"
          fi
  
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name LIKE '$WINNER'")
        
      fi

      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name LIKE '$OPPONENT'")
    # if OPPONENT not fond
      if [[ -z $OPPONENT_ID ]]
      then
        #add OPPONENT to teams
        RESULT_INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
          if [[ $RESULT_INSERT_OPPONENT == 'INSERT 0 1' ]]
          then
            echo -e "\nInserted team: $WINNER into teams table"
          fi
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name LIKE '$OPPONENT'")
      fi


#insert games.csv data into games table
    RESULT_INSERT_GAMES=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
        if [[ $RESULT_INSERT_GAME == 'INSERT 0 1' ]]
        then
            echo -e "\n$WINNER vs $OPPONENT inserted into games table"
        fi
  fi
  done