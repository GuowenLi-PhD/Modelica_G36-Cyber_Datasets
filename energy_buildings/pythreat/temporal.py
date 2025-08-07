#!/usr/bin/env/ python
# -*- coding: utf-8 -*-
#
#
class Signal(object):
    """
    Class that defines a signal in the network-based control system  

    """

    def __init__(self, name, y_min, y_max, unit):
        """
        Initialize the Signal object

        :param name: name of the overwritten signal, which should always start from `ove`.
        :type name: str
        :param y_min: minimum value for the signal as defined in Modelica
        :type y_min: float
        :param y_max: maximum value for the signal as defined in Modelica
        :type y_max: float
        :param unit: unit for the signal as defined in Modelica
        :type unit: str
        """        

        self.name = name
        self.min = y_min
        self.max = y_max
        self.unit = unit

class Temporal(object):
    """
    Class that defines a temporal pattern of threats

    """
    def __init__(self, signal_type, attacker = '',**kwargs):
        """
        Initialize a Temporal class

        :param signal_type: defines the type of signals to be overwritten
        :type signal_type: Signal object
        :param attacker: name of the attackers, defaults to ''
        :type attacker: str, optional
        """        
        
        self.signal_type = signal_type
        self.attacker = attacker
        self.kwargs = kwargs

if __name__ == '__main__':
    signal_type = Signal('TCHWSet',0,300,'K')
    att = Temporal(signal_type,'max')
    print(att.attacker)
