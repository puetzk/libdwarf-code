Created 26 April 2019 
Updated 28 April 2019

The configure script scripts/FIX-COMPILE-TIMES does not apply
to cmake. Don't bother to use it if you build with cmake.
The FIX-COMPILE-TIMES script is irrelevant to cmake.

The cmake build has been revised somewhat.  By default the
build builds just libdwarf and dwarfdump.

cmake testing is not enabled (for now). The testing only tests
various internal interfaces, not libdwarf interfaces. Neither
'make test' nor 'make install' have been verified to work
properly with Makefiles created by cmake (27 April 2019)

Lets assume the base directory of the the libdwarf source in a
directory named 'code' inside the directory '/path/to/' Always
arrange to issue the cmake command in an empty directory.
For example:

    mkdir /tmp/cmbld
    cd /tmp/cmbld
    cmake /path/to/code
    make

The above will build libdwarf (a static library, a libdwarf.a)
and dwarfdump (linking to that static library).  If there is
no libelf.h present during cmake/build then dwarfdump won't
read archives or honor requests to print elf headers.

To show all the available cmake options we'll show the
default build next:

    cmake -DDWARF_WITH_LIBELF=ON \
        -DBUILD_NON_SHARED=ON \
        -DBUILD_SHARED=OFF \
        -DBUILD_DWARFGEN=OFF \
        -DBUILD_DWARFEXAMPLE=OFF \
        -DWALL=OFF \
        -DDO_TESTING=OFF\
        -DHAVE_CUSTOM_LIBELF=OFF \
        -DHAVE_NONSTANDARD_PRINTF_64_FORMAT=OFF \
        -DHAVE_WINDOWS_PATH=OFF \
        -DHAVE_OLD_FRAME_CFA_COL=OFF \
        -DHAVE_SGI_IRIX_OFFSETS=OFF \
        -DHAVE_STRICT_DWARF2_32BIT_OFFSET=OFF \
        /path/to/code
    make

Ignore the -DHAVE_CUSTOM_LIBELF line, that option is not
intended for you :-) .

The options after -DHAVE_WINDOWS_PATH should not normally be
used, they are for testing old features and not relevant to
modern usage.


The short form, doing the same as the default:

    cmake /path/to/code
    make

The short form, nolibelf, for when you wish to build without
libelf even if libelf.h and libelf are present:

    cmake -DDWARF_WITH_LIBELF=OFF /path/to/code
    make

For this case any attempt to compile dwarfgen will be
overridden: dwarfgen requires libelf.

For dwarfexample:

    cmake -DBUILD_DWARFEXAMPLE=ON /path/to/code
    make

If libelf is missing -DBUILD_DWARFGEN=ON will not be honored
as dwarfgen will not build without libelf.

If you wish to run the selftests  (which just test
a few internal interfaces, not dwarfdump or libdwarf):

    cmake -DDO_TESTING=ON /path/to/code
    make
    ctest -N
    ctest -R self

In case one wishes to see the exact compilation/linking options
passed at compile time use
    make VERBOSE=1
instead of plain
    make

On Unix/Linux cmake 'make install' will install to
"/usr/local".  To set another install target set
CMAKE_INSTALL_PREFIX.  Example:

   mkdir /tmp/cmitest
   cmake -DCMAKE_INSTALL_PREFIX=/tmp/cmitest
   make install
