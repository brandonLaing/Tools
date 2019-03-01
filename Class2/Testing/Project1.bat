@echo off

rem If user ask for help give it to them
IF %1==help (
	echo Enter rainbow [Filename] to make copies of that file in rainbow form

rem If user ask for rainbow and the file type is correct start making the file
) else if %1==rainbow (
	set filename=%2
	IF not %~x2==.jpg ( 
		IF not %~x2==.png ( 
			echo Use a .jpg or .png
			exit /b 2 
		) 
	)
	
	set grayFilename=gray_%filename%
	magick convert %filename% -grayscale Rec709Luminance %grayFilename%
	magick %grayFilename% -resize "256x256" -gravity center -extent 256x256 %grayFilename%
	
	CALL :PutBlackBoarders %grayFilename%
	
	CALL :MakeNewImage %grayFilename% violet %filename%
	CALL :MakeNewImage %grayFilename% blue %filename%
	CALL :MakeNewImage %grayFilename% green %filename%
	CALL :MakeNewImage %grayFilename% yellow %filename%
	CALL :MakeNewImage %grayFilename% orange %filename%
	CALL :MakeNewImage %grayFilename% red %filename%
	
	del /q %grayFilename%
	
	EXIT /B 0
)

rem Takes an image and adds a color filter over it
:: @Param: File you are copying from
:: @Param: name of the color you are trying to make
:: @Param: Base file name
:MakeNewImage
	set fileToCopy=%~1
	set color=%~2
	set newFileName=%color%_%~3
	if exist %newFileName% (
		echo Image already exist for %newFileName%
		EXIT /B 0
	) else (
		magick convert %fileToCopy% ( -clone 0 -fill %color% -colorize 50 ^) -compose multiply -composite %newFileName%
	)
	EXIT /B 0
	
rem Adds a black boarder to the desired 256x256 image
:: @Param: name of the file you are wanting to add boarders to
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