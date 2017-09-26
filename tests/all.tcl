#!/usr/bin/env tclsh8.6
package require tcltest

source ../tools/cleardb.tcl
source ../tools/setupdb.tcl
source ../tools/testdata.tcl

tcltest::runAllTests
