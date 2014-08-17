## Sentry and Mailcatcher on a vagrant box

[sentry[mysql]](http://github.com/getsentry/sentry) and [mailcatcher](http://github.com/sj26/mailcatcher) dev installations on a vagrant box.

    vagrant up
    
and it should be running.

On the first run, you need to execute:

    /www/sentry/bin/sentry --config=/etc/sentry.conf.py createsuperuser
    /www/sentry/bin/sentry --config=/etc/sentry.conf.py repair --owner=<username>
    
You should have sentry on http://localhost:9000.

Unfortunately port forwarding is not ok, so mailctacher is found on 192.168.33.10:(1080/1025), but not localhost.