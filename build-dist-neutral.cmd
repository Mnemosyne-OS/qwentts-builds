@echo off
setlocal enabledelayedexpansion
rem Distributable build from a neutral drive letter: __FILE__ in ggml's asserts
rem embeds the source path, and the user's profile path must not ship.
subst Q: /d >nul 2>&1
subst Q: %USERPROFILE%\.mnemosyne\build\qwentts
if errorlevel 1 exit /b 1
cd /d Q:\
call Q:\build-release-vulkan.cmd
set RC=!errorlevel!
cd /d %USERPROFILE%
subst Q: /d
exit /b !RC!
