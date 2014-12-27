%% text2vec.m - covert text to list of vector indices
text = lower(fileread('alice_in_wonderland.txt'));
%text = lower(fileread('AliceWithOutThe.txt'));
alphabet = unique(text);
n_alphabet = length(alphabet);
text_inds = string_to_indices(text, alphabet);
