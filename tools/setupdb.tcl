#!/usr/bin/tclsh

package require Tcl 8.6
package require tdbc::postgres

#create user blog_user with password 'blog_user'

tdbc::postgres::connection create db -host localhost -user blog_user -password blog_user -database postgres

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

