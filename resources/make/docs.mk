DOCS_DIR = $(ROOT_DIR)/docs
REPO = $(shell git config --get remote.origin.url)
DOCS_BUILD_DIR = $(DOCS_DIR)/build
DOCS_PROD_DIR = $(DOCS_DIR)/master
CURRENT = $(DOCS_PROD_DIR)/current
DOCS_GIT_HACK = $(DOCS_DIR)/.git
LOCAL_DOCS_HOST = localhost
LOCAL_DOCS_PORT = 5099

.PHONY: docs

$(DOCS_GIT_HACK):
	-@ln -s $(ROOT_DIR)/.git $(DOCS_DIR)

clean-docs:
	@rm -rf $(CURRENT)

pre-docs:
	@echo "\nBuilding docs ...\n"

gen-docs:
	@echo "Generating docs ..."
	@mkdir -p $(CURRENT)
	@cp -r $(DOCS_DIR)/source/* $(CURRENT)

local-docs: pre-docs gen-docs

docs: clean-docs local-docs

devdocs: docs
	@echo
	@echo "Running docs server on http://$(LOCAL_DOCS_HOST):$(LOCAL_DOCS_PORT) ... (To quit, hit ^c twice)"
	@echo
	@erl -s inets -noshell -eval 'inets:start(httpd,[{server_name,"devdocs"},{document_root, "$(CURRENT)"},{server_root, "$(CURRENT)"},{port, $(LOCAL_DOCS_PORT)},{mime_types,[{"html","text/html"},{"htm","text/html"},{"js","text/javascript"},{"css","text/css"},{"gif","image/gif"},{"jpg","image/jpeg"},{"jpeg","image/jpeg"},{"png","image/png"}]}]).'

prod-docs: clean-docs $(DOCS_GIT_HACK) local-docs

setup-temp-repo: $(DOCS_GIT_HACK)
	@echo "\nSetting up temporary git repos for gh-pages ...\n"
	@rm -rf $(DOCS_PROD_DIR)/.git $(DOCS_PROD_DIR)/*/.git
	@cd $(DOCS_PROD_DIR) && git init
	@cd $(DOCS_PROD_DIR) && git add * > /dev/null
	@cd $(DOCS_PROD_DIR) && git commit -a -m "Generated content." > /dev/null

teardown-temp-repo:
	@echo "\nTearing down temporary gh-pages repos ..."
	@rm $(DOCS_DIR)/.git
	@rm -rf $(DOCS_PROD_DIR)/.git $(DOCS_PROD_DIR)/*/.git

publish-docs: prod-docs setup-temp-repo
	@echo "\nPublishing docs ...\n"
	@cd $(DOCS_PROD_DIR) && git push -f $(REPO) master:gh-pages
	@make teardown-temp-repo
