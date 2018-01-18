function [dz] = nonlinodefun(t, z, A, B, C, F, G)

m=4; %mass
J=0.0475; %intertia
r=0.25; %thrust offset
g=9.8; %gravitational constant
c=0.05; %rotational damping

	sys = z(1:6);
	obs = z(7:12);
	dz = zeros(12, 1);
  
	u = F*sys;
  u(2) = u(2) + m*g;
	dz(1) = z(4); 
	dz(2) = z(5); 
	dz(3) = z(6); 
	dz(4) = -(c/m) * z(4) + (u(1) * 1/m * cos(z(3))) - (u(2) * 1/m * sin(z(3)));
	dz(5) = -g -((c/m) * z(5)) + (u(1) * 1/m * sin(z(3))) + (u(2) * 1/m * cos(z(3)));
	dz(6) = u(1)*r/J;
	dz(7:12) = (A-G*C)*obs + B*F*sys + G*C*sys;
end
