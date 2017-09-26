#!/usr/bin/tclsh

package require Tcl 8.6
package require tdbc::postgres

puts -nonewline {This will remove data from the db at ___BLOG_DB_HOSTNAME___, continue? [Y/n]: }
flush stdout
set confirm [gets stdin]
if { $confirm != "Y" } { exit }


# posts
tdbc::postgres::connection create db -host ___BLOG_DB_HOSTNAME___ -user ___BLOG_DB_USERNAME___ -password ___BLOG_DB_PASSWORD___ -database ___BLOG_DB_DATABASE___

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
