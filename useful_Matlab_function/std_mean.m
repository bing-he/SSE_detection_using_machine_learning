%% remove mean and standard deviatin
function [y1]=std_mean(y)
y = y-mean(y);
y1 = y/std(y);
end
