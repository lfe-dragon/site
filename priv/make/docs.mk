SITE_DIR = $(ROOT_DIR)/site
LANDING_DIR = $(SITE_DIR)/landing-source
DOCS_DIR = $(SITE_DIR)/docs-source
DOCS_BUILD_DIR = $(DOCS_DIR)/build
SITE_PROD_DIR = $(SITE_DIR)/master
DOCS_PROD_DIR = $(SITE_PROD_DIR)/docs
CURRENT = $(DOCS_PROD_DIR)/current
DOCS_GIT_HACK = $(SITE_DIR)/.git
LOCAL_DOCS_HOST = localhost
LOCAL_DOCS_PORT = 5099

docs: clean-docs local-docs

.PHONY: docs

$(DOCS_GIT_HACK):
	-@ln -s $(ROOT_DIR)/.git $(SITE_DIR)

docs-setup:
	@echo "\nInstalling and setting up dependencies ..."
	@cd $(DOCS_DIR) && bundle install

clean-docs:
	@rm -rf $(CURRENT)
	@rm -rf site/master/css
	@rm -rf site/master/img
	@rm -rf site/master/js
	@rm -f site/master/index.html
	@rm -rf site/master/fonts
	@rm -rf site/master/font-awesome

pre-docs:
	@echo "\nBuilding docs ...\n"

gen-landing:
	@echo "Generating landing page ..."
	@mkdir -p $(CURRENT)
	@cp -r $(LANDING_DIR)/* $(SITE_PROD_DIR)/
	@rm $(SITE_PROD_DIR)/img/*.xcf

gen-docs:
	@echo "Generating docs ..."
	@cd $(DOCS_DIR) && bundle exec middleman build --clean --verbose
	@mkdir -p $(CURRENT)
	@cp -r $(DOCS_BUILD_DIR)/* $(CURRENT)/
	@rm site/master/LICENSE

local-docs: pre-docs gen-landing gen-docs

devdocs: docs
	@echo
	@echo "Running docs server on http://$(LOCAL_DOCS_HOST):$(LOCAL_DOCS_PORT) ... (To quit, hit ^c twice)"
	@echo
	@erl -s inets -noshell -eval 'inets:start(httpd,[{server_name,"devdocs"},{document_root, "$(SITE_PROD_DIR)"},{server_root, "$(SITE_PROD_DIR)"},{port, $(LOCAL_DOCS_PORT)},{mime_types,[{"html","text/html"},{"htm","text/html"},{"js","text/javascript"},{"css","text/css"},{"gif","image/gif"},{"jpg","image/jpeg"},{"jpeg","image/jpeg"},{"png","image/png"}]}]).'

prod-docs: clean-docs $(DOCS_GIT_HACK) local-docs

setup-temp-repo: $(DOCS_GIT_HACK)
	@echo "\nSetting up temporary git repos for gh-pages ...\n"
	@rm -rf $(SITE_PROD_DIR)/.git $(SITE_PROD_DIR)/*/.git
	@cd $(SITE_PROD_DIR) && git init
	@cd $(SITE_PROD_DIR) && git add * > /dev/null
	@cd $(SITE_PROD_DIR) && git commit -a -m "Generated content." > /dev/null

teardown-temp-repo:
	@echo "\nTearing down temporary gh-pages repos ..."
	@rm $(SITE_DIR)/.git
	@rm -rf $(SITE_PROD_DIR)/.git $(SITE_PROD_DIR)/*/.git

publish-docs: prod-docs setup-temp-repo
	@echo "\nPublishing docs ...\n"
	@cd $(SITE_PROD_DIR) && git push -f $(REPO) master:gh-pages
	@make teardown-temp-repo
