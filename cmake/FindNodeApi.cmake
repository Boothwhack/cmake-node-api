execute_process(
        COMMAND node "${CMAKE_CURRENT_LIST_DIR}/../identify-version.js" "${NodeApi_FIND_VERSION}"
        OUTPUT_VARIABLE version
        OUTPUT_STRIP_TRAILING_WHITESPACE
        COMMAND_ERROR_IS_FATAL ANY
)

set(node_content_dir "${CMAKE_CURRENT_BINARY_DIR}/node-${version}")
set(node_headers_tarball "${node_content_dir}/node-${version}-headers.tar.gz")
set(node_headers_dir "${node_content_dir}/node-headers")

# Setup Node Api headers
file(DOWNLOAD "https://nodejs.org/dist/${version}/node-${version}-headers.tar.gz" "${node_headers_tarball}")
file(ARCHIVE_EXTRACT INPUT "${node_headers_tarball}" DESTINATION "${node_headers_dir}")

set(node_headers_include_dir "${node_headers_dir}/node-${version}/include/node")

# Windows needs to link to node.lib
if (WIN32)
    if (CMAKE_SYSTEM_PROCESSOR STREQUAL "AMD64")
        set(node_windows_arch "x64")
    elseif (CMAKE_SYSTEM_PROCESSOR STREQUAL "x86")
        set(node_windows_arch "x86")
    else ()
        message(FATAL_ERROR "Incompatible system processor: ${CMAKE_SYSTEM_PROCESSOR}")
    endif ()

    set(node_lib_file "${node_content_dir}/win-${node_windows_arch}/node.lib")
    set(node_lib_url "https://nodejs.org/dist/${version}/win-${node_windows_arch}/node.lib")

    file(DOWNLOAD "${node_lib_url}" "${node_lib_file}")

    add_library(NodeApi UNKNOWN IMPORTED)
    set_target_properties(NodeApi PROPERTIES IMPORTED_LOCATION "${node_lib_file}")
else ()
    add_library(NodeApi INTERFACE)
endif ()

target_include_directories(NodeApi INTERFACE ${node_headers_include_dir})
