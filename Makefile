mdlisten: main.m
	clang $^ -Wall -Werror -fmodules -mmacosx-version-min=10.6 -o $@
