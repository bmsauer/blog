SHELL = /bin/bash

BUILD_DIR = dist_$$BLOG_BUILD_NAME
#Escape special chars from password, for sed
REPLACE_PASSWORD = $$(echo $$BLOG_DB_PASSWORD | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')
build:
	- mkdir $(BUILD_DIR)
	cp post.tcl $(BUILD_DIR)
	cp postw.tcl $(BUILD_DIR)
	cp bcgi.tcl $(BUILD_DIR)
	cp -R tools $(BUILD_DIR)/tools/
	cp -R tests $(BUILD_DIR)/tests/
	cp -R blog-ui $(BUILD_DIR)/blog-ui/

	#tcl files
	find $(BUILD_DIR) -name '*.tcl' -exec sed -i "s/___BLOG_DB_HOSTNAME___/$$BLOG_DB_HOSTNAME/g" {} \;
	find $(BUILD_DIR) -name '*.tcl' -exec sed -i "s/___BLOG_DB_DATABASE___/$$BLOG_DB_DATABASE/g" {} \;
	find $(BUILD_DIR) -name '*.tcl' -exec sed -i "s/___BLOG_DB_USERNAME___/$$BLOG_DB_USERNAME/g" {} \;	
	find $(BUILD_DIR) -name '*.tcl' -exec sed -i "s/___BLOG_DB_PASSWORD___/$(REPLACE_PASSWORD)/g" {} \;
	#js files
	find $(BUILD_DIR) -name '*.js' -exec sed -i "s|___BLOG_UI_POSTW_URL___|$$BLOG_UI_POSTW_URL|g" {} \;
	find $(BUILD_DIR) -name '*.js' -exec sed -i "s|___BLOG_UI_POST_URL___|$$BLOG_UI_POST_URL|g" {} \;

clean:
	rm -rf $(BUILD_DIR)

deploy-local:
	sudo cp $(BUILD_DIR)/post.tcl /usr/lib/cgi-bin/
	sudo cp $(BUILD_DIR)/postw.tcl /usr/lib/cgi-bin/
	sudo cp $(BUILD_DIR)/bcgi.tcl /usr/lib/cgi-bin/
	sudo cp -R $(BUILD_DIR)/blog-ui /var/www

deploy-local-ui:
	sudo cp -R $(BUILD_DIR)/blog-ui /var/www
