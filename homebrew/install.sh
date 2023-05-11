#!/bin/bash

# via https://brew.sh
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

curl \ 
    --fail \    # -f: Fail silently on server errors.
    --silent \    # -s: Silent/quiet mode. Don't show progress meter or error messages.
    --show-error \    # -S: Makes curl show an error message if it fails and is on silent.
    --location \    # -L: If resource has moved to a new location, retries there.
    "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"