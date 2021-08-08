
###############################################
# set cmake version and compiler configurations
###############################################

# find project build type
if(NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Default build type: Debug" FORCE)		
endif()
set (CMAKE_BUILD_TYPE "${CMAKE_BUILD_TYPE}" CACHE STRING "cached build type" FORCE)	


# find target machine compiler arch
if (CMAKE_SIZEOF_VOID_P EQUAL 8)
	set (ARCH "x64" CACHE STRING "target compiler architecture based on x64" FORCE)
else (CMAKE_SIZEOF_VOID_P EQUAL 4)
	set (ARCH "x86" CACHE STRING "target compiler architecture based on x86" FORCE)
endif()

set (CMAKE_VERSION ${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION} CACHE STRING "current cmake version" FORCE)


if (MSVC)

	# adding compiler definitions and flags
	add_definitions (-D_SCL_SECURE_NO_WARNINGS)	

	set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /w44101 /W0 /std:c++17")	

	if (CMAKE_BUILD_TYPE STREQUAL "Release")
		# Perform extremely aggressive optimization on Release builds:
		# Flags on Visual Studio 2010 and newer:	
		# Optimization: Custom Optimization (/O2)
		# Inline Function Expansion: Any Suitable (/Ob2)
		# Enable Intrinsic Functions: Yes (/Oi)
		# Favor Size Or Speed: Favor fast code (/Ot)
		# Enable Fiber-Safe Optimizations: Yes (/GT)
		# Enable String Pooling: Yes (/GF)
		# Buffer Security Check: No (/GS-)
		# Floating Point Model: Fast (/fp:fast)
		# Enable Floating Point Exceptions: No (/fp:except-)
		# Build with Multiple Processes (/MP)		
		set(OPTIMIZATION_FLAGS_RELEASE "/MD /O2 /Ob2 /Oi /Ot /GT /GF /GS- /fp:fast /fp:except- /MP")		
		# Whole Program Optimization: Yes (/GL)
		set(OPTIMIZATION_FLAGS_RELEASE "${OPTIMIZATION_FLAGS_RELEASE} /GL")
		set(CMAKE_C_FLAGS_RELEASE     	"${CMAKE_C_FLAGS_RELEASE} /Oy ${OPTIMIZATION_FLAGS_RELEASE}")
		set(CMAKE_CXX_FLAGS_RELEASE 	"${CMAKE_CXX_FLAGS_RELEASE} /Oy ${OPTIMIZATION_FLAGS_RELEASE}")
		set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_RELEASE}")	

		set(LINKER_OPTIMIZATION_FLAGS_RELEASE "/OPT:ICF /INCREMENTAL:NO")
		# Remove unreferenced data (/OPT:REF)
		set(LINKER_OPTIMIZATION_FLAGS_RELEASE "${LINKER_OPTIMIZATION_FLAGS_RELEASE} /OPT:REF")
		# Link-time Code Generation (/LTCG)
		set(LINKER_OPTIMIZATION_FLAGS_RELEASE "${LINKER_OPTIMIZATION_FLAGS_RELEASE} /LTCG")

		set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} ${LINKER_OPTIMIZATION_FLAGS_RELEASE}")
		set(CMAKE_SHARED_LINKER_FLAGS_RELEASE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE} ${LINKER_OPTIMIZATION_FLAGS_RELEASE}")
		set(CMAKE_MODULE_LINKER_FLAGS_RELEASE "${CMAKE_MODULE_LINKER_FLAGS_RELEASE} ${LINKER_OPTIMIZATION_FLAGS_RELEASE}")

	else()
		set (CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} /MDd /Od /Zi /Gy")
		set (CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /MDd /Od /Zi /Gy")
		set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_DEBUG}")	
	endif()

	# enable directories hierarchy in visual studio projects
	set_property (GLOBAL PROPERTY USE_FOLDERS ON)
	set_property (GLOBAL PROPERTY PREDEFINED_TARGETS_FOLDER _cmake_target)
else (CMAKE_COMPILER_IS_GNUCC)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
endif()

# Export no symbols by default (no windows this is no-op)
set (CMAKE_C_VISABILITY_PRESENT hidden)
set (CMAKE_CXX_VISABILITY_PRESENT hidden)


