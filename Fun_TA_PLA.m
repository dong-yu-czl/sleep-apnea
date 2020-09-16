function [TORACE_MaxX,TORACE_MaxY,idx_overthre_torace,ADDDOME_MaxX,ADDDOME_MaxY,idx_overthre_addome] = Fun_TA_PLA( ADDDOME_,TORACE_,tTick_addome,tTick_torace, ADDDOME_PLA_size,TORACE_PLA_size,error_adddome,error_torace,fig)
% [TORACE_MaxX,TORACE_MaxY,ADDDOME_MaxX,ADDDOME_MaxY,tTick_overthre_addome,TORACE_MinX,TORACE_MinY,ADDDOME_MinX,ADDDOME_MinY]
%   ADDDOME_PLA_size; TORACE_PLA_size: step size
%   fig:figure or not
%% PLA
%% ADDOME
idx_ADDDOME_end=length(ADDDOME_);  % get the end of f;
ADDDOME_PLA_start=1;               % identify strat;
ADDDOME_PLA_stop=1;                % identify stop;
ADDDOME_PLA_idx=1;                % identify idx;
idx_ADDDOME_point=1;
slope_ADDDOME=0;
while idx_ADDDOME_end~=ADDDOME_PLA_stop
    erro=0;
    while (idx_ADDDOME_end~=ADDDOME_PLA_stop && erro <= error_adddome )
        ADDDOME_PLA_stop=ADDDOME_PLA_stop+ADDDOME_PLA_size;     % stop defer one size
        if ADDDOME_PLA_stop >= idx_ADDDOME_end - ADDDOME_PLA_size
            ADDDOME_PLA_stop = idx_ADDDOME_end;
        end
        k_addome=(ADDDOME_(ADDDOME_PLA_start)-ADDDOME_(ADDDOME_PLA_stop))/(ADDDOME_PLA_start-ADDDOME_PLA_stop); % get the slope k
        for in=ADDDOME_PLA_start:ADDDOME_PLA_stop
            err(in)=abs((ADDDOME_(in)-k_addome*(in-ADDDOME_PLA_start)-ADDDOME_(ADDDOME_PLA_start))/sqrt(k_addome*k_addome+1)); % calculate err
        end
%         amp_addome_maxX=ADDDOME_(ADDDOME_PLA_stop);
%         if  amp_addome_maxX<-1
%             erro=0;
%         else
            erro=max(err);  % find the max of err
%         end
        err=0;
    end
    dx1=ADDDOME_PLA_stop-ADDDOME_PLA_start;     % record dx of this idx
    slope_ADDDOME=[slope_ADDDOME k_addome];        % record k  of this id
    ADDDOME_PLA_idx=ADDDOME_PLA_idx+1;
    ADDDOME_PLA_start=ADDDOME_PLA_stop;         % make next start from stop
    idx_ADDDOME_point=[ idx_ADDDOME_point ADDDOME_PLA_stop];
end
clear k

len_slope_A=numel(slope_ADDDOME);% 腹部 折线段数
ADDDOME_x=tTick_addome(idx_ADDDOME_point);% 腹部信号拟合折线的时间戳
ADDDOME_y=ADDDOME_( idx_ADDDOME_point);% 腹部信号拟合折线
ADDDOME_MaxX=zeros(1,len_slope_A);% 腹部 局部极大值时间戳
ADDDOME_MaxY=zeros(1,len_slope_A);% 腹部 局部极大值
for num=1:len_slope_A-1
    if slope_ADDDOME(num)>=0 && slope_ADDDOME(num+1)<0
        ADDDOME_MaxX(num)=ADDDOME_x(num+1);
        ADDDOME_MaxY(num)=ADDDOME_y(num+1);
    end
end
idx_addome_overspace_max=find(ADDDOME_MaxX==0);
ADDDOME_MaxX(idx_addome_overspace_max)=[];ADDDOME_MaxY(idx_addome_overspace_max)=[];
idx_overthre_addome=find(ADDDOME_MaxY>0.35);
ADDDOME_MaxX=ADDDOME_MaxX(idx_overthre_addome);
ADDDOME_MaxY=ADDDOME_MaxY(idx_overthre_addome);
% tTick_overthre_addome=ADDDOME_MaxX(find(ADDDOME_MaxY<=0.35));
    
