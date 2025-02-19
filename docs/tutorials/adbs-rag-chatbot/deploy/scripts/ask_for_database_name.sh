#!/bin/bash

# Ask user for database name
read -p "Enter the database name (letters only): " DATABASE_NAME

while [[ $DATABASE_NAME =~ [^a-zA-Z] ]]; do
  echo "Invalid input. Please enter a database name containing only letters."
  read -p "Enter the database name (letters only): " DATABASE_NAME
done

DATABASE_DISPLAY_NAME=$DATABASE_NAME