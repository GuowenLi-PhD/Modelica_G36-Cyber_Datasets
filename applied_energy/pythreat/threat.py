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

import numpy as np
import scipy.signal as SG

from pythreat.temporal import Temporal

class Threat(object):
    """
    Class that defines a threat

    """
    def __init__(self, active=False,start_threat = 0., end_threat = 3600., \
        temporal = None,injection = 'v'):
        """
        Initialize a Threat class

        :param active: active status of the threat, defaults to False
        :type active: bool, optional
        :param start_threat: threat start time, defaults to 0.
        :type start_threat: float, optional
        :param end_threat: threat end time, defaults to 3600.
        :type end_threat: float, optional
        :param temporal: instance of Temporal object
        :type temporal: Temporal object, optional
        :param injection: injection type, 'v' or 'p', defaults to 'v'
        :type injection: str, optional
        """        

        self.active = active
        self.start_threat = start_threat
        self.end_threat = end_threat
        self.temporal = temporal
        
        if temporal:
            self.location = self.temporal.signal_type.name
        else:
            self.location = ''

        self.injection = injection
        # make sure clock time is earlier than threat start time

class ThreatInjection(object):
    """
    Class that defines the threat injection.

    """

    def __init__(self, threat = None, start_time = 0., end_time = 300., step = 60.):
        """
        Initialize a ThreatInjection class

        :param threat: instance of Threat object, defaults to None
        :type threat: Threat object, optional
        :param start_time: threat injection start time, defaults to 0
        :type start_time: float, optional
        :param end_time: threat injection end time, defaults to 300
        :type end_time: float, optional
        :param step: threat injection step, defaults to 60
        :type step: float, optional
        """
 
        self.threat = threat
        self.start_time = start_time
        self.end_time = end_time
        self.step = step
        self.injection = threat.injection

    def overwrite(self):
        """
        Get the output from threat models as a tuple. 
        The output is sent to fmu model as input or parameters.

        :return: pyfmi fmu input object
        :rtype: Tuple, pyfmi fmu input object
        """        
 
        if self.threat.active:
            thr_name = self.threat.location
            act_name = thr_name.split('_')[0]+'_activate'
            
            t, sig_val = self.generate_signal()
            act_value = np.logical_and(t>=self.threat.start_threat,
                                        t<=self.threat.end_threat)

            u_list = [thr_name,act_name]
            u_trac = np.transpose(np.vstack((t.flatten(),sig_val.flatten(), act_value.flatten())))
            input_object = (u_list, u_trac)

        else:
            input_object = None

        return input_object

    def generate_signal(self):
        """
        Generate threatened signal from the definition of threat

        :return: time series of threatened signal
        :rtype: Tuple of numpy arrays
        """

        if self.threat.temporal.attacker.upper() == 'MAX':
            t,signal = self.max_attack()
        elif self.threat.temporal.attacker.upper() == 'CONSTANT':
            t, signal = self.constant_attack()
        elif self.threat.temporal.attacker.upper() == 'SQUARE':
            t, signal = self.square_attack()
        elif self.threat.temporal.attacker.upper() == 'BLOCK':
            t, signal = self.block_attack()
        else:
            pass
        return t, signal

    def min_attack(self):
        pass
    
    def max_attack(self):
        """
        A model that launches the maximum attack on a signal.

        :return: timestamps and signals
        :rtype: Tuple
        """        

        self.t = self._timestamp()
        self.signal = np.array([self._max() for i in self.t]) 

        return (self.t, self.signal)

    def constant_attack(self):
        """
        A model that launches the constant attack on a signal

        :raises ValueError: parameter 'k' of the constant attacker has not been assigned!
        :return: timestamps and signals
        :rtype: Tuple
        """        
        
        # check if key parameters are assigned
        kwargs = self.threat.temporal.kwargs
        
        if 'k' not in kwargs:
            raise ValueError("Parameter 'k' of the constant attacker has not been assigned!")

        self.t = self._timestamp()
        self.signal = np.array([self._constant(**kwargs) for i in self.t]) 

        return (self.t, self.signal)

    def square_attack(self):
        """Square attack that generates a square signal

        :param amplitude: amplitude of a square signal
        :type amplitude: float
        :param period: time corresponding to one cycle
        :type period: float
        :param duty: value between 0 and 1 and determines the relative
                time that the step transition occurs between the start and the
                end of the cycle, defaults to 0.5
        :type duty: float, optional
        :param offset: increment of signal to each signal value, defaults to 0
        :type offset: float, optional
        :param phase: angle in rads of the phase of the sine wave, defaults to 0
        :type phase: float, optional
        :param start_time: sqaure signal starting time, defaults to 0
        :type start_time: float, optional
        :return: time series of signal
        :rtype: Tuple
        """
        # check if key parameters are assigned
        kwargs = self.threat.temporal.kwargs
        
        if 'amplitude' not in kwargs:
            raise ValueError("Parameter 'amplitude' of the sqaure attacker has not been assigned!")
        if 'period' not in kwargs:
            raise ValueError("Parameter 'period' of the sqaure attacker has not been assigned!")
        if 'duty' not in kwargs:
            kwargs['duty'] = 0.5
            Warning("Parameter 'duty' of the sqaure attacker has not been assigned! A default value of 0.5 is used.")
        if 'offset' not in kwargs:
            kwargs['offset'] = 0.
            Warning("Parameter 'offset' of the sqaure attacker has not been assigned! A default value of 0. is used.")
        if 'phase' not in kwargs:
            kwargs['phase'] = 0.
            Warning("Parameter 'phase' of the sqaure attacker has not been assigned! A default value of 0. is used.")       
            
        start_time = self.threat.start_threat
        end_time = self.threat.end_threat

        self.t = self._timestamp()
        wave = self._square(self.t,**kwargs)
        wave[np.logical_or(self.t<start_time, self.t>end_time)] = kwargs['offset'] # output = offset for time < start_time
        self.signal=wave

        return (self.t, self.signal)

    def block_attack(self):

        self.t = self._timestamp()
        # generate 0 for each time step and will be updated using measurements during simulation
        self.signal = np.array([self._constant(k=0) for i in self.t]) 

        return (self.t, self.signal)

    def _max(self):
        """
        Get the maximum allowable value of a signal

        :return: maximum value of a signal
        :rtype: float
        """        
        return self.threat.temporal.signal_type.max

    def _constant(self,**kwargs):
        """
        Get a externally assigned constant value

        :return: constant value
        :rtype: float
        """        
      
        return kwargs['k']

    def _external(self,input_tuple):
        """
        Get external signal

        :param input_tuple: external signal
        :type input_tuple: Tuple, (timestamp, signal)
        :return: input tuple
        :rtype: Tuple, (timestamp, signal)
        """

        return input_tuple

    def _impulse(self):
        """
        
        """
        pass
    def _step(self,t,ts,offset,amplitude):
        """ Step signal

        Params

        t: current time
        ts: start time
        offset: offset of signal
        amplitude: amplitude of signal

        Return

        """
        x1 = t - ts
        return np.heaviside(x1, 1)*amplitude + offset

    def _square(self,t, **kwargs):
        """Square attack that generates a square signal

        :param amplitude: amplitude of a square signal
        :type amplitude: float
        :param period: time corresponding to one cycle
        :type period: float
        :param duty: value between 0 and 1 and determines the relative
                time that the step transition occurs between the start and the
                end of the cycle, defaults to 0.5
        :type duty: float, optional
        :param offset: increment of signal to each signal value, defaults to 0
        :type offset: float, optional
        :param phase: angle in rads of the phase of the sine wave, defaults to 0
        :type phase: float, optional
        :param start_time: sqaure signal starting time, defaults to 0
        :type start_time: float, optional
        :return: time series of signal
        :rtype: nparray [0,amplitude]
        """
        period = kwargs['period']
        amplitude = kwargs['amplitude']
        duty = kwargs['duty']
        offset = kwargs['offset']
        phase = kwargs['phase']

        phase_array = 2*np.pi*(t/float(period))
        phase_array += phase
        wave = amplitude/2.*SG.square(phase_array,duty) + 0.5+offset
 
        return wave

    def _timestamp(self):
        """
        Generate time stamp

        :return: time stamp
        :rtype: numpy array
        """        

        ts = self.start_time
        te = self.end_time
        dt = self.step

        tl = list(np.arange(ts,te,dt))

        if tl[-1] < te:
            tl.append(te)
        self.t = np.array(tl)

        return self.t

if __name__ == '__main__':
    pass