% ADDDOME_MinX=zeros(1,len_slope_A);% 腹部 局部极大值时间戳
% ADDDOME_MinY=zeros(1,len_slope_A);% 腹部 局部极大值
% for num=1:len_slope_A-1
%     if slope_ADDDOME(num)<=0 && slope_ADDDOME(num+1)>0
%         ADDDOME_MinX(num)=ADDDOME_x(num+1);
%         ADDDOME_MinY(num)=ADDDOME_y(num+1);
%     end
% end
% idx_addome_overspace_min=find(ADDDOME_MinX==0);
% ADDDOME_MinX(idx_addome_overspace_min)=[];ADDDOME_MinY(idx_addome_overspace_min)=[];

%% TORACE
    idx_TORACE_end=length(TORACE_);      % get the end of f;
    TORACE_PLA_start=1;           % identify strat;
    TORACE_PLA_stop=1;            % identify stop;
    TORACE_PLA_idx=1;             % identify idx;
    idx_TORACE_point=1;
    slope_TORACE=0;
    
    while idx_TORACE_end~=TORACE_PLA_stop
        erro=0;
        while (idx_TORACE_end~=TORACE_PLA_stop && erro <= error_torace)
            TORACE_PLA_stop=TORACE_PLA_stop+TORACE_PLA_size;     % stop defer one size
            if TORACE_PLA_stop >= idx_TORACE_end - TORACE_PLA_size
                TORACE_PLA_stop = idx_TORACE_end;
            end
            k_torace=(TORACE_(TORACE_PLA_start)-TORACE_(TORACE_PLA_stop))/(TORACE_PLA_start-TORACE_PLA_stop); % get the slope k
            for in=TORACE_PLA_start:TORACE_PLA_stop
                err(in)=abs((TORACE_(in)-k_torace*(in-TORACE_PLA_start)-TORACE_(TORACE_PLA_start))/sqrt(k_torace*k_torace+1)); % calculate err
            end
            amp_torace_maxX=TORACE_(TORACE_PLA_stop);
%             if  amp_torace_maxX<-1
%                 erro=0;
%             else
                erro=max(err);  % find the max of err
%             end
            err=0;
        end
        dx2=TORACE_PLA_stop-TORACE_PLA_start;     % record dx of this idx
        slope_TORACE=[slope_TORACE k_torace];        % record k  of this id
        TORACE_PLA_idx=TORACE_PLA_idx+1;
        TORACE_PLA_start=TORACE_PLA_stop;         % make next start from stop
        idx_TORACE_point=[idx_TORACE_point TORACE_PLA_stop];
    end
    len_slope_T=numel(slope_TORACE); % 胸部 折线段数
    TORACE_x=tTick_torace(idx_TORACE_point);% 胸部信号拟合折线的时间戳
    TORACE_y=TORACE_(idx_TORACE_point);% 胸部信号拟合折线
    TORACE_MaxX=zeros(1,len_slope_T);% 胸部 局部极大值时间戳
    TORACE_MaxY=zeros(1,len_slope_T);% 胸部 局部极大值
    TORACE_MinX=zeros(1,len_slope_T);% 胸部 局部极大值时间戳
    TORACE_MinY=zeros(1,len_slope_T);% 胸部 局部极大值
    for num=1:len_slope_T-1
        if slope_TORACE(num)>=0 && slope_TORACE(num+1)<0%找到相邻折线斜率相反的折线
            TORACE_MaxX(num)=TORACE_x(num+1);
            TORACE_MaxY(num)=TORACE_y(num+1);
        end
    end
    idx_torace_overspace_max=find(TORACE_MaxX==0);
    TORACE_MaxX(idx_torace_overspace_max)=[];TORACE_MaxY(idx_torace_overspace_max)=[];
    idx_overthre_torace=find(TORACE_MaxY>0.55);
    TORACE_MaxX=TORACE_MaxX(idx_overthre_torace);
    TORACE_MaxY=TORACE_MaxY(idx_overthre_torace);
