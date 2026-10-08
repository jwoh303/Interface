@echo off
cls


echo Copyright (c) 2007 POSDATA Co., Ltd
echo All rights reserved.

echo Posdata u-CUBE User compilation batch file

set JAVA_HOME=C:\Program Files\Java\jdk1.5.0_14

if {"%UCUBE_HOME%"}=={} goto usage
if {"%JAVA_HOME%"}=={} goto usage

REM Setting JBOSS_HOME

echo ===============================================================================
echo   uCUBE Environment
echo UCUBE_HOME : "%UCUBE_HOME%"
echo JAVA_HOME  : "%JAVA_HOME%"
echo CLASS_PATH : %CLASS_PATH%
echo ===============================================================================


set JBOSS_HOME=C:\uCUBE_Entob\manager\jboss
set JAVA_OPTS=-DUCUBE_HOME=C:\uCUBE_Entob

REM Starting Engine 

%JBOSS_HOME%\bin\run.bat -c manager

:usage
echo usage : Please set environment UCUBE_HOME or JAVA_HOME
goto end

:end

