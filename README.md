# FlowVid Android libmpv

[![Build status](https://github.com/flow-vid/flowvid-libmpv-android/actions/workflows/build_release.yml/badge.svg?branch=library)](https://github.com/flow-vid/flowvid-libmpv-android/actions/workflows/build_release.yml)
[![Latest release](https://img.shields.io/github/v/release/flow-vid/flowvid-libmpv-android)](https://github.com/flow-vid/flowvid-libmpv-android/releases)

An Android AAR containing [libmpv](https://github.com/mpv-player/mpv), built for FlowVid Android and
Android TV under the LGPL. mpv uses `-Dgpl=false`; FFmpeg uses `--disable-gpl`; GPL and nonfree
components such as x264 and x265 are not included.

This repository is derived from [`abdallahmehiz/mpv-android`](https://github.com/abdallahmehiz/mpv-android)
and retains its Android bindings while adding FlowVid's pinned LGPL build and immutable release path.

FlowVid Android and Android TV use immutable release [`v0.1.12-lgpl-9`](../../releases/tag/v0.1.12-lgpl-9)
(mpv 0.41.0, FFmpeg n8.1.3). Its AAR has SHA-256
`b3bc7cb546d480c9d5aac431069b2e8ddec4a6f95724ee4895fc6cad1ec94658`.

## Capabilities

- Multiple independent MPV instances
- `mpv_node` support
- DASH support

## Installation

Download the AAR from this repository's [Releases](../../releases), place it in your module's `libs`
directory, and add the local file dependency:

```groovy
dependencies {
    implementation files("libs/flowvid-libmpv.aar")
}
```

## Getting Started

### Using BaseMPVView

The simplest way to extend `BaseMPVView`:

```kotlin
class MyPlayerView(context: Context, attrs: AttributeSet?) : BaseMPVView(context, attrs) {

    override fun initOptions() {
        // Set options before mpv.init() is called
        mpv.setOptionString("hwdec", "auto")
    }

    override fun postInitOptions() {
        // Set options after mpv.init() is called
        mpv.setOptionString("sub-auto", "fuzzy")
    }
}

val playerView = MyPlayerView(context, null)
playerView.initialize(configDir = filesDir.path, cacheDir = cacheDir.path)
playerView.playFile("/path/to/video.mp4")
```

### Using MPV() Directly

You can also use `MPV()` then attach to fully control your mpv instance.

```kotlin
val mpv = MPV()

mpv.create(context)
mpv.setOptionString("config", "yes")
mpv.init()

// Attach to a view surface
mpv.attachSurface(surface)

// Load and play a file
mpv.command("loadfile", "/path/to/video.mp4")

// Access props
val paused: Boolean? = mpv.prop["pause"]
mpv.prop["pause"] = false

// access and set nodes
val node: MPVNode? = mpv.getPropertyNode("track-list")
mpv.setPropertyNode("chapter-list", myCustomChaptersList)

// observe as kotlin flows
val pauseState: StateFlow<Boolean?> = mpv.propFlow["pause"]

// cleanup
mpv.detachSurface()
mpv.destroy()
```

### Multiple Instances

Each `MPV()` or `BaseMPVView` instance is independent:

```kotlin
val player1 = MPV()
val player2 = MPV()

player1.create(context)
player2.create(context)

// Each player can play different content simultaneously
```

## Building from source

Take a look at the [README](buildscripts/README.md) inside the `buildscripts` directory.

Some other documentation can be found at this [link](http://mpv-android.github.io/mpv-android/).
