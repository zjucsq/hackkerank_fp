cmake_minimum_required(VERSION 3.10)

set(CMAKE_CXX_STANDARD 17)
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++2a")

project(my_project)

# # 查找当前目录下所有的源文件，并将它们存储到变量中
# file(GLOB SOURCE_FILES "*.cpp")
# 查找项目主目录和一级目录下所有的.cpp文件，并将它们存储在变量中
file(GLOB_RECURSE SOURCE_FILES 
    "${CMAKE_SOURCE_DIR}/*.cpp"
    "${CMAKE_SOURCE_DIR}/[A-Za-z0-9]*/*.cpp")

# 遍历每一个源文件，生成对应的可执行文件
foreach(SOURCE_FILE ${SOURCE_FILES})
  # 指定可执行文件名
  get_filename_component(EXECUTABLE_NAME ${SOURCE_FILE} NAME_WE)
  # 添加可执行文件
  add_executable(${EXECUTABLE_NAME} ${SOURCE_FILE})
  # set_target_properties(${EXECUTABLE_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/$(notdir $(dir ${SOURCE_FILE})))
endforeach()

# 设置可执行文件的输出目录为当前源文件目录
# set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
# set(EXECUTABLE_OUTPUT_PATH ${CMAKE_CURRENT_SOURCE_DIR})