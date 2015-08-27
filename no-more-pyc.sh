#!/bin/sh
# Just kidding, not even tested on sh. Good luck.

# This will cause python processes in your virtualenv to not write .pyc files.
# If you don't write .pyc files, you can't read .pyc files.

# If you're like me and refuse to reload your virtualenvs, you may pass
# `--no-reload`. Works for me, but good good luck. Did I say that already?

# HOW TO:
# First kill all your python processes in your virtualenv.
# Then run this script. Otherwise you're still writing .pycs.

set -e

# Export PYTHONDONTWRITEBYTECODE every time the virtualenv is activated.
# XXX Doesn't check if it's already there, but I'm lazy.
echo 'export PYTHONDONTWRITEBYTECODE=1' >> "$VIRTUALENVWRAPPER_HOOK_DIR/initialize"

# If you don't want to reload your virtualenvs, you can also enable this hack.
if [ "$1" -eq '--no-reload' ]; then

    # I'm so nice.
    if [ ! -d "$VIRTUAL_ENV" ]; then
        echo 'Please use `workon <your_virtualenv>` first.'
        exit 1
    fi

    find "$VIRTUAL_ENV" -name '*.pyc' -delete

    # UGH. Nor sh nor bash do anonymous functions. Look at all the things I have to cope with.
    np () {
        [ -e "$1"_ ] && echo '"$1"_ already exists. Refusing to run.' && exit 11  # 11 is 1 pressed twice.
        mv "$1"{,_}
        echo '#!/bin/sh\nPYTHONDONTWRITEBYTECODE=1 exec python_ "$@"' >> "$1"
        chmod +x "$1"
    }
    np "$VIRTUAL_ENV"/bin/python

fi
