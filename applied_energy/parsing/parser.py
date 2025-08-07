# -*- coding: utf-8 -*-
"""
Implements the parsing and code generation for signal exchange blocks.

The steps are:
1) Compile Modelica code into fmu
2) Use signal exchange block id parameters to find block instance paths and 
read any associated signals for KPIs, units, min/max, and descriptions.
3) Write Modelica wrapper around instantiated model and associated KPI list.
4) Export as wrapper FMU and save KPI json.
5) Save test case data within wrapper FMU.

"""

from pyfmi import load_fmu
import os
import json
import warnings
#import collections

def parse_instances(model_path, file_name, fmu_name = 'fmu', fmi_version = '2.0', fmi_type = 'cs',simulator='jmodelica',  output_directory='.'):
    """
    Method that parses the signal exchange block class instances using fmu xml.

    :param model_path: class name of Modelica model
    :type model_path: str
    :param file_name: file path
    :type file_name: str
    :param fmu_name: name of fmu file, defaults to 'fmu'
    :type fmu_name: str, optional
    :param fmi_version: fmi version, defaults to '2.0'
    :type fmi_version: str, optional
    :param fmi_type: fmi type, defaults to 'cs'
    :type fmi_type: str, optional
    :param simulator: Modelica simulator, 'dymola' or 'jmodelica', defaults to 'jmodelica'
    :type simulator: str, optional
    :param output_directory: output directory, defaults to '.'
    :type output_directory: str, optional
    :raises ValueError: FMU version must be 2.0
    :return: dictionary of overwrite and read block class instance lists, and signals
    :rtype: dict, dict
    """    

    fmu_path = translate_fmu(model_path,file_name, fmu_name, fmi_version, fmi_type, simulator)
    fmu = load_fmu(fmu_path)

    # Check version
    if fmu.get_version() != '2.0':
        raise ValueError('FMU version must be 2.0')
    # Get all parameters and fmu descriptions
    #allvars = collections.OrderedDict(list(fmu.get_model_variables(variability = 0).items()) + \
    #    list(fmu.get_model_variables(variability = 1).items()))
    allvars = fmu.get_model_variables(variability = 0).keys() + \
            fmu.get_model_variables(variability = 1).keys()
 
    # Initialize dictionaries
    instances = {'Overwrite':dict(), 'OverwriteParameter':dict(),'Read':dict()}
    signals = {}
    # Find instances of 'Overwrite' or 'Read'
    for var in allvars:
        # Get instance name
        instance = '.'.join(var.split('.')[:-1])
        # Overwrite variable
        if 'boptestOverwrite' in var: 
            label = 'Overwrite'
            unit = fmu.get_variable_unit(instance+'.u')
            # String parameter is compiled as a start value in Dymola
            description = fmu.get_variable_start(instance+'.description')
            start = None
            mini = fmu.get_variable_min(instance+'.u')
            maxi = fmu.get_variable_max(instance+'.u')
        elif 'mtiOverwriteParameter'in var:
            label = 'OverwriteParameter'
            unit = fmu.get_variable_unit(instance+'.p')
            # String parameter is compiled as a start value in Dymola
            description = fmu.get_variable_start(instance+'.description')
            start = fmu.get_variable_start(instance+'.p')
            mini = fmu.get_variable_min(instance+'.p')
            maxi = fmu.get_variable_max(instance+'.p')

        # Read
        elif 'boptestRead' in var:
            label = 'Read'
            unit = fmu.get_variable_unit(instance+'.y')
            description = fmu.get_variable_start(instance+'.description')
            start = None
            #description = fmu.get(instance+'.description')[0]
            mini = None
            maxi = None
        # KPI
        elif 'KPIs' in var:
            label = 'kpi'
        else:
            continue
        # Save instance
        if label is not 'kpi':
            instances[label][instance] = {'Unit' : unit}
            instances[label][instance]['Description'] = description
            instances[label][instance]['Start'] = start
            instances[label][instance]['Minimum'] = mini
            instances[label][instance]['Maximum'] = maxi
        else: # don't care about KPIs
            continue

    # Clean up
    os.remove(fmu_path)
    os.remove(fmu_path.replace('.fmu', '_log.txt'))
    return instances, signals

