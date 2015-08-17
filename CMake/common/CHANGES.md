# git master

* Requires cmake 2.8.9 or later
* Added SHALLOW and VERBOSE options to git_external
* Removed legacy RELEASE_VERSION magic
* new targets DIR-rebase and rebase in GitExternal.cmake to update git
  externals and sub projects
* common_compiler_flags() macro replaces globally set CMAKE_C[XX]_FLAGS;
  is automatically applied when using common_application, common_library
  and CommonCTest
* api.h & version.h/cpp are now generated by common_library, not anymore
  globally per project (COMMON_INCLUDES and COMMON_SOURCES are not needed/used
  anymore)
* FindPackages.cmake should no longer be used; use common_package() for each
  dependency and common_package_post() at the end (will write defines.h, hence
  at the end)
* Fix RHEL library path to be lib64, not lib anymore

# 2015.06

* New SubProject module based on GitExternal
* Subprojects share a single copy of CMake/common
* Buildyard bootstrapping mechanism deprecated and removed
* Using "cmake -DINSTALL_PACKAGES=1" installs system packages required by a
  project (Debian/Ubuntu + OSX)
* Added Qt5 support in common_library() and common_application()
* New common_gui_application() for configuring GUI applications (OSX app bundle)
* New common_documentation() for documentation repositories. Deprecated
  generation of index.html by CMake in favor of Jekyll for github projects
* Fixed *doxygen* and *coverage* targets for subprojects, enforce LCOV >= 1.11
* Fixed *cppcheck* and *cpplint* targets for subprojects
* New common_package() macro to find a dependency consistently
* PackageConfig searches for ABI-matching upstream dependencies.
  If VERSION_ABI is not available, fallback to matching VERSION MAJOR+MINOR
* Support for detecting both Python2 and Python3 versions
* Removed LAST_RELEASE variable from projects and use VERSION instead
* Separate unit tests from performance tests
* Arch Linux added to the list of supported platforms
* Multiple fixes for CMake3
* More quiet runs
* Merged and retired CMakeBBP fork
* Removed obsolete components:
    * GNUModules
    * WriteModuleFile
    * BuildLibrary
    * FindDisplayCluster
    * FindFlatBuffers
    * FindTuio
* Windows-specific improvements:
    * Targets are properly organized into folders in VisualStudio IDE
    * Unwanted targets removed from VisualStudio "All Build" target
    * Many fixes for Boost detection
* Mac-specific improvements:
    * common_gui_application() installs a relocatable app bundle packaged into
      a .dmg (if macdeployqt is available)
    * Use C++11 std and stdlib on OSX >= 10.9, C++03 on <= 10.8

# 2014.6

* Flatten git externals in release branches
    Needed for some build services which do not allow to pull in git
    externals at runtime.
* Decouple RELEASE_VERSION from VERSION_ABI. The first is detected
    automatically when build from a release branch or non-git source
    folder. The latter now has to be set explicitely in the top-level
    CMakeLists.
* Add COMMON_USE_CXX03 to disable c++11 features for incompatible
    projects.
* Unify active ubuntu codenames in Ubuntu.cmake
* Denoised output of find_package() generated by PackageConfig
* Match lcov colors to BBP quality metrics