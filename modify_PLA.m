function [normal_TORACE_MaxX,normal_TORACE_MaxY] =modify_PLA(TORACE_MaxX,TORACE_MaxY,thre_T)
% 该函数主要是删除靠近峰值点的局部最大值
% TORACE_MaxX：原始最大值的峰值点（准确时间）
% TORACE_MaxY：原始最大值的峰值点（幅值高度）
% seg_period：窗口滑动步长
% thre_T：判断阈值，为求出平均周期的倍数
len_TORACE_MaxX=numel(TORACE_MaxX);
normal_TORACE_MaxX=[];
normal_TORACE_MaxY=[];
%%剔除不正常的时间最大
mean_period=3;
temp_period=4;
idx=1;
% apnea_first=0;
% apnea_last=0;
for n=2:len_TORACE_MaxX
    peaks_interval=TORACE_MaxX(n)-TORACE_MaxX(idx);
    if idx+temp_period<=len_TORACE_MaxX
        mean_period_temp=(TORACE_MaxX(idx+temp_period)-TORACE_MaxX(idx))./4;
    else
        mean_period_temp=(TORACE_MaxX(end)-TORACE_MaxX(2*idx-len_TORACE_MaxX))./4;
    end
% ***************************
% 作用:PLA修正周期最大值设置
% 更改语句：mean_period_temp>=7
% 更改规则：认为大于7s的周期为呼吸暂停，可以修改参数 7 （一般大于等于7s）
% ***************************
    if mean_period_temp>=7
        mean_period=mean_period;
%         apnea_first=[apnea_first TORACE_MaxX(idx)];
%         apnea_last=[apnea_last TORACE_MaxX(n)];
    elseif mean_period_temp<=3
        mean_period=3;
    else
        mean_period=mean_period_temp;
    end
    
    if peaks_interval>mean_period*thre_T
            normal_TORACE_MaxX=[normal_TORACE_MaxX TORACE_MaxX(idx)];
            normal_TORACE_MaxY=[normal_TORACE_MaxY TORACE_MaxY(idx)];
            idx=n;
    else
        if TORACE_MaxY(n)>=TORACE_MaxY(idx)
            idx=n;
            temp_period=4;
        else
            temp_period=temp_period+1;
        end
    end
end
% apnea_first(1)=[];
% apnea_last(1)=[];
end
    
  