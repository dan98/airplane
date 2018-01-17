function drawengine(coord, theta, scale)

	triangle = 0.4*[0; 0.1 + 1i; -0.1 + 1i];
	rot = exp(theta*1i);
	tl  = coord + rot*(triangle*scale);

	line(real([tl(1) tl(2)]), imag([tl(1) tl(2)]), 'LineWidth', 2, 'Color', 'r');
	line(real([tl(2) tl(3)]), imag([tl(2) tl(3)]), 'LineWidth', 2, 'Color', 'r');
	line(real([tl(1) tl(3)]), imag([tl(1) tl(3)]), 'LineWidth', 2, 'Color', 'r');
	
end
