#!/bin/bash

if [ $# != 1 ]; then
  echo "[ERROR] Please input directory path for garber."
  exit -1
fi

cd $1
for a in *
do
  b=`echo ${a} | sed -E 's/(.*)-([BF]|Edge).(Cu|Mask|SilkS|Cuts)(\.[A-z0-9]{3})/\1\4/g'`
  echo "[INFO] mv $a to $b"
  mv -f ${a} ${b}
  if [ ${b##*.} = "gm1" ]; then
    echo "[INFO] Convert '.gm1' to '.gml'"
    mv -f ${b} `basename ${b} .gm1`.gml
  fi
done

for a in *.drl
do
  mv ${a} `basename ${a} .drl`.txt
  echo "[INFO] mv $a to `basename ${a} .drl`.txt"
done

echo [INFO] Compressing as zip.
zip -r ${PWD##*/}.zip .

exit 0
