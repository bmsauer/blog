#!/usr/bin/tclsh

package require Tcl 8.6
package require tdbc::postgres

#create user blog_user with password 'blog_user'
tdbc::postgres::connection create db -host {___BLOG_DB_HOSTNAME___} -user {___BLOG_DB_USERNAME___} -password {___BLOG_DB_PASSWORD___} -database {___BLOG_DB_DATABASE___}

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

