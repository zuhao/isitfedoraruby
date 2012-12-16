#!/bin/bash

cd $OPENSHIFT_REPO_DIR
export RAILS_ENV="production"
rake "database:update_oldest_rpms[1]" >> $OPENSHIFT_DATA_DIR/last_update.log 2>&1
