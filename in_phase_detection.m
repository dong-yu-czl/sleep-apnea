clear all
[fileName, pathName] = uigetfile('*.mat','Select the .mat file to display'); % only _iBlk_x.mat for now
load([pathName, fileName]); % 'data', 'header', ...

% ecg=data:channel 8
% Flusso:
% TORACE:
% ADDOME:
% SaO2:
% position=channel 16

%  load Data
% sdb1,2,4
% chLabel = 'Flusso';  
% chLabel_2 = 'TORACE'; 
% chLabel_3= 'ADDDOME'; 
% chLabel_4 = 'SAO2'; 
% 
% % sdb3
% % chLabel = 'TERMISTORE'; 
% % chLabel_2 = 'TORACE'; 
% % chLabel_3 = 'ADDOME';
% % chLabel_4 = 'SpO2';
% 
% %% define chNO for Flusso
% for eCH = 1:numel(header.labels)
%     if strcmp(header.labels(eCH), chLabel)
%         chNO = eCH;
%         break;
%     end
% end
% for eCH = 1:numel(header.labels)
%     if strcmp(header.labels(eCH), chLabel_2)
%         chNO2 = eCH; 
%         break;
%     end
% end
% for eCH = 1:numel(header.labels)
%    if strcmp(header.labels(eCH), chLabel_3)
%         chNO3 = eCH;
%         break;
%    end
% end
% for eCH = 1:numel(header.labels)
%     if strcmp(header.labels(eCH), chLabel_4)
%         chNO4 = eCH;
%         break;
%     end
% end
% 
% %% get the Flusso TORACE ADDDOME SAO2 data
% Flusso = data{chNO}; % get Flusso(channel 10) data for the whole i-th block
% TORACE = data{chNO2}; % get TORACE(channel 11)  data for the whole i-th block
% ADDOME = data{chNO3}; % get ADDDOME(channel 12) data for the whole i-th block
% SaO2= data{chNO4}; % get SAO2(channel 13) data for the whole i-th block
% 
% %% get the Flusso TORACE ADDDOME SAO2 time
% startTimeStr = header.starttime;
% idx = findstr(startTimeStr, '.');
% startTimeH = str2num(startTimeStr(1:idx(1)-1));
% startTimeM = str2num(startTimeStr(idx(1)+1:idx(2)-1));
% startTimeS = str2num(startTimeStr(idx(2)+1:end));
% 
% startTime0 = startTimeH*3600 + startTimeM*60 + startTimeS; % startTime(s) for the very first data point 
% startTime_iBlk = startTime0 + (iBlk-1)*3600; % startTime (s) for the i-th Blk data
% 
% %% flusso
% tTick_flusso = startTime_iBlk + [0:numel(data{chNO})-1]/header.samplerate(chNO); % time stamp for the iBlk dat
% sampRate_flusso=header.samplerate(chNO);
% 
% %% choose any time you like
% tTick_flusso=tTick_flusso(1:floor(numel(tTick_flusso)));
% Flusso=Flusso(1:floor(numel(Flusso)));
% 
% %% get aligned time of four signals
% %% sao2
% tTick_sao2 = startTime_iBlk + [0:numel(data{chNO4})-1]/header.samplerate(chNO4);
% [min1,ADDDOME_PLA_idx]=min(abs(tTick_sao2-tTick_flusso(1)));
% [min2,TORACE_PLA_idx]=min(abs(tTick_sao2-tTick_flusso(end)));
% sampRate_sao2=header.samplerate(chNO4);
% samprate_ratio_sao2=sampRate_sao2/sampRate_flusso;
% tTick_sao2=tTick_sao2(ADDDOME_PLA_idx:TORACE_PLA_idx);
%  [ tTick_sao2,delay] = delay_SaO2(15,Flusso,tTick_flusso,sampRate_flusso,SaO2,tTick_sao2,sampRate_sao2 );
% SaO2=SaO2(ADDDOME_PLA_idx:TORACE_PLA_idx);
% 
% %% torace
% tTick_torace = startTime_iBlk + [0:numel(data{chNO2})-1]/header.samplerate(chNO2); 
% [min1,ADDDOME_PLA_idx]=min(abs(tTick_torace-tTick_flusso(1)));
% [min2,TORACE_PLA_idx]=min(abs(tTick_torace-tTick_flusso(end)));
% sampRate_torace=header.samplerate(chNO2);
% samprate_ratio_torace=sampRate_torace/sampRate_flusso;
% tTick_torace=tTick_torace(ADDDOME_PLA_idx:TORACE_PLA_idx);
% TORACE=TORACE(ADDDOME_PLA_idx:TORACE_PLA_idx);
% 
% %% addome
% tTick_addome = startTime_iBlk + [0:numel(data{chNO3})-1]/header.samplerate(chNO3); 
% [min1,ADDDOME_PLA_idx]=min(abs(tTick_addome-tTick_flusso(1)));
% [min2,TORACE_PLA_idx]=min(abs(tTick_addome-tTick_flusso(end)));
% sampRate_addome=header.samplerate(chNO3);
% samprate_ratio_addome=sampRate_addome/sampRate_flusso;
% tTick_addome=tTick_addome(ADDDOME_PLA_idx:TORACE_PLA_idx);
% %% 鼻气流检测
% 
% %  [thre_winpower,firsttTick,lasttTick,firsttTick1,lasttTick1]=Airflow_Function(1.5,Flusso,tTick_flusso,4,2,sampRate_flusso,1);
% %  presentation_foursignals(tTick_flusso,Flusso,tTick_torace,TORACE,tTick_addome,ADDOME,tTick_sao2,SaO2,firsttTick,lasttTick)
% 
% %% 滤波
% ADDOME=ADDOME(ADDDOME_PLA_idx:TORACE_PLA_idx);
% ADDOME=detrend(ADDOME);
% lev=7 ;wn='db4';
% ADDDOME_= wden(ADDOME, 'heursure', 's', 'one', lev ,wn);
% 
% [c,l]=wavedec(TORACE,6,'db4'); %wavelet basis is sym4, level is 6
% ca6=appcoef(c,l,'db4',6); %    get LF 0Hz~0.5Hz
% cd1=detcoef(c,l,1);%16Hz~32Hz   HF details
% cd2=detcoef(c,l,2);%8Hz~16Hz
% cd3=detcoef(c,l,3);%4Hz~8Hz
% cd4=detcoef(c,l,4);%2Hz~4Hz
% cd5=detcoef(c,l,5);%1Hz~2Hz
% cd6=detcoef(c,l,6);%0.5Hz~1Hz
% sd1=(zeros(1,length(cd1)))';%zero setting
% sd2=(zeros(1,length(cd2)))';
% sd3=(zeros(1,length(cd3)))';
% sd4=(zeros(1,length(cd4)))';
% sd5=(zeros(1,length(cd5)))';
% sd6=(zeros(1,length(cd6)))';
% c2=[ca6;sd6;sd5;sd4;sd3;sd2;sd1];
% TORACE_=waverec(c2,l,'db4'); %wavelet reconstruction
% 
% %% PLA
% % ***************************
% % 作用:PLA参数设置
% % 参数：
% % 步长：ADDDOME_PLA_size TORACE_PLA_size
% % 容错：error_adddome  error_torace
% % 更改规则：拟合程度越高，步长和容错设置越小
% % ***************************
% ADDDOME_PLA_size=2;
% TORACE_PLA_size=1;
% error_adddome=0.01;
% error_torace=0.01;
% % [TORACE_MaxX,TORACE_MaxY,ADDDOME_MaxX,ADDDOME_MaxY] = TA_PLA_wincut( ADDDOME_,TORACE_,tTick_addome,tTick_torace, ADDDOME_PLA_size,TORACE_PLA_size,error_adddome,error_torace,sampRate_torace,sampRate_addome,1);
% [TORACE_MaxX,TORACE_MaxY,idx_overthre_torace,ADDDOME_MaxX,ADDDOME_MaxY,idx_overthre_addome]...
%     =Fun_TA_PLA( ADDDOME_,TORACE_,tTick_addome,tTick_torace,...
%         ADDDOME_PLA_size,TORACE_PLA_size,error_adddome,error_torace,1);
%     save('E:\Junior\dachuang\代码包\torace_addome_iblk2.mat','TORACE_MaxX','TORACE_MaxY',...
%     'idx_overthre_torace','ADDDOME_MaxX','ADDDOME_MaxY','idx_overthre_addome',...
%     'tTick_torace','TORACE_','tTick_addome','ADDDOME_','tTick_flusso','Flusso','tTick_sao2','SaO2','ADDOME','TORACE');

