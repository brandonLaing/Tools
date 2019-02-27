@echo off

IF /I %1==a set a=%2
IF /I %1==b set b=%2
IF /I %3==a set a=%4
IF /I %3==b set b=%4

echo a: %a%, b: %b%