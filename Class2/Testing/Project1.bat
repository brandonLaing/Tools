@echo off

set command=%1

:: If user ask for help give it to them
IF "%command%"=="help" GOTO :Help

:: If user ask for rainbow and the file type is correct start making the file
IF "%command%"=="rainbow" GOTO :MakeRainbowVersions %2 %~x2

IF %command%==resize (
	set fileName=%2
	set imageSize%3
	CALL :ResizeImage %fileName% %imageSize%
)

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
	set baseExtention=%2
	set greyFileName=grey_%baseFileName%
	
	echo baseExt: %baseExtention%
	::IF NOT "%baseExtention%"==".jpg" (
	::	IF NOT "%baseExtention%"==".png" (
	::		echo Use a .jpg or .png
	::		Exit /B 0
	::	)
	::)
	
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
	del /q %grayFileName%
	
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
		EXIT /B 0
	:: If there isnt a file already there clone it with a different color
	) else (
		magick convert %fileToCopy% ( -clone 0 -fill %color% -colorize 50 ^) -compose multiply -composite %newFileName%
	)
	
	EXIT /B 0
	
:: Adds a black boarder to the desired 256x256 image
:: @Param1: name of the file you are wanting to add boarders to
:PutBlackBoarders
	set boarderFilename=%~1
	
	rem top left boarder
	magick %boarderFilename% -draw "rectangle 0,0 12,40" %boarderFilename%
	magick %boarderFilename% -draw "rectangle 0,0 40,12" %boarderFilename%
	
	rem top right boarder
	magick %boarderFilename% -draw "rectangle 256,0 244,40" %boarderFilename%
	magick %boarderFilename% -draw "rectangle 256,0 216,12" %boarderFilename%
	
	rem bottom left boarder
	magick %boarderFilename% -draw "rectangle 0,256 12,216" %boarderFilename%
	magick %boarderFilename% -draw "rectangle 0,265 40,244" %boarderFilename%
	
	rem bottom right boarder
	magick %boarderFilename% -draw "rectangle 256,256 244,216" %boarderFilename%
	magick %boarderFilename% -draw "rectangle 256,256 216,244" %boarderFilename%
	
	EXIT /B 0

:: Takes an image and rezies it
:: @Param1: Name of the file you want to resize
:: @Param2: Size that you want the image set to
:ResizeImage
	set fileName=%1
	set imageSize=%2
	set resizedFileName=%imageSize%_%fileName%

	magick %fileName% -resize "%imageSize%x%imageSize%" -gravity center -extent %imageSize%x%imageSize% %resizedFileName%

	Exit /B 0