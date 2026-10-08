@echo off

echo ===============================================================================
REM :END
REM if "%NOPAUSE%" == "" pause

REM :END_NO_PAUSE


echo Copyright (c) 2007 POSDATA Co., Ltd
echo All rights reserved.

echo Posdata u-CUBE User compilation batch file

if {"%UCUBE_HOME%"}=={} goto usage
if {"%JAVA_HOME%"}=={} goto usage

REM Setting JBOSS_HOME

set JBOSS_HOME="%UCUBE_HOME%\engine\jboss"


REM Starting Engine 

echo End Starting MySQL

rem Copy jbossmq-destinations-service.xml File
FOR /F "tokens=1-3 delims=- " %%i IN ('date /t') DO SET date=%%i%%j%%k
FOR /F "tokens=1-3 delims=: " %%i IN ('time /t') DO SET time=%%j%%k

SET backup_name=jbossmq-destinations-service.xml_%date%%time%.bak
echo %JBOSS_HOME%\server\%*\deploy\jms\%backup_name%

rem Backup jbossmq-destinations-service.xml File

echo copy %JBOSS_HOME%\server\%*\deploy\jms\jbossmq-destinations-service.xml %JBOSS_HOME%\server\%*\deploy\jms\%backup_name%
copy /Y %JBOSS_HOME%\server\%*\deploy\jms\jbossmq-destinations-service.xml %JBOSS_HOME%\server\%*\deploy\jms\%backup_name%

rem Copy jbossmq-destinations-service.xml File
copy /Y %JBOSS_HOME%\server\%*\ucube\jbossmq-destinations-service.xml %JBOSS_HOME%\server\%*\deploy\jms


%JBOSS_HOME%\bin\run.bat -c %*

:usage
echo usage : Please set environment UCUBE_HOME or JAVA_HOME
goto end

:end



