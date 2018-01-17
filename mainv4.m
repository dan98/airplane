set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');  
close all
clc
m=4; %mass
J=0.0475; %intertia
r=0.25; %thrust offset
g=9.8; %gravitational constant
c=0.05; %rotational damping

A=[0,0,0,1,0,0;
    0,0,0,0,1,0;
    0,0,0,0,0,1;
    0,0,-g,-c/m,0,0;
    0,0,0,0,-c/m,0;
    0,0,0,0,0,0];

B=[0,0;
    0,0;
    0,0;
    1/m,0;
    0,1/m;
    r/J,0];


% x_0, y_0, th_0, xd_0, yd_0, thd_0

% Initial conditions
sys0 = [4; 4; 12*pi; 0; 0; 0];
obs0 = [0; 0; 0; 0; 0; 0];

z0 = [sys0; obs0];

C = zeros(6);
C(1,1) = 1;
C(2,2) = 1;
C(3,3) = 1;

%this part finds a stabilizing feedback controller

%try these eigenvalues;
p = -randperm(6)*0.1 - [1,1,1,1,1,1];
p

F = -place(A,B,p);
G = -place(A',-C',p);

G=G';
eig(A-G*C)

l = cell(1,3);
l{1}='Real State'; l{2}='Observer'; l{3}='Error';


[t, zt] = ode45(@(t, z) linodefun(t, z, A, B, C, F, G), (0:0.05:10), z0);
%[t, zt] = ode45(@(t, z) nonlinodefun(t, z, A, B, C, F, G), (0:0.02:10), z0);

inputs = F*zt(:, 1:6)';
outputs = C*zt(:, 1:6)';

maxain = max(abs(inputs'));

maxabsx = max(abs(outputs(1,:)));
maxabsy = max(abs(outputs(2,:)));
mxy = max([maxabsx maxabsy]);

mtd = max(abs(zt(:,6)));

maxabsxd = max(abs(zt(:,4)));
maxabsyd = max(abs(zt(:,5)));
mxyd = max([maxabsxd maxabsyd]);

asizes = 1.5 * [-1 1 -1 1];

lwing = [-0.5; 0];
rwing = [0.5; 0];


v = VideoWriter('firsttest.avi');
open(v);
frame = struct('cdata', cell(1,length(1)), 'colormap', cell(1,length(1)));

parfor i = 1:length(t)

	disp(sprintf('%.1f percent', 100*(i/length(t))));
	figure('Position', [10 10 1000 1000]);

	syst = zt(i, 1:6)';
	obst = zt(i, 7:12)';

	output=C*syst;

	x = output(1)/mxy;
	y = output(2)/mxy;
	theta = output(3);
	coord = x + y*1i;

	input = F*syst;

    %h = bar(categorical({'x','y','theta','\dot{x}','ydot','thetadot'}),Q);
    %ylim([min(min(Q)) max(max(Q))]);
    %legend(h,l);

	subplot(4,4,[3,7]);
	bar(input(1)/maxain(1));
    ylim([-maxain(1) maxain(1)]);
	title('$F_1$');
	set(gca, 'fontsize', 20);

	subplot(4,4,[4,8]);
	bar(input(2)/maxain(2));
	ylim([-1 1]);
	title('$F_2$');
	set(gca, 'fontsize', 20);

    subplot(4,4,[1,2,5,6]);
    plot(x,y,'ok','MarkerSize',20,'MarkerFaceColor','k');
	hold on;

	rot = exp(-(theta)*1i);

	coordl = (lwing*rot) + (x + 1i*y);
	coordr = (rwing*rot) + (x + 1i*y);

	plot(real(coordl), imag(coordl), 'LineWidth', 2, 'Color', 'k');
	plot(real(coordr), imag(coordr), 'LineWidth', 2, 'Color', 'k');

	drawengine(coordl(1), -theta, -input(2)/maxain(2));
	drawengine(coordr(1), -theta, input(2)/maxain(2));
	drawengine(x+y*1i, -theta, input(1)/maxain(1));

	% tail
	tail = 0.2*[1i; 0.2; -0.2];
	rot = exp(-theta*1i);
	tl  = coord + rot*tail;

	line(real([tl(1) tl(2)]), imag([tl(1) tl(2)]), 'LineWidth', 2, 'Color', 'k');
	line(real([tl(2) tl(3)]), imag([tl(2) tl(3)]), 'LineWidth', 2, 'Color', 'k');
	line(real([tl(1) tl(3)]), imag([tl(1) tl(3)]), 'LineWidth', 2, 'Color', 'k');

	hold off;
	title('Airplane');
	set(gca, 'fontsize', 20);

	axis(asizes);% can change these

	subplot(4,4,9);
	plot(t, zt(:, 1));
	hold on;
	scatter(t(i), zt(i,1), 'filled');
	title('$x(t)$');
	set(gca, 'fontsize', 20);
	hold off;

	subplot(4,4,10);
	plot(t, zt(:, 2));
	hold on;
	scatter(t(i), zt(i,2), 'filled');
	title('$y(t)$');
	set(gca, 'fontsize', 20);
	hold off;

	subplot(4,4,[13, 14]);
	plot(t, zt(:, 3));
	hold on;
	scatter(t(i), zt(i,3), 'filled');
	title('$\theta (t)$');
	set(gca, 'fontsize', 20);
	hold off;

	subplot(4,4,[11,12]);
	ref = barh([syst(4) obst(4); syst(5) obst(5)], 'grouped');
	set(gca, 'yticklabel', {'$\dot{y}$', '$\dot{x}$'});
    xlim([-mxyd mxyd]);
	title('Acceleration');
	legend(ref, {'system', 'observer'});
	set(gca, 'fontsize', 20);

	subplot(4,4,[15,16]);
	ref = barh([syst(6)], 'grouped');
	set(gca, 'yticklabel', {'$\dot{\theta}$'}); 
	xlim([-mtd mtd]);
	title('Centripetal acceleration');
	legend(ref, {'system'});
	set(gca, 'fontsize', 20);

	%drawnow;
	%pause(0.001);
	frame(i) = getframe(gcf);
end

for i=1:length(frame)
	writeVideo(v, frame(i));
end

close(v);

close all
    
