# qwentts-builds

Windows builds of `tts-server` from
[qwentts.cpp](https://github.com/ServeurpersoCom/qwentts.cpp), the C++ port of
Qwen3-TTS on GGML. Mnemosyne OS downloads one of these when a person installs
the Qwen3-TTS voice from Settings › Voice.

qwentts.cpp publishes no binaries. This repository holds ours, so the app can
pin one file by its SHA-256 digest.

## The release

| Tag | File | Size | SHA-256 |
|---|---|---|---|
| `vulkan-847d69a` | `tts-server-win-x64-vulkan.zip` | 17 590 199 bytes | `e8c4139457f284f1a4cf5f1e738a4a626ac08cc80348bf185ca77c90a4ab2c9f` |

Source: [yaka0007/qwentts.cpp@847d69a](https://github.com/yaka0007/qwentts.cpp/commit/847d69a13675ee1485b34f3be6fa092ae4cb1659).
It is upstream `5916bf7` plus the Windows build notes and the `--list-devices`
flag of [ServeurpersoCom/qwentts.cpp#44](https://github.com/ServeurpersoCom/qwentts.cpp/pull/44).

## What is in the zip

- `tts-server.exe`, `ggml.dll`, `ggml-base.dll`, `ggml-vulkan.dll`.
- One `ggml-cpu-*.dll` per CPU generation. ggml loads the one the CPU can run.
- `BUILD.txt` with the exact CMake flags, and the four licences.

The build links the MSVC runtime statically and leaves OpenMP out. It needs no
Visual C++ redistributable. The only DLL it loads beyond Windows itself is
`vulkan-1.dll`, which the GPU driver installs.

## Measured

On an RTX 4050 Laptop (6 GB), with the Q4_K_M talker and the 12 Hz codec from
[Serveurperso/Qwen3-TTS-GGUF](https://huggingface.co/Serveurperso/Qwen3-TTS-GGUF),
on 2026-10-27:

- ready in 10 s on its first start (Vulkan compiles its shaders), 2.3 GB on
  the card;
- first sound in 150 to 240 ms;
- 0.33 to 0.47 × realtime, French and Spanish, six sentences.

Not measured yet: an AMD card, and a machine without the Vulkan SDK.

## Build it again

Copy `build-dist-neutral.cmd` and `build-release-vulkan.cmd` from this
repository into a qwentts.cpp checkout at `%USERPROFILE%\.mnemosyne\build\qwentts`
(or change the path in the first one), with Visual Studio 2022 or later (C++
workload) and the Vulkan SDK installed, and run `build-dist-neutral.cmd`. It
builds from a drive letter mapped onto the checkout (`subst Q:`):
the path stays short for the Vulkan shader generator, which goes past
Windows' 260-character limit under a deep folder, and the source paths
ggml's asserts embed in the binaries name no user folder.

## Licences

qwentts.cpp, ggml, cpp-httplib and yyjson are MIT. Their licence texts ship in
the zip as `LICENSE-*.txt`. The build script in this repository is MIT too.
