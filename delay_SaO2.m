function [ tTick_sao2, delay] = delay_SaO2(timewindow,Flusso,tTick_flusso,sampRate_flusso,SaO2,tTick_sao2,sampRate_sao2 )
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

%% segment pitch=? ms / shift=? ms
pitch=ceil(timewindow*sampRate_flusso);% the length of window
length_data=numel(Flusso);%the length of flusso
K_temp=ceil(length_data/pitch);
numbers=K_temp;

% save divided signal in seg_data & seg_time
seg_data=zeros(pitch,numbers);
seg_time=zeros(pitch,numbers);
for n=1:numbers
    if n~=numbers
        seg_data(:,n)=Flusso(1+(n-1)*pitch:pitch+(n-1)*pitch);
        seg_time(:,n)=tTick_flusso(1+(n-1)*pitch:pitch+(n-1)*pitch);
    else
        len_lastseg=numel(Flusso)-(1+(n-1)*pitch)+1;
        seg_data(1:len_lastseg,n)=Flusso(1+(n-1)*pitch:end);
        seg_time(1:len_lastseg,n)=tTick_flusso(1+(n-1)*pitch:end);
    end
end

%% envolope flusso signal
%initialize
 envelope_data=zeros(pitch,numbers);
%  figure,
for n=1:numbers
    x=seg_data(:,n);% �����ź�
    t=seg_time(:,n);% �����ź�ʱ��
    %ɾ������洢�ռ�
    idx=find(t==0);
    x(idx)=[];
    t(idx)=[];
    % Reference literature 
    % 'Automated Detection of Sleep Apnea and Hypopnea Events Based on Rob-
    % -ust Airflow Envelope Tracking in the Presence of Breathing Artifacts'
    % See discussions, stats, and author profiles for this publication at: 
    % https://www.researchgate.net/publication/262787198
    % author: Marcin Ciolek  Maciej Niedzwiecki Janusz Siebert
    % Quarterly: IEEE JOURNAL OF BIOMEDICAL AND HEALTH INFORMATICS, VOL. 19, NO. 2, MARCH 2015
    z=hilbert(x);% hilbert transform
    direct_x=z.^2;% hilbert transform �ź�ƽ��
    indiret_x=x.^2;% �ź�ƽ��
    add_x=indiret_x+direct_x;
    sqrt_x=sqrt(add_x);
    if n~=numbers
        envelope_data(:,n)=abs(sqrt_x);%��ð���
    else
        len=numel(sqrt_x);
        envelope_data(1:len,n)=abs(sqrt_x);
    end
% %     ��ͼ
%      plot(t,x,'r',t,abs(sqrt_x),'b')
%     hold on
end
% xlim([105400  106000]);
% 
% title('The result of Hilbert transform on airflow signal')
% legend('Raw signal','Envelope signal') 

%% hilbert & Median filter 
envlopedata=envelope_data(1:end);
envlopedata(find(envlopedata==0))=[];
SMfilter= medfilt1(envlopedata,121);% ��ֵ�˲� %�˲����� 121�� Ϊhilbert transform�Ĵ��ڵ�һ��
SaO2=[SaO2' zeros(1,numel(SMfilter)-numel(SaO2))];%��Ѫ����0 ��ʹ��Ѫ����SMfilter����һ��
[acor,lag]=xcorr(SMfilter,SaO2,'coeff');% �����
SaO2(find(SaO2==0))=[];
lagROI = lag(1:(length(lag)-1)/2+1);
acorROI = acor(1:(length(lag)-1)/2+1);
[maxacor,maxidx]=max(acorROI);
delay=lagROI(maxidx);

%% presentation 
% figure,
% plot(tTick_flusso,Flusso,'r',tTick_flusso,abs(SMfilter),'b')
% xlim([105400  106000]);
% title('The result of Median filter on enveloped airflow signal')
% legend('Raw signal','Median filtered signal') 

%% just hilbert
% SM= envlopedata;
% SaO2=[SaO2' zeros(1,numel(SM)-numel(SaO2))];
% [acor1,lag1]=xcorr(SM,SaO2,'coeff');
% lagROI1 = lag1(1:(length(lag1)-1)/2+1);
% acorROI1 = acor1(1:(length(lag1)-1)/2+1);
% SaO2(find(SaO2==0))=[];
% [maxacor1,maxidx1]=max(acorROI1);
% delay=lagROI1(maxidx1)

%% Contrast : just hilbert VS hilbert & Median filter 
% figure,
% plot(lagROI1,acorROI1,'r',lagROI,acorROI,'b');
% legend('Before Median filter','After Median filter');
% title('the cross-correlation of airflow and SpO2')
% xlabel('lag')
% ylabel('cross-correlation')
% ylim([-0.01 0.20])
% xlim([-6000 0])
% hold on
% plot(delay1,maxacor1,'k*',delay,maxacor,'k*');
% str=['Maximum value position:(',num2str(delay),' , ',num2str(maxacor),')\rightarrow'];
% str1=['Maximum value position:(',num2str(delay1),' , ',num2str(maxacor1),')\rightarrow'];
% text(delay-2000,maxacor+0.005,str,'Color','blue');
% text(delay1-2000,maxacor1+0.005,str1,'Color','red');

%% ʱ�Ӻ�
tTick_sao2=tTick_sao2+delay/sampRate_sao2;
% figure,
% subplot(211)
% plot(tTick,airf,'r')
% xlim([tTick_sao2(1)  tTick(numel(tTick)/2)])
% title('airflow')
% xlabel('Time(s)');ylabel('Amplitude(V)')
% line([105870 105870], [-0.1 0.25],'LineWidth',0.5,'Color','k','LineStyle','--');
% line([105910 105910], [-0.1 0.25],'LineWidth',0.5,'Color','k','LineStyle','--');
% subplot(212)
% plot(tTick_sao2,SaO2,'b')
% xlim([tTick_sao2(1)  tTick(numel(tTick)/2)])
% title('SpO2')
% xlabel('Time(s)');ylabel('Amplitude(%)')
% ylim([ 84 100])
% line([105870 105870], [84 100],'LineWidth',0.5,'Color','k','LineStyle','--');
% line([105910 105910], [84 100],'LineWidth',0.5,'Color','k','LineStyle','--');


end

