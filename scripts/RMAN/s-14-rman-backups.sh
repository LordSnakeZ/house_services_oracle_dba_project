#!/usr/bin/env bash
# Wrapper to trigger RMAN backup cycles: weekly | daily | arch | copy
export ORACLE_SID=free
# export ORACLE_HOME=/opt/oracle/product/21c/dbhome_1 
export PATH=$ORACLE_HOME/bin:$PATH
# SCRIPT_DIR=/home/oracle/scripts/rman
# LOG_DIR=/unam/bda/logs
mkdir -p "$LOG_DIR"

case "$1" in
  weekly)  FILE=rman_level0.rcv   ;;  # Sunday
  daily)   FILE=rman_level1.rcv   ;;  # Monday–Saturday
  arch)    FILE=rman_arch.rcv     ;;  # every 30 min
  copy)    FILE=rman_monthly_copy.rcv ;;# 1st day each month
  *) echo "Usage: $0 weekly|daily|arch|copy"; exit 2 ;;
esac

TIMESTAMP=$(date +%Y%m%d_%H%M)
rman target / log="$LOG_DIR/${1}_${TIMESTAMP}.log" cmdfile="$SCRIPT_DIR/$FILE"

