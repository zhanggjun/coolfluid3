# - Try to find Boost include dirs and libraries
# Usage of this module as follows:
#
# NOTE: Take note of the Boost_ADDITIONAL_VERSIONS variable below.
# Due to Boost naming conventions and limitations in CMake this find
# module is NOT future safe with respect to Boost version numbers,
# and may break.
#
# == Using Header-Only libraries from within Boost: ==
#
#   find_package( Boost 1.36.0 )
#   if(Boost_FOUND)
#      include_directories(${Boost_INCLUDE_DIRS})
#      add_executable(foo foo.cc)
#   endif()
#
#
# == Using actual libraries from within Boost: ==
#
#   set(Boost_USE_STATIC_LIBS   ON)
#   set(Boost_USE_MULTITHREADED ON)
#   find_package( Boost 1.36.0 COMPONENTS date_time filesystem system ... )
#
#   if(Boost_FOUND)
#      include_directories(${Boost_INCLUDE_DIRS})
#      add_executable(foo foo.cc)
#      target_link_libraries(foo ${Boost_LIBRARIES})
#   endif()
#
#
# The components list needs to contain actual names of boost libraries only,
# such as "date_time" for "libboost_date_time".  If you're using parts of
# Boost that contain header files only (e.g. foreach) you do not need to
# specify COMPONENTS.
#
# You should provide a minimum version number that should be used. If you provide this
# version number and specify the REQUIRED attribute, this module will fail if it
# can't find the specified or a later version. If you specify a version number this is
# automatically put into the considered list of version numbers and thus doesn't need
# to be specified in the Boost_ADDITIONAL_VERSIONS variable (see below).
#
# NOTE for Visual Studio Users:
#     Automatic linking is used on MSVC & Borland compilers by default when
#     #including things in Boost.  It's important to note that setting
#     Boost_USE_STATIC_LIBS to OFF is NOT enough to get you dynamic linking,
#     should you need this feature.  Automatic linking typically uses static
#     libraries with a few exceptions (Boost.Python is one).
#
#     Please see the section below near Boost_LIB_DIAGNOSTIC_DEFINITIONS for
#     more details.  Adding a TARGET_LINK_LIBRARIES() as shown in the example
#     above appears to cause VS to link dynamically if Boost_USE_STATIC_LIBS
#     gets set to OFF.  It is suggested you avoid automatic linking since it
#     will make your application less portable.
#
# =========== The mess that is Boost_ADDITIONAL_VERSIONS (sorry?) ============
#
# OK, so the Boost_ADDITIONAL_VERSIONS variable can be used to specify a list of
# boost version numbers that should be taken into account when searching
# for Boost. Unfortunately boost puts the version number into the
# actual filename for the libraries, so this variable will certainly be needed
# in the future when new Boost versions are released.
#
# Currently this module searches for the following version numbers:
# 1.33, 1.33.0, 1.33.1, 1.34, 1.34.0, 1.34.1, 1.35, 1.35.0, 1.35.1,
# 1.36, 1.36.0, 1.36.1, 1.37, 1.37.0, 1.38, 1.38.0, 1.39, 1.39.0,
# 1.40, 1.40.0
#
# NOTE: If you add a new major 1.x version in Boost_ADDITIONAL_VERSIONS you should
# add both 1.x and 1.x.0 as shown above.  Official Boost include directories
# omit the 3rd version number from include paths if it is 0 although not all
# binary Boost releases do so.
#
# set(Boost_ADDITIONAL_VERSIONS "1.78" "1.78.0" "1.79" "1.79.0")
#
# ===================================== ============= ========================
#
# Variables used by this module, they can change the default behaviour and
# need to be set before calling find_package:
#
#   Boost_USE_MULTITHREADED      Can be set to OFF to use the non-multithreaded
#                                boost libraries.  If not specified, defaults
#                                to ON.
#
#   Boost_USE_STATIC_LIBS        Can be set to ON to force the use of the static
#                                boost libraries. Defaults to OFF.
#
# Other Variables used by this module which you may want to set.
#
#   Boost_ADDITIONAL_VERSIONS    A list of version numbers to use for searching
#                                the boost include directory.  Please see
#                                the documentation above regarding this
#                                annoying, but necessary variable :(
#
#   Boost_DEBUG                  Set this to TRUE to enable debugging output
#                                of FindBoost.cmake if you are having problems.
#                                Please enable this before filing any bug
#                                reports.
#
#   Boost_DETAILED_FAILURE_MSG   FindBoost doesn't output detailed information
#                                about why it failed or how to fix the problem
#                                unless this is set to TRUE or the REQUIRED
#                                keyword is specified in find_package().
#                                  [Since CMake 2.8.0]
#
#   Boost_COMPILER               Set this to the compiler suffix used by Boost
#                                (e.g. "-gcc43") if FindBoost has problems finding
#                                the proper Boost installation
#
# These last three variables are available also as environment variables:
#
#   BOOST_ROOT or BOOSTROOT      The preferred installation prefix for searching for
#                                Boost.  Set this if the module has problems finding
#                                the proper Boost installation.
#
#   BOOST_INCLUDEDIR             Set this to the include directory of Boost, if the
#                                module has problems finding the proper Boost installation
#
#   BOOST_LIBRARYDIR             Set this to the lib directory of Boost, if the
#                                module has problems finding the proper Boost installation
#
# Variables defined by this module:
#
#   Boost_FOUND                         System has Boost, this means the include dir was
#                                       found, as well as all the libraries specified in
#                                       the COMPONENTS list.
#
#   Boost_INCLUDE_DIRS                  Boost include directories: not cached
#
#   Boost_INCLUDE_DIR                   This is almost the same as above, but this one is
#                                       cached and may be modified by advanced users
#
#   Boost_LIBRARIES                     Link to these to use the Boost libraries that you
#                                       specified: not cached
#
#   Boost_LIBRARY_DIRS                  The path to where the Boost library files are.
#
#   Boost_VERSION                       The version number of the boost libraries that
#                                       have been found, same as in version.hpp from Boost
#
#   Boost_LIB_VERSION                   The version number in filename form as
#                                       it's appended to the library filenames
#
#   Boost_MAJOR_VERSION                 major version number of boost
#   Boost_MINOR_VERSION                 minor version number of boost
#   Boost_SUBMINOR_VERSION              subminor version number of boost
#
#   Boost_LIB_DIAGNOSTIC_DEFINITIONS    [WIN32 Only] You can call
#                                       add_definitions(${Boost_LIB_DIAGNOSTIC_DEFINITIONS})
#                                       to have diagnostic information about Boost's
#                                       automatic linking outputted during compilation time.
#
# For each component you specify in find_package(), the following (UPPER-CASE)
# variables are set.  You can use these variables if you would like to pick and
# choose components for your targets instead of just using Boost_LIBRARIES.
#
#   Boost_${COMPONENT}_FOUND            True IF the Boost library "component" was found.
#
#   Boost_${COMPONENT}_LIBRARY          Contains the libraries for the specified Boost
#                                       "component" (includes debug and optimized keywords
#                                       when needed).

