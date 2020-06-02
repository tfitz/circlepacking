%% build

clear all
close all
clc

%%

% signature:
% output = obj(X,r)
X = coder.typeof(1, [1 2*30], [false true] );
r = coder.typeof(1.0);

codegen obj -args {X,r}

%%
k = 10;
X = rand(1,2*k);
r = rand();
n = 10000;

tic
for i = 1:n
    obj(X,r);
end
toc

tic
for i = 1:n
    obj_mex(X,r);
end
toc