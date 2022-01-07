function(ResolveNodeVersion requestedVersion out)
    execute_process(
            COMMAND node "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/../identify-version.js" "${requestedVersion}"
            OUTPUT_VARIABLE version
            OUTPUT_STRIP_TRAILING_WHITESPACE
            COMMAND_ERROR_IS_FATAL ANY
    )
    set("${out}" "${version}" PARENT_SCOPE)
endfunction()
