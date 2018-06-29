%% Incorrect measurements before processing
%  09_Jun_23_48 wrong measurements 
%  Incorrect measurements after processing:
%  09_Jun_00_48 - Full MPTCP 1 value - 5 standard deviation
%  09_Jun_21_48 - Backup MPTCP 1 Value - 8 standard deviation
%  09_Jun_22_48 - WiFi TCP 1 Value - 4 standard deviation


clear variables;
close all;
clc;

%Changing to the directory in which this file is located
%(for the relative path below to work
if(~isdeployed)
  cd(fileparts(which(mfilename)));
end

%Importing multipath data
time_full=[];
time_back=[];
time_tcp=[];
rate_full=[];
rate_back=[];
rate_tcp=[];
rate_both = [];
rate_wifi = [];
rate_4g = [];
first_switch_back = [];
second_switch_back = [];
first_switch_full = [];
second_switch_full = [];
second_switch_wifi = [];

for d = 7:10
    if d == 7
        a = 23;
        b = 23;
    end
    if d == 8
        a = 0;
        b = 23;
    end
    if d == 9
        a = 1;  %00 - 09_Jun_00_48 wrong measurements
        b = 22; %21 & 22 & 23 - 09_Jun_23_48 & 09_Jun_21_48 wrong measurements 
    end
    if d == 10
        a = 0;
        b = 23;
    end
               
    for n=a:b
        
        k = sprintf('%02d', n);
        kk = sprintf('%02d', d);
        
        filename = ['./res_serv_' kk '_Jun_' k '_48.csv'];
        data1 = csvread(filename, 0,0);
        list = [];
        name = filename;
        name(1:11) = [];
        name(end-3:end) = [];

        for nn=1:length(data1)-1
            if data1(nn,2) > data1(nn+1,1) 
                list = [list;nn];
            end   
        end

        time_full = [time_full; data1(list(2),2)];
        time_back = [time_back; data1(list(4),2)];
        time_tcp = [time_tcp; data1(end, 2)];


        data2=data1(list(1)+2:list(3),:);   %back
        data3=data1(list(3)+2:end-1,:);     %tcp
        data1(list(1)+1:end,:)=[];          %full
        
        rate_full = [rate_full; mean(data1(:,4))];
        rate_back = [rate_back; mean(data2(:,4))];
        rate_tcp = [rate_tcp; mean(data3(:,4))];
        
        %% Local Rates 
        % 5 to 7 seconds 4G
        mean_rate_4g = mean(data2(25:35,4));
        
        % 2 to 4 seconds WiFi
        mean_rate_wifi = mean(data3(10:20,4));
        
        % 2 to 4 seconds Both
        mean_rate_both = mean(data1(10:20,4));

        rate_4g = [rate_4g; mean_rate_4g];
        rate_both = [rate_both; mean_rate_both];
        rate_wifi = [rate_wifi; mean_rate_wifi];
        
        %% Handovers
        % Backup MPTCP
        first_back = find(data2(20:end,4)>9.5 & data2(20:end,4)<10.5);
        second_back = find(data2(40:end,4)>3.5 & data2(40:end,4)<4.5);
        first_switch_back = [first_switch_back; data2(first_back(1)+19,2)];
        second_switch_back = [second_switch_back; data2(second_back(1)+39,2)];
        
        % Full MPTCP
        first_full = find(data1(20:end,4)>9.5 & data1(20:end,4)<10.5);
        second_full = find(data1(40:end,4)>13 & data1(40:end,4)<15);
        first_switch_full = [first_switch_full; data1(first_full(1)+19,2)];
        second_switch_full = [second_switch_full; data1(second_full(1)+39,2)];
        
        % WiFi TCP
        second_wifi = find(data3(40:end,4)>3.5 & data3(40:end,4)<4.5);
        second_switch_wifi = [second_switch_wifi, data3(second_wifi(1)+39,2)];
        
        
         %% figure 10_Jun_17_48 - Closest values to means
         if d == 10 && n==17
         a(:,1) = plot(data1(:,1), data1(:,4)); m(1) = string('Full MPTCP');
         hold on;
         a(:,2) = plot(data2(:,1), data2(:,4)); m(2) = 'Backup MPTCP';
         hold on;
         a(:,3) = plot(data3(:,1), data3(:,4)); m(3) = 'TCP';
         legend(a, m)
         title(strcat('Goodput (', name, ')'), 'Interpreter', 'none')
         xlabel('Time')
         ylabel('Goodput (Mbits/sec)')
         end
    end
end

avg_time_full = mean(time_full);
std_time_full = sqrt(var(time_full));

avg_time_back = mean(time_back);
std_time_back = sqrt(var(time_back));

avg_time_tcp = mean(time_tcp);
std_time_tcp = sqrt(var(time_tcp));

avg_rate_full = mean(rate_full);
std_rate_full = sqrt(var(rate_full));

avg_rate_back = mean(rate_back);
std_rate_back = sqrt(var(rate_back));

avg_rate_tcp = mean(rate_tcp);
std_rate_tcp = sqrt(var(rate_tcp));

avg_rate_4g = mean(rate_4g);
std_rate_4g = sqrt(var(rate_4g));

avg_rate_both = mean(rate_both);
std_rate_both = sqrt(var(rate_both));

avg_rate_wifi = mean(rate_wifi);
std_rate_wifi = sqrt(var(rate_wifi));

avg_switch_back1 = mean(first_switch_back);
std_switch_back1 = sqrt(var(first_switch_back));
avg_switch_back2 = mean(second_switch_back);
std_switch_back2 = sqrt(var(second_switch_back));

avg_switch_full1 = mean(first_switch_full);
std_switch_full1 = sqrt(var(first_switch_full));
avg_switch_full2 = mean(second_switch_full);
std_switch_full2 = sqrt(var(second_switch_full));

avg_switch_wifi2 = mean(second_switch_wifi);
std_switch_wifi2 = sqrt(var(second_switch_wifi));
