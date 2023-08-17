#!/bin/bash

PSQL="psql -U freecodecamp periodic_table -t --tuples-only -c"

if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
    exit
fi

if [[ $1 =~ ^[1-9]|10+$ ]]
then
  EL=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where atomic_number = '$1'")
    
    else
      EL=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where name = '$1' or symbol = '$1'")
fi

if [[ -z $EL ]]
  then
    echo "I could not find that element in the database."
    exit
fi

echo $EL | while IFS=" |" read A_NUM NAME SYMBOL TYPE A_MASS MPC BPC
do
  echo "The element with atomic number $A_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $A_MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
done
exit