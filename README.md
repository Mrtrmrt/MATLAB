# MATLAB
My MATLAB codes for various physics problems

Here you can find my MATLAB implementation for set of various physics and math problems. Most of them are dedicated to aerodynamics and plasma physics

motion.m - is a function, which solves Newton-Lorentz equation for charged particles using numerical integration by Runge-Kutta method

poloidal_field_2.m - is a function, which calculates magnetic field of a current loop, using elliptic integrals

Graphs.m - is a program, which creates and plots the magnetic fields constituents distribution around tokamak

Newton_Lorentz.m - is a program, which uses motion.m function to visualize only one charged particle trajectory inside a neutral beam injector

Magnetic_final_T15.m - is a program, which uses poloidal_field_2.m function to calculate and visualize magnetic forcelines destribution insine and outside a tokamak

Newton_Lorentz_many_parts.m - is a program, which uses motion.m function to visualize charged particles beam trajectory inside a neutral beam injector. Moreover, it calculates
beam deviation in degrees and calculates the optimal koefficient to decrease magnetic field impact.
