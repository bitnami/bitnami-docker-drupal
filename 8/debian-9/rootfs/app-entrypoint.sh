#!/bin/bash -e

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "httpd" ]]; then

	. /init.sh
	nami_initialize apache php mysql-client libphp drupal
  
	until [ -f /bitnami/drupal/.initialized ]; do
    	echo Drupal is still initializing...
    	sleep 5
	done
	
	echo Drupal has been initialized.;
  
	if [ -d /bitnami/drupal/vendor ]; then
		rm -rf /opt/bitnami/drupal/vendor
	else
		mv /opt/bitnami/drupal/vendor /bitnami/drupal/vendor
	fi
  
	ln -s /bitnami/drupal/vendor /opt/bitnami/drupal/vendor
	echo Created vendor symlink.;

	RUN ln -s /bitnami/drupal/libraries /opt/bitnami/drupal/libraries
	echo Created libraries symlink.;
  
	info "Starting drupal... "
fi

exec tini -- "$@"
