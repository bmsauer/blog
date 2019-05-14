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

puts -nonewline "This will remove data from the db at $db_hostname, continue? \[Y/n\]:" 
flush stdout
set confirm [gets stdin]
if { $confirm != "Y" } { exit }


# posts
tdbc::postgres::connection create db -host $db_hostname -user $db_username -password $db_password -database $db_database

set stmt [db prepare {DROP TABLE blog_tags}]
if { [catch { set res [$stmt execute] } err ] } {
    puts "could not delete tags data: $err"
}
$stmt close

set stmt [db prepare {DROP TABLE blog_posts}]
if { [catch { set res [$stmt execute] } err ] } {
    puts "could not delete posts data: $err"
}
$stmt close




db close

#tags
