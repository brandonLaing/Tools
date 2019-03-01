@echo off

set filename=%1

set extention=%~x1

IF %extention%==.jpg (
	set grayFilename=grey_%filename%
	set redFilename=red%filename%
	set orangeFilename=orange%filename%
	set yellowFilename=yello_%filename%
	set greenFilename=green_%filename%
	set blueFilename=blue_%filename%
	set violetFilename=violet_%filename%
	
	
	
	
) else (
	echo No conversion needed
	)