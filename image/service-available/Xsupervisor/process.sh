#!/bin/sh -e
log-helper level eq trace && set -x

#devo lanciare il procecesso
#exec /xxxxx/xxx/xxxx -f
#/etc/init.d/ssh start
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
