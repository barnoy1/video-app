cmake_minimum_required(VERSION 3.9)
set(TARGET_NAME stb_image)
project(${TARGET_NAME})

set(SOURCES
	${CMAKE_CURRENT_SOURCE_DIR}/src/stb_image.cpp
)

set(HEADERS
	${CMAKE_CURRENT_SOURCE_DIR}/include/stb_image.h	
)
add_library(${TARGET_NAME} STATIC ${SOURCES} ${HEADERS})

target_include_directories( ${TARGET_NAME} PRIVATE 
	${CMAKE_CURRENT_SOURCE_DIR}/include
)

set (stb_image_LIBRARIES "${TARGET_NAME}" CACHE STRING "stb_image library" FORCE)
set (stb_image_INCLUDE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/include" CACHE STRING "glad include dir" FORCE)
set_target_properties (${TARGET_NAME} PROPERTIES FOLDER 3rdParty/${TARGET_NAME})