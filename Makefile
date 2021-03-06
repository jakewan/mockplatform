PACKAGE_NAME=mockplatform

DEV_VENV_DIR=.devenv
DEV_BIN_DIR=$(DEV_VENV_DIR)/bin
DEV_PYTHON=$(DEV_BIN_DIR)/python
DEV_PIP=$(DEV_BIN_DIR)/pip
DEV_APP=$(DEV_BIN_DIR)/$(PACKAGE_NAME)

PROD_VENV_DIR=.prodenv
PROD_BIN_DIR=$(PROD_VENV_DIR)/bin
PROD_PYTHON=$(PROD_BIN_DIR)/python
PROD_PIP=$(PROD_BIN_DIR)/pip
PROD_APP=$(PROD_BIN_DIR)/$(PACKAGE_NAME)

dev-env-destroy:
	@rm -rf $(DEV_VENV_DIR)

dev-env-create: dev-env-destroy
	@python3 -m venv $(DEV_VENV_DIR)
	@echo "Environment created at $(DEV_VENV_DIR)"

dev-env-clean:
	@echo "Uninstalling environment packages..."
	@$(DEV_PYTHON) setup.py develop -u
	@$(DEV_PIP) freeze | xargs $(DEV_PIP) uninstall -y
	@echo "Environment packages uninstalled"

dev-update-build-tools:
	@echo "Updating build tools..."
	@$(DEV_PIP) install --upgrade pip setuptools wheel twine
	@echo "Build tools updated"

dev-env-install: dev-env-clean dev-update-build-tools
	@echo "Installing packages..."
	@$(DEV_PIP) install -e .[dev]
	@echo "Environment packages installed"

dev-run:
	@$(DEV_APP) --forwarded-secret foo || true

dev-test:
	@$(DEV_BIN_DIR)/pytest

dev-check-setup:
	@$(DEV_PYTHON) setup.py check

clean-build-dirs:
	@rm -rf ./build ./dist ./*egg-info

generate-dist-packages: dev-update-build-tools clean-build-dirs
	@echo "Generating distribution packages..."
	@$(DEV_PYTHON) setup.py sdist bdist_wheel

upload-to-pypi-test:
	@$(DEV_PYTHON) -m twine upload --repository testpypi dist/*

upload-to-pypi-prod:
	@$(DEV_PYTHON) -m twine upload dist/*

prod-env-destroy:
	@rm -rf $(PROD_VENV_DIR)

prod-env-create: prod-env-destroy
	@python3 -m venv $(PROD_VENV_DIR)
	@echo "Environment created at $(PROD_VENV_DIR)"
	@echo "Installing packages..."
	@$(PROD_PIP) install --upgrade pip setuptools wheel
	@$(PROD_PIP) install .
	@echo "Environment packages installed"

prod-run:
	@$(PROD_APP) --forwarded-secret foo || true
