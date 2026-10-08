@echo off
cls
echo Copyright (c) 2007 POSDATA Co., Ltd
echo All rights reserved.

echo Posdata u-CUBE User compilation batch file
set UCUBE_HOME="C:\uCUBE_Entob"
set JAVA_HOME=C:\Program Files\Java\jdk1.5.0_14
if {"%UCUBE_HOME%"}=={} goto usage
if {"%JAVA_HOME%"}=={} goto usage

REM Setting CLASS_PATH.

set CLASS_PATH="%UCUBE_HOME%"\lib\seadapter.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\log4j-1.2.11.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\jbossall-client.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\xerces.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\xml-apis.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib

echo ===============================================================================
echo   uCUBE Environment
echo UCUBE_HOME : "%UCUBE_HOME%"
echo JAVA_HOME  : "%JAVA_HOME%"
echo CLASS_PATH : %CLASS_PATH%
echo ===============================================================================


echo Starting run 
"%JAVA_HOME%"\bin\java -classpath %CLASS_PATH%; com.posdata.eai.adapter.file.FileSend "%UCUBE_HOME%"\service\file\config\cfg\file.cfg "%UCUBE_HOME%"\service\file\config\cfg\UCUBE_FILESEND.xml
echo End run
goto end

:usage
echo usage : Please set environment UCUBE_HOME or JAVA_HOME
goto end

:end

