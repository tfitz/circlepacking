function output = obj(X,r)

k = length(X)/2;

x = X(1:k);
y = X(k+1:end);

output = 0;
for i = 1:k
    for j = 1:k
        if i < j
            output = output + max([0, 4*r^2 - (x(i) - x(j))^2 - (y(i) - y(j))^2 ] )^2;
        end
    end
end
