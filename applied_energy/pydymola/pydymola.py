#!/usr/bin/env/ python
# -*- coding: utf-8 -*-
#
#
# import from future to make Python2 behave like Python3
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals
from future import standard_library
standard_library.install_aliases()
from builtins import *
from io import open
# end of from future import

import os
# Depends on buildingspy 2.1.0: this should be updated 
# because buildingspy has some ongoing refacotring of codes.
from buildingspy.simulate.Simulator import Simulator

class dymola(Simulator):
    """
    Class that inherits from simulator classess 
            as defined in buildingspy. 
    
    This child class adds function for translating Modelica models into fmu.

    """    

    def __init__(self,model_name, file_name=[],outputDirectory='.'):
        """
        __init__ Method that initialzes a dymola class

        :param model_name: name of the dymola model
        :type model_name: str
        :param file_name: List of the paths of dependent libraries, defaults to []
        :type file_name: list, optional
        :param outputDirectory: output directory, defaults to '.'
        :type outputDirectory: str, optional
        :raises ValueError: More than one file names is passed: consider combine them as one file or add them into MODELICAPATH!    

        * Only model_name is passed: 
            - Class is assumed to be in MODELICAPATH.
    
         * model_name and file_name is passed:
            - file_name is be a list of path (string)   
        """
        if not file_name:
            file_name = None
        elif len(file_name) == 0:
            file_name = None
        elif len(file_name) == 1:
            file_name = file_name[0]
        else:
            raise ValueError('More than one file names is passed: consider combine them as one file or add them into MODELICAPATH!')
        
        super(dymola,self).__init__(
            modelName = model_name,
            simulator = "dymola",
            outputDirectory = outputDirectory,
            packagePath = file_name)

    def translateFMU(self,fmu_name,fmi_version,fmi_type):
        """
        Method that translates the model into Dymola FMU.

        This method
            1. Creates a temporary folder and copy work directory to the temporary folder
            2. Writes a Dymola script to simulate the model.
            4. Translates the model.
            5. Copies the results to working directory
            6. Deletes temporary folder
        This method requires that the directory that contains the executable ``dymola``
        is on the system PATH variable. If it is not found, the function returns with
        an error message.

        :param fmu_name: name of generated fmu file
        :type fmu_name: str
        :param fmi_version: fmi version, '1' or '2'
        :type fmi_version: str
        :param fmi_type: fmi type, 'me' for model exchange, 'cs' for co-simulation
        :type fmi_type: str
        :return: path of generated fmu file
        :rtype: str
        """        

        import os
        import shutil

        # Get directory name. This ensures for example that if the directory is called xx/Buildings
        # then the simulations will be done in tmp??/Buildings
        worDir = self._create_worDir()
        self._translateDir_ = worDir
        # Copy directory
        shutil.copytree(os.path.abspath(self._packagePath), worDir)
        
        # Construct the model instance with all parameter values
        # and the package redeclarations
        dec = self._declare_parameters()
        dec.extend(self._modelModifiers_)

        mi = '"{mn}({dec})"'.format(mn=self.modelName, dec=','.join(dec))

        # Define preprocessing commands
         # this is required for Dymola to be integrated into BOPTEST environment 
         # because string parameters are used as an indicator for searching. 
        self.addPreProcessingStatement("Advanced.AllowStringParametersForFMU=true;")        
        self.addPreProcessingStatement("Advanced.FMI.UseExperimentSettings=false;")
        self.addPreProcessingStatement("Advanced.FMI.xmlIgnoreProtected=false;")  
        self.addPreProcessingStatement("Evaluate = false;") 
        self.addPreProcessingStatement("Advanced.FMI.ImageSetting = 1;")
        self.addPreProcessingStatement("Advanced.FMI.Integrate = false;")
    
        try:
            # Write the Modelica script
            runScriptName = os.path.join(worDir, "run_translateFMU.mos")
            with open(runScriptName, mode="w", encoding="utf-8") as fil:
                fil.write(self._get_dymola_fmu_commands(
                    working_directory=worDir,
                    model_name=mi,
                    fmu_name = fmu_name,
                    fmi_version = fmi_version,
                    fmi_type = fmi_type))
            # Run translation
            self._runSimulation(runScriptName,
                                self._simulator_.get('timeout'),
                                worDir)
            # Copy the results to output directory
            fil = fmu_name+'.fmu'
            srcFil = os.path.join(worDir,fil)
            newFil = os.path.join(self._outputDir_,fil)
            try:
                if os.path.exists(srcFil):
                    shutil.copy(srcFil, newFil)
                else:
                    raise ValueError("Failed to generate '" +
                            srcFil + "'.")   
            except IOError as e:
                self._reporter.writeError("Failed to copy '" +
                                          srcFil + "' to '" + newFil +
                                          "; : " + e.strerror)            
            # Delete temporary folder
            self._deleteTemporaryDirectory(worDir)

        except BaseException:
            self._reporter.writeError("Translation failed in '" + worDir + "'\n" +
                                        "   You need to delete the directory manually.")
            raise

        # return the fmu location
        return newFil

    def _get_dymola_fmu_commands(self, working_directory, model_name,fmu_name, fmi_version, fmi_type):
        """
        Method that returns a string that contains all the commands required
                to run or translate the model into dymola FMU.

        :param working_directory: Working directory for the simulation or translation.
        :type working_directory: str
        :param model_name: Class name of Modelica model
        :type model_name: str
        :param fmu_name: name of fmu file
        :type fmu_name: str
        :param fmi_version: fmi version, '1' or '2'
        :type fmi_version: str
        :param fmi_type: fmi type, 'me' for model exchange, 'cs' for co-simulation
        :type fmi_type: str
        :return: Dymola commands for generating fmu
        :rtype: str        
        """     

        s = """
            // File autogenerated by _get_dymola_fmu_commands
            // Do not edit.
            //cd("{working_directory}");
            """.format(working_directory=working_directory)
        # Pre-processing commands
        for prePro in self._preProcessing_:
            s += prePro + '\n'

        s += "modelInstance={0};\n".format(model_name)
        # translate_fmu:
        s += """translateModelFMU(modelInstance, false, "{fmu_name}","{fmi_version}","{fmi_type}");\n
            """.format(fmu_name=fmu_name,
                    fmi_version = fmi_version,
                    fmi_type = fmi_type)

        # Post-processing commands
        for posPro in self._postProcessing_:
            s += posPro + '\n'

        if self._exitSimulator:
            s += "Modelica.Utilities.System.exit();\n"
        return s

if __name__ == '__main__':
    modelName = 'SimpleRC'
    dy = dymola(modelName,outputDirectory='.')
    print(dy._packagePath)

    # test command generation
    fmu_name = 'fmu'
    fmi_version = '2'
    fmi_type = 'cs'
    fmu = dy.translateFMU(fmu_name,fmi_version,fmi_type)
    print (fmu)
