APP_FILES=$(shell find . -type f -name '*.lua')

wit: lit $(APP_FILES)
	./lit make

clean:
	rm -rf wit lit*

lit:
	curl -L https://github.com/luvit/lit/raw/0.10.4/get-lit.sh | sh
