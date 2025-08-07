rem add library dependencies
rem add Buildings library to Modelicapath
echo on

set BUILDINGS_PATH="D:\github\modelica-fault-library\Libraries"
echo %MODELICAPATH%|find /i "%BUILDINGS_PATH%">nul || set MODELICAPATH=%BUILDINGS_PATH%;%MODELICAPATH% 
rem add ThreatInjection library to Modelicapath
set THREATINJECTION_PATH="D:\github\modelica-fault-library"
echo %MODELICAPATH%; |find /i "%THREATINJECTION_PATH%;" >nul || set MODELICAPATH=%THREATINJECTION_PATH%;%MODELICAPATH%
rem add current model to ModelicaPATH
set CURRENT_PATH="%CD%"
echo %MODELICAPATH%|find /i "%CURRENT_PATH%">nul || set MODELICAPATH=%CURRENT_PATH%;%MODELICAPATH%
rem add python libraries to PYTHONPATH
echo %PYTHONPATH%|find /i "%THREATINJECTION_PATH%">nul || set PYTHONPATH=%THREATINJECTION_PATH%;%PYTHONPATH%

python testcase.py