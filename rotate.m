function [out] = rotate(in, theta)
	z = in(1) + in(2)*1i;
	z = z * exp((theta)*1i);
	out = [real(z); imag(z)];
end
