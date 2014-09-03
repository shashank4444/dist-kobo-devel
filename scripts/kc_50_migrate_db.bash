#!/bin/bash

# scripts/kc_50_migrate_db.sh

# ============================
# EXTEND ENVIRONMENT VARIABLES
if [ -d /home/vagrant ]; then
    SCRIPT_DIR=/vagrant/scripts
else
    THIS_SCRIPT_PATH=$(readlink -f "$0")
    SCRIPT_DIR=$(dirname "$THIS_SCRIPT_PATH")
fi
. $SCRIPT_DIR/01_environment_vars.sh
# ============================

install_info "Migrate KC Database"

cd $KOBOCAT_PATH

# Ensure the profile is loaded (once).
[ ! ${KOBO_PROFILE_LOADED:-"false"} = "true" ] && . $PROFILE_PATH
workon kc

python manage.py syncdb --noinput
python manage.py migrate --noinput

echo "from django.contrib.auth.models import User; User.objects.create_superuser('kobo', 'kobo@example.com', 'kobo');" | python manage.py shell
