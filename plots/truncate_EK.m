function [Xi,f] = truncate_EK(Xi,f,data)
%truncate kdensity points outside real data
idx_upper = find(Xi > max(data));
idx_lower = find(Xi < min(data));
idx = [idx_upper,idx_lower];
Xi(idx) = [];
f(idx) = [];
end