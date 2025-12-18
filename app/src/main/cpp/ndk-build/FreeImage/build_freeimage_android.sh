#!/usr/bin/env bash
set -e

############################################
# CONFIGURATION
############################################

ANDROID_NDK=$HOME/Android/Sdk/ndk/25.1.8937393
API=21
ABI=arm64-v8a
TARGET=aarch64-linux-android
TOOLCHAIN=$ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64/bin

CC=$TOOLCHAIN/${TARGET}${API}-clang
CXX=$TOOLCHAIN/${TARGET}${API}-clang++
AR=$TOOLCHAIN/llvm-ar
RANLIB=$TOOLCHAIN/llvm-ranlib

ROOT_DIR=$(pwd)
SRC_DIR=$ROOT_DIR/Source
BUILD_DIR=$ROOT_DIR/build-android/$ABI
OBJ_DIR=$BUILD_DIR/obj

############################################
# PRÉPARATION
############################################

echo "==> Nettoyage"
rm -rf "$BUILD_DIR"
mkdir -p "$OBJ_DIR"

############################################
# FLAGS
############################################

CFLAGS="\
-fPIC \
-DANDROID \
-O2 \
-DNO_JASPER \
-DNO_JPGE200 \
-DFREEIMAGE_NO_JPGE200 \
-DNO_RAW \
-DNO_LIBRAW \
-DNO_DCRAW \
-DNO_WDP \
-DNO_JPEGXR \
-DNO_TIFF_JPEG \
-DNO_WEBP \
-DNO_EXR \
-I$ROOT_DIR \
-I$ROOT_DIR/Source \
-I$ROOT_DIR/Source/FreeImage \
"

CXXFLAGS="$CFLAGS -std=c++14"

############################################
# COMPILATION DES .c
############################################

echo "==> Compilation des fichiers C"
find "$SRC_DIR" -name "*.c" | while read f; do
    obj="$OBJ_DIR/$(basename "$f").o"
    echo "  CC  $(basename "$f")"
    $CC $CFLAGS -c "$f" -o "$obj"
done

############################################
# COMPILATION DES .cpp
############################################

echo "==> Compilation des fichiers C++"
find "$SRC_DIR" -name "*.cpp" | while read f; do
    obj="$OBJ_DIR/$(basename "$f").o"
    echo "  CXX $(basename "$f")"
    $CXX $CXXFLAGS -c "$f" -o "$obj"
done

############################################
# CRÉATION DE LA LIBRAIRIE STATIQUE
############################################

echo "==> Création de libfreeimage.a"
$AR rcs "$BUILD_DIR/libfreeimage.a" "$OBJ_DIR"/*.o
$RANLIB "$BUILD_DIR/libfreeimage.a"

############################################
# RÉSULTAT
############################################

echo
echo "✅ Build terminé avec succès"
echo "➡️  Librairie : $BUILD_DIR/libfreeimage.a"

