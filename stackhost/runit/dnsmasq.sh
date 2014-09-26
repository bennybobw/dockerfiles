#!/bin/bash
exec 2>&1
exec dnsmasq -d -C /etc/dnsmasq.conf
