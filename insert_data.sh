#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
while IFS="," read -r year round winner opponent winner_goals opponent_goals
do

r1="$($PSQL "SELECT COUNT(*) FROM teams WHERE name = '$winner'")"
r2="$($PSQL "SELECT COUNT(*) FROM teams WHERE name = '$opponent'")"

if [ $r1 -lt 1 ]; then
  echo "$($PSQL "INSERT INTO teams(name) VALUES('$winner')")"
fi

if [ $r2 -lt 1 ]; then
  echo "$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")"
fi

wid="$($PSQL "SELECT team_id FROM teams WHERE name = '$winner'")"
oid="$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent'")"

echo "$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', $wid, $oid, $winner_goals, $opponent_goals)")"

done < <(tail -n +2 games.csv)

