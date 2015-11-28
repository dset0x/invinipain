#!/bin/sh
set -e

# These patches give you a correct stacktrace when you have an indirect import
# error that werkzeug/flask-registry otherwise hide.

# As of today there is still a bug that the fixes above don't catch, but I have
# a horribly long backlog of other things to do. You can still extract those
# with ipdb. Patches welcome.

if [ ! -d "$VIRTUAL_ENV" ]; then
    echo 'Please use `workon <your_virtualenv>` first.'
    exit 1
fi

cd "$VIRTUAL_ENV/src"

pip install 'git+https://github.com/dset0x/werkzeug.git@import_stacktrace'
pip install 'git+https://github.com/dset0x/flask-registry.git@implicit_broken_module_import'
