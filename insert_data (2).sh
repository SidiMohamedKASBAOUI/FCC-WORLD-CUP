#! /bin/bash
#Script to insert data from games.csv into worldcup database
if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER_ID OPPONENT_ID WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != year ]]
then
 # get team_id
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT_ID' ")
  

  # if not found
  if [[ -z $TEAM_ID ]]
  then
  # insert team  from winners
  INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER_ID')")
  if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
  then 
    echo Inserted into teams, $WINNER_ID
  fi
  # insert team from opponents
  INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT_ID')")
  if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
  then 
    echo Inserted into teams, $OPPONENT_ID
  fi
  # get new team_id
  # TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER_ID' OR name='$OPPONENT_ID'")
  fi

fi
done
cat games.csv | while IFS="," read YEAR ROUND WINNER_ID OPPONENT_ID WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != year ]]
then
 # get winner_id
  WINNER_ID_INT=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER_ID'")
  # get opponent_id 
  OPPONENT_ID_INT=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT_ID'")
  # INSERT DATA 
  INSERT_DATA_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID_INT', '$OPPONENT_ID_INT', '$WINNER_GOALS', '$OPPONENT_GOALS')")
  if [[ $INSERT_DATA_RESULT == "INSERT 0 1" ]]
  then 
    echo Inserted into games, $YEAR $ROUND $WINNER_ID_INT $OPPONENT_ID_INT $WINNER_GOALS $OPPONENT_GOALS
  fi
fi
done