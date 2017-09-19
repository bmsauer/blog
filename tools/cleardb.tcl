#!/usr/bin/tclsh

package require Tcl 8.6
package require tdbc::postgres

puts -nonewline {This will remove data from the db, continue? [Y/n]: }
flush stdout
set confirm [gets stdin]
if { $confirm != "Y" } { exit }


# posts
tdbc::postgres::connection create db -host localhost -user blog_user -password blog_user -database postgres

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
