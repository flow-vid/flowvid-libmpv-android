#!/bin/bash -e

## Dependency versions
# Make sure to keep v_ndk and v_ndk_n in sync, both are listed on the NDK download page

v_sdk=11076708_latest
v_ndk=r29
v_ndk_n=29.0.14206865
v_sdk_platform=35
v_sdk_build_tools=35.0.0

v_lua=5.2.4
v_unibreak=6.1
v_harfbuzz=12.2.0
v_fribidi=1.0.17
v_freetype=2.14.3
v_mbedtls=3.6.7
v_libxml2=2.13.5
v_dav1d=1.5.4
v_libass=0.17.5


## Dependency tree
# I would've used a dict but putting arrays in a dict is not a thing

dep_mbedtls=()
dep_libxml2=()
dep_dav1d=()
dep_ffmpeg=(mbedtls dav1d libxml2)
dep_freetype2=()
dep_fribidi=()
dep_harfbuzz=()
dep_unibreak=()
dep_libass=(freetype2 fribidi harfbuzz unibreak)
dep_lua=()
dep_libplacebo=()
dep_mpv=(ffmpeg libass lua libplacebo)
dep_mpv_android=(mpv)


## for CI workflow

# pinned ffmpeg revision — n8.1.3 (8.1 point release; was n8.0, which lacked the 8.0.1-8.0.3 and 8.1.x
# security fixes). The earlier vo=gpu black screen was actually a PAUSE bug
# in the app, not FFmpeg 8.0; once fixed, mpv 0.41 + FFmpeg 8.0 decode correctly. FlowVidTV uses
# vo=mediacodec_embed (HW, correct colors) by default and vo=gpu+software only for the styled-subs
# mode, so the n7.1 downgrade is unnecessary. Stay on latest for newest codec/security fixes.
v_ci_ffmpeg=n8.1.3

# filename used to uniquely identify a build prefix
ci_tarball="prefix-ndk-${v_ndk}-lua-${v_lua}-unibreak-${v_unibreak}-harfbuzz-${v_harfbuzz}-fribidi-${v_fribidi}-freetype-${v_freetype}-mbedtls-${v_mbedtls}-dav1d-${v_dav1d}-libass-${v_libass}-ffmpeg-${v_ci_ffmpeg}.tgz"
