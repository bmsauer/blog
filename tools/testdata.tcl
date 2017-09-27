#!/usr/bin/tclsh

package require Tcl 8.6
package require tdbc::postgres

tdbc::postgres::connection create db -host {___BLOG_DB_HOSTNAME___} -user {___BLOG_DB_USERNAME___} -password {___BLOG_DB_PASSWORD___} -database {___BLOG_DB_DATABASE___}

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
