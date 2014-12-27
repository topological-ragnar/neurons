%% gen_text.m - generate text by running network
%
% network and text parameters are defined from esn.m and text2vec.m

fprintf('\n########\n');
n_init = 100; % Uses one more than this

x = zeros(n_input,1);
y = zeros(n_neuron,1);

outputnoisedamper = 10;
inputnoisedamper = 1;

sz=sqrt(n_neuron);

% prime the network
start_idx = randi(length(text_inds) - (n_init+1));
for i = start_idx:(start_idx+n_init-1)
    x(x ~= 0) = 0;
    x(text_inds(i)) = 1;
    fprintf('%c', alphabet(text_inds(i)));
    y = tanh(W*y + Q*(x+randn(n_alphabet,1)/inputnoisedamper)) + randn^2/outputnoisedamper;
end

x(x ~= 0) = 0; %sets all nonzero x values to zero
x(text_inds(start_idx + n_init)) = 1;
fprintf('%c', alphabet(text_inds(start_idx + n_init)));
    
fprintf('>>>>>');

T=200;
Y=zeros(n_neuron,T);
for i = 1:T
    y = tanh(W*y + Q*x)+ randn^2/outputnoisedamper;
    Z = R*y + b;
    [max_val1, x_out1] = max(Z);
    Z(x_out1) = -max_val1;
    [max_val2, x_out2] = max(Z);
    Z(x_out2) = -max_val2;
    [max_val3, x_out3] = max(Z);
    if mod(i,1)==1
        whichOne = randsample(3,1,true,[max_val1,max_val2/5,max_val3/8]);
    else
        whichOne = 1;
    end
    if whichOne==1
        fprintf('%c', alphabet(x_out1));
        x(x ~= 0) = 0;
        x(x_out1) = 1;
    elseif whichOne==2
        fprintf('%c', alphabet(x_out2));
        x(x ~= 0) = 0;
        x(x_out2) = 1;
    else
        fprintf('%c', alphabet(x_out3));
        x(x ~= 0) = 0;
        x(x_out3) = 1;
    end
    Y(:,i)=y;
end

fprintf('\n########\n');
