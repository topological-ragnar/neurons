%% esn.m - script for training output weights of echo state network
%
% you must first run text2vec.m to generate list of vector indices and
% alphabet

% initialize network parameters
init_network

%% Learn the output weights via logistic regression
rho = .001;
lambda = 1e-5;
n_train = 10000; %length(text_inds) - 1;
n_trial = 100;

for iter = 1:n_trial

    y = zeros(n_neuron,1);
    x = zeros(n_input, 1);
    x(text_inds(1)) = 1;

    for i = 1:(n_train-1)
        
        y_next = tanh(W*y + Q*x);
        z = exp(R*y_next + b);
        q = z./sum(z);
        
        % get the next input vector
        x_next = zeros(n_input, 1);
        x_next(text_inds(i)) = 1; %this is the actual (deterministic) probability distribution for the next character
        
        % update parameters
        R_grad = (x_next - q)*y_next' - lambda*R; % using a regularization term-- might only be necessary when there's very little data
        b_grad = x_next - q;

        assert(~(any(isnan(R_grad(:))) || any(isnan(b_grad(:)))));
        R = R + rho*R_grad;
        b = b + rho*b_grad;
        
        x = x_next;
        y = y_next;
    end
    fprintf('\rtrial %d',iter);
end
fprintf('\n');

