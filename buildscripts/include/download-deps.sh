#!/bin/bash -e

. ./include/depinfo.sh

[ -z "$IN_CI" ] && IN_CI=0
[ -z "$WGET" ] && WGET=wget

mkdir -p deps && cd deps

# mbedtls
if [ ! -d mbedtls ]; then
	mkdir mbedtls
	$WGET https://github.com/Mbed-TLS/mbedtls/releases/download/mbedtls-$v_mbedtls/mbedtls-$v_mbedtls.tar.bz2 -O - | \
		tar -xj -C mbedtls --strip-components=1
fi

# libxml2
if [ ! -d libxml2 ]; then
	mkdir libxml2
	$WGET https://gitlab.gnome.org/GNOME/libxml2/-/archive/v$v_libxml2/libxml2-v$v_libxml2.tar.gz -O - | \
		tar -xz -C libxml2 --strip-components=1
fi

# dav1d
[ ! -d dav1d ] && git clone --depth 1 https://github.com/videolan/dav1d

# ffmpeg — ALWAYS pin to the release tag (was only pinned when IN_CI=1; our build pulled master).
if [ ! -d ffmpeg ]; then
    git clone --branch $v_ci_ffmpeg --depth 1 https://github.com/FFmpeg/FFmpeg ffmpeg
fi

# freetype2
[ ! -d freetype2 ] && git clone --depth 1 --recurse-submodules https://gitlab.freedesktop.org/freetype/freetype.git freetype2 -b VER-${v_freetype//./-}

# fribidi
if [ ! -d fribidi ]; then
	mkdir fribidi
	$WGET https://github.com/fribidi/fribidi/releases/download/v$v_fribidi/fribidi-$v_fribidi.tar.xz -O - | \
		tar -xJ -C fribidi --strip-components=1
fi

# harfbuzz
if [ ! -d harfbuzz ]; then
	mkdir harfbuzz
	$WGET https://github.com/harfbuzz/harfbuzz/releases/download/$v_harfbuzz/harfbuzz-$v_harfbuzz.tar.xz -O - | \
		tar -xJ -C harfbuzz --strip-components=1
fi

# unibreak
if [ ! -d unibreak ]; then
	mkdir unibreak
	$WGET https://github.com/adah1972/libunibreak/releases/download/libunibreak_${v_unibreak//./_}/libunibreak-${v_unibreak}.tar.gz -O - | \
		tar -xz -C unibreak --strip-components=1
fi

# libass — PINNED to 0.17.4 (master pulled ahead of stable mpv 0.41.0 → broke Android rendering)
[ ! -d libass ] && git clone --depth 1 --branch 0.17.4 https://github.com/libass/libass

# lua
if [ ! -d lua ]; then
	mkdir lua
	$WGET https://www.lua.org/ftp/lua-$v_lua.tar.gz -O - | \
		tar -xz -C lua --strip-components=1
fi

# libplacebo — PINNED to v7.360.1 (the minimum mpv 0.41.0's meson requires; master broke ABI)
[ ! -d libplacebo ] && git clone --depth 1 --recursive --branch v7.360.1 https://github.com/haasn/libplacebo

# mpv — PINNED to v0.41.0 stable (was master HEAD = v0.41.0-dev which black-screens on MediaTek;
# v0.41.0 is the known-good build that mpv-android-lib:0.1.12 / NuvioTV use)
[ ! -d mpv ] && git clone --depth 1 --branch v0.41.0 https://github.com/mpv-player/mpv

cd ..
