%% Trial 1
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
L2 = 25+10; % [ft]

% podium distance
d = 5; % [ft]

% offset of sides and rear walls (since chairs can't be placed against walls)
w = 1; % [ft]

% total radius of each person bubble (from their center)
r = 1.5+3; % [ft]


%% setup room and boundaries
fig = figure();
ax = axes('parent', fig);
rectangle(ax, 'Position', [0,0,L2, L1], 'LineWidth', 3);
ax.DataAspectRatio = [1,1,1];
hold(ax,'on');
line(ax,[0,L2],(L1-d)*[1,1], 'LineStyle', '--')
line(ax, [w, w, L2-w, L2-w], [L1-d, w, w, L1-d], 'LineStyle', ':')


%% Naive packing
% starting in the SW and SE corners and building the back row first, pack in
% circles of radius r
plotCircle(ax, w, w, r)
plotCircle(ax, L2-w, w, r)

% distance between two people in the corner
b = L2-2*w - 2*r;
num_to_place = floor( b/(2*r) );
inc = linspace(-b/2+r,b/2-r,num_to_place);
for i = 1:num_to_place
    plotCircle(ax, inc(i)+w+r+b/2, w, r)
end


%%
function plotCircle(ax, x_ctr, y_ctr, radius)
    theta = linspace(0,2*pi,31);
    x = radius*cos(theta);
    y = radius*sin(theta);
    patch(ax, 'XData', x_ctr + x, 'YData', y_ctr + y, ...
        'FaceColor', [0.8,0,0], 'FaceAlpha', 0.4)
    plot(ax, x_ctr, y_ctr, 'marker', '.', 'markersize', 8, 'color', 'k')
end


