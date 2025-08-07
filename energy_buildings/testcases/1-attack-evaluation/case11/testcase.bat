rem add library dependencies
rem add Buildings library to Modelicapath
echo on
rem direct to some folders
for %%a in ("%CD%") do set "p_dir=%%~dpa"
for %%a in (%p_dir:~0,-1%) do set "p2_dir=%%~dpa"
for %%a in (%p2_dir:~0,-1%) do set "p3_dir=%%~dpa"

set BUILDINGS_PATH=Libraries\
set BUILDINGS_FULL_PATH=%p3_dir%%BUILDINGS_PATH%
echo %BUILDINGS_FULL_PATH%
set MODELICAPATH=%BUILDINGS_FULL_PATH%;%MODELICAPATH% 

rem add ThreatInjection library to Modelicapath
set THREATINJECTION_PATH=%p3_dir%
set MODELICAPATH=%THREATINJECTION_PATH%;%MODELICAPATH%

rem add template model to ModelicaPATH
set TEMPLATE_RELATIVE_PATH=model\
set TEMPLATE_FULL_PATH=%p_dir%%TEMPLATE_RELATIVE_PATH%
set MODELICAPATH=%TEMPLATE_FULL_PATH%;%MODELICAPATH%

rem add python libraries to PYTHONPATH
set PYTHONPATH=%THREATINJECTION_PATH%;%PYTHONPATH%

python testcase.py