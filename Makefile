VENV_DIR=.devenv
BIN_DIR=$(VENV_DIR)/bin
PYTHON=$(BIN_DIR)/python
PIP=$(BIN_DIR)/pip

dev-env-up:
	@rm -rf $(VENV_DIR)
	@python3 -m venv $(VENV_DIR)
	@echo "Environment created at $(VENV_DIR)"

dev-env-clean:
	@echo "Uninstalling environment packages..."
	@$(PYTHON) setup.py develop -u
	@$(PIP) freeze | xargs $(PIP) uninstall -y
	@echo "Environment packages uninstalled"

dev-env-install: dev-env-clean
	@echo "Installing packages..."
	@$(PIP) install --upgrade pip setuptools wheel
	@$(PIP) install -e .[dev]
	@echo "Environment packages installed"

dev-run:
	@$(BIN_DIR)/platformsapp --forwarded-secret foo || true

dev-test:
	@$(BIN_DIR)/pytest
