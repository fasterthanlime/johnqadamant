
DEBUG_FLAGS:=+-O0 -g
RELEASE_FLAGS:=+-O2
WIN_FLAGS:=-v -j0 -I/usr/local/include -L/usr/local/lib --gc=dynamic

win32-debug:
	rock -v ${DEBUG_FLAGS} ${WIN_FLAGS}

win32-release:
	rock -v ${RELEASE_FLAGS} ${WIN_FLAGS}
