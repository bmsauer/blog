Personal Blog Software

Tech:
- Postgresql database
- UI in backbone.js
- Backend TCL CGI scripts
- Make for building scripts and targets

Setup:
1) Setup a postgres instance, su to postgres, run psql, create database blog:
  CREATE DATABASE blog
2) Create blog_user account:
  CREATE USERE blog_user WITH PASSWORD 'xxxx'
3) Copy blogconfig.ini.template to <ENV>_blogconfig.ini, where <ENV> is the
   environment you want to build.  Then copy env.template to <ENV>_env.sh.
   Fill out the values.  The env.sh file is for the UI and general setup.
   blogconfig.ini is for the backend service to use when running.
4) Copy blogconfig.ini.template to tools/tools_blogconfig.ini and fill out.
   This copy is for running tools, which you can run on local or remote
   databases.

Building:
1) Source <ENV>_env.sh to shell, then run
   make build
   This will create a dist_<ENV> folder with the built files.

Running:
1) Copy the backend services to their CGI folder, and the UI to a webserver.
   Their ability to connect should be setup in the env and config files.

Tools:
1) Tools can clear the database, setup a new database tables, and inject test
data.
2) cd to the tools folder, and run tclsh <tool file>.

Testing:
1) Create an environment called test, with test_env.sh and test_blogconfig.ini.
2) Make sure tools have a config file (see above).
3) Set the config file path and tcl-cgi paths to ../blogconfig.ini and ../tcl-cgi.tcl
4) Build with make build
5) cd into dist_test/tests
6) run ./all.tcl
