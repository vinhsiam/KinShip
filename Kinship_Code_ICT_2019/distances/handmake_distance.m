%based on EuDist
function D=handmake_distance(a, b)
if (nargin ~= 2)
   error('Not enough input arguments');
end

if (size(a,2) ~= size(b,2))
   error('A and B should be of same dimensionality');
end
N = size(a,2);
D = zeros(N, 1);
    %
    for i = 1:N
        P1 = a(:,i);
    	P2 = b(:,i);
        X1=sum(P1.^2,1);
        X2=sum(P2.^2,1);
        R = P1 * P2';
        D(i) = real((sqrt(X1 + X2' - 2*R)));
    end
end
