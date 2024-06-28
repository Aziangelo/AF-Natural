@echo off

set MBT_VERSION=0.9.0
set MBT=cores\jar\MaterialBinTool-%MBT_VERSION%-all.jar
set SHADERC=cores\bin\shaderc
set DATA_DIR=cores/datas

set MBT_RELEASE_URL=https://github.com/lonelyang/MaterialBinTool/releases/download/v%MBT_VERSION%
set M_DATA_URL=https://github.com/devendrn/RenderDragonData

if not exist %MBT% (
  mkdir cores\jar\
  echo Downloading MaterialBinTool-%MBT_VERSION%-all.jar
  curl -L -o %MBT% %MBT_RELEASE_URL%/MaterialBinTool-%MBT_VERSION%-all.jar
)

if not exist %SHADERC% (
  echo Downloading shaderc.exe
  curl -L -o %SHADERC% %MBT_RELEASE_URL%/shaderc
)

if not exist %DATA_DIR% (
  echo Cloning RenderDragonData
  git clone --filter=tree:0 %M_DATA_URL% %DATA_DIR%
) else (
  cd %DATA_DIR%
  git pull
)
