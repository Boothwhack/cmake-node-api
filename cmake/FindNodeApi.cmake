include(ResolveNodeVersion)
ResolveNodeVersion("${NodeApi_FIND_VERSION}" version)

set(node_content_dir "${CMAKE_BINARY_DIR}/node-${version}")

function(SetupNodeHeaders)
    set(node_headers_tarball "${node_content_dir}/node-${version}-headers.tar.gz")
    set(node_headers_dir "${node_content_dir}/node-headers")

    file(DOWNLOAD "https://nodejs.org/dist/${version}/node-${version}-headers.tar.gz" "${node_headers_tarball}")
    file(ARCHIVE_EXTRACT INPUT "${node_headers_tarball}" DESTINATION "${node_headers_dir}")

    set(node_include_dir "${node_headers_dir}/node-${version}/include/node" PARENT_SCOPE)
endfunction()

if (NOT TARGET NodeApi)
    # Download headers
    SetupNodeHeaders()

    # Windows needs to link to node.lib
    if (WIN32)
        set(node_lib_file "${node_content_dir}/win-${NODE_ARCH}/node.lib")
        set(node_lib_url "https://nodejs.org/dist/${version}/win-${NODE_ARCH}/node.lib")

        file(DOWNLOAD "${node_lib_url}" "${node_lib_file}")

        add_library(NodeApi SHARED IMPORTED)
        set_target_properties(NodeApi PROPERTIES IMPORTED_IMPLIB "${node_lib_file}")
        target_include_directories(NodeApi INTERFACE "${node_include_dir}")

    elseif (UNIX AND NOT APPLE)
        add_library(NodeApi INTERFACE)
        target_include_directories(NodeApi INTERFACE "${node_include_dir}")
    endif ()

    add_library(Node::Api ALIAS NodeApi)
endif ()
