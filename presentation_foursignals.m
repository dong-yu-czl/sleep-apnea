function varargout = presentation_foursignals(varargin)
% if nargin==4
%展示任意一路信号大于10s的呼吸暂停
% presentation_foursignals(tTick_anysignal,anysignal,firsttTick_higher10s,lasttTick_higher10s)
% if nargin==6
%展示任意一路信号大于10s的呼吸暂停和小于10s的呼吸暂停
% presentation_foursignals(tTick_anysignal,anysignal,firsttTick(higher10s),...
% lasttTick(higher10s),firsttTick1(lower10s).lasttTick1(lower10s))
% if nargin==10
%展示4路信号大于10s的呼吸暂停
% presentation_foursignals(tTick_flusso,flusso,tTick_addome,addome,..., ...
% firsttTick(higher10s),lasttTick(higher10s))
% if nargin==12
%展示4路信号大于10s的呼吸暂停和小于10s的呼吸暂停
% presentation_foursignals(tTick_flusso,flusso,tTick_addome,addome,..., ...
% firsttTick(higher10s),lasttTick(higher10s),firsttTick1(lower10s).lasttTick1(lower10s))

if nargin==4
    tTick_flusso=varargin{1};Flusso=varargin{2};
    firsttTick=varargin{3};lasttTick=varargin{4};
    ang=1;
elseif nargin==6
    tTick_flusso=varargin{1};Flusso=varargin{2};
    firsttTick=varargin{3};lasttTick=varargin{4};
    firsttTick1=varargin{5};lasttTick1=varargin{6};
    ang=2;
elseif nargin==10
    tTick_flusso=varargin{1};Flusso=varargin{2};
    tTick_torace=varargin{3};TORACE=varargin{4};
    tTick_addome=varargin{5};ADDOME=varargin{6};
    tTick_sao2=varargin{7};SaO2=varargin{8};
    firsttTick=varargin{9};lasttTick=varargin{10};
    ang=1;
elseif nargin==12
    tTick_flusso=varargin{1};Flusso=varargin{2};
    tTick_torace=varargin{3};TORACE=varargin{4};
    tTick_addome=varargin{5};ADDOME=varargin{6};
    tTick_sao2=varargin{7};SaO2=varargin{8};
    firsttTick=varargin{9};lasttTick=varargin{10};
    firsttTick1=varargin{11};lasttTick1=varargin{12};
    ang=2;
end

if nargin==4||nargin==7
    promt='Which type  of signal you want to present？  ';
    signal_type=input(promt,'s');
   if ang==1||ang==2
    figure,
    plot(tTick_flusso,Flusso); 
    hold on
    title(signal_type)
     for m = 1:numel(firsttTick)
         flusso_tTick_start=find(tTick_flusso==firsttTick(m));
         flusso_tTick_end=find(tTick_flusso==lasttTick(m));
         plot (tTick_flusso (flusso_tTick_start:flusso_tTick_end), Flusso (flusso_tTick_start:flusso_tTick_end),'r' );
         hold on 
     end
     legend('原信号','>10s暂停')
     if ang==2
        for m = 1:numel(firsttTick1)
             flusso_tTick_start1=find(tTick_flusso==firsttTick1(m));
             flusso_tTick_end1=find(tTick_flusso==lasttTick1(m));
             plot (tTick_flusso (flusso_tTick_start1:flusso_tTick_end1), Flusso (flusso_tTick_start1:flusso_tTick_end1),'g' );
             hold on 
        end
        legend('原信号','>10s暂停','<10s暂停')
     end
   end
   
