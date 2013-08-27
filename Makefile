
DEBUG_FLAGS:=+-O0 -g -j0
RELEASE_FLAGS:=+-O2
WIN_FLAGS:=-v -I/usr/local/include -L/usr/local/lib --gc=dynamic

win32-debug: johnq.res
	rock -v ${DEBUG_FLAGS} ${WIN_FLAGS}

win32-release: johnq.res
	rock -v ${RELEASE_FLAGS} ${WIN_FLAGS}

linux64:
	PATH=${PATH}:~/Dev/prefix64/bin rock -v +-Wl,-rpath=bin/libs64/ -I${HOME}/Dev/prefix64/include -L${HOME}/Dev/prefix64/lib -o=johnq64 ${RELEASE_FLAGS}

linux32:
	PATH=${PATH}:~/Dev/prefix32/bin rock -v +-Wl,-rpath=bin/libs32/ -I${HOME}/Dev/prefix32/include -L${HOME}/Dev/prefix32/lib -o=johnq32 ${RELEASE_FLAGS}

johnq.res:
	windres -i johnq.rc -o johnq.res -O coff

clean:
	rm -f johnq johnq.exe johnq.res
	rock -x

.PHONY: clean
