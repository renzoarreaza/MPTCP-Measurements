
clear variables;
close all;
clc;

%Changing to the directory in which this file is located
%(for the relative path below to work
if(~isdeployed)
  cd(fileparts(which(mfilename)));
end

%MPTCP
mptcp = readtable('netperf_mptcp.csv', 'Delimiter', ',');
mptcp_cell = table2cell(mptcp);
dates_mptcp = datetime(mptcp_cell(:,1),'InputFormat','MMM_dd_uuuu_HH_mm');
data_mptcp = table2array(mptcp(:,2));

%TCP
tcp = readtable('netperf_tcp.csv', 'Delimiter', ',');
tcp_cell = table2cell(tcp);
dates_tcp = datetime(tcp_cell(:,1),'InputFormat','MMM_dd_uuuu_HH_mm');
data_tcp = table2array(tcp(:,2));

avg_mptcp = mean(data_mptcp);
std_mptcp = sqrt(var(data_mptcp));

avg_tcp = mean(data_tcp);
std_tcp = sqrt(var(data_tcp));

plot(dates_mptcp, data_mptcp, '-')
hold on;
plot(dates_tcp, data_tcp, '-')
legend('MPTCP', 'TCP')
% plot(dates, data, '-')
title('Netperf TCP\_CRR')
xlabel('Datetime')
ylabel('Transactions per second')
