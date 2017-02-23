#!/usr/bin/expect
set device_address [lindex $argv 0]
spawn ssh user@$device_address "show access-lists \n"
expect "user@$device_address\'s password"
send "yourPassword\r"
expect eof
