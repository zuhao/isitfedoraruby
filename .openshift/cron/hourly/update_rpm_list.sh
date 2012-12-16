#!/bin/bash
if [ `date +%H` == "02" ]
then
	export RAILS_ENV="production"
	cd $OPENSHIFT_REPO_DIR
	echo "Starting RPM list update..." > $OPENSHIFT_DATA_DIR/last_update.log
        rake "database:import_rpms[refresh_list]" >> $OPENSHIFT_DATA_DIR/last_update.log 2>&1
	echo "RPM list update done!" >> $OPENSHIFT_DATA_DIR/last_update.log
fi
