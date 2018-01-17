function [dz] = linodefun(t, z, A, B, C, F, G)
	sys = z(1:6);
	obs = z(7:12);
	dz = zeros(12, 1);

	dz(1:6) = (A + B*F)*sys;
	dz(7:12) = (A-G*C)*obs + B*F*sys + G*C*sys;
end
