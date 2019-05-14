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

tdbc::postgres::connection create db -host $db_hostname -user $db_username -password $db_password -database $db_database

for { set i 0 } { $i < 3 } {incr i} {
    set title "title $i"
    set content "hello world $i"
    set stmt [db prepare {INSERT INTO blog_posts (content, title,  date) VALUES (:content, :title, CURRENT_TIMESTAMP)}]
    if { [catch { set res [$stmt execute] } err ] } {
	puts "could not add record: $err"
    }
    $stmt close
    after 1000
}


set tag "red"
set stmt [db prepare {INSERT INTO blog_tags (post_id,  tag) VALUES (1, :tag)}]
if { [catch { set res [$stmt execute] } err ] } {
    puts "could not add record: $err"
}
$stmt close

set tag "red"
set stmt [db prepare {INSERT INTO blog_tags (post_id,  tag) VALUES (2, :tag)}]
if { [catch { set res [$stmt execute] } err ] } {
    puts "could not add record: $err"
}
$stmt close

set tag "blue"
set stmt [db prepare {INSERT INTO blog_tags (post_id,  tag) VALUES (2, :tag)}]
if { [catch { set res [$stmt execute] } err ] } {
    puts "could not add record: $err"
}
$stmt close

db close
