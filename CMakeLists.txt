cmake_minimum_required(VERSION 3.17)
project(untitled)

set(CMAKE_CXX_STANDARD 14)
add_executable(json dist/jsoncpp.cpp)
add_executable(untitled controller.cpp)