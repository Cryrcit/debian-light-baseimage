#!/bin/sh -e
log-helper level eq trace && set -x

#
mkdir -p /run/sshd
chmod 755 /run/sshd
#

ln -sf "${CONTAINER_SERVICE_DIR}/Xssh/assets/sshd_config" /etc/ssh/sshd_config

chmod 444 -R "${CONTAINER_SERVICE_DIR}"/Xssh/assets/sshd_config
