@echo off

rem user input
rem echo %1

rem echo %~1

set fp=%~1
set sp=%~2

set /a "sum=fp+sp"

echo %sum%

set /a "mod=(fp+sp)%%2"

echo %mod%


IF %mod%==0 echo even
IF %mod%==1 echo odd