#=============================================================================
# Copyright 2006-2009 Kitware, Inc.
# Copyright 2006-2008 Andreas Schneider <mail@cynapses.org>
# Copyright 2007      Wengo
# Copyright 2007      Mike Jackson
# Copyright 2008      Andreas Pakulat <apaku@gmx.de>
# Copyright 2008-2009 Philip Lowman <philip@yhbt.com>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distributed this file outside of CMake, substitute the full
#  License text for the above reference.)

#-------------------------------------------------------------------------------
#  FindBoost functions & macros
#
############################################
#
# Check the existence of the libraries.
#
############################################
# This macro was taken directly from the FindQt4.cmake file that is included
# with the CMake distribution. This is NOT my work. All work was done by the
# original authors of the FindQt4.cmake file. Only minor modifications were
# made to remove references to Qt and make this file more generally applicable
# And ELSE/ENDIF pairs were removed for readability.
#########################################################################

macro (_Boost_ADJUST_LIB_VARS basename)
  if(Boost_INCLUDE_DIR )
    if(Boost_${basename}_LIBRARY_DEBUG AND Boost_${basename}_LIBRARY_RELEASE)
      # if the generator supports configuration types then set
      # optimized and debug libraries, or if the CMAKE_BUILD_TYPE has a value
      if(CMAKE_CONFIGURATION_TYPES OR CMAKE_BUILD_TYPE)
        set(Boost_${basename}_LIBRARY optimized ${Boost_${basename}_LIBRARY_RELEASE} debug ${Boost_${basename}_LIBRARY_DEBUG})
      else()
        # if there are no configuration types and CMAKE_BUILD_TYPE has no value
        # then just use the release libraries
        set(Boost_${basename}_LIBRARY ${Boost_${basename}_LIBRARY_RELEASE} )
      endif()
      # FIXME: This probably should be set for both cases
      set(Boost_${basename}_LIBRARIES optimized ${Boost_${basename}_LIBRARY_RELEASE} debug ${Boost_${basename}_LIBRARY_DEBUG})
    endif()

    # if only the release version was found, set the debug variable also to the release version
    if(Boost_${basename}_LIBRARY_RELEASE AND NOT Boost_${basename}_LIBRARY_DEBUG)
      set(Boost_${basename}_LIBRARY_DEBUG ${Boost_${basename}_LIBRARY_RELEASE})
      set(Boost_${basename}_LIBRARY       ${Boost_${basename}_LIBRARY_RELEASE})
      set(Boost_${basename}_LIBRARIES     ${Boost_${basename}_LIBRARY_RELEASE})
    endif()

    # if only the debug version was found, set the release variable also to the debug version
    if(Boost_${basename}_LIBRARY_DEBUG AND NOT Boost_${basename}_LIBRARY_RELEASE)
      set(Boost_${basename}_LIBRARY_RELEASE ${Boost_${basename}_LIBRARY_DEBUG})
      set(Boost_${basename}_LIBRARY         ${Boost_${basename}_LIBRARY_DEBUG})
      set(Boost_${basename}_LIBRARIES       ${Boost_${basename}_LIBRARY_DEBUG})
    endif()

    if(Boost_${basename}_LIBRARY)
      set(Boost_${basename}_LIBRARY ${Boost_${basename}_LIBRARY} CACHE FILEPATH "The Boost ${basename} library")

      # Remove superfluous "debug" / "optimized" keywords from
      # Boost_LIBRARY_DIRS
      foreach(_boost_my_lib ${Boost_${basename}_LIBRARY})
        GET_FILENAME_COMPONENT(_boost_my_lib_path "${_boost_my_lib}" PATH)
        list(APPEND Boost_LIBRARY_DIRS ${_boost_my_lib_path})
      endforeach()
      list(REMOVE_DUPLICATES Boost_LIBRARY_DIRS)

      set(Boost_LIBRARY_DIRS ${Boost_LIBRARY_DIRS} CACHE FILEPATH "Boost library directory")
      set(Boost_${basename}_FOUND ON CACHE INTERNAL "Whether the Boost ${basename} library found")
    endif(Boost_${basename}_LIBRARY)

  endif(Boost_INCLUDE_DIR )
  # Make variables changeble to the advanced user
  mark_as_advanced(
      Boost_${basename}_LIBRARY
      Boost_${basename}_LIBRARY_RELEASE
      Boost_${basename}_LIBRARY_DEBUG
  )
endmacro (_Boost_ADJUST_LIB_VARS)

#-------------------------------------------------------------------------------

#
# Runs compiler with "-dumpversion" and parses major/minor
# version with a regex.
#
FUNCTION(_Boost_COMPILER_DUMPVERSION _OUTPUT_VERSION)

  EXEC_PROGRAM(${CMAKE_CXX_COMPILER}
    ARGS ${CMAKE_CXX_COMPILER_ARG1} -dumpversion
    OUTPUT_VARIABLE _boost_COMPILER_VERSION
  )
 string(REGEX REPLACE "([0-9])\\.([0-9])(\\.[0-9])?" "\\1\\2"
    _boost_COMPILER_VERSION ${_boost_COMPILER_VERSION})

  set(${_OUTPUT_VERSION} ${_boost_COMPILER_VERSION} PARENT_SCOPE)
ENDFUNCTION()

#
# End functions/macros
#
#-------------------------------------------------------------------------------




if(NOT DEFINED Boost_USE_MULTITHREADED)
    set(Boost_USE_MULTITHREADED TRUE)
endif()

if(Boost_FIND_VERSION_EXACT)
  # The version may appear in a directory with or without the patch
  # level, even when the patch level is non-zero.
  set(_boost_TEST_VERSIONS
    "${Boost_FIND_VERSION_MAJOR}.${Boost_FIND_VERSION_MINOR}.${Boost_FIND_VERSION_PATCH}"
    "${Boost_FIND_VERSION_MAJOR}.${Boost_FIND_VERSION_MINOR}")
