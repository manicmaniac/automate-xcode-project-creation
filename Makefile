DEPLOYMENT_TARGET := '11.0'
GITIGNORE_URL := 'https://raw.githubusercontent.com/github/gitignore/master/Swift.gitignore'
REPOSITORY_NAME := 'product-name'
PRODUCT_NAME := 'ProductName'
XCODE_APP_NAME := 'Xcode'
ORGANIZATION_NAME := 'Example Ltd.'
ORGANIZATION_IDENTIFIER := 'com.example'

.PHONY: all build clean

all: build

build: $(REPOSITORY_NAME)

clean:
	$(RM) -R '$(REPOSITORY_NAME)'

$(REPOSITORY_NAME):
	osascript create-project.applescript '$(XCODE_APP_NAME)' '$(PRODUCT_NAME)' '$(ORGANIZATION_NAME)' '$(ORGANIZATION_IDENTIFIER)' '.'
	mv '$(PRODUCT_NAME)' '$@'
	perl -pi -e 's/(?<=IPHONEOS_DEPLOYMENT_TARGET = )[0-9.]+/$(DEPLOYMENT_TARGET)/g' '$@/$(PRODUCT_NAME).xcodeproj/project.pbxproj'
	perl -pi -e 's/(?<=CODE_SIGN_STYLE = )Automatic/Manual/g' '$@/$(PRODUCT_NAME).xcodeproj/project.pbxproj'
	curl -o '$@/.gitignore' '$(GITIGNORE_URL)'
	$(RM) -R '$@/.git'
	git init '$@'
