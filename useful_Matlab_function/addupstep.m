%% add step signal function
% start_time: slow slip events start time
% end_time: slow slip events end time
% step: the size of slow slip events
% raw_data: the original data should be added some step signals
% internal_time: real days

function [raw_data1,step_line]=addupstep(start_time,end_time,step,raw_data,internal_time)
raw_data1=raw_data;
II = find(internal_time >= start_time & internal_time<=end_time);
%II1 = find(internal_time < i1);
II2 = find(internal_time > end_time);
step_line=zeros(size(raw_data1));
y = linspace(0,step,length(II))';
step_line(II) = y;
step_line(II2) = step;
raw_data1 = raw_data+step_line;
end