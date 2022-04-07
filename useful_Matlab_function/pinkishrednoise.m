%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   generalizes spectral slope from rednoise,m   %
%                                                      %
%   R.Watts                          Jan 24, 2019 .    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = pinkishrednoise(N, sl) 

% function: y = pinkishrednoise(N, slope) 
% N - number of samples to be returned in a row vector
% y - a row vector of noise samples with 
% sl = chosen spectral slope, restricted here to have values between
%   sl=-1 for pink noise ("jitter") and sl=-2 for red noise 
% output has zero mean and unity standard deviation
if(sl> -1 || sl< -2) 
    sl
    return;
else
    
% difine the length of the vector and
% ensure that the M is even, this will simplify the processing
if rem(N, 2)
    M = N+1;
else
    M = N;
end

% generate white noise
x = randn(1, M);

% FFT
X = fft(x);

% prepare a vector with frequency indexes 
NumUniquePts = M/2 + 1;     % number of the unique fft points
n = 1:NumUniquePts;         % vector with frequency indexes 

% manipulate the left half of the spectrum so the PSD
% is proportional to the frequency by a factor of 1/f, 
% i.e. the amplitudes are proportional to 1/sqrt(f)
X = X(1:NumUniquePts);      
X = X.*(n.^(sl/2));

% prepare the right half of the spectrum - a conjugate copy of the left one,
% except the DC component and the Nyquist component - they are unique
% and reconstruct the whole spectrum
X = [X conj(X(end-1:-1:2))];

% IFFT
y = real(ifft(X));

% ensure that the length of y is N
y = y(1, 1:N);

% ensure unity standard deviation and zero mean value
y = y - mean(y);
y = y/std(y, 1);

end