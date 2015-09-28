#!/bin/bash

# This looks in your virtualenv for any invenio-* module that is installed from pip, and installs it from git instead.
# This way you can apply compatibility hacks real quick from inside your src/.

set -e

if [ ! -d "$VIRTUAL_ENV" ]; then
    echo 'Please use `workon <your_virtualenv>` first.'
    exit 1
fi

cd "$VIRTUAL_ENV/src"
while read thing; do

    if [ ! -d "$thing" ]; then
        git clone git@github.com:inveniosoftware/"$thing".git
    else
        (cd "$thing" && git pull)
    fi

    pip uninstall -y "$thing"
    pip install -e ./"$thing"

    #find "$thing" -type f -name '*.py' -print0 | xargs -0 sed -i 's/invenio.modules.upgrader/invenio_upgrader/g'
done < <(pip freeze 2>/dev/null | grep -P 'invenio-.+==' | cut -d'=' -f1)

find "$VIRTUAL_ENV" -name '*.pyc' -delete
