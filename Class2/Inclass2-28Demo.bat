@echo off

set filename=%1

set extention=%~x1

echo %filename%
echo %extention%

IF /1 %extenstion%==.jpg (
	echo Conversion needed
) else (
	echo No conversion needed
	)
	
rem set gray=grey_%1

rem magick convert %1 -grayscale Rec709Luninance %grey%

rem del /q %grey%