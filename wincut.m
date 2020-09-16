%seg_data���ָ�õ��źţ�seg_data(:1)Ϊ��һ�������ź�
% seg_tTick����Ӧ���ڵ�ʱ����Ϣ
% numbers���ָ��ܶ���
% signal���豻�ָ��ź�
% tTick���豻�ָ��źŵ�ʱ����Ϣ
% window_step�����ڳ��ȣ���λs
% window_move�����ڻ�����������λs
% sampRate���豻�ָ��źŵĲ�����

function [seg_data,seg_tTick,numbers] = wincut(signal,tTick,window_step,window_move,sampRate)
pitch=ceil(window_step*sampRate);%���ڳ���s
pitch_shift=ceil(window_move*sampRate);%���ڻ�������s
dispitch_shift=pitch-pitch_shift;%���ڴ����ص��Ĳ���
length_data=numel(signal);%�ź�1����
flag=1;
numbers=0;%��������
if dispitch_shift ~= 0 
    K_temp = ceil(length_data/dispitch_shift);%��������������
else
    flag=0;
    numbers = ceil(length_data/pitch_shift);%��������������
end

if flag~=0
    len_rest=length_data;%�ź�ʣ��δ�ָ�ĳ���
    for n=1:K_temp
        if length_data>pitch%�źų��ȴ��ڴ��ڳ���
            numbers=numbers+1;%������1
            len_rest=len_rest-dispitch_shift;%�ָ���ź�ʣ�೤��
            if len_rest<=pitch%ʣ�೤��С�ڴ��ڳ���
                %�����źų��Ȳ������ָ�����һ�γ��ȿ��ܱȴ��ڳ���С����һ������ô�жϵ�ǰ�ָ�Ķ�Ϊ���һ�Σ��ָ����
                numbers=numbers+1;
                break;%�ָ����������
            end
        else
            numbers=numbers+1;%�źų���С�ڵ��ڴ��ڳ��ȣ�ֻ��һ��
            break;
        end
    end
end

% ���ָ�õ��źű����ڱ�����
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