#!/bin/sh
SOURCE_DIRECTORY='/Users/robertjoscelyne/Development/Java/dropwizard-20150826/dropwizard-example/target'
BASE_DIRECTORY='/Users/robertjoscelyne/Sites/dropwizard'
SITE_DIRECTORY='example'

if [ ! -d "$BASE_DIRECTORY" ]; then
  mkdir "$BASE_DIRECTORY"
  if [ $? -eq 0 ]
  then
    echo "Successfully created directory $BASE_DIRECTORY"
  else
    echo "Could not create directory " >&2
    exit 1
  fi
fi

cd "$BASE_DIRECTORY"

if [ ! -d "$SITE_DIRECTORY" ]; then
  mkdir "$SITE_DIRECTORY"
  if [ $? -eq 0 ]
  then
    echo "Successfully created directory $SITE_DIRECTORY"
  else
    echo "Could not create directory " >&2
    exit 1
  fi
fi

echo "Deploying artifacts to production"
cp "$SOURCE_DIRECTORY/dropwizard-example-0.9.0-rc4-SNAPSHOT.jar" "$BASE_DIRECTORY/$SITE_DIRECTORY"

if [ $? -eq 0 ]
then
  echo "artifacts copied"
else
  echo "artifacts copy failed " >&2
  exit 1
fi

cd "$BASE_DIRECTORY/$SITE_DIRECTORY"
java -jar dropwizard-example-0.9.0-rc4-SNAPSHOT.jar db migrate example.yml
java -jar dropwizard-example-0.9.0-rc4-SNAPSHOT.jar server example.yml &
curl -H "Content-Type: application/json" -X POST -d '{"fullName":"Other Person","jobTitle":"Other Title"}' http://localhost:8080/people
