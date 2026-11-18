#!/bin/sh -e
log-helper level eq trace && set -x

#

ln -sf "${CONTAINER_SERVICE_DIR}/Xsupervisor/assets/supervisord.conf" /etc/supervisor/conf.d/supervisord.conf
chmod 444 -R "${CONTAINER_SERVICE_DIR}"/Xsupervisor/assets/supervisord.conf
