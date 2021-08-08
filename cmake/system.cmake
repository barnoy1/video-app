
function(execute_cmd 
			CMD 
			DESCR
			WORKING_DIR
			OUT_VAR
			RES_VAR)

message(STATUS "")
message(STATUS "***************************************************************************************************")
message("${DESCR}:")
message("${CMD}")

execute_process(
	COMMAND  cmd.exe /c  ${CMD}
	WORKING_DIRECTORY ${WORKING_DIR}
	RESULT_VARIABLE result 
	OUTPUT_VARIABLE output 	
	OUTPUT_STRIP_TRAILING_WHITESPACE
)

set(OUT_VAR ${output} PARENT_SCOPE)
set(RES_VAR ${result} PARENT_SCOPE)	
message(STATUS "---------------------------------------------------------------------------------------------------")
message(STATUS "${output}")
if (NOT ${result} STREQUAL "0")
	message(FATAL_ERROR "Failed to execute command. error code: ${result}")	
endif()
message(STATUS "***************************************************************************************************")
message(STATUS "")


endfunction()

function(delete_directory_if_exists DIRECTORY_NAME)

message("")
message(STATUS delete_directory_if_exists:)
message(STATUS ---------------------)
message(STATUS "DIRECTORY_NAME: ${DIRECTORY_NAME}")
message("")

# remove directory if exists
if (WIN32)
	string(REPLACE "/" "\\" DIRECTORY_NAME "${DIRECTORY_NAME}")
	set (CMD "if exist ${DIRECTORY_NAME} rd /s /q ${DIRECTORY_NAME}")	
endif()
execute_cmd(${CMD} "delete directory if exists" ${CMAKE_CURRENT_SOURCE_DIR} OUT_VAR RES_VAR )		

endfunction()


function(assign_source_group SOURCE_LIST FOLDER_NAME)
    foreach(_source IN ITEMS ${SOURCE_LIST})
        if (IS_ABSOLUTE "${_source}")
            file(RELATIVE_PATH _source_rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_source}")
        else()
            set(_source_rel "${_source}")
        endif()
        #get_filename_component(_source_path "${_source_rel}" PATH)
        string(REPLACE "/" "\\" ${FOLDER_NAME} "${FOLDER_NAME}")
        source_group("${FOLDER_NAME}" FILES "${_source}")
    endforeach()
endfunction(assign_source_group)


function (copy_resource_file_to_build_dir
			RESOURCE_FILE_PATH
			RESOURCE_DESTINATION_DIRECTORY)

	message("")
	message(STATUS copy_resource_file_to_build_dir:)
	message(STATUS --------------------------------)
	message(STATUS "RESOURCE_FILE_PATH: ${RESOURCE_FILE_PATH}")
	message(STATUS "RESOURCE_DESTINATION_DIRECTORY: ${RESOURCE_DESTINATION_DIRECTORY}")	
	message("")
	
file(MAKE_DIRECTORY ${RESOURCE_DESTINATION_DIRECTORY})
file(GLOB RESOURCE_FILES "${RESOURCE_FILE_PATH}")
file(COPY ${RESOURCE_FILES} DESTINATION ${RESOURCE_DESTINATION_DIRECTORY} )

endfunction(copy_resource_file_to_build_dir)


function (set_target_build_directory ${LIBRARY_NAME} TARGET_OUTPUT_DIR)


# create empty directory at plugins target dir for the current plugin
file (MAKE_DIRECTORY ${TARGET_OUTPUT_DIR})

message("")
message(STATUS set_target_build_directory:)
message(STATUS ---------------------------)
message(STATUS "LIBRARY_NAME: ${LIBRARY_NAME}")
message(STATUS "DESTINATION:  ${TARGET_OUTPUT_DIR}")
message("")

set_target_properties (${LIBRARY_NAME} PROPERTIES CMAKE_RUNTIME_OUTPUT_DIRECTORY 	${TARGET_OUTPUT_DIR})
set_target_properties (${LIBRARY_NAME} PROPERTIES CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${TARGET_OUTPUT_DIR})
set_target_properties (${LIBRARY_NAME} PROPERTIES CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${TARGET_OUTPUT_DIR})

set_target_properties (${LIBRARY_NAME} PROPERTIES CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${TARGET_OUTPUT_DIR})
set_target_properties (${LIBRARY_NAME} PROPERTIES CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${TARGET_OUTPUT_DIR})
set_target_properties (${LIBRARY_NAME} PROPERTIES CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${TARGET_OUTPUT_DIR})

set_target_properties (${LIBRARY_NAME} PROPERTIES CMAKE_LIBRARY_OUTPUT_DIRECTORY ${TARGET_OUTPUT_DIR})
set_target_properties (${LIBRARY_NAME} PROPERTIES CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG ${TARGET_OUTPUT_DIR})
set_target_properties (${LIBRARY_NAME} PROPERTIES CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE ${TARGET_OUTPUT_DIR})

set_target_properties (${LIBRARY_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY 	${TARGET_OUTPUT_DIR})
set_target_properties (${LIBRARY_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_DEBUG ${TARGET_OUTPUT_DIR})
set_target_properties (${LIBRARY_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELEASE ${TARGET_OUTPUT_DIR})

set_target_properties (${LIBRARY_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY ${TARGET_OUTPUT_DIR})
set_target_properties (${LIBRARY_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${TARGET_OUTPUT_DIR})
set_target_properties (${LIBRARY_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${TARGET_OUTPUT_DIR})

set_target_properties (${LIBRARY_NAME} PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${TARGET_OUTPUT_DIR})
set_target_properties (${LIBRARY_NAME} PROPERTIES LIBRARY_OUTPUT_DIRECTORY_DEBUG ${TARGET_OUTPUT_DIR})
set_target_properties (${LIBRARY_NAME} PROPERTIES LIBRARY_OUTPUT_DIRECTORY_RELEASE ${TARGET_OUTPUT_DIR})

endfunction()



