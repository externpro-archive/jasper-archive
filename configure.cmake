include(CheckCSourceCompiles)
include(CheckFunctionExists)
include(CheckIncludeFile)
include(CheckLibraryExists)
include(CheckSymbolExists)
include(CheckTypeSize)
########################################
function(set_define var)
  if(${ARGC} GREATER 1 AND ${var})
    set(DEFINE_${var} cmakedefine01 PARENT_SCOPE)
  else()
    set(DEFINE_${var} cmakedefine PARENT_SCOPE)
  endif()
  if(${var})
    set(JAS_TEST_DEFINES "${JAS_TEST_DEFINES} -D${var}" PARENT_SCOPE)
    set(CMAKE_REQUIRED_DEFINITIONS ${JAS_TEST_DEFINES} PARENT_SCOPE)
  endif(${var})
endfunction()
##########
macro(check_include_file_concat incfile var)
  check_include_file("${incfile}" ${var})
  set_define(${var} 1)
  if(${var})
    set(JAS_INCLUDES ${JAS_INCLUDES} ${incfile})
  endif(${var})
endmacro()
##########
macro(check_exists_define01 func var)
  if(UNIX)
    check_function_exists("${func}" ${var})
  else()
    check_symbol_exists("${func}" "${JAS_INCLUDES}" ${var})
  endif()
  set_define(${var} 1)
endmacro()
##########
macro(check_library_exists_concat lib symbol var)
  check_library_exists("${lib};${JAS_SYSTEM_LIBS}" ${symbol} "${CMAKE_LIBRARY_PATH}" ${var})
  set_define(${var} 1)
  if(${var})
    set(JAS_SYSTEM_LIBS ${lib} ${JAS_SYSTEM_LIBS})
    set(CMAKE_REQUIRED_LIBRARIES ${JAS_SYSTEM_LIBS})
  endif(${var})
endmacro()
########################################
check_include_file_concat(windows.h HAVE_WINDOWS_H)
check_include_file_concat(dlfcn.h HAVE_DLFCN_H)
check_include_file_concat(fcntl.h HAVE_FCNTL_H)
check_include_file_concat(inttypes.h HAVE_INTTYPES_H)
check_include_file_concat(io.h HAVE_IO_H)
check_include_file_concat(limits.h HAVE_LIMITS_H)
check_include_file_concat(memory.h HAVE_MEMORY_H)
check_include_file_concat(stdbool.h HAVE_STDBOOL_H)
check_include_file_concat(stddef.h HAVE_STDDEF_H)
check_include_file_concat(stdint.h HAVE_STDINT_H)
check_include_file_concat(stdlib.h HAVE_STDLIB_H)
check_include_file_concat(strings.h HAVE_STRINGS_H)
check_include_file_concat(string.h HAVE_STRING_H)
check_include_file_concat(sys/stat.h HAVE_SYS_STAT_H)
check_include_file_concat(sys/time.h HAVE_SYS_TIME_H)
check_include_file_concat(sys/types.h HAVE_SYS_TYPES_H)
check_include_file_concat(unistd.h HAVE_UNISTD_H)
##########
check_library_exists_concat(m log HAVE_LIBM)
##########
check_exists_define01(getrusage HAVE_GETRUSAGE)
check_exists_define01(gettimeofday HAVE_GETTIMEOFDAY)
check_exists_define01(vprintf HAVE_VPRINTF) #TODO: not used in code?
########################################
set(CMAKE_EXTRA_INCLUDE_FILES sys/types.h)
check_type_size(longlong SIZEOF_LONGLONG) # sets HAVE_SIZEOF_LONGLONG
check_type_size(size_t SIZEOF_SIZE_T) # sets HAVE_SIZEOF_SIZE_T
check_type_size(ssize_t SIZEOF_SSIZE_T) # sets HAVE_SIZEOF_SSIZE_T
check_type_size(uchar SIZEOF_UCHAR) # sets HAVE_SIZEOF_UCHAR
check_type_size(uint SIZEOF_UINT) # sets HAVE_SIZEOF_UINT
check_type_size(ulong SIZEOF_ULONG) # sets HAVE_SIZEOF_ULONG
check_type_size(ulonglong SIZEOF_ULONGLONG) # sets HAVE_SIZEOF_ULONGLONG
check_type_size(ushort SIZEOF_USHORT) # sets HAVE_SIZEOF_USHORT
set(CMAKE_EXTRA_INCLUDE_FILES)
##########
if(NOT HAVE_SIZEOF_LONGLONG)
  set(longlong "long long") # Define to `long long' if <sys/types.h> does not define.
