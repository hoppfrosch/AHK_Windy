@echo off
echo.
echo Creating documentation....
echo.

SET WORK=MKDOC_TEMP
mkdir %WORK%
copy ..\lib\Windy\MultiMonitorEnv.ahk %WORK%
copy ..\lib\Windy\Rectangle.ahk %WORK%
copy ..\lib\Windy\Point.ahk %WORK%
REM copy ..\lib\Windy\Mouse.ahk %WORK%
copy ..\lib\Windy\WindowHandler.ahk %WORK%

::path to the natural doc folder
SET NDPATH=D:\Portable\PortableApps\AutoHotkey\App\Tools\NaturalDocs\NaturalDocs

pushd %WORK%

::project root path
SET ROOT=%CD%

::documentation folder
SET DOC=_doc

mkdir "%ROOT%\%DOC%\_ndProj" 2>nul
pushd "%NDPATH%"
if exist "%ROOT%\images" SET IMG=-img "%ROOT%\images"

call NaturalDocs.bat -i "%ROOT%" -o HTML "%ROOT%\%DOC%" -p "%ROOT%\%DOC%\_ndProj" %IMG%

popd

if "%1" == "s" (
echo Merging html files ...
mkdocs
rmdir /Q /S _doc
echo Done.
echo.
)

popd

.. Publish documentation to gh-page branch ...
pushd ..\..\AHK_Windy_gh-pages
xcopy /E /Y %ROOT%\%DOC% .
popd
rmdir /S /Q %WORK%
