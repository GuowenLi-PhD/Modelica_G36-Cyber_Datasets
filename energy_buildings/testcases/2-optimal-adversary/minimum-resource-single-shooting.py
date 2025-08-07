# an optimal control problem solved with multiple-shooting
import casadi as ca
import numpy as np
import matplotlib.pyplot as plt
import math

N = 100; # number of control intervals
opti = ca.Opti()

# ---- decision variables ---------
X = opti.variable(1,N+1) # state trajectory: kpi cost
print type(X)
print X.shape

U = opti.variable(1,N)   # control trajectory (throttle)
T = opti.variable()      # final time

# ---- objective          ---------
opti.minimize(T) # race in minimal time

# ---- dynamic constraints --------
# dx/dt = f(x,u)
def dyn(x,u):
    xdot = [x[1],u-x[1]]
    return xdot

def f(x,u):
    r = dyn(x,u)
    return ca.vertcat(r[0],r[1])

#f = lambda x,u: vertcat(x[1],u-x[1]) # dx/dt = f(x,u)
dt = T/N #% length of a control interval

# load fmu


# loop over control intervals
def calculateStates(fmu,t,dt,u_t,s_t):
    """For calculating states for single/multiple-shooting OCP. 
        FMU-based simulator is called to calculate KPI total cost in this case.
    - arguments
        fmu - fmu model from last time step
        t - current clock
        dt - time step
        u_t - control inputs at time t
        s_t - FMU states at time t
    - pesudo codes:
        1. apply current states to FMU at the beginning
        2. simulate FMU for KPI total cost 
            2.1 get dT, E, Pmax
            2.2 save states after attack - this is for initial states for next attack
            2.3 get DF if possible here 
        3. return KPI total cost and the final states
            kpi_cost_next, states_next, t_next
    """

    pass

def F(xk,uk):
    # This is part to predict trajectory from your model.
    # Here we use FMU for trajectory prediction. We assume perfect prediction.
    #=========================================================================
    #           some thoughts
    #-------------------------------------------------------------------------
    #
    #
    x_next = 0

    return x_next

for k in np.arange(N): 
   xk=X[:,k]
   uk=U[:,k]
   x_next = F(xk,uk)
   opti.subject_to(X[:,k+1]==x_next) # close the gaps

# ---- path constraints -----------
limit = lambda pos: 1-np.sin(2*math.pi*pos)/2
opti.subject_to(speed<=limit(pos)) # track speed limit
opti.subject_to(opti.bounded(0,U,1))           # control is limited

# ---- boundary conditions --------
opti.subject_to(pos[0]==0)   # start at position 0 ...
opti.subject_to(speed[0]==0) # ... from stand-still 
opti.subject_to(pos[N]==1) # finish line at position 1

# ---- misc. constraints  ----------
opti.subject_to(T>=0) # Time must be positive

# ---- initial values for solver ---
opti.set_initial(speed, 1)
opti.set_initial(T, 1)

# ---- solve NLP              ------
opti.solver('ipopt') # set numerical backend
sol = opti.solve()   # actual solve

# ---- post-processing        ------

t = np.linspace(0,sol.value(T),N+1)

plt.figure()
plt.plot(t,sol.value(speed))
plt.plot(t,sol.value(pos))
plt.plot(t,limit(sol.value(pos)),'r--')
plt.step(t[:-1],sol.value(U),'k')
plt.xlabel('Time [s]')
plt.legend(['speed','pos','speed limit','throttle'])
plt.savefig('states.pdf')

plt.figure()
plt.spy(sol.value(ca.jacobian(opti.g,opti.x)))
plt.xlabel('decision variables')
plt.ylabel('constraints')
plt.savefig('jacobian.pdf')
