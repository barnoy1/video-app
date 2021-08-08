


set (3RD_PARTY_DIR "${CMAKE_CURRENT_SOURCE_DIR}" CACHE STRING "3rd party directory" FORCE)


############################################
# opengl
############################################

find_package(OpenGL REQUIRED)


############################################
# KHR
############################################

print_status_title("KHR")
set (KHR_ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/KHR" CACHE STRING "irrKlang include directories" FORCE)
set (KHR_INCLUDE_DIRS "${KHR_ROOT_DIR}/include" CACHE STRING "irrKlang include directories" FORCE)
message("")
message(STATUS KHR_ROOT_DIR: "KHR libraries")
message(STATUS KHR_INCLUDE_DIRS: "${KHR_INCLUDE_DIRS}")
message("")


############################################
# glad
############################################

add_subdirectory(glad)


############################################
# stb_image
############################################

add_subdirectory(stb_image)

############################################
# glfw
############################################

add_subdirectory(glfw)


############################################
# FFmpeg
############################################

print_status_title("FFmpeg")
set (FFmpeg_ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/FFmpeg" CACHE STRING "FFmpeg include directories" FORCE)
set (FFmpeg_INCLUDE_DIRS "${FFmpeg_ROOT_DIR}/include" CACHE STRING "glew include directories" FORCE)
set (FFmpeg_LIBRARIES_DIR "${FFmpeg_ROOT_DIR}/lib")
set (FFmpeg_LIBRARIES 
	${FFmpeg_LIBRARIES_DIR}/avcodec.lib  
	${FFmpeg_LIBRARIES_DIR}/avdevice.lib
	${FFmpeg_LIBRARIES_DIR}/avfilter.lib
	${FFmpeg_LIBRARIES_DIR}/avformat.lib
	${FFmpeg_LIBRARIES_DIR}/avutil.lib
	${FFmpeg_LIBRARIES_DIR}/swresample.lib
	${FFmpeg_LIBRARIES_DIR}/swscale.lib
	CACHE STRING "FFmpeg include libraries" FORCE)
set (FFmpeg_BIN_DIR "${FFmpeg_ROOT_DIR}/bin" CACHE STRING "FFmpeg binaries libraries" FORCE)

message("")
message(STATUS FFmpeg_ROOT_DIR: "FFmpeg libraries")
message(STATUS FFmpeg_ROOT_DIR: "${FFmpeg_ROOT_DIR}")
message(STATUS FFmpeg_INCLUDE_DIRS: "${FFmpeg_INCLUDE_DIRS}")
message(STATUS FFmpeg_LIBRARIES: "${FFmpeg_LIBRARIES}")
message(STATUS FFmpeg_BIN_DIR: "${FFmpeg_BIN_DIR}")
message("")



############################################
# glew
############################################

print_status_title("glew")
set (GLEW_ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/glew" CACHE STRING "glew include directories" FORCE)
set (GLEW_INCLUDE_DIRS "${GLEW_ROOT_DIR}/include" CACHE STRING "glew include directories" FORCE)
set (GLEW_LIBRARIES_DIR "${GLEW_ROOT_DIR}/lib")
set (GLEW_LIBRARIES 
	${GLEW_LIBRARIES_DIR}/glew32.lib 
	${GLEW_LIBRARIES_DIR}/glew32s.lib 
CACHE STRING "glew include libraries" FORCE)
set (GLEW_BIN_DIR "${GLEW_ROOT_DIR}/bin" CACHE STRING "glew binaries libraries" FORCE)

message("")
message(STATUS "glew libraries")
message(STATUS GLEW_INCLUDE_DIRS: "${GLEW_INCLUDE_DIRS}")
message(STATUS GLEW_LIBRARIES: "${GLEW_LIBRARIES}")
message("")


############################################
# freetype
############################################

print_status_title("freetype")
set (freetype_ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/freetype" CACHE STRING "freetype include directories" FORCE)
set (freetype_INCLUDE_DIRS 
	${freetype_ROOT_DIR}/include
	${freetype_ROOT_DIR}
	CACHE STRING "freetype include directories" FORCE)
set (freetype_LIBRARIES_DIR "${freetype_ROOT_DIR}/lib")
set (freetype_LIBRARIES 
	${freetype_LIBRARIES_DIR}/freetype.lib  
	CACHE STRING "freetype include libraries" FORCE)
set (irrKlang_BIN_DIR "${freetype_ROOT_DIR}/bin" CACHE STRING "freetype binaries libraries" FORCE)

message("")
message(STATUS freetype_ROOT_DIR: "${freetype_ROOT_DIR}")
message(STATUS freetype_INCLUDE_DIRS: "${freetype_INCLUDE_DIRS}")
message(STATUS freetype_LIBRARIES: "${freetype_LIBRARIES}")
message(STATUS freetype_BIN_DIR: "${freetype_BIN_DIR}")
message("") 




############################################
# glm
############################################

set (GLM_INCLUDE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/glm/include" CACHE STRING "glm include directories" FORCE)
message("")
print_status_title("glm headers")
message(STATUS GLM_INCLUDE_DIRS: "${GLM_INCLUDE_DIRS}")
message("")


############################################
# boost libraries
############################################

print_status_title("Boost libraries")
set (Boost_Dir $ENV{Boost_Dir}  "boot root directory")
set (Boost_USE_STATIC_LIBS 		ON )
set (Boost_USE_MULTITHREADED 	ON )
set (Boost_USE_STATIC_RUNTIME 	OFF)
set (Boost_NO_SYSTEM_PATH 		ON )

find_package (Boost REQUIRED 
	thread
	filesystem
	regex			
)



# Make the boost libararies / include directories cmake variable persistent by saving it to cache for later use
set (BOOST_INCLUDE_DIRS ${Boost_INCLUDE_DIRS} CACHE STRING "boost include directories" FORCE)
set (BOOST_LIBRARIES ${Boost_LIBRARIES} CACHE STRING "boost libraries" FORCE)

message(STATUS Boost_Dir: "${Boost_Dir}")
message(STATUS BOOST_INCLUDE_DIRS: "${BOOST_INCLUDE_DIRS}")
message(STATUS BOOST_LIBRARIES: "${BOOST_LIBRARIES}")
message(STATUS Boost_USE_STATIC_LIBS: "${Boost_USE_STATIC_LIBS}")
message(STATUS Boost_USE_MULTITHREADED: "${Boost_USE_MULTITHREADED}")
message(STATUS Boost_USE_STATIC_RUNTIME: "${Boost_USE_STATIC_RUNTIME}")
message(STATUS Boost_NO_SYSTEM_PATH: "${Boost_NO_SYSTEM_PATH}")
message("")


