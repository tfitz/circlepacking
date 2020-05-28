function [fig, ax] = gen_plot_results(width, depth, podium_distance, radius, wall_offset, x, y)


%% unpack inputs
L1 = depth; % [ft]

% the W-E distance:
L2 = width; % [ft]

% podium distance
d = podium_distance; % [ft]

% offset of sides and rear walls (since chairs can't be placed against walls)
w = wall_offset; % [ft]

% total radius of each person bubble (from their center)
r = radius; % [ft]


%% setup room
fig = figure();
ax = axes('parent', fig);
rectangle(ax, 'Position', [0,0,L2, L1], 'LineWidth', 3);
ax.DataAspectRatio = [1,1,1];
hold(ax,'on');
line(ax,[0,L2],(L1-d)*[1,1], 'LineStyle', '--')
line(ax, [w, w, L2-w, L2-w], [L1-d, w, w, L1-d], 'LineStyle', ':')

x_lb = w;
x_ub = L2-w;
y_lb = w;
y_ub = L1-d-r; % include the distance to the instructor

% centers of the circles must be inside this patch
patch( ax, 'XData', [x_lb, x_ub, x_ub, x_lb], ...
    'YData', [y_lb, y_lb, y_ub, y_ub],...
    'FaceColor', [0,0.4,0], 'FaceAlpha', 0.1, 'EdgeAlpha', 0);


% plot each circle location
k = length(x);
for i = 1:k
    plotCircle(ax, x(i),y(i), r, [0,0.0, 0.6])
end

title(ax,sprintf('Feasible solution: r=%3.1f, k =%3d', r, k));



end


function plotCircle(ax, x_ctr, y_ctr, radius, color)
theta = linspace(0,2*pi,31);
x = radius*cos(theta);
y = radius*sin(theta);
patch(ax, 'XData', x_ctr + x, 'YData', y_ctr + y, ...
    'FaceColor', color, 'FaceAlpha', 0.4)
plot(ax, x_ctr, y_ctr, 'marker', '.', 'markersize', 8, 'color', 'k')
end