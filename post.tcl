#!/usr/bin/env tclsh8.6
package require Tcl 8.6
package require ncgi
package require tdbc::postgres
package require json::write

## global vars
::ncgi::parse
set output [list]
tdbc::postgres::connection create db -host localhost -user blog_user -password blog_user -database postgres

## procs
proc get_post {id} {
    set stmt [db prepare {SELECT id, content, date from blog_posts WHERE id = :id}]
    try {
	set res [$stmt execute]
	try {
	    set rows [$res allrows]
	} finally {
	    $res close
	}
    } finally {
	$stmt close
    }
    if { [llength $rows] > 0 } {
	set record [lindex $rows 0]
	set result [json::write object \
			id [json::write string [lindex $record 1] ] \
			content [json::write string [lindex $record 3] ] \
			date [json::write string [lindex $record 5]]\
		       ]
	return $result
    } else {
	set result [json::write object \
			error [json::write string "post with id $id not found"]
		    ]
	return $result
    }
}

proc get_all {} {
    set stmt [db prepare {SELECT id, content, date from blog_posts}]
    try {
	set res [$stmt execute]
	try {
	    set rows [$res allrows]
	} finally {
	    $res close
	}
    } finally {
	$stmt close
    }
    if { [llength $rows] > 0 } {
	set result_rows [list]
	foreach {row} $rows {
	    set post [json::write object \
			    id [json::write string [lindex $row 1] ] \
			    content [json::write string [lindex $row 3] ] \
			    date [json::write string [lindex $row 5]]\
			 ]
	    lappend result_rows $post
	}
	set result [json::write object posts [json::write array {*}$result_rows] ]
	return $result
    } else {
	set result [json::write object \
			error [json::write string "posts not found"]
		    ]
	return $result
    }
}

proc main {} {
    if { $::env(REQUEST_METHOD) == "GET" } {
	set id [::ncgi::value id]
	if { $id == ""} {
	    lappend output [get_all]
	} else {
	    lappend output [get_post $id]
	}
    } else {
	lappend output "method not allowed"
    }

    ::ncgi::header
    foreach {line} $output {
	puts "$line"
    }
}

if { ![info exists _testing] } { #if _testing var not set, do main
    main
}
	
