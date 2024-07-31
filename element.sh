#!/bin/bash

# Define the PSQL variable to connect to the periodic_table database
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Function to fetch element details
fetch_element_details() {
  local input=$1
  local query="SELECT atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type 
               FROM elements 
               JOIN properties USING(atomic_number) 
               JOIN types USING(type_id) 
               WHERE atomic_number = $1 OR symbol = '$1' OR name = '$1'"
  # Execute the query and return the result
  echo $($PSQL "$query")
}

# Check if an argument is provided
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

# Fetch element data based on the provided input
ELEMENT=$(fetch_element_details "$1")

# Check if the element exists in the database
if [[ -z $ELEMENT ]]; then
  echo "I could not find that element in the database."
  exit 0
else
  # Read the element details into variables
  IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE <<< "$ELEMENT"
  # Output the element details
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL)."
  echo "It's a $TYPE, with a mass of $ATOMIC_MASS amu."
  echo "$NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
fi

