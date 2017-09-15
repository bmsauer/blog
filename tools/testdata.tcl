#!/usr/bin/tclsh

package require Tcl 8.6
package require tdbc::postgres

tdbc::postgres::connection create db -host localhost -user blog_user -password blog_user -database postgres

for { set i 0 } { $i < 3 } {incr i} {
    set content "hello world $i"
    set stmt [db prepare {INSERT INTO blog_posts (content, date) VALUES (:content, CURRENT_TIMESTAMP)}]
    if { [catch { set res [$stmt execute] } err ] } {
	puts "could not add record: $err"
    }
    $stmt close
    after 1000
}
