PROJECT_DIR := ep1a

.PHONY: html cpp

html:
	cd $(PROJECT_DIR) && lime test html5 -verbose -clean -debug

cpp:
	cd $(PROJECT_DIR) && lime test cpp -verbose -clean -debug
