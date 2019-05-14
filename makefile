SHELL = /bin/bash

BUILD_DIR = dist_$$BLOG_BUILD_NAME

build:
	- mkdir $(BUILD_DIR)
	cp post.tcl $(BUILD_DIR)
	cp postw.tcl $(BUILD_DIR)
	cp tcl-cgi.tcl $(BUILD_DIR)
	cp $${BLOG_BUILD_NAME}_blogconfig.ini $(BUILD_DIR)/blogconfig.ini
	cp -RT tools $(BUILD_DIR)/tools/
	cp -RT tests $(BUILD_DIR)/tests/
	cp -RT blog-ui $(BUILD_DIR)/blog-ui/

	#tcl files
	find $(BUILD_DIR) -name '*.tcl' -exec sed -i "s|___CONFIG_FILE_PATH___|$$CONFIG_FILE_PATH|g" {} \;
	#js files
	find $(BUILD_DIR) -name '*.js' -exec sed -i "s|___BLOG_UI_POSTW_URL___|$$BLOG_UI_POSTW_URL|g" {} \;
	find $(BUILD_DIR) -name '*.js' -exec sed -i "s|___BLOG_UI_POST_URL___|$$BLOG_UI_POST_URL|g" {} \;

clean:
	rm -rf $(BUILD_DIR)

clean-all:
	rm -rf dist_*

deploy-local:
	sudo cp $(BUILD_DIR)/post.tcl /usr/lib/cgi-bin/blog/
	sudo cp $(BUILD_DIR)/postw.tcl /usr/lib/cgi-bin/blog/
	sudo cp $(BUILD_DIR)/tcl-cgi.tcl /usr/lib/cgi-bin/files/
	sudo cp $(BUILD_DIR)/blogconfig.ini /usr/lib/cgi-bin/files/
	sudo cp -R $(BUILD_DIR)/blog-ui /var/www
