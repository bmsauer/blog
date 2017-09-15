#!/usr/bin/tclsh

package require Tcl 8.6
package require tdbc::postgres

puts -nonewline {This will remove data from the db, continue? [Y/n]: }
flush stdout
set confirm [gets stdin]
if { $confirm != "Y" } { exit }

tdbc::postgres::connection create db -host localhost -user blog_user -password blog_user -database postgres

set stmt [db prepare {DELETE from blog_posts}]
if { [catch { set res [$stmt execute] } err ] } {
    puts "could not delete data: $err"
}
$stmt close


set stmt [db prepare {ALTER SEQUENCE blog_posts_id_seq RESTART WITH 1}]
if { [catch { set res [$stmt execute] } err ] } {
    puts "could not reset sequence: $err"
}
$stmt close