endif()
if(NOT HAVE_SIZEOF_SIZE_T)
  set(size_t "unsigned") # Define to `unsigned' if <sys/types.h> does not define.
endif()
if(NOT HAVE_SIZEOF_SSIZE_T AND NOT WIN32) # TRICKY: don't define on Windows, see jas_config2.h
  set(ssize_t "int") # Define to `int' if <sys/types.h> does not define.
endif()
if(NOT HAVE_SIZEOF_UCHAR)
  set(uchar "unsigned char") # Define to `unsigned char' if <sys/types.h> does not define.
endif()
if(NOT HAVE_SIZEOF_UINT)
  set(uint "unsigned int") # Define to `unsigned int' if <sys/types.h> does not define.
endif()
if(NOT HAVE_SIZEOF_ULONG)
  set(ulong "unsigned long") # Define to `unsigned long' if <sys/types.h> does not define.
endif()
if(NOT HAVE_SIZEOF_ULONGLONG)
  set(ulonglong "unsigned long long") # Define to `unsigned long long' if <sys/types.h> does not define.
endif()
if(NOT HAVE_SIZEOF_USHORT)
  set(ushort "unsigned short") # Define to `unsigned short' if <sys/types.h> does not define.
endif()
########################################
# Name of package
file(STRINGS jasper.spec PACKAGE REGEX "^%define[\t ]+package_name[ \t]+.")
string(REGEX REPLACE "^%define[\t ]+package_name([ \t]+)" "" PACKAGE ${PACKAGE})
# Version number of package
file(STRINGS jasper.spec VERSION REGEX "^%define[\t ]+ver[ \t]+([0-9]+)\\.([0-9]+)\\.([0-9]+)?")
string(REGEX REPLACE "^%define[\t ]+ver([ \t]+)" "" VERSION ${VERSION})
set(JAS_VERSION ${VERSION})
# Define to the address where bug reports for this package should be sent.
set(PACKAGE_BUGREPORT "http://groups.yahoo.com/group/jasper-discussion")
# Define to the full name of this package.
set(PACKAGE_NAME ${PACKAGE})
# Define to the version of this package.
set(PACKAGE_VERSION ${VERSION})
# Define to the full name and version of this package.
set(PACKAGE_STRING "${PACKAGE} ${PACKAGE_VERSION}")
# Define to the one symbol short name of this package.
set(PACKAGE_TARNAME ${PACKAGE})
########################################
option(DEBUG "Extra debugging support" FALSE)
option(DEBUG_MEMALLOC "Debugging memory allocator" FALSE)
option(DEBUG_OVERFLOW "Debugging overflow detection" FALSE)
list(APPEND cmakedefine
  DEBUG
  DEBUG_MEMALLOC
  DEBUG_OVERFLOW
  )
########################################
# Define to 1 if you don't have `vprintf' but do have `_doprnt'.
if(NOT HAVE_VPRINTF)
check_c_source_compiles("
/* Define _doprnt to an innocuous variant, in case <limits.h> declares _doprnt.
   For example, HP-UX 11i <limits.h> declares gettimeofday.  */
#define _doprnt innocuous__doprnt

/* System header to define __stub macros and hopefully few prototypes,
    which can conflict with char _doprnt (); below.
    Prefer <limits.h> to <assert.h> if __STDC__ is defined, since
    <limits.h> exists even on freestanding compilers.  */

#ifdef __STDC__
# include <limits.h>
#else
# include <assert.h>
#endif

#undef _doprnt

/* Override any gcc2 internal prototype to avoid an error.  */
#ifdef __cplusplus
extern \"C\"
{
#endif
/* We use char because int might match the return type of a gcc2
   builtin and then its argument prototype would still apply.  */
char _doprnt ();
/* The GNU C library defines this for functions which it implements
    to always fail with ENOSYS.  Some functions are actually named
    something starting with __ and the normal name is an alias.  */
#if defined (__stub__doprnt) || defined (__stub____doprnt)
choke me
#else
char (*f) () = _doprnt;
#endif
#ifdef __cplusplus
}
#endif

int
main ()
{
return f != _doprnt;
  ;
  return 0;
}
" HAVE_DOPRNT # TODO: not used in code?
  )
