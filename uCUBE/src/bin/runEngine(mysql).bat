@echo off
cls


echo Copyright (c) 2007 POSDATA Co., Ltd
echo All rights reserved.

echo Posdata u-CUBE User compilation batch file

if {"%UCUBE_HOME%"}=={} goto usage
if {"%JAVA_HOME%"}=={} goto usage

REM Setting JBOSS_HOME

set JBOSS_HOME="%UCUBE_HOME%\engine\jboss"

echo "Copy jbossmq-destinations-service.xml File" 
copy %JBOSS_HOME%\server\messaging\deploy\jms\jbossmq-destinations-service.xml %JBOSS_HOME%\server\messaging\deploy\jms\jbossmq-destinations-service.xml_%date%.bak
copy %JBOSS_HOME%\server\messaging\ucube\jbossmq-destinations-service.xml %JBOSS_HOME%\server\messaging\deploy\jms\

echo copy engine_db_configuration_file to deploy
move %UCUBE_HOME%\engine\jboss\server\messaging\deploy\hsqldb-ds.xml %UCUBE_HOME%\engine\jboss\server\messaging\ucube\hsqldb-ds.xml
move %UCUBE_HOME%\engine\jboss\server\messaging\deploy\jms\hsqldb-jdbc2-service.xml %UCUBE_HOME%\engine\jboss\server\messaging\ucube\hsqldb-jdbc2-service.xml
copy %UCUBE_HOME%\engine\jboss\server\messaging\ucube\mysql-ds.xml %UCUBE_HOME%\engine\jboss\server\messaging\deploy\mysql-ds.xml
copy %UCUBE_HOME%\engine\jboss\server\messaging\ucube\mysql-jdbc2-service.xml %UCUBE_HOME%\engine\jboss\server\messaging\deploy\jms\mysql-jdbc2-service.xml

REM Starting Engine 
%JBOSS_HOME%\bin\run.bat -c messaging

:usage
echo usage : Please set environment UCUBE_HOME or JAVA_HOME
goto end

:end

