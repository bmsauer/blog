#!/usr/bin/tclsh
package require Tcl 8.6
package require tdbc::postgres
package require inifile

set config [::ini::open tools_blogconfig.ini r]
set db_hostname [::ini::value $config main db_hostname]
set db_username [::ini::value $config main db_username]
set db_password [::ini::value $config main db_password]
set db_database [::ini::value $config main db_database]
::ini::close $config

#create user blog_user with password 'blog_user'
tdbc::postgres::connection create db -host $db_hostname -user $db_username -password $db_password -database $db_database

set stmt [db prepare {CREATE TABLE blog_posts (id serial PRIMARY KEY, title text, content text, date timestamp)}]
if { [catch { set res [$stmt execute] } err ] } {
    puts "could not create posts table: $err"
}
$stmt close

set stmt [db prepare {CREATE TABLE blog_tags (post_id integer REFERENCES blog_posts (id), tag text)}]
if { [catch { set res [$stmt execute] } err ] } {
    puts "could not create tags table: $err"
}
$stmt close

db close