else(Boost_FIND_VERSION_EXACT)
  # The user has not requested an exact version.  Among known
  # versions, find those that are acceptable to the user request.
  set(_Boost_KNOWN_VERSIONS ${Boost_ADDITIONAL_VERSIONS}
    "1.40.0" "1.40" "1.39.0" "1.39" "1.38.0" "1.38" "1.37.0" "1.37"
    "1.36.1" "1.36.0" "1.36" "1.35.1" "1.35.0" "1.35" "1.34.1" "1.34.0"
    "1.34" "1.33.1" "1.33.0" "1.33")
  set(_boost_TEST_VERSIONS)
  if(Boost_FIND_VERSION)
    set(_Boost_FIND_VERSION_SHORT "${Boost_FIND_VERSION_MAJOR}.${Boost_FIND_VERSION_MINOR}")
    # Select acceptable versions.
    foreach(version ${_Boost_KNOWN_VERSIONS})
      if(NOT "${version}" VERSION_LESS "${Boost_FIND_VERSION}")
        # This version is high enough.
        list(APPEND _boost_TEST_VERSIONS "${version}")
      elseif("${version}.99" VERSION_EQUAL "${_Boost_FIND_VERSION_SHORT}.99")
        # This version is a short-form for the requested version with
        # the patch level dropped.
        list(APPEND _boost_TEST_VERSIONS "${version}")
      endif()
    endforeach(version)
  else(Boost_FIND_VERSION)
    # Any version is acceptable.
    set(_boost_TEST_VERSIONS "${_Boost_KNOWN_VERSIONS}")
  endif(Boost_FIND_VERSION)
endif(Boost_FIND_VERSION_EXACT)

# The reason that we failed to find Boost. This will be set to a
# user-friendly message when we fail to find some necessary piece of
# Boost.
set(Boost_ERROR_REASON)

set( _boost_IN_CACHE TRUE)
if(Boost_INCLUDE_DIR)

  # On versions < 1.35, remove the System library from the considered list
  # since it wasn't added until 1.35.
  if(Boost_VERSION AND Boost_FIND_COMPONENTS)
     math(EXPR _boost_maj "${Boost_VERSION} / 100000")
     math(EXPR _boost_min "${Boost_VERSION} / 100 % 1000")
     if(${_boost_maj}.${_boost_min} VERSION_LESS 1.35)
       list(REMOVE_ITEM Boost_FIND_COMPONENTS system)
     endif()
  endif()

  foreach(COMPONENT ${Boost_FIND_COMPONENTS})
   string(TOUPPER ${COMPONENT} COMPONENT)
    if(NOT Boost_${COMPONENT}_FOUND)
      set( _boost_IN_CACHE FALSE)
    endif(NOT Boost_${COMPONENT}_FOUND)
  endforeach(COMPONENT)
ELSE(Boost_INCLUDE_DIR)
  set( _boost_IN_CACHE FALSE)
endif(Boost_INCLUDE_DIR)

if(_boost_IN_CACHE)
  # in cache already
  set(Boost_FOUND TRUE)
  foreach(COMPONENT ${Boost_FIND_COMPONENTS})
   string(TOUPPER ${COMPONENT} COMPONENT)
    _Boost_ADJUST_LIB_VARS( ${COMPONENT} )
    set(Boost_LIBRARIES ${Boost_LIBRARIES} ${Boost_${COMPONENT}_LIBRARY})
  endforeach(COMPONENT)
  set(Boost_INCLUDE_DIRS ${Boost_INCLUDE_DIR})
  if(Boost_VERSION AND NOT "${Boost_VERSION}" STREQUAL "0")
    math(EXPR Boost_MAJOR_VERSION "${Boost_VERSION} / 100000")
    math(EXPR Boost_MINOR_VERSION "${Boost_VERSION} / 100 % 1000")
    math(EXPR Boost_SUBMINOR_VERSION "${Boost_VERSION} % 100")
  endif(Boost_VERSION AND NOT "${Boost_VERSION}" STREQUAL "0")
  if(Boost_DEBUG)
      message(STATUS "[ ${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE} ] "
                     "boost ${Boost_MAJOR_VERSION}.${Boost_MINOR_VERSION}.${Boost_SUBMINOR_VERSION} "
                     "is already in the cache.  For debugging messages, please clear the cache.")
  endif()
