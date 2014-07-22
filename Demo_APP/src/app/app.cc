#include "app.hh"
#include "foo/foo.hh"
#include "bar/bar.h"
#include "version/version.hh"

#include <iostream>
using namespace std;

int App::main( int argc, char **argv ) {
	Foo f;
	f.p();
	bar_p();
	cout << "main in app component, version: " << APP_VERSION << endl;
	return 0;
}
