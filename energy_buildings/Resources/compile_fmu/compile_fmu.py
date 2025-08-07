# -*- coding: utf-8 -*-
"""
This module compiles the defined test case model into an FMU using the
overwrite block parser.

The following libraries must be on the MODELICAPATH:

- Modelica IBPSA
- Modelica Buildings

"""


from pymodelica import compile_fmu
# DEFINE MODEL
# ------------
# mopath = 'test'
library='../../FaultInjection'
model = 'FaultInjection.Experimental.Regulation.SystemCoolSeason'
# ------------

# COMPILE FMU: set JVM maximum leap to 5G to avoid memory issues
# -----------
# the defauted compilation target is model exchange, where no numerical integrator is integrated into the fmu. The equations in FMU is solved by numerical solvers in the importing tool.

# Default relative tolerance is 1e-6, which is too small for my VAV model. Time consuming to be solved.
fmupath = compile_fmu(model,library, jvm_args='-Xmx3g', target='cs', version='2.0', compile_to='regulationFan.fmu')
# -----------