elseif nargin==10||nargin==13
 
    if ang==1||ang==2
        figure,
        subplot(411)
        plot(tTick_flusso,Flusso); 
        hold on
        title('FLUSSO')
         for m = 1:numel(firsttTick)
             [ln1,flusso_tTick_start]=min(abs(tTick_flusso-firsttTick(m)));
             [ln1,flusso_tTick_end]=min(abs(tTick_flusso-lasttTick(m)));
             plot (tTick_flusso (flusso_tTick_start:flusso_tTick_end), Flusso (flusso_tTick_start:flusso_tTick_end),'r' );
             hold on 
         end
         legend('原信号','暂停')
         if ang==2
            for m = 1:numel(firsttTick1)
                 [ln1,flusso_tTick_start1]=min(abs(tTick_flusso-firsttTick(m)));
                 [ln1,flusso_tTick_end1]=min(abs(tTick_flusso-lasttTick(m)));
                 plot (tTick_flusso (flusso_tTick_start1:flusso_tTick_end1), Flusso (flusso_tTick_start1:flusso_tTick_end1),'g' );
                 hold on 
            end
            legend('原信号','>10s暂停','<10s暂停')
         end

        subplot(412)
        plot(tTick_torace,TORACE);
        hold on
        title('TORACE')
          for m = 1:numel(firsttTick)
             [lh1,T_effort_tTick1]=min(abs(tTick_torace-firsttTick(m)));
             [lh2,T_effort_tTick2]=min(abs(tTick_torace-lasttTick(m)));
             plot(tTick_torace(T_effort_tTick1:T_effort_tTick2),TORACE (T_effort_tTick1:T_effort_tTick2),'r')
             hold on 
          end
          legend('原信号','暂停')
         if ang==2
            for m = 1:numel(firsttTick1)
                 [lh1,T_effort_tTick_1]=min(abs(tTick_torace-firsttTick1(m)));
                 [lh2,T_effort_tTick_2]=min(abs(tTick_torace-lasttTick1(m)));
                 plot(tTick_torace(T_effort_tTick_1:T_effort_tTick_2),TORACE (T_effort_tTick_1:T_effort_tTick_2),'g')
                 hold on 
            end
            legend('原信号','>10s暂停','<10s暂停')
         end


        subplot(413)
        plot(tTick_addome,ADDOME); 
        hold on
        title('ADDOME')
          for m = 1:numel(firsttTick)
             [lh1,A_effort_tTick1]=min(abs(tTick_addome-firsttTick(m)));
             [lh2,A_effort_tTick2]=min(abs(tTick_addome-lasttTick(m)));
             plot(tTick_addome(A_effort_tTick1:A_effort_tTick2),ADDOME (A_effort_tTick1:A_effort_tTick2),'r')
             hold on 
          end
          legend('原信号','暂停')
         if ang==2
            for m = 1:numel(firsttTick1)
                 [lh1,A_effort_tTick_1]=min(abs(tTick_addome-firsttTick1(m)));
                 [lh2,A_effort_tTick_2]=min(abs(tTick_addome-lasttTick1(m)));
                 plot(tTick_addome(A_effort_tTick_1:A_effort_tTick_2),ADDOME (A_effort_tTick_1:A_effort_tTick_2),'g')
                 hold on 
            end
            legend('原信号','>10s暂停','<10s暂停')
         end


        subplot(414)
        plot(tTick_sao2,SaO2); 
        hold on
        title('SaO2')
          for m = 1:numel(firsttTick)
             [lh1,sao2tTick1]=min(abs(tTick_sao2-firsttTick(m)));
             [lh2,sao2tTick2]=min(abs(tTick_sao2-lasttTick(m)));
             plot(tTick_sao2(sao2tTick1:sao2tTick2),SaO2 (sao2tTick1:sao2tTick2),'r')
             hold on 
          end
          legend('原信号','暂停')
         if ang==2
             for m = 1:numel(firsttTick1)
                 [lh1,sao2tTick_1]=min(abs(tTick_sao2-firsttTick1(m)));
                 [lh2,sao2tTick_2]=min(abs(tTick_sao2-lasttTick1(m)));
                 plot(tTick_sao2(sao2tTick_1:sao2tTick_2),SaO2 (sao2tTick_1:sao2tTick_2),'g')
                 hold on 
             end
             legend('原信号','>10s暂停','<10s暂停')
         end

        ax(1)=subplot(4,1,1);
        ax(2)=subplot(4,1,2);
        ax(3)=subplot(4,1,3);
        ax(4)=subplot(4,1,4);
        linkaxes(ax,'x');
    end
    % suptitle('Apnea detect on flusso')
end
end

