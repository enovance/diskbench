#!/bin/bash

ROOT_PATH="results"

for year in `ls -1 $ROOT_PATH/`;
do
  YEAR_PATH=$ROOT_PATH/$year
  for month in `ls -1 $YEAR_PATH/`;
  do
    MONTH_PATH=$YEAR_PATH/$month
    for day in `ls -1 $MONTH_PATH/`;
    do
      DAY_PATH=$MONTH_PATH/$day
      echo "Results for $month/$day/$year"
      for runset in `ls -1 $DAY_PATH | awk -F- {'print \$1"-"\$2"-"\$3'} | uniq | sort`;
      do
          echo "Run Timestamp: ${runset}" | sed s/-/:/g
        for pass in `ls -1 $DAY_PATH/$runset-* | awk -F'pass-' {'print \$2'} | uniq | sort`;
        do
          echo "Pass Number: ${pass}"
          for file in `ls -1 $DAY_PATH/$runset-*-$pass`;
          do
            echo "File: ${file}"
            JOB=`head -n 1 ${file} | awk -F: {'print \$1'}`
            echo "JOB: ${JOB}";
            READ_IOPS=`grep iops ${file}| grep read | awk -F'iops=' {'print \$2'} | awk {'print \$1'}`
            echo "READ_IOPS: ${READ_IOPS}"
            WRITE_IOPS=`grep iops ${file}| grep write | awk -F'iops=' {'print \$2'} | awk {'print \$1'}`
            echo "WRITE_IOPS: ${WRITE_IOPS}"
            READ_BANDWIDTH=`grep READ ${file} | awk -F'maxb=' {'print \$2'} | awk -F, {'print \$1'}`
            echo "READ_BANDWIDTH: ${READ_BANDWIDTH}"
            WRITE_BANDWIDTH=`grep WRITE ${file} | awk -F'maxb=' {'print \$2'} | awk -F, {'print \$1'}`
            echo "WRITE_BANDWIDTH: ${WRITE_BANDWIDTH}"
          done
        done
      done
    done
  done
done