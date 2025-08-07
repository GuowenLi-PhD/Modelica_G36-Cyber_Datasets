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
from casadi import *
from pyfmi import load_fmu
import math

# load race car dynamics from fmu
car = load_fmu('Car.fmu')
options = car.simulate_options()
options['ncp'] = 500.
options['initialize'] = True

N = 100 # number of control intervals

# Declare model variables
x1 = MX.sym('x1')
x2 = MX.sym('x2')
x = vertcat(x1, x2)
u = MX.sym('u')
t = MX.sym('t')
d = vertcat(u,t)

# Model equations
xdot = vertcat(x2, u-x2)

# Objective term
L = t

# Formulate discrete time dynamics
if False:
   # CVODES from the SUNDIALS suite
   dae = {'x':x, 'p':d, 'ode':xdot, 'quad':L}
   opts = {'tf':t/N}
   F = integrator('F', 'cvodes', dae, opts)
else:
   # Fixed step Runge-Kutta 4 integrator
   M = 4 # RK4 steps per interval
   DT = t/N/M

   # car dynamics equation
   f = Function('f', [x, d], [xdot, L])

   X0 = MX.sym('X0', 2)
   U = MX.sym('U')
   D = vertcat(U,t)

   X = X0
   for j in range(M):
       k1, k1_q = f(X, D)
       k2, k2_q = f(X + DT/2 * k1, D)
       k3, k3_q = f(X + DT/2 * k2, D)
       k4, k4_q = f(X + DT * k3, D)
       X=X+DT/6*(k1 +2*k2 +2*k3 +k4)

    # create vdp system dynamic function to calculate system states and outputs for one step using RK45
    #  with input "X0" and "U", renamed to 'x0' and 'u'
    # output 'X' and 'Q', renmaed to 'xf' and 'qf'.
   F = Function('F', [X0, D], [X, L],['x0','p'],['xf','qf'])

# Evaluate at a test point
Fk = F(x0=[0.,0.],p=[0.4,10])
print(Fk['xf'])
print(Fk['qf'])

# Start with an empty NLP
w=[]
w0 = []
lbw = []
ubw = []

g=[]
lbg = []
ubg = []

# Formulate the NLP
Xk = MX([0, 0]) # initialize states at time=0

# formulate constraints 
# limit on x2
limit = lambda pos: 1-np.sin(2*math.pi*pos)/2
print(limit(0.2))
for k in range(N):
    # New NLP variable for the control - creat a series of control inputs for each step
    Uk = MX.sym('U_' + str(k))
    Dk = vertcat (Uk, t)
    w += [Uk] # optimization variable
    lbw += [0] # lb
    ubw += [1] # ub
    w0 += [0] # initialize optimal variable


    # Integrate till the end of the interval
    Fk = F(x0=Xk, p=Dk) # get system states and systme outputs at the end of current step
    Xk = Fk['xf'] # get states

    # Add inequality constraint
    g += [Xk[0],limit(Xk[0])-Xk[1]] # constraints on x1 and x2 at each step
    lbg += [0.,0.]
    #ubg += [1,0.6]
    ubg += [1.,inf]

    # add final state constraints for position
    if k==N-1:
        lbg[-2:] = [1.,0.]
# add constraints for final time
w += [t] 
lbw += [0.1]
ubw += [inf]
w0 += [0.1]

# Create an NLP solver
prob = {'f': L, 'x': vertcat(*w), 'g': vertcat(*g)}
solver = nlpsol('solver', 'ipopt', prob)
print(lbg)
print(ubg)

# Solve the NLP
sol = solver(x0=w0, lbx=lbw, ubx=ubw, lbg=lbg, ubg=ubg)
w_opt = sol['x']
t_opt = w_opt[-1]
# Plot the solution
u_opt = w_opt[:-1]
x_opt = [[0., 0.]]
for k in range(N):
    Fk = F(x0=x_opt[-1], p=vertcat(u_opt[k],t_opt))
    x_opt += [Fk['xf'].full()]
x1_opt = [r[0] for r in x_opt]
x2_opt = [r[1] for r in x_opt]

tgrid = [t_opt/N*k for k in range(N+1)]
import matplotlib.pyplot as plt
plt.figure(1)
plt.clf()
plt.plot(tgrid, x1_opt, '--')
plt.plot(tgrid, x2_opt, '-')
plt.step(tgrid, vertcat(DM.nan(1), u_opt), '-.')
plt.xlabel('t')
plt.legend(['x1','x2','u'])
plt.grid()
plt.show()