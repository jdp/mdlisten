OUT=mdlisten

$(OUT): main.m QueryListener.m
	clang $^ -Wall -Werror -fmodules -mmacosx-version-min=10.6 -o $@

clean:
	-rm $(OUT)

.PHONY: clean
