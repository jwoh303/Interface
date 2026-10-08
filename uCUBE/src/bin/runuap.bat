@echo off
cls


echo Copyright (c) 2007 POSDATA Co., Ltd
echo All rights reserved.

echo Posdata u-CUBE User compilation batch file

if {"%UCUBE_HOME%"}=={} goto usage
if {"%JAVA_HOME%"}=={} goto usage

REM Setting CLASS_PATH.

set CLASS_PATH="%UCUBE_HOME%"\lib\seadapter30.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\log4j-1.2.11.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\jbossall-client.jar

echo ===============================================================================
echo   uCUBE Environment
echo UCUBE_HOME : "%UCUBE_HOME%"
echo JAVA_HOME  : %JAVA_HOME%
echo CLASS_PATH : %CLASS_PATH%
echo ===============================================================================


echo Starting run 
"%JAVA_HOME%"\bin\java -classpath .;%CLASS_PATH%; %*
echo End run
goto end

:usage
echo usage : Please set environment UCUBE_HOME or JAVA_HOME
goto end

:end

