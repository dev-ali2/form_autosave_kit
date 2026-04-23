SHELL := /bin/zsh

.PHONY: help pub-get format analyze analyze-root analyze-example test test-coverage publish-dry-run pana check update

help:
	@printf '%s\n' "Available targets:"
	@printf '%s\n' "  make pub-get          Install package dependencies for root and example"
	@printf '%s\n' "  make format           Check formatting with dart format"
	@printf '%s\n' "  make analyze          Run root and example static analysis"
	@printf '%s\n' "  make test             Run package tests"
	@printf '%s\n' "  make test-coverage    Run tests with coverage"
	@printf '%s\n' "  make publish-dry-run  Run pub.dev publish validation"
	@printf '%s\n' "  make pana             Run pana pub points scoring"
	@printf '%s\n' "  make check            Run the full pre-publish check suite"
	@printf '%s\n' "  make update           Bump version, run checks, add changelog section"

pub-get:
	flutter pub get
	cd example && flutter pub get

format:
	dart format --output=none --set-exit-if-changed .

analyze-root:
	flutter analyze

analyze-example:
	cd example && flutter analyze

analyze: analyze-root analyze-example

test:
	flutter test

test-coverage:
	flutter test --coverage

publish-dry-run:
	flutter pub publish --dry-run

pana:
	@command -v pana >/dev/null 2>&1 || dart pub global activate pana
	@command -v pana >/dev/null 2>&1 && pana . || dart pub global run pana .

check: pub-get format analyze test publish-dry-run

update:
	@current_version=$$(awk '/^version:/ {print $$2; exit}' pubspec.yaml); \
	if [[ -z "$$current_version" ]]; then echo "Could not find version in pubspec.yaml"; exit 1; fi; \
	base_version=$${current_version%%+*}; \
	IFS='.' read -r major minor patch <<< "$$base_version"; \
	if [[ -z "$$major" || -z "$$minor" || -z "$$patch" ]]; then echo "Unsupported version format: $$current_version"; exit 1; fi; \
	bump_type=$${BUMP:-patch}; \
	case "$$bump_type" in \
	  major) major=$$((major + 1)); minor=0; patch=0 ;; \
	  minor) minor=$$((minor + 1)); patch=0 ;; \
	  patch) patch=$$((patch + 1)) ;; \
	  *) echo "Invalid BUMP=$$bump_type. Use major, minor, or patch."; exit 1 ;; \
	esac; \
	new_version="$$major.$$minor.$$patch"; \
	sed -i '' -E "s/^version: .*/version: $$new_version/" pubspec.yaml; \
	echo "Version bumped: $$current_version -> $$new_version"; \
	$(MAKE) check; \
	if grep -q "^## \[$$new_version\] - " CHANGELOG.md; then \
	  echo "CHANGELOG already has section for $$new_version"; \
	else \
	  today=$$(date +%Y-%m-%d); \
	  tmp_file=$$(mktemp); \
	  awk -v v="$$new_version" -v d="$$today" 'BEGIN {inserted=0} {print $$0} !inserted && $$0 ~ /^## \[Unreleased\]/ {print ""; print "## [" v "] - " d; print ""; inserted=1}' CHANGELOG.md > "$$tmp_file"; \
	  mv "$$tmp_file" CHANGELOG.md; \
	  echo "Added CHANGELOG section for $$new_version"; \
	fi; \
	echo "Update workflow completed. Write changelog details under $$new_version before publishing."