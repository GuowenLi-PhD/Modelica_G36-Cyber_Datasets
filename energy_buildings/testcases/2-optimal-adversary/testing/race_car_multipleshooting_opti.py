# car race along a track
#   minimize T
#      s.t. x=[x1,x2]
#           der(x1) = x2
#           der(x2) = u-x2
#           x1(0) = 0; x2(0)=0
#           x1(T) = 1;
#           0<=u<=1
#           x2(t) <= L(x1(t))
#=========================
# an optimal control problem solved with multiple-shooting
import casadi as ca
import numpy as np
import matplotlib.pyplot as plt
import math

N = 100; # number of control intervals
opti = ca.Opti()

# ---- decision variables ---------
X = opti.variable(2,N+1) # state trajectory
print type(X)
print X.shape
pos   = X[0,:]
speed = X[1,:]
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

# loop over control intervals
for k in np.arange(N): 
   # Runge-Kutta 4 integration
   k1 = f(X[:,k],         U[:,k])
   k2 = f(X[:,k]+dt/2*k1, U[:,k])
   k3 = f(X[:,k]+dt/2*k2, U[:,k])
   k4 = f(X[:,k]+dt*k3,   U[:,k])
   x_next = X[:,k] + dt/6*(k1+2*k2+2*k3+k4) 
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
