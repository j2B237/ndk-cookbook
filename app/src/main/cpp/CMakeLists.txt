cmake_minimum_required(VERSION 3.22.1)

project(native-lib)

# ⚡ Forcer C++14 pour compatibilité avec code legacy
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)  # optionnel, pour éviter les extensions GNU


# Declaration de librairies statiques precompilees
add_library(mymath STATIC IMPORTED)
add_library(curl STATIC IMPORTED)
add_library(ssl STATIC IMPORTED)
add_library(crypto STATIC IMPORTED)
add_library(FreeImage STATIC IMPORTED)


# Library JNI (shared)
add_library(
    native-lib
    SHARED
    native-lib.cpp
)

set_target_properties(
    mymath
    PROPERTIES
    IMPORTED_LOCATION
    ${CMAKE_SOURCE_DIR}/prebuilt/${ANDROID_ABI}/libmymath.a
)

set_target_properties(
    curl
    PROPERTIES
    IMPORTED_LOCATION
    ${CMAKE_SOURCE_DIR}/prebuilt/${ANDROID_ABI}/libcurl.a
)

set_target_properties(
    ssl
    PROPERTIES
    IMPORTED_LOCATION
    ${CMAKE_SOURCE_DIR}/prebuilt/${ANDROID_ABI}/libssl.a
)

set_target_properties(
    crypto
    PROPERTIES
    IMPORTED_LOCATION
    ${CMAKE_SOURCE_DIR}/prebuilt/${ANDROID_ABI}/libcrypto.a
)


set_target_properties(
    FreeImage 
    PROPERTIES
    IMPORTED_LOCATION
    ${CMAKE_SOURCE_DIR}/prebuilt/${ANDROID_ABI}/libfreeimage.a
)


# Include headers
target_include_directories(
    native-lib
    PRIVATE
    ${CMAKE_SOURCE_DIR}/include
)

# Link de la librairie statique mymath dans le native-lib.so
# Linkage egalement d'autres librairies dynamiques
target_link_libraries(
    native-lib
    mymath
    curl
    ssl
    crypto
    FreeImage
    log
    android
)