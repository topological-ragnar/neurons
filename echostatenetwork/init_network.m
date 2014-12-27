%% Create a random initial network
n_input = n_alphabet;
n_output = n_alphabet;
n_neuron = 150;

% The recurrent weights
p_W_connected = 0.3;
W_mask = rand(n_neuron, n_neuron) < p_W_connected;
W = randn(n_neuron, n_neuron).*W_mask;
% Scale the weights by 1/sqrt(# of presynaptic neurons) to make the sum of
% input weights to neuron roughly equal variance across neurons
W = bsxfun(@rdivide, W, sqrt(sum(W_mask,2)));

% The input and output weights 
Q = randn(n_neuron, n_input);
R = randn(n_output, n_neuron)/sqrt(n_neuron);
b = zeros(n_output, 1);
