@echo off
setlocal enabledelayedexpansion
rem Distributable Vulkan build of tts-server for Mnemosyne OS (doc 31 13.6, lot 2).
rem Static MSVC runtime (no VC++ redistributable needed), no OpenMP (no VCOMP140),
rem backends as DLLs with every CPU variant, so an older CPU loads the variant it can run.
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
for /f "usebackq delims=" %%i in (`""!VSWHERE!" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath"`) do set "VSDIR=%%i"
call "!VSDIR!\VC\Auxiliary\Build\vcvars64.bat"
set "VULKAN_SDK=C:\VulkanSDK\1.4.363.0"
set "PATH=!VSDIR!\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin;!VSDIR!\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja;%VULKAN_SDK%\Bin;!PATH!"
rd /s /q build-rel 2>nul
mkdir build-rel
cd build-rel
cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Release -DGGML_VULKAN=ON -DGGML_NATIVE=OFF -DGGML_BACKEND_DL=ON -DGGML_CPU_ALL_VARIANTS=ON -DBUILD_SHARED_LIBS=ON -DGGML_OPENMP=OFF -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded -DCMAKE_POLICY_DEFAULT_CMP0091=NEW
if errorlevel 1 exit /b 1
cmake --build . --config Release -j %NUMBER_OF_PROCESSORS% --target tts-server
