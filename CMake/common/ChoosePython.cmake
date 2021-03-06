##
## Copyright (c) 2012-2015 Cajal Blue Brain, BBP/EPFL
## All rights reserved. Do not distribute without permission.
##
## Responsible Author: Juan Hernando Vieites (JHV)
## contact: jhernando@fi.upm.es

# This script provides an option to choose which Python version should be
# requested to FindPythonInterp and FindPythonLibs. The user can choose
# between version 2, 3 or autodetection (the default). If
# CHOOSE_PYTHON_REQUIRE_BOOST is set, autodetection will choose Python 3 only
# if Boost.Python is found to have support for Python 3.
#
# Input Variables:
# * CHOOSE_PYTHON_REQUIRE_BOOST
#
# Output Variables:
# * ${PROJECT_NAME}_USE_PYTHON3: Set to 1 if and only if Python 3 is chosen.
# * ${PROJECT_NAME}_USE_BOOST_PYTHON_VERSION: Equals 3 if Python 3 is choosen,
#     empty string otherwise
# * PYTHON_LIBRARY_SUFFIX: The suffix path where Python site packages are
#     to be installed for the chosen Python version.
# * PythonLibs_FIND_VERSION
#   PythonInter_FIND_VERSION: Variables used by Python find scripts as input.
#     Set to 2 or 3 depending on the version chosen.
#
# Input/output varaibles:
# * USE_PYTHON_VERSION: (input/output), the Python version chosen. At return it
#   can only be 2 or 3.
#
# Defines:
# * -D${PROJECT_NAME}_USE_PYTHON3=1: If Python 3 is chosen.

include(FindBoostConfig) # Including the workarounds for boost finders.

set(USE_PYTHON_VERSION "auto" CACHE STRING
  "Choose the required Python version (2, 3 or auto).")

set_property(CACHE USE_PYTHON_VERSION PROPERTY STRINGS 2 3 auto)

if(NOT PYTHONINTERP_FOUND AND ${USE_PYTHON_VERSION} STREQUAL auto)
  find_package(PythonInterp 3 QUIET)
  if(CHOOSE_PYTHON_REQUIRE_BOOST)
    find_package(Boost COMPONENTS python3 QUIET)
  endif()

  if(PYTHONINTERP_FOUND AND (NOT CHOOSE_PYTHON_REQUIRE_BOOST OR Boost_FOUND))
    set(USE_PYTHON_VERSION 3)
    message(STATUS "Python 3 chosen automatically")
  else()
    set(USE_PYTHON_VERSION 2)
    message(STATUS "Python 2 chosen automatically")
  endif()
endif()

if(${USE_PYTHON_VERSION} STREQUAL 3)
  set(${PROJECT_NAME}_USE_PYTHON3 ON)
  # Enforcing a Python version to be searched by scripts included by
  # Common.cmake that search for Python (e.g. cpplint)
  set(PYTHON_ADDITIONAL_VERSIONS 3.4 3.3 3.2)
  set(Python_ADDITIONAL_VERSIONS 3.4 3.3 3.2)
  set(PythonLibs_FIND_VERSION 3)
  set(PythonInterp_FIND_VERSION 3)
  add_definitions(-D${PROJECT_NAME}_USE_PYTHON3=1)
  set(${PROJECT_NAME}_USE_BOOST_PYTHON_VERSION 3)
  # This shouldn't be necessary but helps detecting the Python libs
  # provided by the module python/3.2-rhel6-x86_64
  if(DEFINED ENV{PYTHON_LIBRARY})
    # find_path is called twice using these variables as input and output.
    # If the variables are not set as CACHE variables the second call to
    # file_path fails for no apparent reason except that the variables have
    # been marked as advanced by FindPythonLibs.cmake
    set(PYTHON_LIBRARY $ENV{PYTHON_LIBRARY} CACHE FILEPATH "")
    set(PYTHON_INCLUDE_DIR  $ENV{PYTHON_INCLUDE_DIR} CACHE PATH "")
  endif()
else()
  set(PythonLibs_FIND_VERSION 2)
  set(PythonInterp_FIND_VERSION 2)
endif()

execute_process(COMMAND
  ${PYTHON_EXECUTABLE} -c "from distutils.sysconfig import get_python_lib; print(get_python_lib(1,0,prefix=''))"
  OUTPUT_VARIABLE PYTHON_LIBRARY_SUFFIX OUTPUT_STRIP_TRAILING_WHITESPACE)
message(STATUS "Python package suffix path: ${PYTHON_LIBRARY_SUFFIX}")