%     tTick_overthre_torace=TORACE_MaxX(find(TORACE_MaxY<=0.55));
%     for num=1:len_slope_T-1
%         if slope_TORACE(num)<=0 && slope_TORACE(num+1)>0%找到相邻折线斜率相反的折线
%             TORACE_MinX(num)=TORACE_x(num+1);
%             TORACE_MinY(num)=TORACE_y(num+1);
%         end
%     end
%     idx_torace_overspace_min=find(TORACE_MinX==0);
%     TORACE_MinX(idx_torace_overspace_min)=[];TORACE_MinY(idx_torace_overspace_min)=[];
%% 同相位检测
%% 初始化
% len_slope_T=numel(slope_TORACE); % 胸部 折线段数
% len_slope_A=numel(slope_ADDDOME);% 腹部 折线段数
% % for slope_type=1:2
%
% TORACE_x=tTick_torace(idx_TORACE_point);% 胸部信号拟合折线的时间戳
% TORACE_y=TORACE_(idx_TORACE_point);% 胸部信号拟合折线
% ADDDOME_x=tTick_addome(idx_ADDDOME_point);% 腹部信号拟合折线的时间戳
% ADDDOME_y=ADDDOME_(idx_ADDDOME_point);% 腹部信号拟合折线
%
% TORACE_MaxX=zeros(1,len_slope_T);% 胸部 局部极大值时间戳
% TORACE_MaxY=zeros(1,len_slope_T);% 胸部 局部极大值
% ADDDOME_MaxX=zeros(1,len_slope_A);% 腹部 局部极大值时间戳
% ADDDOME_MaxY=zeros(1,len_slope_A);% 腹部 局部极大值
%
% %% 同相位检测
% %% 胸部
% for num=1:len_slope_T-1
%     if slope_TORACE(num)>=0 && slope_TORACE(num+1)<0%找到相邻折线斜率相反的折线
%         TORACE_MaxX(num)=TORACE_x(num+1);
%         TORACE_MaxY(num)=TORACE_y(num+1);
%     end
% end
% %% 腹部
% for num=1:len_slope_A-1
%     if slope_ADDDOME(num)>=0 && slope_ADDDOME(num+1)<0
%         ADDDOME_MaxX(num)=ADDDOME_x(num+1);
%         ADDDOME_MaxY(num)=ADDDOME_y(num+1);
%     end
% end
%
% %% 删除多余(overspace)存储空间
% idx_torace_overspace=find(TORACE_MaxX==0);
% idx_addome_overspace=find(ADDDOME_MaxX==0);
% TORACE_MaxX(idx_torace_overspace)=[];TORACE_MaxY(idx_torace_overspace)=[];
% ADDDOME_MaxX(idx_addome_overspace)=[];ADDDOME_MaxY(idx_addome_overspace)=[];


%%  PLA 折线
if  fig==1
    %     slope_ADDDOME(1)=[];
    %     slope_TORACE(1)=[];
    figure
        plot(TORACE_)
        hold on
        plot(idx_TORACE_point,TORACE_( idx_TORACE_point),'r')
        legend('原信号','PLA折线')
        title('胸部信号（PLA）')
        hold on
    figure
        plot(ADDDOME_)
        hold on
        plot( idx_ADDDOME_point,ADDDOME_( idx_ADDDOME_point),'r')
        legend('原信号','PLA折线')
        title('腹部信号（PLA）')
end

%% 同相位检测结果
if  fig==1
    figure
    subplot(211)
    plot(tTick_torace,TORACE_)%,x1,y1,'b');
    hold on
    plot(TORACE_MaxX,TORACE_MaxY,'r*');
    title('胸部信号局部极大值检测')
    % title('胸部信号同相位检测')
    
    subplot(212)
    plot(tTick_addome,ADDDOME_)%,x2,y2,'b');
    hold on
    plot(ADDDOME_MaxX,ADDDOME_MaxY,'r*');
    title('腹部信号局部极大值检测')
    ax(1)=subplot(2,1,1);
    ax(2)=subplot(2,1,2);
    linkaxes(ax,'x');
end
end

