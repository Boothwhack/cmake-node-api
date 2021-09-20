include(ExecuteNode)

execute_node("require('node-addon-api').include"
        TRIM_QUOTES
        OUTPUT_VARIABLE naa_include_dir
        WORKING_DIRECTORY ${NODE_PACKAGE_DIR})

add_library(NodeAddonApi INTERFACE)
target_include_directories(NodeAddonApi INTERFACE ${naa_include_dir})
