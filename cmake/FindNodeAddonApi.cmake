include(ExecuteNode)

execute_node("require('node-addon-api').include"
        TRIM_QUOTES
        OUTPUT_VARIABLE naa_include_dir
        ERROR_VARIABLE naa_error
        RESULT_VARIABLE naa_result
        WORKING_DIRECTORY ${NODE_PACKAGE_DIR})

if (naa_result)
    if (NodeAddonApi_FIND_REQUIRED)
        message(FATAL_ERROR "Could not find NodeAddonApi:\n${naa_error}\nEnsure that the 'node-addon-api' package is installed properly.")
    endif ()
else ()
    add_library(_NodeAddonApi INTERFACE)
    target_include_directories(_NodeAddonApi INTERFACE ${naa_include_dir})
    add_library(NodeAddonApi::NodeAddonApi ALIAS _NodeAddonApi)
endif ()
