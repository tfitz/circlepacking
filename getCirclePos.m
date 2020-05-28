function [k,x,y,data] = getCirclePos(width, depth, podium_distance, radius, wall_offset)


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
L1 = depth; % [ft]

% the W-E distance:
L2 = width; % [ft]

% podium distance
d = podium_distance; % [ft]

% offset of sides and rear walls (since chairs can't be placed against walls)
w = wall_offset; % [ft]

% total radius of each person bubble (from their center)
r = radius; % [ft]

%% bounds for optimization
x_lb = w;
x_ub = L2-w;
y_lb = w;
y_ub = L1-d-r; % include the distance to the instructor

%% number of students in the room
k_0 = 4;
data = {};

k = k_0-1;
flag = 0;
while flag == 0
    k = k + 1;
    
    % states are:
    % [x1 x2 x3 ... xk y1 y2 ... yk]
    lb = [x_lb*ones(k,1); y_lb*ones(k,1)];
    ub = [x_ub*ones(k,1); y_ub*ones(k,1)];
    
    
    %% Solve using a canned genetic algorithm
    options = optimoptions('ga');
    options.PopulationSize = 2*k*1000;
    options.MaxGenerations = 2*k*400;
    % since the obj function has a known minimum of 0 for feasible
    % solutions:
    options.FitnessLimit = 0;
    
    fprintf('Working on k=%2d\n',k)
    [X,fval] = ga(@(X) obj_mex(X,r),2*k,[],[],[],[],lb,ub,[],options);
    
    data{k}.X = X;
    data{k}.fval = fval;
    
    if fval > 1e2*eps
        flag = 1;
    end
end
%% extract the last feasible solution
k = k-1;
X = data{k}.X;
fval = data{k}.fval;

%% Find the 'most spaced' solution for this k
% use a gradient based method, starting from a feasible solution
lb = [x_lb*ones(k,1); y_lb*ones(k,1)];
ub = [x_ub*ones(k,1); y_ub*ones(k,1)];
fprintf('Maximizing separation for k=%2d\n',k)
[X2,fval] = fmincon(@(X) obj_smoother(X),X,[],[],[],[],lb,ub);

%% setup the output
x = X2(1:k);
y = X2(k+1:end);
