

###############################################################
# project settings
###############################################################
set(TARGET_NAME video-app)
cmake_minimum_required (VERSION 3.11)
project (video_app         
        DESCRIPTION "${TARGET_NAME}"
        LANGUAGES CXX)

        
# set compiler configuration for this project
include (${CMAKE_SOURCE_DIR}/cmake/compiler.conf.cmake)
include (${CMAKE_SOURCE_DIR}/cmake/printer.cmake)
include (${CMAKE_SOURCE_DIR}/cmake/system.cmake)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

###############################################################
# 3rd party
###############################################################

add_subdirectory(3rdparty)



###############################################################
# video app assemble executable
###############################################################
set (SOURCES_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)
set (INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include)
set (SHADERS_DIR ${CMAKE_CURRENT_SOURCE_DIR}/shaders)

list(APPEND SOURCES
    ${SOURCES_DIR}/main.cpp
    ${SOURCES_DIR}/video_reader.cpp
    ${SOURCES_DIR}/shader.cpp
    ${SOURCES_DIR}/video_app_renderer.cpp
    ${SOURCES_DIR}/resource_manager.cpp
    ${SOURCES_DIR}/text_renderer.cpp
    ${SOURCES_DIR}/sprite_renderer.cpp
    ${SOURCES_DIR}/texture.cpp
    ${SOURCES_DIR}/render_object.cpp
    ${SOURCES_DIR}/post_processor.cpp
)

list(APPEND HEADERS
    ${INCLUDE_DIR}/video_reader.hpp
    ${INCLUDE_DIR}/shader.h
	${INCLUDE_DIR}/filesystem.h
    ${INCLUDE_DIR}/video_app_renderer.h
    ${INCLUDE_DIR}/resource_manager.h
    ${INCLUDE_DIR}/sprite_renderer.h
    ${INCLUDE_DIR}/text_renderer.h    
    ${INCLUDE_DIR}/texture.h
    ${INCLUDE_DIR}/render_object.h
    ${INCLUDE_DIR}/post_processor.h
)

add_executable(${TARGET_NAME} ${SOURCES} ${HEADERS})
list(APPEND EXTRA_LIBS
    "-lglu32 -lopengl32"
)
set(CMAKE_EXE_LINKER_FLAGS "-std=gnu99 -static -static-libgcc -static-libstdc++ -mwindows")

target_include_directories( ${TARGET_NAME} PRIVATE 
    ${GLAD_INCLUDE_DIRECTORY} 
    ${GLEW_INCLUDE_DIRS} 
    ${FFmpeg_INCLUDE_DIRS}
    ${KHR_INCLUDE_DIRS}
    ${glad_INCLUDE_DIRS}
	${BOOST_INCLUDE_DIRS}
    ${GLM_INCLUDE_DIRS}
    ${freetype_INCLUDE_DIRS}
    ${stb_image_INCLUDE_DIRS}
	${INCLUDE_DIR}
)
target_link_libraries( ${TARGET_NAME} 
    ${FFmpeg_LIBRARIES} 
    ${GLEW_LIBRARIES}      
    ${glad_LIBRARIES}
	${BOOST_LIBRARIES}
    ${freetype_LIBRARIES}
    ${stb_image_LIBRARIES}
	${EXTRA_LIBS}    
    glfw 
)
 
 

###############################################################
# solution configuration
###############################################################


set (VIDEO_APP_SOLUTION_SOURCES_FOLDER
    ${SOURCES}
    ${HEADERS}
)

set_target_properties (${TARGET_NAME} PROPERTIES FOLDER application)

assign_source_group("${VIDEO_APP_SOLUTION_SOURCES_FOLDER}" 			src)


###############################################################
# build and deployment
###############################################################

MESSAGE("TARGET_NAME=${TARGET_NAME}")
MESSAGE("BINARY_DIR_OUTPUT=${BINARY_DIR_OUTPUT}")
set_target_build_directory( ${TARGET_NAME} ${PROJECT_BINARY_DIR_OUTPUT})


# copy shader blueprints and globals to runtime dir
file(GLOB 3RD_PARTY_FILES 
	"${FFmpeg_BIN_DIR}/*.dll"
    "${GLEW_BIN_DIR}/*.dll")
message( "copy 3rd party binaries from ${FFmpeg_BIN_DIR}, ${GLEW_BIN_DIR} to destination ${PROJECT_BINARY_DIR} ..." )
file(COPY ${3RD_PARTY_FILES} DESTINATION ${PROJECT_BINARY_DIR_OUTPUT})

# copy shader blueprints and globals to runtime dir
copy_resource_file_to_build_dir(
	assets
	${PROJECT_BINARY_DIR_OUTPUT}
)

# copy shader blueprints and globals to runtime dir
copy_resource_file_to_build_dir(
	shaders
	${PROJECT_BINARY_DIR_OUTPUT}
)