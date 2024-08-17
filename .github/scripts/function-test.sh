#!/bin/bash
docker compose up -d --build
# Check frontend is ready
URL=http://localhost:8080
timeout 10 sh -c "until curl '${URL}'; do echo 'Sleeping...'; sleep 1; done"
EXIT_CODE="$?"

# Check backend is ready
URL_2=http://localhost:9000/fortunes
timeout 10 sh -c "until curl '${URL_2}'; do echo 'Sleeping...'; sleep 1; done"
EXIT_CODE_2="$?"

# Clean-up
docker compose down

# exit code for frontend curl check
if [ "$EXIT_CODE" -ne 0 ]; then
    echo "failed connection to $URL"
    exit "$EXIT_CODE"
fi
# exit code for backend curl check
if [ "$EXIT_CODE_2" -ne 0 ]; then
    echo "failed connection to $URL_2"
    exit "$EXIT_CODE_2"
fi