# Conditional Parameters
Dymola and jModelica have different supports for conditional parameters in their fmus.

The provided demo `example.mo` demonstrates the definition of conditional parameters in Modelica language. 
The model can be simulated in Dymola.

The purpose of using conditional parameter is to test if we can use this wrapper to change model parameters during simulation.
The detailed scripts of testing this idea using an overwritten wrapper are shown in `*.py` files.

Currently, the fmu of such conditonal parameters can be correctly simulated in jModelica fmu, but cannot be correctly simulated in Dymola fmu.
In Dymola fmu, although the changed parameters are passed to fmu during simulation, but it seems that the changed parameter is not used for calculation.

# Model without Conditional Parameter
Two simple models without conditional parameters are built here.
One is `ode.mo` that represents a odinary differential equation.
The other is `ae.mo`, which is a simple algebraic equation.

The ODE is displayed as:
$$\dot x = a$$

And the DE is displayed as:

$$ x = a + 1$$

In both equations, `a` is the Modelica parameter. 
In this experiment, `a` is changeable during simulation. 
Detailed implementation is shown in `simulate_ode.py`, and `simulate_ae.py`.

The simulation results are strange when the models are exported as Dymola fmu.

For AE, the changes of `a` start at step 1 and end at step 2, with a value of 1 and 2, respectively. 
The `a` is 5 when the change is not implemented. 
The results simulated from the `simulate_ae.py` is shown as `result_ae.pdf`. 
The results are strange because the change seems to be delayed for one step.

For ODE, except for the delayed step, the final points of the simulation seem to have a relationship with the simulation parameter `ncp`.

The above issues are eliminated in **jModelica** fmu.
