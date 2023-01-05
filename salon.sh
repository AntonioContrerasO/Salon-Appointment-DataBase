#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"
MAIN_MENU(){
  if [[ $1 ]]
  then
  echo -e "\n$1"
  fi
  SERVICES=$($PSQL "SELECT * FROM services")
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE
    do
      echo "$SERVICE_ID) $SERVICE"
    done

  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) ADD_APPOINTMENT 1 Hair-cutting ;;
    2) ADD_APPOINTMENT 2 Massages;;
    3) ADD_APPOINTMENT 3 facials;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}

ADD_APPOINTMENT(){
  echo -e "\nWhat's your phone number? $2"
  read CUSTOMER_PHONE
  ALREADY_CLIENT=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $ALREADY_CLIENT ]]
  then
    echo -e "\nwhat's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  fi
  echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
  read SERVICE_TIME
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  NEW_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES('$CUSTOMER_ID','$1','$SERVICE_TIME')")

  echo -e "\nI have put you down for a $2 at $SERVICE_TIME, $CUSTOMER_NAME."
}


MAIN_MENU "Welcome to My Salon, how can I help you?\n"
