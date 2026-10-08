@echo off
cls


echo Copyright (c) 2007 POSDATA Co., Ltd
echo All rights reserved.

echo Posdata u-CUBE User compilation batch file

if {"%UCUBE_HOME%"}=={} goto usage
if {"%JAVA_HOME%"}=={} goto usage

REM Setting JBOSS_HOME

set JBOSS_HOME="%UCUBE_HOME%\engine\jboss"


REM Starting Engine 
%JBOSS_HOME%\bin\run.bat -c messaging2

:usage
echo usage : Please set environment UCUBE_HOME or JAVA_HOME
goto end

:end

