cmake_minimum_required(VERSION 3.16)
project(AsmCalcQt LANGUAGES CXX ASM_NASM)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

option(BUILD_I386 "Build 32-bit i386 binary" OFF)

set(CMAKE_ASM_NASM_OBJECT_FORMAT elf64)

find_package(Qt6 COMPONENTS Widgets QUIET)
set(QT_PACKAGE Qt6::Widgets)

add_library(calc_asm STATIC main.asm)
set_target_properties(calc_asm PROPERTIES POSITION_INDEPENDENT_CODE ON)

add_executable(calc-gui main.cpp)
target_link_libraries(calc-gui PRIVATE ${QT_PACKAGE} calc_asm)