endif()
list(APPEND cmakedefine01 HAVE_DOPRNT)
########################################
# Have variable length arrays
check_c_source_compiles("
int main()
{
  int n;
  int foo[n];
  ;
  return 0;
}
" HAVE_VLA
  )
list(APPEND cmakedefine01 HAVE_VLA)
########################################
set(JAS_CONFIGURE TRUE)
list(APPEND cmakedefine01 JAS_CONFIGURE)
########################################
# Define to 1 if you have the ANSI C header files.
set(STDC_HEADERS TRUE) #TODO: determine if true - only used in configure?
list(APPEND cmakedefine01 STDC_HEADERS)
########################################
# Define to 1 if the X Window System is missing or not being used.
set(X_DISPLAY_MISSING FALSE) #TODO: determine if false, not used in code?
list(APPEND cmakedefine01 X_DISPLAY_MISSING)
########################################
# Define to empty if `const' does not conform to ANSI C.
check_c_source_compiles("
int main()
{
#ifndef __cplusplus
  /* Ultrix mips cc rejects this sort of thing.  */
  typedef int charset[2];
  const charset cs = { 0, 0 };
  /* SunOS 4.1.1 cc rejects this.  */
  char const *const *pcpcc;
  char **ppc;
  /* NEC SVR4.0.2 mips cc rejects this.  */
  struct point {int x, y;};
  static struct point const zero = {0,0};
  /* AIX XL C 1.02.0.0 rejects this.
     It does not let you subtract one const X* pointer from another in
     an arm of an if-expression whose if-part is not a constant
     expression */
  const char *g = \"string\";
  pcpcc = &g + (g ? g-g : 0);
  /* HPUX 7.0 cc rejects these. */
  ++pcpcc;
  ppc = (char**) pcpcc;
  pcpcc = (char const *const *) ppc;
  { /* SCO 3.2v4 cc rejects this sort of thing.  */
    char tx;
    char *t = &tx;
    char const *s = 0 ? (char *) 0 : (char const *) 0;

    *t++ = 0;
    if (s) return 0;
  }
  { /* Someone thinks the Sun supposedly-ANSI compiler will reject this.  */
    int x[] = {25, 17};
    const int *foo = &x[0];
    ++foo;
  }
  { /* Sun SC1.0 ANSI compiler rejects this -- but not the above. */
    typedef const int *iptr;
    iptr p = 0;
    ++p;
  }
  { /* AIX XL C 1.02.0.0 rejects this sort of thing, saying
       \"k.c\", line 2.27: 1506-025 (S) Operand must be a modifiable lvalue. */
    struct s { int j; const int *ap[3]; } bx;
    struct s *b = &bx; b->j = 5;
  }
  { /* ULTRIX-32 V3.1 (Rev 9) vcc rejects this */
    const int foo = 10;
    if (!foo) return 0;
  }
  return !cs[0] && !zero.x;
#endif
  ;
  return 0;
}
" ANSI_CONST
  )
if(NOT ANSI_CONST)
  set(const empty)
endif()
list(APPEND cmakedefine const)
########################################
unset(inline)
########################################
foreach(var ${cmakedefine01})
  set_define(${var} 1)
endforeach()
foreach(var ${cmakedefine})
  set_define(${var})
endforeach()
########################################
configure_file(${CMAKE_SOURCE_DIR}/src/libjasper/include/jasper/jas_config.h.in .)
configure_file(${CMAKE_BINARY_DIR}/jas_config.h.in ${PROJECT_BINARY_DIR}/jasper/jas_config.h)
include_directories(${PROJECT_BINARY_DIR})
if(EXISTS ${CMAKE_SOURCE_DIR}/src/libjasper/include/jasper/jas_config.h)
  file(REMOVE ${CMAKE_SOURCE_DIR}/src/libjasper/include/jasper/jas_config.h)
endif()
################################################################################
set(CMAKE_REQUIRED_LIBRARIES)
set(CMAKE_REQUIRED_DEFINITIONS)
