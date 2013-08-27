
DEBUG_FLAGS:=+-O0 -g -j0
RELEASE_FLAGS:=+-O2
WIN_FLAGS:=-v -I/usr/local/include -L/usr/local/lib --gc=dynamic

win32-debug: johnq.res
	rock -v ${DEBUG_FLAGS} ${WIN_FLAGS}

win32-release: johnq.res
	rock -v ${RELEASE_FLAGS} ${WIN_FLAGS}

johnq.res:
	windres -i johnq.rc -o johnq.res -O coff

clean:
	rm -f johnq johnq.exe johnq.res
	rock -x

.PHONY: clean
