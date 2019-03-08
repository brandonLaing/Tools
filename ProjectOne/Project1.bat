@echo off

set command=%1

IF "%command%"=="help" CALL :Help

IF "%command%"=="rainbow" CALL :MakeRainbowVersions %2

IF "%command%"=="resize" CALL :ResizeImage %2 %3

IF "%command%"=="border" CALL :PutBlackBoarders %2







	EXIT /B 0
	
:: Debugs out help info
:Help
	echo rainbow [FileName] - makes array of rainbow colored version of that image
	echo resize [FileName] [size] - makes a copy of an image at a certainn size
	echo border [FileName] - makes copy of an image and adds borders to it
	
	Exit /B 0
	
:: Takes a single image and makes a series of diffrent colored versions
:: @Param1: File you are wanting to copy
:MakeRainbowVersions
	:: set file names for the in and out
	set baseFileName=%1
	set greyFileName=grey_%baseFileName%
	set baseExtention=%~x1
	
	IF NOT "%baseExtention%"==".jpg" (
		IF NOT "%baseExtention%"==".png" (
			echo Use a .jpg or .png
			Exit /B 0
		)
	)
	
	:: Make the gray version
	magick convert %baseFileName% -grayscale Rec709Luminance %greyFileName%
	 
	:: Make different colors for each version
	CALL :MakeNewImage %greyFileName% violet %baseFileName%
	CALL :MakeNewImage %greyFileName% blue %baseFileName%
	CALL :MakeNewImage %greyFileName% green %baseFileName%
	CALL :MakeNewImage %greyFileName% yellow %baseFileName%
	CALL :MakeNewImage %greyFileName% orange %baseFileName%
	CALL :MakeNewImage %greyFileName% red %baseFileName%

	:: Delete the gray file
	del /q %greyFileName%
	
	Exit /B 0

:: Takes an image and adds a color filter over it
:: @Param1: File you are copying from
:: @Param2: name of the color you are trying to make
:: @Param3: Base file name
:MakeNewImage
	:: Grab the base file name
	set fileToCopy=%~1
	:: get the color
	set color=%~2
	:: Make the exit files name
	set newFileName=%color%_%~3
	
	:: If there is already a file of that name. Dont over write it
	if exist %newFileName% (
		echo Image already exist for %newFileName%
	) else (
		magick convert %fileToCopy% ( -clone 0 -fill %color% -colorize 50 ^) -compose multiply -composite %newFileName%
	)
	
	EXIT /B 0
	
:: Takes an image and rezies it
:: @Param1: Name of the file you want to resize
:: @Param2: Size that you want the image set to
:ResizeImage
	set fileName=%1
	set imageSize=%2
	set resizedFileName=%imageSize%_%fileName%
	
	if %imageSize% GTR 32 (
		if %imageSize% LSS 1024 (
			magick %fileName% -resize "%imageSize%x%imageSize%" -gravity center -extent %imageSize%x%imageSize% %resizedFileName%
		)
	)
	
	Exit /B 0
	
:: Adds a black boarder to the desired 256x256 image
:: @Param1: name of the file you are wanting to add boarders to
:PutBlackBoarders
	set boarderFilename=%~1
	
	rem top left boarder
	magick %boarderFilename% -draw "rectangle 0,0 12,40" bordered_%boarderFilename%
	magick bordered_%boarderFilename% -draw "rectangle 0,0 40,12" bordered_%boarderFilename%
	
	magick convert bordered_%boarderFileName% -flip bordered_%boarderFilename%
	
	magick bordered_%boarderFilename% -draw "rectangle 0,0 12,40" bordered_%boarderFilename%
	magick bordered_%boarderFilename% -draw "rectangle 0,0 40,12" bordered_%boarderFilename%

	magick convert bordered_%boarderFileName% -flop bordered_%boarderFilename%
	
	magick bordered_%boarderFilename% -draw "rectangle 0,0 12,40" bordered_%boarderFilename%
	magick bordered_%boarderFilename% -draw "rectangle 0,0 40,12" bordered_%boarderFilename%
	
	magick convert bordered_%boarderFileName% -flip bordered_%boarderFilename%
	
	magick bordered_%boarderFilename% -draw "rectangle 0,0 12,40" bordered_%boarderFilename%
	magick bordered_%boarderFilename% -draw "rectangle 0,0 40,12" bordered_%boarderFilename%

	magick convert bordered_%boarderFileName% -flop bordered_%boarderFilename%
	
	EXIT /B 0