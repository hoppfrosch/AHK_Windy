@echo off
echo.
echo Creating documentation....
echo.

SET WORK=MKDOC_TEMP
mkdir %WORK%
REM copy ..\lib\Windy\Mony.ahk %WORK%
copy ..\lib\Windy.ahk %WORK%\Windy_Main.ahk
copy ..\lib\Windy\Mony.ahk %WORK%
copy ..\lib\Windy\MultiMony.ahk %WORK%
copy ..\lib\Windy\Recty.ahk %WORK%
copy ..\lib\Windy\Pointy.ahk %WORK%
copy ..\lib\Windy\Mousy.ahk %WORK%
copy ..\lib\Windy\Windy.ahk %WORK%

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
