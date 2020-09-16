function [thre_winpower,firsttTick,lasttTick,firsttTick1,lasttTick1]=Airflow_Function(modify_vector, signal,tTick,window_step,window_move,sampRate,ang)
%ymin,ymax为图形y轴的范围  
%startTime_iBlk为这段信号的起始时间
%modify_vector为修正系数
%signal为需被分割信号
% tTick：需被分割信号的时间信息
% window_step：窗口长度，单位s
% window_move：窗口滑动步幅，单位s
% sampRate：需被分割信号的采样率
[seg_data,seg_tTick,numbers] = wincut(signal,tTick,window_step,window_move,sampRate);
seg_tTick(1,1)
sign = [];
winpower=zeros(1,numbers);
for in = 1:numbers
    N = 1024;
    n = 0:(N-1);
    y = fft(seg_data(:,in),1024);
    f = n*8/N;
    s = f(1:N/2);
    q = abs(y(1:N/2));
    winpower(in) = trapz(s,q); %计算每个窗口的功率，当低于定值时认为是呼吸暂停
%      normal = trapz(s(28:33),q(28:33)); 
end

ymin=1.3.*min(signal);
ymax=1.3.*max(signal);

winpower=log(1+winpower);

thre_winpower=modify_vector.*(mean(winpower)-0.3*std(winpower));
for m=1:numbers
    if winpower(m) <=thre_winpower%% 修改 观察C_stringfind是否为空，是的话增大
         sign = [sign,1];
    else sign = [sign,0];
    end
end

sign=[0 sign 0];
C_stringfind=sign(2:end)-sign(1:end-1);
first_idx=find(C_stringfind==1);
last_idx=find(C_stringfind==-1);
lasttTick =zeros(1,numel(last_idx));
firsttTick =zeros(1,numel(first_idx));
for n=1:numel(firsttTick)
    firsttTick(n)=seg_tTick(1,first_idx(n));
    lasttTick(n)=seg_tTick(end,last_idx(n)-1);
end
 %% 判断呼吸暂停是否大于十秒
last_time=lasttTick-firsttTick;%呼吸暂停的每一段的持续时间
idx_overtime=find(last_time>=10);%持续时间超过10s的索引
idx_lowtime=find(last_time<10);
firsttTick1=firsttTick(idx_lowtime);%持续时间不超过10s的每一段的开始时间点
lasttTick1=lasttTick(idx_lowtime);%持续时间部不超过10s的每一段的结束时间点
firsttTick=firsttTick(idx_overtime);%持续时间超过10s的每一段的开始时间点
lasttTick=lasttTick(idx_overtime);%持续时间超过10s的每一段的结束时间点

end


