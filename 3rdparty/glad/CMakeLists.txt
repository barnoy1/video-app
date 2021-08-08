cmake_minimum_required(VERSION 3.9)
set(TARGET_NAME glad)
project(${TARGET_NAME})

set(SOURCES
	${CMAKE_CURRENT_SOURCE_DIR}/src/glad.c	
)

set(HEADERS
	${CMAKE_CURRENT_SOURCE_DIR}/include/glad/glad.h	
)
add_library(${TARGET_NAME} STATIC ${SOURCES} ${HEADERS})

target_include_directories( ${TARGET_NAME} PRIVATE 
	${CMAKE_CURRENT_SOURCE_DIR}/include
	${KHR_INCLUDE_DIRS}
)

set (glad_LIBRARIES "${TARGET_NAME}" CACHE STRING "glad library" FORCE)
set (glad_INCLUDE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/include" CACHE STRING "glad include dir" FORCE)
set_target_properties (${TARGET_NAME} PROPERTIES FOLDER 3rdParty/${TARGET_NAME})