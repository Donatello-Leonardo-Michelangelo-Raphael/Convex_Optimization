A = [1 2 0 1;0 0 3 1;0 3 1 1;2 1 2 5;1 0 3 2];   % "Activity-Consumption-Resource" Matrix
c_max = [100;100;100;100;100];                   % Maximum Allowable Resource Consumption by all Activities
p = [3;2;7;6];                                   % Basic Price
p_disc = [2;1;4;2];                              % Discounted Price
q = [4;10;5;10];                                 % Threshold vector deciding which piecewise linear function ...
                                                      % ... to choose for the objective function

[A_rows,A_cols] = size(A);                       % Getting size of matrix A


cvx_begin                                 % Begin CVX

    variables x(A_cols) y                 % Defining variables in CVX (x==Optimum Activity Levels) (y==slack variable) 
    
    maximize (y)                          % Objective Function
    
    subject to                            % Constraints
    
        p'*x >= y;                             % Piecewise linear function
        p'*q + p_disc'*(x-q) >= y;             % Piecewise linear function
        A*x <= c_max;                          % Limitation on Resource Consumption
        x >= 0;                                % Non-negative Activities
        
cvx_end                                   % End CVX


opt_val_indi = zeros(A_cols,1);                                                   
for ii = 1:A_cols
    opt_val_indi(ii) = min(p(ii)*x(ii),p(ii)*q(ii)+p_disc(ii)*(x(ii)-q(ii)));   % Revenue generated by each Activity 
end


opt_val = sum(opt_val_indi);                                                    % Total Revenue Generated


avg_price = zeros(A_cols,1);
for jj = 1:A_cols
    avg_price(jj) = opt_val_indi(jj)/x(jj);                                     % Average Price of each Activity
end