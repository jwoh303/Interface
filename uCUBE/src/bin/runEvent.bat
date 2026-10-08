@echo off
cls


echo Copyright (c) 2007 POSDATA Co., Ltd
echo All rights reserved.

echo Posdata u-CUBE User compilation batch file

if {"%UCUBE_HOME%"}=={} goto usage
if {"%JAVA_HOME%"}=={} goto usage

echo ===============================================================================
echo   uCUBE Environment
echo UCUBE_HOME : "%UCUBE_HOME%"
echo JAVA_HOME  : %JAVA_HOME%
echo CLASS_PATH : %CLASS_PATH%
echo ===============================================================================


echo Starting run 
start runAdapter.bat  C:\uCUBE\service\event\config\cfg\datahandler.xml

start runAdapter.bat  C:\uCUBE\service\event\config\cfg\eventhandler.xml

start runAdapter.bat  C:\uCUBE\service\event\config\cfg\statushandler.xml

echo End run
goto end

:usage
echo usage : Please set environment UCUBE_HOME or JAVA_HOME
goto end

:end