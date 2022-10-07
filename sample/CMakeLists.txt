cmake_minimum_required(VERSION 3.0)

project(NodeAddonSample CXX)

add_library(NodeAddonSample SHARED addon.cpp)
find_package(NodeApi 18 REQUIRED)
find_package(NodeAddonApi REQUIRED)

target_link_libraries(NodeAddonSample PRIVATE Node::Api NodeAddonApi::NodeAddonApi)
