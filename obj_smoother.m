function output = obj_smoother(X)
k = length(X)/2;

x = X(1:k);
y = X(k+1:end);

% TODO: check this
s = zeros( k/2*(k-1),1 ); % I'm pretty sure that's the number of elements in the strictly lower triangular part of the square matrix
p = 0;
for i = 1:k
    for j = 1:k
        if i < j
            p = p+1;
            s(p) = ( x(i) - x(j) )^2 + ( y(i) - y(j) )^2;
        end
    end
end

% minus to Maximize
output = -min(s);
