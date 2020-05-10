function v = variance(X)
    u = mean(X);
    [n,~] = size(X);
    sum_N = 0;
    for i = 1:n
        sum_N = sum_N + ((X(i) - u)^2);
    end
    v = sum_N / n;
end