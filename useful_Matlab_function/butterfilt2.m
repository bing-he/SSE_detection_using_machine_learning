% Low, High,or band pass filter, but not remove the trend of curve.
function [out]=butterfilt2(in,order,filtT,sampT,ftype)
%
%
% This function is designed to do lowpass filtering of any vector of 
% data.  It uses a  Butterworth filter and does the 
% filtering twice, once forward and once in the reverse direction.  
%
% INPUTS:
%        in    -- the data vector
%	 filtT -- the smoothing period
%	 sampT -- the sample period
%        order -- of the butterworth filter
%
%  NOTE:  filtT and sampT must be entered in the same units!!!!!
%

[mm,nn]=size(in);
if nn>mm & mm==1
 in=in';
 [mm,nn]=size(in);
elseif mm~=1 & nn~=1
 error('Input must be a vector and not an array!!!')
end

%
% First remove a ramp so that the first and last points are zero.  
% This minimizes the filter transients at the ends of the record.  
%
P=polyfit([1 mm],[in(1) in(mm)],1);
dumx=[1:mm]';
lineartrend=polyval(P,dumx);
%in=in-lineartrend;

%
% Second, create the Butterworth filter.  
%
Wn=(2./filtT).*sampT;
[b,a]=butter(order,Wn,ftype);

%
% Third, filter the data both forward and reverse.  
%
inan=find(isnan(in));
if ~isempty(inan)
 error('There are NaNs in the data set!!! Remove them and try again!')
end
out=filtfilt(b,a,in);
%

%
% Finally return the linear trend removed earlier.
%
%out=out+lineartrend;
%
%
end 