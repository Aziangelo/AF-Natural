@echo off

set MBT=cores\jar\MaterialBinTool-0.9.0-all.jar
set SHADERC=cores\bin\shaderc

set MBT_ARGS=--compile --shaderc %SHADERC% --include cores/include/ --include src/

set DATA_VER=1.20.0
set DATA_DIR=cores/datas/%DATA_VER%
set BUILD_DIR=build
set MATERIALS_DIR=src/materials

set MATERIALS=
set TARGETS=
set ARG_MODE=
:loop_args
  if "%1" == "" goto :end_args
  if "%1" == "-p" goto :set_arg
  if "%1" == "-t" goto :set_arg
  if "%1" == "-m" goto :set_arg

  if "%ARG_MODE%" == "" (
    goto :next_arg
  )
  if "%ARG_MODE%" == "-p" (
    set TARGETS=%TARGETS% %1
    goto :next_arg
  )
  if "%ARG_MODE%" == "-m" (
    set MATERIALS=%MATERIALS% %MATERIALS_DIR%\%1
    goto :next_arg
  )
  if "%ARG_MODE%" == "-t" (
    set THREADS=%1
    goto :next_arg
  )
:set_arg
    set ARG_MODE=%1
:next_arg
    shift
    goto :loop_args
:end_args

if "%TARGETS%" == "" (
  set TARGETS=Windows
)

if "%MATERIALS%" == "" (
  set MATERIALS=%MATERIALS_DIR%\*
)

if "%THREADS%" == "" (
  set THREADS=%NUMBER_OF_PROCESSORS%
)

set MBT_ARGS=%MBT_ARGS% --threads %THREADS%

for %%f in (%MBT%) do echo %%~nxf 
for %%p in (%TARGETS%) do (
  echo ---------------------------
  echo ^>^> Building materials - %%p %DATA_VER%:
  if exist %DATA_DIR%\%%p (
    for /d %%s in (%MATERIALS%) do (
      echo  - %%s
      java -jar %MBT% %MBT_ARGS% --output %BUILD_DIR%\%%p --data %DATA_DIR%\%%p\%%~nxs %%s
    )
  ) else (
    echo Error: %DATA%\%%p not found
  )
)
pause
