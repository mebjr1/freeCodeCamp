#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo "Welcome to My Salon, how can I help you?" 

MAIN_MENU() {
  if [[ $1 ]]
    then
      echo -e "\n$1"
  fi

  LIST_OF_SERVICES=$($PSQL "select * from services order by service_id")
  echo "$LIST_OF_SERVICES" | while read SERVICE_ID BAR NAME
    do
      S_ID=$(echo $SERVICE_ID | sed 's/ //g')
      SNAME=$(echo $NAME | sed 's/ //g')
      echo "$S_ID) $SNAME" 
    done
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    [1-5]) PHONE ;;
    *) MAIN_MENU "I could not find that service. What would you like today\n" ;;
  esac
}

PHONE() {
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CXNAME=$($PSQL "select name from customers where phone = '$CUSTOMER_PHONE'")
  CUSTOMER_NAME=$(echo $CXNAME | sed 's/ //g')

  if [[ -z $CUSTOMER_NAME ]]
    then 
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      INSERT_NEW_CX=$($PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi

  S_NAME=$($PSQL "select name from services where service_id = '$SERVICE_ID_SELECTED'")
  SERVICE_NAME=$(echo $S_NAME | sed 's/ //g')
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE'")

  echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME
  INSERT_NEW_APPT=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  if [[ $INSERT_NEW_APPT == "INSERT 0 1" ]]
    then
      echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

MAIN_MENU