def write_wrapper(model_path, file_name, instances,fmi_version='2.0', fmi_type='cs',simulator='jmodelica'):
    """
    Method that writes the wrapper modelica model and export as fmu

    :param model_path: path to orginal modelica model
    :type model_path: str
    :param file_name: path(s) to modelica file and required libraries not on MODELICAPATH. 
    :type file_name: str
    :param instances: dictionary of overwrite and read block class instance lists
    :type instances: dict
    :param fmi_version: fmi version, defaults to '2.0'
    :type fmi_version: str, optional
    :param fmi_type: fmi type, defaults to 'cs'
    :type fmi_type: str, optional
    :param simulator: Modelica simulator, 'dymola' or 'jmodelica', defaults to 'jmodelica'
    :type simulator: str, optional
    :return: paths to wrapped fmu model and Modelica model
    :rtype: str, str
    """    

    # Check for instances of Overwrite and/or Read blocks
    len_write_blocks = len(instances['Overwrite'])
    len_parameter_blocks = len(instances['OverwriteParameter'])
    len_read_blocks = len(instances['Read'])
    # If there are, write and export wrapper model
    if (len_write_blocks + len_parameter_blocks + len_read_blocks):
        # Define wrapper modelica file path
        wrapped_path = 'wrapped.mo'
        # Open file
        with open(wrapped_path, 'w') as f:
            # Start file
            f.write('model wrapped "Wrapped model"\n')
            # Add outputs for every overwrite parameter block
            f.write('\t// Parameter Overwrite\n')
            parameter_w_info = dict()
            parameter_wo_info = dict()
            for block in instances['OverwriteParameter'].keys():
                # Add to singal input list with and without attributes
                parameter_w_info[block] = _make_var_name(block,style='parameter',description=instances['OverwriteParameter'][block]['Description'],attribute='(unit="{0}", min={1}, max={2})'.format(instances['OverwriteParameter'][block]['Unit'], instances['OverwriteParameter'][block]['Minimum'], instances['OverwriteParameter'][block]['Maximum']))
                parameter_wo_info[block] = _make_var_name(block,style='parameter')
                # Instantiate parameter
                f.write('\tparameter Real {0} = {1} "{2}";\n'.format(_make_var_name(block,style='parameter',attribute='(unit="{0}")'.format(instances['OverwriteParameter'][block]['Unit'])), instances['OverwriteParameter'][block]['Start'],instances['OverwriteParameter'][block]['Description']))

            # Add inputs for every overwrite block
            f.write('\t// Input overwrite\n')
            input_signals_w_info = dict()
            input_signals_wo_info = dict()
            input_activate_w_info = dict()
            input_activate_wo_info = dict()
            for block in instances['Overwrite'].keys(): # Overwrite variables
                # Add to signal input list with and without units
                input_signals_w_info[block] = _make_var_name(block,style='input_signal',description=instances['Overwrite'][block]['Description'],attribute='(unit="{0}", min={1}, max={2})'.format(instances['Overwrite'][block]['Unit'], instances['Overwrite'][block]['Minimum'], instances['Overwrite'][block]['Maximum']))
                input_signals_wo_info[block] = _make_var_name(block,style='input_signal')
                # Add to signal activate list
                input_activate_w_info[block] = _make_var_name(block,style='input_activate',description='Activation for {0}'.format(instances['Overwrite'][block]['Description']))
                input_activate_wo_info[block] = _make_var_name(block,style='input_activate')
                # Instantiate input signal
                f.write('\tModelica.Blocks.Interfaces.RealInput {0};\n'.format(input_signals_w_info[block], block))
                # Instantiate input activation
                f.write('\tModelica.Blocks.Interfaces.BooleanInput {0};\n'.format(input_activate_w_info[block], block))
            # Add outputs for every read block
            f.write('\t// Out read\n')
            for block in instances['Read'].keys():
                # Instantiate input signal
                f.write('\tModelica.Blocks.Interfaces.RealOutput {0} = mod.{1}.y "{2}";\n'.format(_make_var_name(block,style='output',attribute='(unit="{0}")'.format(instances['Read'][block]['Unit'])), block, instances['Read'][block]['Description']))
            # Add original model
            f.write('\t// Original model\n')
            f.write('\t{0} mod(\n'.format(model_path))
            # Connect parameter to original model overwrite
            if len_parameter_blocks + len_write_blocks:
                instances_overwrite_ls = map(instances.get,['OverwriteParameter','Overwrite'])
                for ite,item in enumerate(instances_overwrite_ls):
                    for i, block in enumerate(item):
                        if ite == 0: # write parameter
                            f.write('\t\t{0}(p={1})'.format(block, parameter_wo_info[block]))
                        elif ite == 1: # write variable
                            f.write('\t\t{0}(uExt(y={1}),activate(y={2}))'.format(block, input_signals_wo_info[block], input_activate_wo_info[block]))
                        else:
                            ValueError('Unknown overwrite type!!!')

                        if i == len(item)-1 and ite == len(instances_overwrite_ls)-1:
                            f.write(') "Original model with overwrites";\n')
                        else:
                            f.write(',\n')
            else:
                f.write(') "Original model without overwrites";\n')

            # End file
            f.write('end wrapped;')
        # Export as fmu
        fmu_path = translate_fmu('wrapped',file_name, 'wrapped', fmi_version, fmi_type, simulator)

    # If there are not, write and export wrapper model
    else:
        # Warn user
        warnings.warn('No signal exchange block instances found in model.  Exporting model as is.')
        # Compile fmu
        fmu_path = translate_fmu(model_path, file_name, 'wrapped', fmi_version, fmi_type, simulator)
        wrapped_path = None

    return fmu_path, wrapped_path

