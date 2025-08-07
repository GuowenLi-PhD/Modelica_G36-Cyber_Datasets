# modelica-fault-library
Base library for Modelica fault modeling of thermal fluid systems. 
This library provides a holistic way of fault modeling and simulation for FMU-supported energy simulators.
The library is mainly demonstrated for Modelica tools.
More detailed description of this library can be found at `/modelica-fault-library/docs`.

# 1. Installation and Dependency
The following environment and libraies are required to run the cases as shown in this library.

Because current developing environment is windowsOS, we cannot provide a batch script for installing everything.
However, we will provide a bash script for installing the whole environment in a linux OS and a docker file in the near future.

## 1.1 Tested 
### 1.1.1 Base Environment
The following enviroment is mainly tested for this library:
- OS: Windows 10
- Modelica tool: Dymola 2020
- Python: Python 2.7/Python3.8

### 1.1.2 Installation Guideline
In this section, we assume the base environment has been installed, and only focus on the dependency installation.

1. Modelica FMU environment.

    One way for Modelica models to communicate with other tools is through FMU. Exporting a Modelica model to FMU requires rumtime license in Dymola, and this type of license usually is available as part of the standard license.

2. Python FMU environment - `pyfmi=2.6`

    This is for simulating FMUs in a python environment using python scripts as the master. 
    The library `pyfmi` is designed for this purpose, and actively maintained.
    The easist way to install `pyfmi` is through `conda` as shown in https://anaconda.org/conda-forge/pyfmi. 

    Note that currently only pyfmi 2.6 is supported. See issue #[218](https://github.com/YangyangFu/modelica-fault-library/issues/218).
    
3. FMU-based Fault Injection Framework
   
   This is for parsing, auto-generating FMU and simulating FMUs for the purposes of this project.

   `Buildingspy<=2.1.0`:        
   
   This is a python library that is used for running Modelica simulations using Dymola. 
   This project inherits a historian version of this library and extends it by adding capabilities of automatically generating Dymola FMU as shown in `pydymola`.

   This library has to be installed at a specific version.
   Any verion higher than `2.1.0` will not be compitible due to a significant code refactoring of `buildingspy` recently (https://github.com/lbl-srg/BuildingsPy).

   The major python libraries such as `parsing`, `pydymola`, `pyscore`, `pysimulate` and `pysthreat` are developed in this project basing on the the aforementioned `pyfmi` and `buildingspy 2.1.0`. Some other common python libraries such as `numpy`, `pandas` `matplotlib` and `scipy` are also required.

4. MPC Environment.
   
   The optimization problem currently is proposed to be established and solved in this Python environment.
   An optimization package `casadi` can be installed for this purpose. 
   Details can be referred to https://web.casadi.org/.

### 1.2.3 Installation Script for Python Support
For the installation, we assume `conda` is available in the local computer.

(1). For creating a python 3.8 environment, we can leverage the virtual environment delivered by `conda`:

```txt
conda create --name cyber-attack-py38 python=3.8
conda activate cyber-attack-py38
pip install buildingspy==2.1.0
conda install -c conda-forge pyfmi==2.6
conda install -c conda-forge numpy==1.17.5
conda install -c conda-forge pandas
conda install -c anaconda flask
conda install -c conda-forge casadi
```

Or we can directly install from a file:

```txt
conda env create -f cyber-attack-py38.yml
```

(2). If an MPC environment is developed based on `openopt` instead of `casadi`, then a python 3.7 or lower envrionment has to be created:

```txt
conda create --name cyber-attack-py37 python=3.7
conda activate cyber-attack-py37
pip install buildingspy==2.1.0
conda install -c conda-forge pyfmi==2.6
conda install -c conda-forge numpy==1.17.5
conda install -c conda-forge pandas
conda install -c anaconda flask
pip install openopt
pip install FuncDesigner
pip install DerApproximator
```
Or we can directly install from a file:

```txt
conda env create -f cyber-attack-py37.yml
```

## 1.2 To-be Tested 
- OS: Linux
- Modelica tool: jModelica

# 2. How to Run
To run the examples for fault modeling and simulation, we can direct to `testcases\1-attack-evaluation`, where different attack cases are located.

To test the newly installed envrionment, we can further go to `case0`, which is the baseline case and no attacks are launched in the building system. 
Open an terminal under the folder `/XXX/XX/case0`, and type:

        testcase.bat

This will call `testcase.py` for fault simulation. 
Real-time impact evaluation KPI values will be outputted to the terminal as the simulation proceed.


# 3. Contact

Dr. Yangyang Fu: yangyang.fu@tamu.edu

Dr. Zheng O'Neill: zoneill@tamu.edu

