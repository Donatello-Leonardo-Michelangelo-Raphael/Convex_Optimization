load('piecewise_constant_data.mat');        % Loading given data into Matlab

[rows , cols] = size(y);                    % Getting the size of the data set            
A = -eye(rows-1,rows);                      % Initializing the "jump" matrix

for ii = 1:rows-1
    A(ii,ii+1) = 1;                         % Completing the "jump" matrix
end


w1 = 1;
w2 = 0.5;                                   % Definig the weights


cvx_begin                                   % Begin CVX
    variables x_hat(rows,cols) a(1) b(1)    % Definig variables in CVX (a and b are slack variables)
    minimize w1*a + w2*b                    % Weighted Objective Function
    subject to                              % Constraints
        norm(y-x_hat,2) <= a;                   % SOCP Condition
        norm(A*x_hat,1) <= b;                   % Cardinality condition approximation
cvx_end                                     % End CVX


opt_val_norm_e = norm(y-x_hat,2);           % Optimum Value of L2 Norm of Error


figure(1);plot(x_hat,'-k');title('Approximated Piecewise Constant Function to the given Data'); ...
    legend('$\hat{x}$');ylabel('$\hat{x}$');                     % Plotting Approximated Piecewise Constant Function
figure(2);plot(y,'-k');title('Original Data'); ...
    legend('y');ylabel('y');                                     % Plotting the original data
figure(3);plot(1:rows,x_hat,'-k',1:rows,y,'o');title('Comparing Data and Approximated Function'); ...
    legend('Approximated Piecewise Constant Function','Original Data');   % x_hat and y in the same plot
figure(4);plot(1:rows,x_hat,'-k',1:rows,y,'-y');title('Comparing Data and Approximated Function'); ...
    legend('Approximated Piecewise Constant Function','Original Data');   % x_hat and y in the same plot