# Export no symbols by default (if the compiler supports it).
# This makes e.g. GCC's "visibility behavior" consistent with MSVC's. 
# On Windows/MSVC this is a noop.
set(CMAKE_C_VISIBILITY_PRESET hidden)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)

include(CheckLanguage)

if (WIN32)
	set (OS "win" CACHE STRING "define machine os (windows or linux)" FORCE)
	#add_definitions(-D_WIN32_WINNT=0x0601)
	add_compile_definitions(_WIN32_WINNT=0x0601)
else()
	set (OS "linux" CACHE STRING "define machine os (windows or linux)" FORCE)
endif()


set (PROJECT_BINARY_DIR_OUTPUT ${CMAKE_BINARY_DIR}/bin CACHE STRING "build directory" FORCE)

set (CMAKE_RUNTIME_OUTPUT_DIRECTORY	 		${PROJECT_BINARY_DIR_OUTPUT} CACHE STRING "install directory" FORCE)
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG 	${PROJECT_BINARY_DIR_OUTPUT} CACHE STRING "install directory" FORCE)
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${PROJECT_BINARY_DIR_OUTPUT} CACHE STRING "install directory" FORCE)

set (CMAKE_ARCHIVE_OUTPUT_DIRECTORY 		${PROJECT_BINARY_DIR_OUTPUT} CACHE STRING "install directory" FORCE)
set (CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG 	${PROJECT_BINARY_DIR_OUTPUT} CACHE STRING "install directory" FORCE)
set (CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${PROJECT_BINARY_DIR_OUTPUT} CACHE STRING "install directory" FORCE)

set (CMAKE_LIBRARY_OUTPUT_DIRECTORY 		${PROJECT_BINARY_DIR_OUTPUT} CACHE STRING "install directory" FORCE)
set (CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG 	${PROJECT_BINARY_DIR_OUTPUT} CACHE STRING "install directory" FORCE)
set (CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE ${PROJECT_BINARY_DIR_OUTPUT} CACHE STRING "install directory" FORCE)





message ("")
message (STATUS "COMPILER INFO: ")
message (STATUS "---------------")
message (STATUS "CMAKE_PROJECT_NAME: ${CMAKE_PROJECT_NAME}")
message (		"CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")
message (STATUS "CMAKE_VERSION: ${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}")
message (STATUS "OS: ${OS}")
message (STATUS "ARCHITECTURE: ${ARCH}")
message (STATUS "CMAKE_CXX_FLAGS: ${CMAKE_CXX_FLAGS}")
message (STATUS "CHECK_CXX_COMPILER_FLAG: ${_cpp_latest_flag_supported}")
message(STATUS "CMAKE_ARCHIVE_OUTPUT_DIRECTORY: ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")
message(STATUS "CMAKE_RUNTIME_OUTPUT_DIRECTORY: ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
message(STATUS "CMAKE_LIBRARY_OUTPUT_DIRECTORY: ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")

if (CMAKE_BUILD_TYPE STREQUAL "Release")

	message (STATUS "CMAKE_C_FLAGS_RELEASE: ${CMAKE_C_FLAGS_RELEASE}")
	message (STATUS "CMAKE_CXX_FLAGS_RELEASE: ${CMAKE_CXX_FLAGS_RELEASE}")

	message (STATUS "CMAKE_EXE_LINKER_FLAGS_RELEASE: ${CMAKE_EXE_LINKER_FLAGS_RELEASE}")
	message (STATUS "CMAKE_SHARED_LINKER_FLAGS_RELEASE: ${CMAKE_SHARED_LINKER_FLAGS_RELEASE}")
	message (STATUS "CMAKE_MODULE_LINKER_FLAGS_RELEASE: ${CMAKE_MODULE_LINKER_FLAGS_RELEASE}")
else()
	message (STATUS "CMAKE_C_FLAGS_DEBUG: ${CMAKE_C_FLAGS_DEBUG}")
	message (STATUS "CMAKE_CXX_FLAGS_DEBUG: ${CMAKE_CXX_FLAGS_DEBUG}")
endif()

message (STATUS "PROJECT_BINARY_DIRECTORY: ${PROJECT_BINARY_DIR}")
message ("")