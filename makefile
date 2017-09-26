SHELL = /bin/bash

BUILD_DIR = dist_$$BLOG_BUILD_NAME
build:
	- mkdir $(BUILD_DIR)
	cp post.tcl $(BUILD_DIR)
	cp postw.tcl $(BUILD_DIR)
	cp -R tools $(BUILD_DIR)/tools/
	cp -R tests $(BUILD_DIR)/tests/
	cp -R blog-ui $(BUILD_DIR)/blog-ui/

	#tcl files
	find $(BUILD_DIR) -name '*.tcl' -exec sed -i "s/___BLOG_DB_HOSTNAME___/$$BLOG_DB_HOSTNAME/g" {} \;
	find $(BUILD_DIR) -name '*.tcl' -exec sed -i "s/___BLOG_DB_DATABASE___/$$BLOG_DB_DATABASE/g" {} \;
	find $(BUILD_DIR) -name '*.tcl' -exec sed -i "s/___BLOG_DB_USERNAME___/$$BLOG_DB_USERNAME/g" {} \;	
	find $(BUILD_DIR) -name '*.tcl' -exec sed -i "s/___BLOG_DB_PASSWORD___/$$BLOG_DB_PASSWORD/g" {} \;
	#js files
	find $(BUILD_DIR) -name '*.js' -exec sed -i "s|___BLOG_API_BASE___|$$BLOG_API_BASE|g" {} \;

clean:
	rm -rf $(BUILD_DIR)

deploy-local:
	sudo cp $(BUILD_DIR)/post.tcl /usr/lib/cgi-bin/
	sudo cp $(BUILD_DIR)/post.tcl /usr/lib/cgi-bin/
	sudo cp -R $(BUILD_DIR)/blog-ui /var/www/blog-ui/
