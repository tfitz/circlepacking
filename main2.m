%% Trial 2
clear all
close all
clc

%% Define size of room
% N is where the board/console/etc is
% ---------N---------
% |                 |
% |. . . . . . . . .|d
% |                 |
% W                 E
% |                 |
% |                 |
% |                 |
% ---------S---------
% 
% The N-S distance:
L1 = 23; % [ft]

% the W-E distance:
L2 = 25; % [ft]

% podium distance
d = 5; % [ft]

% offset of sides and rear walls (since chairs can't be placed against walls)
w = 1; % [ft]

% total radius of each person bubble (from their center)
r = 1.5+3; % [ft]

%% setup room
fig = figure();
ax = axes('parent', fig);
rectangle(ax, 'Position', [0,0,L2, L1], 'LineWidth', 3);
ax.DataAspectRatio = [1,1,1];
hold(ax,'on');
line(ax,[0,L2],(L1-d)*[1,1], 'LineStyle', '--')
line(ax, [w, w, L2-w, L2-w], [L1-d, w, w, L1-d], 'LineStyle', ':')

%% bounds for optimization
x_lb = w;
x_ub = L2-w;
y_lb = w;
y_ub = L1-d-r; % include the distance to the instructor

% centers of the circles must be inside this patch
patch( ax, 'XData', [x_lb, x_ub, x_ub, x_lb], ...
    'YData', [y_lb, y_lb, y_ub, y_ub],...
    'FaceColor', [0,0.4,0], 'FaceAlpha', 0.1, 'EdgeAlpha', 0);

%% number of students in the room
k = 7;

% states are:
% [x1 x2 x3 ... xk y1 y2 ... yk]
lb = [x_lb*ones(k,1); y_lb*ones(k,1)];
ub = [x_ub*ones(k,1); y_ub*ones(k,1)];

%% initial guess if using fmincon
% x0 = x_ub*rand(k,1)+x_lb;
% y0 = y_ub*rand(k,1)+y_lb;
% X0 = [x0; y0];

%% Solve using a canned genetic algorithm
options = optimoptions('ga');
options.PopulationSize = 5000;

[X,fval] = ga(@(X) obj(X,r),2*k,[],[],[],[],lb,ub);

%% Review solution
x = X(1:k);
y = X(k+1:end);

if fval < 100*eps
    title(ax,sprintf('k=%d is feasible',k))
    color = [0,0.8,0.4];
else
    title(ax,sprintf('k=%d is not feasible',k))
    color = [0.8,0,0];
end

for i = 1:k
    plotCircle(ax, x(i),y(i), r, color)    
end
   

%%
function plotCircle(ax, x_ctr, y_ctr, radius, color)
    theta = linspace(0,2*pi,31);
    x = radius*cos(theta);
    y = radius*sin(theta);
    patch(ax, 'XData', x_ctr + x, 'YData', y_ctr + y, ...
        'FaceColor', color, 'FaceAlpha', 0.4)
    plot(ax, x_ctr, y_ctr, 'marker', '.', 'markersize', 8, 'color', 'k')
end
