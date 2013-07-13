OCAMLFIND_CONF:=C:\\OCaml\\etc\\findlib.conf
OCAMLLIB=c:\\OCaml\\lib
PATH:=/cygdrive/c/OCaml/bin:${PATH}
SDK:="/cygdrive/c/Program Files/Microsoft SDKs/Windows/v7.0/Bin"

all:
	ocamlc -g -c -o windows.o -cclib -lshell32 "${SRCDIR}/windows.c"
	ocamlc -g -c -o windows.cmo "${SRCDIR}/windows.ml"
	ocamlmklib -o windows windows.cmo windows.o
	OCAMLFIND_CONF="${OCAMLFIND_CONF}" ocamlfind ocamlopt -w +a-4 -o runenv.exe -linkpkg -package yojson,unix "${SRCDIR}/runenv.ml"
	${SDK}/mt.exe -nologo -manifest "${SRCDIR}\\runenv.exe.manifest" -outputresource:"runenv.exe;#1"
	ocaml "${SRCDIR}/test.ml"

	cp dllwindows.dll runenv.exe "${DISTDIR}/"