% % 将结构体变量转为数组形式
% % torace_MaxX=0;
% % torace_MaxY=0;
% % for n=1:numel(TORACE_MaxX.seg)
% %     torace_MaxX=[torace_MaxX TORACE_MaxX.seg(n).MaxX];
% %     torace_MaxY=[torace_MaxY TORACE_MaxY.seg(n).MaxY];
% % end
% % torace_MaxX(1)=[];
% % torace_MaxY(1)=[];
% % 
% % addome_MaxX=0;
% % addome_MaxY=0;
% % for n=1:numel(ADDDOME_MaxX.seg)
% %     addome_MaxX=[addome_MaxX ADDDOME_MaxX.seg(n).MaxX];
% %     addome_MaxY=[addome_MaxY ADDDOME_MaxY.seg(n).MaxY];
% % end
% % addome_MaxX(1)=[];
% % addome_MaxY(1)=[];

%% PLA修正
% ***************************
% 若直接运行数据 torace_addome_iblk2.mat\torace_addome_iblk3.mat...\torace_addome_iblk9.mat
% 可以从此位置开始运行，上面代码注释掉
% ***************************
% 函数：modify_PLA
% 作用:PLA修正周期最大值设置
% 更改语句：mean_period_temp>=7（modify_PLA函数语句）
% 更改规则：认为大于7s的周期为呼吸暂停，可以修改参数 7 （一般大于等于7s）
% ***************************
torace_MaxX=TORACE_MaxX;
torace_MaxY=TORACE_MaxY;
addome_MaxX=ADDDOME_MaxX;
addome_MaxY=ADDDOME_MaxY;
[normal_ADDDOME_MaxX,normal_ADDDOME_MaxY] =modify_PLA(addome_MaxX,addome_MaxY,0.5);
[normal_TORACE_MaxX,normal_TORACE_MaxY] =modify_PLA(torace_MaxX,torace_MaxY,0.5);

