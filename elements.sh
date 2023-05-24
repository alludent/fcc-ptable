#! /bin/bash
if [[ ! -n $1 ]]
then # no arguments given
  echo "Please provide an element as an argument."
else
  PSQL="psql -U freecodecamp -d periodic_table --no-align -t -c"
  if [[ $1 =~ ^[0-9]+$ ]] # it is a number input
  then
    name=$($PSQL "SELECT name FROM elements where atomic_number=$1")
    symbol=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1")
    if [[ -z $1 || -z $name || -z $symbol ]] # input is not found in the database in some/all locs
    then
      echo "I could not find that element in the database."
    else 
      typeid=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$1")
      type=$($PSQL "SELECT type FROM types WHERE type_id=$typeid")
      atomic_mass=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$1")
      melting=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$1")
      boiling=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$1")
      echo "The element with atomic number $1 is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting celsius and a boiling point of $boiling celsius."
    fi
  else # it is a symbol or name input
    if [[ ${#1} -le 2 ]] # it is a symbol
    then
      number=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
    else # it is a name
      number=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
    fi
    name=$($PSQL "SELECT name FROM elements where atomic_number=$number")
    symbol=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$number")
    if [[ -z $1 || -z $name || -z $symbol ]] # input is not found in the database in some/all locs
    then
      echo "I could not find that element in the database."
    else
      typeid=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$number")
      type=$($PSQL "SELECT type FROM types WHERE type_id=$typeid")
      atomic_mass=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$number")
      melting=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$number")
      boiling=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$number")
      echo "The element with atomic number $number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting celsius and a boiling point of $boiling celsius."
    fi
  fi
fi
