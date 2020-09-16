%seg_data：分割好的信号，seg_data(:1)为第一个窗口信号
% seg_tTick：对应窗口的时间信息
% numbers：分割总段数
% signal：需被分割信号
% tTick：需被分割信号的时间信息
% window_step：窗口长度，单位s
% window_move：窗口滑动步幅，单位s
% sampRate：需被分割信号的采样率

function [seg_data,seg_tTick,numbers] = wincut(signal,tTick,window_step,window_move,sampRate)
pitch=ceil(window_step*sampRate);%窗口长度s
pitch_shift=ceil(window_move*sampRate);%窗口滑动步幅s
dispitch_shift=pitch-pitch_shift;%相邻窗口重叠的部分
length_data=numel(signal);%信号1长度
flag=1;
numbers=0;%段数计数
if dispitch_shift ~= 0 
    K_temp = ceil(length_data/dispitch_shift);%段数（最大段数）
else
    flag=0;
    numbers = ceil(length_data/pitch_shift);%段数（最大段数）
end

if flag~=0
    len_rest=length_data;%信号剩余未分割的长度
    for n=1:K_temp
        if length_data>pitch%信号长度大于窗口长度
            numbers=numbers+1;%段数加1
            len_rest=len_rest-dispitch_shift;%分割后信号剩余长度
            if len_rest<=pitch%剩余长度小于窗口长度
                %由于信号长度不定，分割的最后一段长度可能比窗口长度小或者一样，那么判断当前分割的段为最后一段，分割结束
                numbers=numbers+1;
                break;%分割结束，跳出
            end
        else
            numbers=numbers+1;%信号长度小于等于窗口长度，只有一段
            break;
        end
    end
end

% 将分割好的信号保存在变量中
seg_data=zeros(pitch,numbers);
seg_tTick=zeros(pitch,numbers);
if flag~=0
    win=pitch_shift;
else
    win=pitch;
end
for n=1:numbers
    if n~=numbers
        seg_data(:,n)=signal(1+(n-1)*win:pitch+(n-1)*win);
        seg_tTick(:,n)=tTick(1+(n-1)*win:pitch+(n-1)*win);
    else
        len_lastseg=numel(signal)-(1+(n-1)*win)+1;
        seg_data(1:len_lastseg,n)=signal(1+(n-1)*win:end);
        seg_tTick(1:len_lastseg,n)=tTick(1+(n-1)*win:end);
    end
end
end