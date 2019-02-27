@echo off

rem i am a comment

set a=foo

echo %a%

set b=bar

echo %a%%b%

set c=%a%%b%

echo %c%

set x=123
set y=456

set z=%x%+%y%

echo %z%

set /a "znum=x+y"
echo znum after arithmetic set: %znum%