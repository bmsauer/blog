#!/usr/bin/env tclsh8.6
package require Tcl 8.6
package require ncgi
package require tdbc::postgres
package require json

##global vars
::ncgi::parse
set output [list]
tdbc::postgres::connection create db -host localhost -user blog_user -password blog_user -database postgres

proc main {} {
    if { $::env(REQUEST_METHOD) == "POST" } {
	#create
	lappend output "create"
    } else {
	lappend output "method not allowed"
    }

    ::ncgi::header application/json
    puts [::ncgi::nvlist]
    foreach {line} $output {
	puts "$line"
    }
}

if { ![info exists _testing] } { #if _testing var not set, do main
    main
}
	
