function U = compute_U_matrix(X, Y)

big = 0;
if nargin == 1
    [n d] = size(X);
    U = zeros(n,n);
    if n < big
        for i=1:d
            temp = repmat(X(:,i),[1 n]);
            temp = (temp - temp');
            U = U + real(temp).*real(temp) + imag(temp).*imag(temp);
        end
        f = find( U ==0 );
        U(f) = 0;
        f_not = 1:prod(size(U));
        f_not(f) = [];
        U(f_not) = U(f_not) .* log2(sqrt(U(f_not)));
    else
        for i = 1:n
            for j = (i+1):n
                if (i ~= j)
                    rr = sum((X(i,:) - X(j,:)).^2,2);
                    if (rr < eps*eps )
                        U_val = eps;
                    else
                        U_val = rr * log2(sqrt(rr));
                    end
                    U(i,j) = U_val;
                    U(j,i) = U_val;
                end
            end
        end
    end
else
    [n d] = size(X);
    [m d] = size(Y);
    U = zeros(n, m);
    if n < big && m < big
        for i=1:d
            temp = repmat(X(:,i),[1 m]);
            temp = temp - repmat(Y(:,i)',[n 1]);
            U = U + real(temp).*real(temp) + imag(temp).*imag(temp);
        end
        f = find( U ==0 );
        U(f) = 0;
        f_not = 1:prod(size(U));
        f_not(f) = [];
        U(f_not) = U(f_not) .* log2(sqrt(U(f_not)));
    else
        for i = 1:n
            for j = 1:m
                rr = sum((X(i,:) - Y(j,:)).^2,2);
                if (rr ==0 )
                    U_val = 0;
                else
                    U_val = rr * log2(sqrt(rr));
                end
                U(i,j) = U_val;
            end
        end
    end
end
end