def translate_fmu(model_name,file_name, fmu_name, fmi_version = '2.0', fmi_type='cs',simulator='jmodelica'):
    """
    Method that translates Modelica models into FMU using different simulators

    :param model_path: path to orginal modelica model
    :type model_path: str
    :param file_name: path(s) to modelica file and required libraries not on MODELICAPATH. 
    :type file_name: str
    :param fmu_name: name of fmu file, defaults to 'fmu'
    :type fmu_name: str, optional
    :param fmi_version: fmi version, defaults to '2.0'
    :type fmi_version: str, optional
    :param fmi_type: fmi type, defaults to 'cs'
    :type fmi_type: str, optional
    :param simulator: Modelica simulator, 'dymola' or 'jmodelica', defaults to 'jmodelica'
    :type simulator: str, optional
    :raises ValueError: simulator has to be "jmodelica" or "dymola"
    :return: fmu path
    :rtype: str
    """    

    # Export as fmu
    if simulator is 'jmodelica':
        from pymodelica import compile_fmu
        fmu_path = compile_fmu(class_name = model_name, 
                        file_name = file_name,
                        target = fmi_type, 
                        version = fmi_version, 
                        compile_to = fmu_name+'.fmu')
    elif simulator is 'dymola':
        from pydymola.pydymola import dymola
        fmi_version = int(float(fmi_version))
        dy = dymola(model_name = model_name, 
                    file_name = file_name)
        fmu_path = dy.translateFMU(fmu_name,fmi_version,fmi_type) 
    else:
        raise ValueError('simulator has to be "jmodelica" or "dymola"')

    return fmu_path

def export_fmu(model_path, file_name,fmi_version='2.0', fmi_type='cs',simulator='jmodelica',output_directory='.'):
    """
    Parse signal exchange blocks and export mti fmu.

    :param model_path: path to orginal modelica model
    :type model_path: str
    :param file_name: path(s) to modelica file and required libraries not on MODELICAPATH. 
    :type file_name: str
    :param fmi_version: fmi version, defaults to '2.0'
    :type fmi_version: str, optional
    :param fmi_type: fmi type, defaults to 'cs'
    :type fmi_type: str, optional
    :param simulator: Modelica simulator, 'dymola' or 'jmodelica', defaults to 'jmodelica'
    :type simulator: str, optional
    :param output_directory: output directory, defaults to '.'
    :type output_directory: str, optional
    :return: fmu path of wrapped Modelica model
    :rtype: str
    """    
    # Get signal exchange instances and kpi signals
    instances, signals = parse_instances(model_path, file_name, 'fmu', fmi_version, fmi_type, simulator, output_directory)
    # Write wrapper and export as fmu
    fmu_path, _ = write_wrapper(model_path, file_name, instances, fmi_version, fmi_type, simulator)
  
    return fmu_path

def _make_var_name(block, style, description='', attribute=''):
    """
    Make a variable name from block instance name.

    :param block: instance name of Modelica block
    :type block: str
    :param style: style of variable to be made.
            "parameter"|"input_signal"|"input_activate"|"output"
    :type style: str
    :param description: description of variable to be added as comment, defaults to ''
    :type description: str, optional
    :param attribute: attribute string of variable, defaults to ''
    :type attribute: str, optional
    :raises ValueError: unknown style
    :return: variable name associated with block
    :rtype: str
    """    

    # General modification
    name = block.replace('.', '_')
    # Handle empty descriptions
    if description is '':
        description = ''
    else:
        description = ' "{0}"'.format(description)
        
    # Specific modification
    if style is 'input_signal':
        var_name = '{0}_u{1}{2}'.format(name,attribute, description)
    elif style is 'input_activate':
        var_name = '{0}_activate{1}'.format(name, description)
    elif style is 'output':
        var_name = '{0}_y{1}{2}'.format(name,attribute, description)
    elif style is 'parameter':
        var_name = '{0}_p{1}{2}'.format(name,attribute, description)
    else:
        raise ValueError('Style {0} unknown.'.format(style))

    return var_name
        

if __name__ == '__main__':
    # Define model
    model_path = 'SimpleRC_Parameter'
    #mo_path = 'SimpleRC.mo'
    # translate fmu
    #fmu_rc_path = translate_fmu(model_path,[],'SimpeRC_Parameter',simulator='dymola')
    # Parse and export
    fmu_path= export_fmu(model_path, [], simulator='dymola')
    # Print information
    print('Exported FMU path is: {0}'.format(fmu_path))
