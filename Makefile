export BIN_DIR=.
export BIN_NAME=smartparking

build:
	GOOS=linux GOARCH=amd64 go build -o $(BIN_DIR)/$(BIN_NAME)

config: build
	$(BIN_DIR)/$(BIN_NAME) config

run: config
	$(BIN_DIR)/$(BIN_NAME) start

migrate: config
	$(BIN_DIR)/$(BIN_NAME) migrate

deploy: build
	ssh $(USER)@$(HOST) "echo $(PASS) sudo -S systemctl stop $(BIN_NAME) && rm -rf /home/$(USER)/$(BIN_NAME)"
	scp $(BIN_DIR)/$(BIN_NAME) $(USER)@$(HOST):/home/$(USER)
	ssh $(USER)@$(HOST) "echo $(PASS) sudo -S systemctl start $(BIN_NAME)"
