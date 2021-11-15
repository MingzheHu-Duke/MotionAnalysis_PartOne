% This is the script for extracting the leading principle component
function pr_com = pc1(sig_in)
% sig_in: the input signal
% pr_com: The output principle component

% The principle component matrix
pcm = pca(sig_in);
% Projection to the axis
pr_com = sig_in * pcm(:, 1);
end