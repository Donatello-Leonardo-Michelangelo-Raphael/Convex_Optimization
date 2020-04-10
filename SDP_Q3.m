load('Ratings.mat');              % Loading given data into Matlab
[X_rows , X_cols] = size(X);      % Getting size of the data set


cvx_begin SDP                                                      % Begin CVX

    variable Y(X_rows,X_rows) symmetric                           
    variable Z(X_cols,X_cols) symmetric                           % Defining variables in CVX (a==Slack Variable)
    variable X_hat(X_rows,X_cols) 
    variable Obj
        
    minimize Obj                                                   % Objective Function
    
    subject to                                                          % Constraints
    
    (trace(Y) + trace(Z)) <= Obj;                                       % Relaxation Condition   
        for ii = 1:X_cols
            for jj = 1:X_rows
                if X(jj,ii) ~= 0
                    X_hat(jj,ii) == X(jj,ii); %#ok<EQEFF>               % Defining entries for which rating is given
                else
                    X_hat(jj,ii) <= 5;
                    X_hat(jj,ii) >= 1;                                  % Defining range for entries which were not rated
                end
            end
        end
        [Y,X_hat;X_hat',Z] == semidefinite(X_rows+X_cols);              % Using relaxation
        
cvx_end                                                            % End CVX


rank_X_hat = rank(X_hat);           % Rank of the completed ratings matrix X_hat