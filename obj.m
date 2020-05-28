function output = obj(X,r) %#codegen

k = length(X)/2;

x = X(1:k);
y = X(k+1:end);

output = 0;
for j = 1:k
    for i = 1:j-1 % ensure i < j
        output = output + max([0, 4*r^2 - (x(i) - x(j))^2 - (y(i) - y(j))^2 ] )^2;
    end
end