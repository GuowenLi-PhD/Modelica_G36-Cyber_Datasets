.. _SetKPIs:

KPI Cost
=======================

Definition of KPI Cost
-----------------------

The KPI Cost is defined as normalized metric to quantify how the building performance is.
The greater the cost is, the worse the building performance in terms of building service and grid service is.

KPI Cost Functions
-------------------

Total Discomfort Cost
~~~~~~~~~~~~~~~~~~~~~

.. math:: c_{dTh} = \frac{dTh}{dTh_{max}}
.. math:: dTh_{max} = dT_{max,thr}\Delta t

   where :math:`dT_{max,thr}` is the threshold of the maximum allowable temperature deviation from comfort constraints. 
   For example, :math:`dT_{max,thr}` is 4K when zone temperature is allowed to fluctuate between :math:`24 \pm 4\degree`C. 

Energy Use Cost
~~~~~~~~~~~~~~~~
  
.. math:: c_{E} = \frac{E}{E_{max}}=\frac{\int_{t}^{t+\Delta t}Pdt}{\int_{t}^{t+\Delta t}P_{nominal}dt}

Peak Demand
~~~~~~~~~~~~~

   .. math:: c_{P_{peak}} = \frac{P_{peak}}{P_{nominal}}

Demand Flexibility
~~~~~~~~~~~~~~~~~~
   
   .. math:: c_{DFI} = 1-\frac{DFI}{DFI_{max}} = 1-\frac{DFI}{P_{nominal}}


Calculation Module
---------------------

A KPI Cost calculation module is implemented as *pyscore*.