figure
subplot(211)
plot(tTick_torace,TORACE_,torace_MaxX,torace_MaxY,'r*')
title('未修正的胸部信号最大值检测')
subplot(212)
plot(tTick_torace,TORACE_,normal_TORACE_MaxX,normal_TORACE_MaxY,'r*')
title('修正后的胸部信号最大值检测')
ax(1)=subplot(211);
ax(2)=subplot(212);
linkaxes(ax,'x');
figure
subplot(211)
plot(tTick_addome,ADDDOME_,addome_MaxX,addome_MaxY,'r*')
title('未修正的腹部信号最大值检测')
subplot(212)
plot(tTick_addome,ADDDOME_,normal_ADDDOME_MaxX,normal_ADDDOME_MaxY,'r*')
title('修正后的腹部信号最大值检测')
ax(1)=subplot(211);
ax(2)=subplot(212);
linkaxes(ax,'x');

% %% 同相位检测
% [len_min,len_tag]=min([length(normal_TORACE_MaxX),length(normal_ADDDOME_MaxX)]);
% if len_tag==1
%     short_MaxX=normal_TORACE_MaxX;
%     short_full=tTick_torace;
%     long_MaxX=normal_ADDDOME_MaxX;
%     long_full=tTick_addome;
% else
%     short_MaxX=normal_ADDDOME_MaxX;
%     short_full=tTick_addome;
%     long_MaxX=normal_TORACE_MaxX;
%     long_full=tTick_torace;
% end
% long_in_phase=zeros(1,numel(long_MaxX));
% short_in_phase=zeros(3,len_min-1);
% % othertype_short_start=[];
% % othertype_short_over=[];
% % othertype_long_start=[];
% % othertype_long_over=[];
% for num=1:len_min-1
%     [value_diff,compare_index]=min(abs(long_MaxX-short_MaxX(num)));
%     if abs(long_MaxX-short_MaxX(num))>5
%         long_in_phase(compare_index)=2;
%         short_in_phase(1,num)=2;
%     else
%         if compare_index<numel(long_MaxX)
%             com_T=(long_MaxX(compare_index+1)-long_MaxX(compare_index)+short_MaxX(num+1)-short_MaxX(num))/2;
%             com_Tp=abs(long_MaxX(compare_index)-short_MaxX(num));
%         end
%         if 3*com_T/8>com_Tp ||(11*com_T/8>=com_Tp && com_Tp>com_T)   %%判断是否同相位
%             long_in_phase(compare_index)=long_MaxX(compare_index);
%             short_in_phase(1,num)=short_MaxX(num);
%         else
%             if value_diff<0
%                 short_in_phase(1,num)=-1;
%             end
%             [long_a,long_b]=min(abs(long_full-short_MaxX(num)));
%             if long_full(long_b)>long_MaxX(compare_index)
%                 short_in_phase(2,num)=long_MaxX(compare_index);
%                 short_in_phase(3,num)=long_full(long_b);
%             else
%                 short_in_phase(2,num)=long_full(long_b);
%                 short_in_phase(3,num)=long_MaxX(compare_index);
%             end
%         end
%     end
% end
% full_long_in_phase=long_in_phase;
% long_in_phase(long_in_phase==0)=[];
% long_in_phase(long_in_phase==2)=[];
% full_short_in_phase=short_in_phase;
% short_in_phase=short_in_phase(1,:);
% short_in_phase(short_in_phase==0)=[]; 
% short_in_phase(short_in_phase==2)=[]; 
% if len_tag==1
%     in_phase_TORACE_MaxX=short_in_phase;
%     full_phase_TORACE_MaxX=full_short_in_phase;
%     in_phase_ADDDOME_MaxX=long_in_phase;
%     full_phase_ADDDOME_MaxX=full_long_in_phase;
% else
%     in_phase_TORACE_MaxX=long_in_phase;
%     full_phase_TORACE_MaxX=full_long_in_phase;
%     in_phase_ADDDOME_MaxX=short_in_phase;
%     full_phase_ADDDOME_MaxX=full_short_in_phase;
%     
% end
% in_phase_TORACE_MaxY=zeros(1,numel(in_phase_TORACE_MaxX));
% in_phase_ADDDOME_MaxY=zeros(1,numel(in_phase_ADDDOME_MaxX));
% for idx=1:numel(in_phase_TORACE_MaxX)
%     in_phase_TORACE_MaxY(idx)=normal_TORACE_MaxY(normal_TORACE_MaxX==in_phase_TORACE_MaxX(idx));
% end
% 
% for idx=1:numel(in_phase_ADDDOME_MaxX)
%     in_phase_ADDDOME_MaxY(idx)=normal_ADDDOME_MaxY(normal_ADDDOME_MaxX==in_phase_ADDDOME_MaxX(idx));
% end
% 
% %%分开绘图
% % figure
% % subplot(211)
% % plot(tTick_torace,TORACE_,in_phase_TORACE_MaxX,in_phase_TORACE_MaxY,'r*')
% % subplot(212)
% % plot(tTick_addome,ADDDOME_,in_phase_ADDDOME_MaxX,in_phase_ADDDOME_MaxY,'r*')
% % ax(1)=subplot(211);
% % ax(2)=subplot(212);
% % linkaxes(ax,'x');
% 
% 
% figure
% plot(tTick_torace,TORACE_,'b',in_phase_TORACE_MaxX,in_phase_TORACE_MaxY,'r*')
% hold on
% plot(tTick_addome,ADDDOME_,'m',in_phase_ADDDOME_MaxX,in_phase_ADDDOME_MaxY,'g*')
% title('胸腹部信号的同相位检测')
% legend('胸部信号','胸部同相位点','腹部信号','腹部同相位点')
% 
% 
% %%腹部信号
% start_pause_ADDDOME=zeros(1,numel(normal_ADDDOME_MaxX));
% stop_pause_ADDDOME=start_pause_ADDDOME;
% diff_normal_ADDDOME_MaxX=diff(normal_ADDDOME_MaxX);
% % ***************************
% % 作用:呼吸暂停时间点获取
% % 更改语句：break_ADDDOME_index=find(diff_normal_ADDDOME_MaxX>8)
% % 更改规则：认为大于8s的周期为呼吸暂停，可以修改参数 8 （一般大于7s）
% % ***************************
% break_ADDDOME_index=find(diff_normal_ADDDOME_MaxX>8);
% if len_tag==1
%     find_short_A=find(full_short_in_phase(2,:)~=0);
%     for idx=1:numel(find_short_A)
%         start_pause_ADDDOME(idx)=full_short_in_phase(2,find_short_A(idx));
%         stop_pause_ADDDOME(idx)=full_short_in_phase(3,find_short_A(idx));
%     end
% else
%     break_full_ADDDOME_index1=find(full_phase_ADDDOME_MaxX(1,:)==0);
%     break_full_ADDDOME_index2=find(full_phase_ADDDOME_MaxX(1,:)==-1);
%     for idx=1:numel(break_full_ADDDOME_index1)
%         if  break_full_ADDDOME_index1(idx)~=numel(normal_ADDDOME_MaxX)
%             start_pause_ADDDOME(idx)=normal_ADDDOME_MaxX(break_full_ADDDOME_index1(idx));
%             stop_pause_ADDDOME(idx)=normal_ADDDOME_MaxX(break_full_ADDDOME_index1(idx)+1);
%         end
%     end
%     for idx=numel(break_full_ADDDOME_index1)+1:numel(break_full_ADDDOME_index1)+numel(break_full_ADDDOME_index2)
%         start_pause_ADDDOME(idx)=normal_ADDDOME_MaxX(break_full_ADDDOME_index1(idx-numel(break_full_ADDDOME_index1))-1);
%         stop_pause_ADDDOME(idx)=normal_ADDDOME_MaxX(break_full_ADDDOME_index1(idx-numel(break_full_ADDDOME_index1)));
%     end
% end
% 
% numel_start_A=numel(find(start_pause_ADDDOME~=0));
% 
% for idx=numel_start_A+1:numel_start_A+numel(break_ADDDOME_index)
%     start_pause_ADDDOME(idx)=normal_ADDDOME_MaxX(break_ADDDOME_index(idx-numel_start_A));
%     stop_pause_ADDDOME(idx)=normal_ADDDOME_MaxX(break_ADDDOME_index(idx-numel_start_A)+1);
% end
% 
% start_pause_ADDDOME(start_pause_ADDDOME==0)=[];
% stop_pause_ADDDOME(stop_pause_ADDDOME==0)=[];
% 
% 
% %%胸部信号
% start_pause_TORACE=zeros(1,numel(normal_TORACE_MaxX));
% stop_pause_TORACE=start_pause_TORACE;
% diff_normal_TORACE_MaxX=diff(normal_TORACE_MaxX);
% % ***************************
% % 作用:呼吸暂停时间点获取
% % 更改语句：break_ADDDOME_index=find(diff_normal_ADDDOME_MaxX>8)
% % 更改规则：认为大于8s的周期为呼吸暂停，可以修改参数 8 （一般大于7s）
% % ***************************
% break_TORACE_index=find(diff_normal_TORACE_MaxX>8); %%大于7秒
% if len_tag~=1
%     find_short_T=find(full_short_in_phase(2,:)~=0);
%     for idx=1:numel(find_short_T)
%         start_pause_TORACE(idx)=full_short_in_phase(2,find_short_T(idx));
%         stop_pause_TORACE(idx)=full_short_in_phase(3,find_short_T(idx));
%     end
% else
%     break_full_TORACE_index1=find(full_phase_TORACE_MaxX(1,:)==0);
%     break_full_TORACE_index2=find(full_phase_TORACE_MaxX(1,:)==-1);
%     for idx=1:numel(break_full_TORACE_index1)
%         if  break_full_TORACE_index1(idx)~=numel(normal_TORACE_MaxX)
%             start_pause_TORACE(idx)=normal_TORACE_MaxX(break_full_TORACE_index1(idx));
%             stop_pause_TORACE(idx)=normal_TORACE_MaxX(break_full_TORACE_index1(idx)+1);
%         end
%     end
%     for idx=numel(break_full_TORACE_index1)+1:numel(break_full_TORACE_index1)+numel(break_full_TORACE_index2)
%         start_pause_TORACE(idx)=normal_TORACE_MaxX(break_full_TORACE_index1(idx-numel(break_full_TORACE_index1))-1);
%         stop_pause_TORACE(idx)=normal_TORACE_MaxX(break_full_TORACE_index1(idx-numel(break_full_TORACE_index1)));
%     end
% end
% numel_start_T=numel(find(start_pause_TORACE~=0));
% 
% for idx=numel_start_T+1:numel_start_T+numel(break_TORACE_index)
%     start_pause_TORACE(idx)=normal_TORACE_MaxX(break_TORACE_index(idx-numel_start_T));
%     stop_pause_TORACE(idx)=normal_TORACE_MaxX(break_TORACE_index(idx-numel_start_T)+1);
% end
% 
% 
% start_pause_TORACE(start_pause_TORACE==0)=[];
% stop_pause_TORACE(stop_pause_TORACE==0)=[];
% 
% 
% 
% figure
% plot(tTick_torace,TORACE_,'g')
% H(1)=plot(tTick_torace,TORACE_,'g');
% hold on
% plot(tTick_addome,ADDDOME_,'b')
% H(2)=plot(tTick_addome,ADDDOME_,'b');
% 
% hold on
% for idx=1:numel(start_pause_ADDDOME)
%     plot(tTick_addome(find(tTick_addome==start_pause_ADDDOME(idx)):find(tTick_addome==stop_pause_ADDDOME(idx))),ADDDOME_(find(tTick_addome==start_pause_ADDDOME(idx)):find(tTick_addome==stop_pause_ADDDOME(idx))),'r');
%     hold on
% end
% 
% 
% 
% hold on
% for idx=1:numel(start_pause_TORACE)
%     plot(tTick_torace(find(tTick_torace==start_pause_TORACE(idx)):find(tTick_torace==stop_pause_TORACE(idx))),TORACE_(find(tTick_torace==start_pause_TORACE(idx)):find(tTick_torace==stop_pause_TORACE(idx))),'k');
%     hold on
% end
% hold on
% plot(normal_TORACE_MaxX,normal_TORACE_MaxY,'g*')
% H(3)=plot(normal_TORACE_MaxX,normal_TORACE_MaxY,'g*');
% hold on
% plot(normal_ADDDOME_MaxX,normal_ADDDOME_MaxY,'b*')
% H(4)=plot(normal_ADDDOME_MaxX,normal_ADDDOME_MaxY,'b*');
% legend(H([1 2 3 4]),'胸部信号','腹部信号','胸部信号峰值点','腹部信号峰值点')
% 
% title('胸腹部信号同相位检测')
% 
% 
% 
% 
% 
% %% 
% % ***************************
% % 作用:胸腹部检测最终结果
% % 图形描述：胸腹部暂停标注位置不一样，由于算法原因导致，无需在意
% %           值得注意的是，由于暂时没有解决胸腹部信号暂停标注的统一问题，所以花了图21、22
% %           图21是以腹部信号的暂停标注对鼻气流、血氧信号标注
% %           图22是以胸部信号的暂停标注对鼻气流、血氧信号标注
% %           任意选择一幅图观察
% % 任务：观察并记录信号标记矛盾的地方，例如,鼻气流显示呼吸但是胸腹部确实暂停
% % 注意：呼吸暂停结果不一定大于10s，legend 标注有误
% % ***************************
% % figure(21)
% for idx=1:numel(start_pause_ADDDOME)
%     A_firsttTick(idx)=tTick_addome(find(tTick_addome==start_pause_ADDDOME(idx)));
%     A_lasttTick(idx)=tTick_addome(find(tTick_addome==stop_pause_ADDDOME(idx)));
% end
% presentation_foursignals(tTick_flusso,Flusso,tTick_torace,TORACE,tTick_addome,ADDOME,tTick_sao2,SaO2, A_firsttTick, A_lasttTick);
% title('胸腹部呼吸暂停检测结果（腹部标记为准）')
% 
% % figure(22)
% for idx=1:numel(start_pause_TORACE)
%     T_firsttTick(idx)=tTick_torace(find(tTick_torace==start_pause_TORACE(idx)));
%     T_lasttTick(idx)=tTick_torace(find(tTick_torace==stop_pause_TORACE(idx)));
% end
% presentation_foursignals(tTick_flusso,Flusso,tTick_torace,TORACE,tTick_addome,ADDOME,tTick_sao2,SaO2, T_firsttTick, T_lasttTick);
% 
% title('胸腹部呼吸暂停检测结果（胸部标记为准）')


    





