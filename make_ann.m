function [anno pts Y] = make_ann(dim, n)
pts = single(randn(dim,n)*10);
anno = ann(pts);
Y = squareform(pdist(pts'));
Y = single(Y.^2 + 100000*eye(n));
end