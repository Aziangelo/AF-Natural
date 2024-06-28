#!/bin/bash
CURRENTDIR=$(basename "$PWD")
G='\e[1;32m' GD='\e[0;32m' Y='\e[1;33m' YD='\e[0;33m' RESET='\e[0m'

MBT_JAR_FILES=(cores/jar/MaterialBinTool-0.*.jar)
MBT_JAR="java -jar ${MBT_JAR_FILES[0]}"

SHADERC=cores/bin/shaderc
LIB_DIR=cores/lib

MBT_ARGS="--compile --shaderc $SHADERC --include cores/include/ --include src/"

BUILD_DIR=build
MATERIAL_DIR=src/materials

TARGETS=""
MATERIALS=""
DATA_VER=""
ARG_MODE=""
for t in "$@"; do
  if [ "${t:0:1}" == "-" ]; then
    # mode
    OPT=${t:1}
    if [[ "$OPT" =~ ^[pmvt]$ ]]; then
      ARG_MODE=$OPT
    else
      echo "Invalid option: $t"      
      exit 1
    fi
  elif [ "$ARG_MODE" == "p" ]; then
    # target platform
    TARGETS+="$t "
  elif [ "$ARG_MODE" == "m" ]; then
    # material files
    MATERIALS+="$MATERIAL_DIR/$t "
  elif [ "$ARG_MODE" == "v" ]; then
    # version
    DATA_VER+="$t"
  elif [ "$ARG_MODE" == "t" ]; then
    # mbt threads
    THREADS="$t"
  fi
  shift
done

if [ -z "$DATA_VER" ]; then
  DATA_VER="1.20.0"
fi

DATA_DIR=../RenderDragonData/$DATA_VER

if [ -z "$TARGETS" ]; then
  TARGETS="Android"
fi

if [ -z "$MATERIALS" ]; then
  # all materials
  MATERIALS="$MATERIAL_DIR/*"
fi

if [ -z "$THREADS" ]; then
  # 1 thread per core
  THREADS=$(nproc --all)
fi

MBT_ARGS+=" --threads $THREADS"

for p in $TARGETS; do
  echo "----------------------------------------------------"
  echo "-- ${MBT_JAR##*/}"
  echo -e "$YD>> File:$Y $CURRENTDIR $RESET"
  echo -e "$GD>> Building materials -$G $p $VD$DATA_VER:$RESET"
  if [ -d "$DATA_DIR/$p" ]; then
    for s in $MATERIALS; do
      echo "-- $s"
      LD_LIBRARY_PATH=$LIB_DIR $MBT_JAR $MBT_ARGS --output $BUILD_DIR/$p --data $DATA_DIR/$p/${s##*/} $s -m
      echo -e "$G>> Success. $RESET"
   echo "----------------------------------------------------"
    done
  else
    echo "Error: $DATA_DIR/$p not found"
  fi
done