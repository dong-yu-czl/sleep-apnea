function [thre_winpower,firsttTick,lasttTick,firsttTick1,lasttTick1]=Airflow_Function(modify_vector, signal,tTick,window_step,window_move,sampRate,ang)
%ymin,ymaxΪͼ��y��ķ�Χ  
%startTime_iBlkΪ����źŵ���ʼʱ��
%modify_vectorΪ����ϵ��
%signalΪ�豻�ָ��ź�
% tTick���豻�ָ��źŵ�ʱ����Ϣ
% window_step�����ڳ��ȣ���λs
% window_move�����ڻ�����������λs
% sampRate���豻�ָ��źŵĲ�����
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
    winpower(in) = trapz(s,q); %����ÿ�����ڵĹ��ʣ������ڶ�ֵʱ��Ϊ�Ǻ�����ͣ
%      normal = trapz(s(28:33),q(28:33)); 
end

ymin=1.3.*min(signal);
ymax=1.3.*max(signal);

winpower=log(1+winpower);

thre_winpower=modify_vector.*(mean(winpower)-0.3*std(winpower));
for m=1:numbers
    if winpower(m) <=thre_winpower%% �޸� �۲�C_stringfind�Ƿ�Ϊ�գ��ǵĻ�����
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
 %% �жϺ�����ͣ�Ƿ����ʮ��
last_time=lasttTick-firsttTick;%������ͣ��ÿһ�εĳ���ʱ��
idx_overtime=find(last_time>=10);%����ʱ�䳬��10s������
idx_lowtime=find(last_time<10);
firsttTick1=firsttTick(idx_lowtime);%����ʱ�䲻����10s��ÿһ�εĿ�ʼʱ���
lasttTick1=lasttTick(idx_lowtime);%����ʱ�䲿������10s��ÿһ�εĽ���ʱ���
firsttTick=firsttTick(idx_overtime);%����ʱ�䳬��10s��ÿһ�εĿ�ʼʱ���
lasttTick=lasttTick(idx_overtime);%����ʱ�䳬��10s��ÿһ�εĽ���ʱ���

end


