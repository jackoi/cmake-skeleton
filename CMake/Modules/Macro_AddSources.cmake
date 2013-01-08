# Takes any amount of sources and propagates them up in hierarchy.
# Be aware that add_subdirectory must go before add_sources to propagate correctly.

MACRO (MACRO_PREPARE_SOURCES)
  IF (${ARGN})
    SET (VARIABLE_NAME ${ARGN})
  ELSE()
    SET (VARIABLE_NAME "SRCS")
  ENDIF()
  MESSAGE(STATUS "Filling variable ${VARIABLE_NAME} with source list")
  SET (CURRENT_RETURN_VARIABLE_NAME ${VARIABLE_NAME})
  SET (CUMULATIVE_SRCS "")
ENDMACRO()

MACRO (MACRO_ADD_SOURCES)
    FILE (RELATIVE_PATH _relPath "${CMAKE_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}")
    FOREACH (_src ${ARGN})
        IF (_relPath)
            LIST (APPEND CUMULATIVE_SRCS "${_relPath}/${_src}")
        ELSE()
            LIST (APPEND CUMULATIVE_SRCS "${_src}")
        ENDIF()
    ENDFOREACH()
    IF (_relPath)
        # Propagate CUMULATIVE_SRCS to parent directory
        # If this is not the root dir (by relative path)
        SET (CUMULATIVE_SRCS ${CUMULATIVE_SRCS} PARENT_SCOPE)
    ELSE()
        SET (${CURRENT_RETURN_VARIABLE_NAME} ${CUMULATIVE_SRCS})
    ENDIF()
ENDMACRO()

MACRO (MACRO_PRINT_SOURCES)
  MESSAGE(STATUS "Current sources: ")
  FOREACH (_src ${CUMULATIVE_SRCS}) {
    MESSAGE(STATUS ${_src})
  ENDFOREACH()
ENDMACRO()