ELSE (_boost_IN_CACHE)
  # Need to search for boost
  if(Boost_DEBUG)
    message(STATUS "[ ${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE} ] "
                   "Boost not in cache")
    # Output some of their choices
    message(STATUS "[ ${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE} ] "
                   "_boost_TEST_VERSIONS = ${_boost_TEST_VERSIONS}")
    message(STATUS "[ ${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE} ] "
                   "Boost_USE_MULTITHREADED = ${Boost_USE_MULTITHREADED}")
    message(STATUS "[ ${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE} ] "
                   "Boost_USE_STATIC_LIBS = ${Boost_USE_STATIC_LIBS}")
  endif()

  if(WIN32)
    # In windows, automatic linking is performed, so you do not have
    # to specify the libraries.  If you are linking to a dynamic
    # runtime, then you can choose to link to either a static or a
    # dynamic Boost library, the default is to do a static link.  You
    # can alter this for a specific library "whatever" by defining
    # BOOST_WHATEVER_DYN_LINK to force Boost library "whatever" to be
    # linked dynamically.  Alternatively you can force all Boost
    # libraries to dynamic link by defining BOOST_ALL_DYN_LINK.

    # This feature can be disabled for Boost library "whatever" by
    # defining BOOST_WHATEVER_NO_LIB, or for all of Boost by defining
    # BOOST_ALL_NO_LIB.

    # If you want to observe which libraries are being linked against
    # then defining BOOST_LIB_DIAGNOSTIC will cause the auto-linking
    # code to emit a #pragma message each time a library is selected
    # for linking.
    set(Boost_LIB_DIAGNOSTIC_DEFINITIONS
      "-DBOOST_LIB_DIAGNOSTIC" CACHE STRING "Boost diagnostic define")
  endif(WIN32)

  set(_boost_INCLUDE_SEARCH_DIRS
    C:/boost/include
    C:/boost
    "$ENV{ProgramFiles}/boost/include"
    "$ENV{ProgramFiles}/boost"
    /sw/local/include
  )

  # If BOOST_ROOT was defined in the environment, use it.
  if(NOT BOOST_ROOT AND NOT $ENV{BOOST_ROOT} STREQUAL "")
    set(BOOST_ROOT $ENV{BOOST_ROOT})
  endif(NOT BOOST_ROOT AND NOT $ENV{BOOST_ROOT} STREQUAL "")

  # If BOOSTROOT was defined in the environment, use it.
  if(NOT BOOST_ROOT AND NOT $ENV{BOOSTROOT} STREQUAL "")
    set(BOOST_ROOT $ENV{BOOSTROOT})
  endif(NOT BOOST_ROOT AND NOT $ENV{BOOSTROOT} STREQUAL "")

  # If BOOST_INCLUDEDIR was defined in the environment, use it.
  if( NOT $ENV{BOOST_INCLUDEDIR} STREQUAL "" )
    set(BOOST_INCLUDEDIR $ENV{BOOST_INCLUDEDIR})
  endif( NOT $ENV{BOOST_INCLUDEDIR} STREQUAL "" )

  # If BOOST_LIBRARYDIR was defined in the environment, use it.
  if( NOT $ENV{BOOST_LIBRARYDIR} STREQUAL "" )
    set(BOOST_LIBRARYDIR $ENV{BOOST_LIBRARYDIR})
  endif( NOT $ENV{BOOST_LIBRARYDIR} STREQUAL "" )

  if( BOOST_ROOT )
    file(TO_CMAKE_PATH ${BOOST_ROOT} BOOST_ROOT)
  endif( BOOST_ROOT )

  if(Boost_DEBUG)
    message(STATUS "[ ${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE} ] "
                   "Declared as CMake or Environmental Variables:")
    message(STATUS "[ ${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE} ] "
                   "  BOOST_ROOT = ${BOOST_ROOT}")
    message(STATUS "[ ${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE} ] "
                   "  BOOST_INCLUDEDIR = ${BOOST_INCLUDEDIR}")
    message(STATUS "[ ${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE} ] "
                   "  BOOST_LIBRARYDIR = ${BOOST_LIBRARYDIR}")
    message(STATUS "[ ${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE} ] "
                   "_boost_TEST_VERSIONS = ${_boost_TEST_VERSIONS}")
  endif()

  if( BOOST_ROOT )
    set(_boost_INCLUDE_SEARCH_DIRS
      ${BOOST_ROOT}/include
      ${BOOST_ROOT}
      ${_boost_INCLUDE_SEARCH_DIRS})
  endif( BOOST_ROOT )

  if( BOOST_INCLUDEDIR )
    file(TO_CMAKE_PATH ${BOOST_INCLUDEDIR} BOOST_INCLUDEDIR)
    set(_boost_INCLUDE_SEARCH_DIRS
      ${BOOST_INCLUDEDIR} ${_boost_INCLUDE_SEARCH_DIRS})
  endif( BOOST_INCLUDEDIR )

  # ------------------------------------------------------------------------
  #  Search for Boost include DIR
  # ------------------------------------------------------------------------
  # Try to find Boost by stepping backwards through the Boost versions
  # we know about.
  if( NOT Boost_INCLUDE_DIR )
    # Build a list of path suffixes for each version.
    set(_boost_PATH_SUFFIXES)
    foreach(_boost_VER ${_boost_TEST_VERSIONS})
      # Add in a path suffix, based on the required version, ideally
      # we could read this from version.hpp, but for that to work we'd
      # need to know the include dir already
      set(_boost_BOOSTIFIED_VERSION)

      # Transform 1.35 => 1_35 and 1.36.0 => 1_36_0
      if(_boost_VER MATCHES "[0-9]+\\.[0-9]+\\.[0-9]+")
         string(REGEX REPLACE "([0-9]+)\\.([0-9]+)\\.([0-9]+)" "\\1_\\2_\\3"
            _boost_BOOSTIFIED_VERSION ${_boost_VER})
      ELSEif(_boost_VER MATCHES "[0-9]+\\.[0-9]+")
         string(REGEX REPLACE "([0-9]+)\\.([0-9]+)" "\\1_\\2"
            _boost_BOOSTIFIED_VERSION ${_boost_VER})
      endif()

      list(APPEND _boost_PATH_SUFFIXES "boost-${_boost_BOOSTIFIED_VERSION}")
      if(WIN32)
        # For BoostPro's underscores (and others?)
        list(APPEND _boost_PATH_SUFFIXES "boost_${_boost_BOOSTIFIED_VERSION}")
      endif()

    endforeach(_boost_VER)

    if(Boost_DEBUG)
      message(STATUS "[ ${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE} ] "
                     "Include debugging info:")
      message(STATUS "[ ${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE} ] "
                     "  _boost_INCLUDE_SEARCH_DIRS = ${_boost_INCLUDE_SEARCH_DIRS}")
      message(STATUS "[ ${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE} ] "
                     "  _boost_PATH_SUFFIXES = ${_boost_PATH_SUFFIXES}")
    endif()

    # Look for a standard boost header file.
    find_path(Boost_INCLUDE_DIR
      NAMES         boost/config.hpp
      HINTS         ${_boost_INCLUDE_SEARCH_DIRS}
      PATH_SUFFIXES ${_boost_PATH_SUFFIXES}
      )
  endif( NOT Boost_INCLUDE_DIR )

  # ------------------------------------------------------------------------
  #  Extract version information from version.hpp
  # ------------------------------------------------------------------------

  if(Boost_INCLUDE_DIR)
    # Extract Boost_VERSION and Boost_LIB_VERSION from version.hpp
    # Read the whole file:
    #
    set(BOOST_VERSION 0)
    set(BOOST_LIB_VERSION "")
    file(READ "${Boost_INCLUDE_DIR}/boost/version.hpp" _boost_VERSION_HPP_CONTENTS)
    if(Boost_DEBUG)
      message(STATUS "[ ${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE} ] "
                     "location of version.hpp: ${Boost_INCLUDE_DIR}/boost/version.hpp")
    endif()

   string(REGEX REPLACE ".*#define BOOST_VERSION ([0-9]+).*" "\\1" Boost_VERSION "${_boost_VERSION_HPP_CONTENTS}")
   string(REGEX REPLACE ".*#define BOOST_LIB_VERSION \"([0-9_]+)\".*" "\\1" Boost_LIB_VERSION "${_boost_VERSION_HPP_CONTENTS}")

    set(Boost_LIB_VERSION ${Boost_LIB_VERSION} CACHE INTERNAL "The library version string for boost libraries")
    set(Boost_VERSION ${Boost_VERSION} CACHE INTERNAL "The version number for boost libraries")

    if(NOT "${Boost_VERSION}" STREQUAL "0")
      math(EXPR Boost_MAJOR_VERSION "${Boost_VERSION} / 100000")
      math(EXPR Boost_MINOR_VERSION "${Boost_VERSION} / 100 % 1000")
      math(EXPR Boost_SUBMINOR_VERSION "${Boost_VERSION} % 100")

      set(Boost_ERROR_REASON
          "${Boost_ERROR_REASON}Boost version: ${Boost_MAJOR_VERSION}.${Boost_MINOR_VERSION}.${Boost_SUBMINOR_VERSION}\nBoost include path: ${Boost_INCLUDE_DIR}")
    endif(NOT "${Boost_VERSION}" STREQUAL "0")
    if(Boost_DEBUG)
      message(STATUS "[ ${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE} ] "
                     "version.hpp reveals boost "
                     "${Boost_MAJOR_VERSION}.${Boost_MINOR_VERSION}.${Boost_SUBMINOR_VERSION}")
    endif()
  ELSE(Boost_INCLUDE_DIR)
    set(Boost_ERROR_REASON
      "${Boost_ERROR_REASON}Unable to find the Boost header files. Please set BOOST_ROOT to the root directory containing Boost or BOOST_INCLUDEDIR to the directory containing Boost's headers.")
  endif(Boost_INCLUDE_DIR)

  # ------------------------------------------------------------------------
  #  Suffix initialization and compiler suffix detection.
  # ------------------------------------------------------------------------

  # Setting some more suffixes for the library
  set(Boost_LIB_PREFIX "")
  if( WIN32 AND Boost_USE_STATIC_LIBS )
    set(Boost_LIB_PREFIX "lib")
  endif()

  if(Boost_COMPILER)
    set(_boost_COMPILER ${Boost_COMPILER})
    if(Boost_DEBUG)
      message(STATUS "[ ${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE} ] "
                     "using user-specified Boost_COMPILER = ${_boost_COMPILER}")
    endif()
  else(Boost_COMPILER)
    # Attempt to guess the compiler suffix
    # NOTE: this is not perfect yet, if you experience any issues
    # please report them and use the Boost_COMPILER variable
    # to work around the problems.
    if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel"
        OR "${CMAKE_CXX_COMPILER}" MATCHES "icl"
        OR "${CMAKE_CXX_COMPILER}" MATCHES "icpc")
      if(WIN32)
        set(_boost_COMPILER "-iw")
      else()
        set(_boost_COMPILER "-il")
      endif()
    elseif(MSVC90)
      set(_boost_COMPILER "-vc90")
    elseif(MSVC10)
      set(_boost_COMPILER "-vc100")
    elseif(MSVC80)
      set(_boost_COMPILER "-vc80")
    elseif(MSVC71)
      set(_boost_COMPILER "-vc71")
    elseif(MSVC70) # Good luck!
      set(_boost_COMPILER "-vc7") # yes, this is correct
    elseif(MSVC60) # Good luck!
      set(_boost_COMPILER "-vc6") # yes, this is correct
    elseif(BORLAND)
      set(_boost_COMPILER "-bcb")
    elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "SunPro")
      set(_boost_COMPILER "-sw")
    elseif(MINGW)
      if(${Boost_MAJOR_VERSION}.${Boost_MINOR_VERSION} VERSION_LESS 1.34)
          set(_boost_COMPILER "-mgw") # no GCC version encoding prior to 1.34
      else()
        _Boost_COMPILER_DUMPVERSION(_boost_COMPILER_VERSION)
        set(_boost_COMPILER "-mgw${_boost_COMPILER_VERSION}")
      endif()
    elseif(UNIX)
      if(CMAKE_COMPILER_IS_GNUCXX)
        if(${Boost_MAJOR_VERSION}.${Boost_MINOR_VERSION} VERSION_LESS 1.34)
          set(_boost_COMPILER "-gcc") # no GCC version encoding prior to 1.34
        else()
          _Boost_COMPILER_DUMPVERSION(_boost_COMPILER_VERSION)
          # Determine which version of GCC we have.
          if(APPLE)
            if(Boost_MINOR_VERSION)
              if(${Boost_MINOR_VERSION} GREATER 35)
                # In Boost 1.36.0 and newer, the mangled compiler name used
                # on Mac OS X/Darwin is "xgcc".
                set(_boost_COMPILER "-xgcc${_boost_COMPILER_VERSION}")
              else(${Boost_MINOR_VERSION} GREATER 35)
                # In Boost <= 1.35.0, there is no mangled compiler name for
                # the Mac OS X/Darwin version of GCC.
                set(_boost_COMPILER "")
              endif(${Boost_MINOR_VERSION} GREATER 35)
            ELSE(Boost_MINOR_VERSION)
              # We don't know the Boost version, so assume it's
              # pre-1.36.0.
              set(_boost_COMPILER "")
            endif(Boost_MINOR_VERSION)
          else()
            set(_boost_COMPILER "-gcc${_boost_COMPILER_VERSION}")
          endif()
        endif()
      endif(CMAKE_COMPILER_IS_GNUCXX)
    endif()
    if(Boost_DEBUG)
      message(STATUS "[ ${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE} ] "
        "guessed _boost_COMPILER = ${_boost_COMPILER}")
    endif()
  endif(Boost_COMPILER)

  set(_boost_MULTITHREADED "-mt")
  if( NOT Boost_USE_MULTITHREADED )
    set(_boost_MULTITHREADED "")
  endif()
  if(Boost_DEBUG)
    message(STATUS "[ ${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE} ] "
      "_boost_MULTITHREADED = ${_boost_MULTITHREADED}")
  endif()

  set( _boost_STATIC_TAG "")
  set( _boost_ABI_TAG "")
  if(WIN32)
    if(MSVC OR "${CMAKE_CXX_COMPILER}" MATCHES "icl"
            OR "${CMAKE_CXX_COMPILER}" MATCHES "icpc")
      set(_boost_ABI_TAG "g")
    endif()
    if( Boost_USE_STATIC_LIBS )
      set( _boost_STATIC_TAG "-s")
    endif( Boost_USE_STATIC_LIBS )
  endif(WIN32)
  set(_boost_ABI_TAG "${_boost_ABI_TAG}d")
  if(Boost_DEBUG)
    message(STATUS "[ ${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE} ] "
      "_boost_STATIC_TAG = ${_boost_STATIC_TAG}")
    message(STATUS "[ ${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE} ] "
      "_boost_ABI_TAG = ${_boost_ABI_TAG}")
  endif()

  # ------------------------------------------------------------------------
  #  Begin finding boost libraries
  # ------------------------------------------------------------------------

  set(_boost_LIBRARIES_SEARCH_DIRS
    ${Boost_INCLUDE_DIR}/lib
    ${Boost_INCLUDE_DIR}/../lib
    C:/boost/lib
    C:/boost
    "$ENV{ProgramFiles}/boost/boost_${Boost_MAJOR_VERSION}_${Boost_MINOR_VERSION}_${Boost_SUBMINOR_VERSION}/lib"
    "$ENV{ProgramFiles}/boost/boost_${Boost_MAJOR_VERSION}_${Boost_MINOR_VERSION}/lib"
    "$ENV{ProgramFiles}/boost/lib"
    "$ENV{ProgramFiles}/boost"
    /sw/local/lib
  )
  if( BOOST_ROOT )
    set(_boost_LIBRARIES_SEARCH_DIRS
      ${BOOST_ROOT}/lib
      ${BOOST_ROOT}/stage/lib
      ${_boost_LIBRARIES_SEARCH_DIRS})
  endif( BOOST_ROOT )

  if( BOOST_LIBRARYDIR )
    file(TO_CMAKE_PATH ${BOOST_LIBRARYDIR} BOOST_LIBRARYDIR)
    set(_boost_LIBRARIES_SEARCH_DIRS
      ${BOOST_LIBRARYDIR} ${_boost_LIBRARIES_SEARCH_DIRS})
  endif( BOOST_LIBRARYDIR )

  if(Boost_DEBUG)
    message(STATUS "[ ${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE} ] "
      "_boost_LIBRARIES_SEARCH_DIRS = ${_boost_LIBRARIES_SEARCH_DIRS}")
  endif()

  foreach(COMPONENT ${Boost_FIND_COMPONENTS})
   string(TOUPPER ${COMPONENT} UPPERCOMPONENT)
    set( Boost_${UPPERCOMPONENT}_LIBRARY "Boost_${UPPERCOMPONENT}_LIBRARY-NOTFOUND" )
    set( Boost_${UPPERCOMPONENT}_LIBRARY_RELEASE "Boost_${UPPERCOMPONENT}_LIBRARY_RELEASE-NOTFOUND" )
    set( Boost_${UPPERCOMPONENT}_LIBRARY_DEBUG "Boost_${UPPERCOMPONENT}_LIBRARY_DEBUG-NOTFOUND")

    # Support preference of static libs by adjusting CMAKE_find_library_SUFFIXES
    if( Boost_USE_STATIC_LIBS )
      set( _boost_ORIG_CMAKE_find_library_SUFFIXES ${CMAKE_find_library_SUFFIXES})
      if(WIN32)
        set(CMAKE_find_library_SUFFIXES .lib .a ${CMAKE_find_library_SUFFIXES})
      ELSE(WIN32)
        set(CMAKE_find_library_SUFFIXES .a ${CMAKE_find_library_SUFFIXES})
      endif(WIN32)
    endif( Boost_USE_STATIC_LIBS )

    find_library(Boost_${UPPERCOMPONENT}_LIBRARY_RELEASE
        NAMES  ${Boost_LIB_PREFIX}boost_${COMPONENT}${_boost_COMPILER}${_boost_MULTITHREADED}-${Boost_LIB_VERSION}
               ${Boost_LIB_PREFIX}boost_${COMPONENT}${_boost_COMPILER}${_boost_MULTITHREADED}${_boost_STATIC_TAG}-${Boost_LIB_VERSION}
               ${Boost_LIB_PREFIX}boost_${COMPONENT}${_boost_MULTITHREADED}-${Boost_LIB_VERSION}
               ${Boost_LIB_PREFIX}boost_${COMPONENT}${_boost_MULTITHREADED}${_boost_STATIC_TAG}-${Boost_LIB_VERSION}
               ${Boost_LIB_PREFIX}boost_${COMPONENT}${_boost_MULTITHREADED}
               ${Boost_LIB_PREFIX}boost_${COMPONENT}${_boost_MULTITHREADED}${_boost_STATIC_TAG}
               ${Boost_LIB_PREFIX}boost_${COMPONENT}
        HINTS  ${_boost_LIBRARIES_SEARCH_DIRS}
  NO_DEFAULT_PATH
    )

    find_library(Boost_${UPPERCOMPONENT}_LIBRARY_RELEASE
        NAMES  ${Boost_LIB_PREFIX}boost_${COMPONENT}${_boost_COMPILER}${_boost_MULTITHREADED}-${Boost_LIB_VERSION}
               ${Boost_LIB_PREFIX}boost_${COMPONENT}${_boost_COMPILER}${_boost_MULTITHREADED}${_boost_STATIC_TAG}-${Boost_LIB_VERSION}
               ${Boost_LIB_PREFIX}boost_${COMPONENT}${_boost_MULTITHREADED}-${Boost_LIB_VERSION}
               ${Boost_LIB_PREFIX}boost_${COMPONENT}${_boost_MULTITHREADED}${_boost_STATIC_TAG}-${Boost_LIB_VERSION}
               ${Boost_LIB_PREFIX}boost_${COMPONENT}${_boost_MULTITHREADED}
               ${Boost_LIB_PREFIX}boost_${COMPONENT}${_boost_MULTITHREADED}${_boost_STATIC_TAG}
               ${Boost_LIB_PREFIX}boost_${COMPONENT}
        HINTS  ${_boost_LIBRARIES_SEARCH_DIRS}
    )

    find_library(Boost_${UPPERCOMPONENT}_LIBRARY_DEBUG
        NAMES  ${Boost_LIB_PREFIX}boost_${COMPONENT}${_boost_COMPILER}${_boost_MULTITHREADED}-${_boost_ABI_TAG}-${Boost_LIB_VERSION}
               ${Boost_LIB_PREFIX}boost_${COMPONENT}${_boost_COMPILER}${_boost_MULTITHREADED}${_boost_STATIC_TAG}${_boost_ABI_TAG}-${Boost_LIB_VERSION}
               ${Boost_LIB_PREFIX}boost_${COMPONENT}${_boost_MULTITHREADED}-${_boost_ABI_TAG}-${Boost_LIB_VERSION}
               ${Boost_LIB_PREFIX}boost_${COMPONENT}${_boost_MULTITHREADED}${_boost_STATIC_TAG}${_boost_ABI_TAG}-${Boost_LIB_VERSION}
               ${Boost_LIB_PREFIX}boost_${COMPONENT}${_boost_MULTITHREADED}-${_boost_ABI_TAG}
               ${Boost_LIB_PREFIX}boost_${COMPONENT}${_boost_MULTITHREADED}${_boost_STATIC_TAG}${_boost_ABI_TAG}
               ${Boost_LIB_PREFIX}boost_${COMPONENT}-${_boost_ABI_TAG}
        HINTS  ${_boost_LIBRARIES_SEARCH_DIRS}
  NO_DEFAULT_PATH
    )

    find_library(Boost_${UPPERCOMPONENT}_LIBRARY_DEBUG
        NAMES  ${Boost_LIB_PREFIX}boost_${COMPONENT}${_boost_COMPILER}${_boost_MULTITHREADED}-${_boost_ABI_TAG}-${Boost_LIB_VERSION}
               ${Boost_LIB_PREFIX}boost_${COMPONENT}${_boost_COMPILER}${_boost_MULTITHREADED}${_boost_STATIC_TAG}${_boost_ABI_TAG}-${Boost_LIB_VERSION}
               ${Boost_LIB_PREFIX}boost_${COMPONENT}${_boost_MULTITHREADED}-${_boost_ABI_TAG}-${Boost_LIB_VERSION}
               ${Boost_LIB_PREFIX}boost_${COMPONENT}${_boost_MULTITHREADED}${_boost_STATIC_TAG}${_boost_ABI_TAG}-${Boost_LIB_VERSION}
               ${Boost_LIB_PREFIX}boost_${COMPONENT}${_boost_MULTITHREADED}-${_boost_ABI_TAG}
               ${Boost_LIB_PREFIX}boost_${COMPONENT}${_boost_MULTITHREADED}${_boost_STATIC_TAG}${_boost_ABI_TAG}
               ${Boost_LIB_PREFIX}boost_${COMPONENT}-${_boost_ABI_TAG}
        HINTS  ${_boost_LIBRARIES_SEARCH_DIRS}
    )

    _Boost_ADJUST_LIB_VARS(${UPPERCOMPONENT})
    if( Boost_USE_STATIC_LIBS )
      set(CMAKE_find_library_SUFFIXES ${_boost_ORIG_CMAKE_find_library_SUFFIXES})
    endif( Boost_USE_STATIC_LIBS )
  endforeach(COMPONENT)
  # ------------------------------------------------------------------------
  #  End finding boost libraries
  # ------------------------------------------------------------------------

  set(Boost_INCLUDE_DIRS
    ${Boost_INCLUDE_DIR}
  )

  set(Boost_FOUND FALSE)
  if(Boost_INCLUDE_DIR)
    set( Boost_FOUND TRUE )

    # Check the version of Boost against the requested version.
    if(Boost_FIND_VERSION AND NOT Boost_FIND_VERSION_MINOR)
      message(SEND_ERROR "When requesting a specific version of Boost, you must provide at least the major and minor version numbers, e.g., 1.34")
    endif(Boost_FIND_VERSION AND NOT Boost_FIND_VERSION_MINOR)
    if(Boost_MAJOR_VERSION LESS "${Boost_FIND_VERSION_MAJOR}" )
      set( Boost_FOUND FALSE )
      set(_Boost_VERSION_AGE "old")
    elseif(Boost_MAJOR_VERSION EQUAL "${Boost_FIND_VERSION_MAJOR}" )
      if(Boost_MINOR_VERSION LESS "${Boost_FIND_VERSION_MINOR}" )
        set( Boost_FOUND FALSE )
        set(_Boost_VERSION_AGE "old")
      elseif(Boost_MINOR_VERSION EQUAL "${Boost_FIND_VERSION_MINOR}" )
        if( Boost_FIND_VERSION_PATCH AND Boost_SUBMINOR_VERSION LESS "${Boost_FIND_VERSION_PATCH}" )
          set( Boost_FOUND FALSE )
          set(_Boost_VERSION_AGE "old")
        endif( Boost_FIND_VERSION_PATCH AND Boost_SUBMINOR_VERSION LESS "${Boost_FIND_VERSION_PATCH}" )
      endif( Boost_MINOR_VERSION LESS "${Boost_FIND_VERSION_MINOR}" )
    endif( Boost_MAJOR_VERSION LESS "${Boost_FIND_VERSION_MAJOR}" )

    if(Boost_FOUND AND Boost_FIND_VERSION_EXACT)
      # If the user requested an exact version of Boost, check
      # that. We already know that the Boost version we have is >= the
      # requested version.
      set(_Boost_VERSION_AGE "new")

      # If the user didn't specify a patchlevel, it's 0.
      if(NOT Boost_FIND_VERSION_PATCH)
        set(Boost_FIND_VERSION_PATCH 0)
      endif(NOT Boost_FIND_VERSION_PATCH)

      # We'll set Boost_FOUND true again if we have an exact version match.
      set(Boost_FOUND FALSE)
      if(Boost_MAJOR_VERSION EQUAL "${Boost_FIND_VERSION_MAJOR}" )
        if(Boost_MINOR_VERSION EQUAL "${Boost_FIND_VERSION_MINOR}" )
          if(Boost_SUBMINOR_VERSION EQUAL "${Boost_FIND_VERSION_PATCH}" )
            set( Boost_FOUND TRUE )
          endif(Boost_SUBMINOR_VERSION EQUAL "${Boost_FIND_VERSION_PATCH}" )
        endif( Boost_MINOR_VERSION EQUAL "${Boost_FIND_VERSION_MINOR}" )
      endif( Boost_MAJOR_VERSION EQUAL "${Boost_FIND_VERSION_MAJOR}" )
    endif(Boost_FOUND AND Boost_FIND_VERSION_EXACT)

    if(NOT Boost_FOUND)
      # State that we found a version of Boost that is too new or too old.
      set(Boost_ERROR_REASON
        "${Boost_ERROR_REASON}\nDetected version of Boost is too ${_Boost_VERSION_AGE}. Requested version was ${Boost_FIND_VERSION_MAJOR}.${Boost_FIND_VERSION_MINOR}")
      if(Boost_FIND_VERSION_PATCH)
        set(Boost_ERROR_REASON
          "${Boost_ERROR_REASON}.${Boost_FIND_VERSION_PATCH}")
      endif(Boost_FIND_VERSION_PATCH)
      if(NOT Boost_FIND_VERSION_EXACT)
        set(Boost_ERROR_REASON "${Boost_ERROR_REASON} (or newer)")
      endif(NOT Boost_FIND_VERSION_EXACT)
      set(Boost_ERROR_REASON "${Boost_ERROR_REASON}.")
    endif(NOT Boost_FOUND)

    if(Boost_FOUND)
      set(_boost_CHECKED_COMPONENT FALSE)
      set(_Boost_MISSING_COMPONENTS)
      foreach(COMPONENT ${Boost_FIND_COMPONENTS})
        string(TOUPPER ${COMPONENT} COMPONENT)
        set(_boost_CHECKED_COMPONENT TRUE)
        if(NOT Boost_${COMPONENT}_FOUND)
          string(TOLOWER ${COMPONENT} COMPONENT)
          list(APPEND _Boost_MISSING_COMPONENTS ${COMPONENT})
          set( Boost_FOUND FALSE)
        endif(NOT Boost_${COMPONENT}_FOUND)
      endforeach(COMPONENT)
    endif(Boost_FOUND)

    if(Boost_DEBUG)
      message(STATUS "[ ${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE} ] Boost_FOUND = ${Boost_FOUND}")
    endif()

    if(_Boost_MISSING_COMPONENTS)
      # We were unable to find some libraries, so generate a sensible
      # error message that lists the libraries we were unable to find.
      set(Boost_ERROR_REASON
        "${Boost_ERROR_REASON}\nThe following Boost libraries could not be found:\n")
      foreach(COMPONENT ${_Boost_MISSING_COMPONENTS})
        set(Boost_ERROR_REASON
          "${Boost_ERROR_REASON}        boost_${COMPONENT}\n")
      endforeach(COMPONENT)

      list(LENGTH Boost_FIND_COMPONENTS Boost_NUM_COMPONENTS_WANTED)
      list(LENGTH _Boost_MISSING_COMPONENTS Boost_NUM_MISSING_COMPONENTS)
      if(${Boost_NUM_COMPONENTS_WANTED} EQUAL ${Boost_NUM_MISSING_COMPONENTS})
        set(Boost_ERROR_REASON
          "${Boost_ERROR_REASON}No Boost libraries were found. You may need to set Boost_LIBRARYDIR to the directory containing Boost libraries or BOOST_ROOT to the location of Boost.")
      else (${Boost_NUM_COMPONENTS_WANTED} EQUAL ${Boost_NUM_MISSING_COMPONENTS})
        set(Boost_ERROR_REASON
          "${Boost_ERROR_REASON}Some (but not all) of the required Boost libraries were found. You may need to install these additional Boost libraries. Alternatively, set Boost_LIBRARYDIR to the directory containing Boost libraries or BOOST_ROOT to the location of Boost.")
      endif(${Boost_NUM_COMPONENTS_WANTED} EQUAL ${Boost_NUM_MISSING_COMPONENTS})
    endif(_Boost_MISSING_COMPONENTS)

    if( NOT Boost_LIBRARY_DIRS AND NOT _boost_CHECKED_COMPONENT )
      # Compatibility Code for backwards compatibility with CMake
      # 2.4's FindBoost module.

      # Look for the boost library path.
      # Note that the user may not have installed any libraries
      # so it is quite possible the Boost_LIBRARY_PATH may not exist.
      set(_boost_LIB_DIR ${Boost_INCLUDE_DIR})

      if("${_boost_LIB_DIR}" MATCHES "boost-[0-9]+")
        GET_FILENAME_COMPONENT(_boost_LIB_DIR ${_boost_LIB_DIR} PATH)
      endif("${_boost_LIB_DIR}" MATCHES "boost-[0-9]+")

      if("${_boost_LIB_DIR}" MATCHES "/include$")
        # Strip off the trailing "/include" in the path.
        GET_FILENAME_COMPONENT(_boost_LIB_DIR ${_boost_LIB_DIR} PATH)
      endif("${_boost_LIB_DIR}" MATCHES "/include$")

      if(EXISTS "${_boost_LIB_DIR}/lib")
        set(_boost_LIB_DIR ${_boost_LIB_DIR}/lib)
      ELSE(EXISTS "${_boost_LIB_DIR}/lib")
        if(EXISTS "${_boost_LIB_DIR}/stage/lib")
          set(_boost_LIB_DIR ${_boost_LIB_DIR}/stage/lib)
        ELSE(EXISTS "${_boost_LIB_DIR}/stage/lib")
          set(_boost_LIB_DIR "")
        endif(EXISTS "${_boost_LIB_DIR}/stage/lib")
      endif(EXISTS "${_boost_LIB_DIR}/lib")

      if(_boost_LIB_DIR AND EXISTS "${_boost_LIB_DIR}")
        set(Boost_LIBRARY_DIRS ${_boost_LIB_DIR} CACHE FILEPATH "Boost library directory")
      endif(_boost_LIB_DIR AND EXISTS "${_boost_LIB_DIR}")

    endif( NOT Boost_LIBRARY_DIRS AND NOT _boost_CHECKED_COMPONENT )

  ELSE(Boost_INCLUDE_DIR)
    set( Boost_FOUND FALSE)
  endif(Boost_INCLUDE_DIR)

  if(Boost_FOUND)
      if(NOT Boost_FIND_QUIETLY)
        message(STATUS "Boost version: ${Boost_MAJOR_VERSION}.${Boost_MINOR_VERSION}.${Boost_SUBMINOR_VERSION}")
      endif(NOT Boost_FIND_QUIETLY)
      if(NOT Boost_FIND_QUIETLY)
        message(STATUS "Found the following Boost libraries:")
      endif(NOT Boost_FIND_QUIETLY)
      foreach( COMPONENT  ${Boost_FIND_COMPONENTS} )
       string( TOUPPER ${COMPONENT} UPPERCOMPONENT )
        if( Boost_${UPPERCOMPONENT}_FOUND )
          if(NOT Boost_FIND_QUIETLY)
            message(STATUS "  ${COMPONENT}")
          endif(NOT Boost_FIND_QUIETLY)
          set(Boost_LIBRARIES ${Boost_LIBRARIES} ${Boost_${UPPERCOMPONENT}_LIBRARY})
        endif( Boost_${UPPERCOMPONENT}_FOUND )
      endforeach(COMPONENT)
      list( APPEND CF_DEPS_LIBRARIES ${Boost_LIBRARIES} )
  else()
    if(Boost_FIND_REQUIRED)
      message(SEND_ERROR "Unable to find the requested Boost libraries.\n${Boost_ERROR_REASON}")
    else()
      if(NOT Boost_FIND_QUIETLY)
        # we opt not to automatically output Boost_ERROR_REASON here as
        # it could be quite lengthy and somewhat imposing in it's requests
        # Since Boost is not always a required dependency we'll leave this
        # up to the end-user.
        if(Boost_DEBUG OR Boost_DETAILED_FAILURE_MSG)
          message(STATUS "Could NOT find Boost\n${Boost_ERROR_REASON}")
        else()
          message(STATUS "Could NOT find Boost")
        endif()
      endif()
    endif(Boost_FIND_REQUIRED)
  endif()

  # show the Boost_INCLUDE_DIRS AND Boost_LIBRARIES variables only in the advanced view
  mark_as_advanced(Boost_INCLUDE_DIR
      Boost_INCLUDE_DIRS
      Boost_LIBRARY_DIRS
  )
endif(_boost_IN_CACHE)

