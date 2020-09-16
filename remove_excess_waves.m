function [diff_TORACE_MaxX,mean_phase,normal_TORACE_MaxX,normal_TORACE_MaxY] =remove_excess_waves(TORACE_MaxX,TORACE_MaxY,seg_period,thre_T)
% �ú�����Ҫ��ɾ��������ֵ��ľֲ����ֵ
% TORACE_MaxX��ԭʼ���ֵ�ķ�ֵ�㣨׼ȷʱ�䣩
% TORACE_MaxY��ԭʼ���ֵ�ķ�ֵ�㣨��ֵ�߶ȣ�
% seg_period�����ڻ�������
% thre_T���ж���ֵ��Ϊ���ƽ�����ڵı���
len_TORACE_MaxX=numel(TORACE_MaxX);
normal_TORACE_MaxX=[];
normal_TORACE_MaxY=[];
%%�޳���������ʱ������
diff_TORACE_MaxX=diff(TORACE_MaxX);
aver_T=0;
flag=1;
aver_phase=zeros(1,len_TORACE_MaxX);
for idx=1:len_TORACE_MaxX-1
    if idx<len_TORACE_MaxX-seg_period+1
        total_T=zeros(1,seg_period);
        for idxx=1:seg_period
            total_T(idxx)=diff_TORACE_MaxX(idx+idxx-1);
        end
        sort_T=sort(total_T);
        if sort_T(seg_period)>2*sort_T(seg_period-1)
            aver_T=aver_T;
        else
            aver_T=mean(total_T);
        end
        aver_phase(idx)=aver_T;
        if flag
            if  diff_TORACE_MaxX(idx)>aver_T*thre_T
                normal_TORACE_MaxX=[normal_TORACE_MaxX TORACE_MaxX(idx)];
                normal_TORACE_MaxY=[normal_TORACE_MaxY TORACE_MaxY(idx)];
                flag=1;
            else
                if TORACE_MaxY(idx)>TORACE_MaxY(idx+1)
                    normal_TORACE_MaxX=[normal_TORACE_MaxX TORACE_MaxX(idx)];
                    normal_TORACE_MaxY=[normal_TORACE_MaxY TORACE_MaxY(idx)];
                    flag=0;
                else
                    flag=1;
                end
            end
        else
            if  diff_TORACE_MaxX(idx)>aver_T*thre_T
                flag=1;
            end
        end
    else
        if flag
            if  diff_TORACE_MaxX(idx)>aver_T*thre_T
                normal_TORACE_MaxX=[normal_TORACE_MaxX TORACE_MaxX(idx)];
                normal_TORACE_MaxY=[normal_TORACE_MaxY TORACE_MaxY(idx)];
                flag=1;
            else
                if TORACE_MaxY(idx)>TORACE_MaxY(idx+1)
                    normal_TORACE_MaxX=[normal_TORACE_MaxX TORACE_MaxX(idx)];
                    normal_TORACE_MaxY=[normal_TORACE_MaxY TORACE_MaxY(idx)];
                    flag=0;
                else
                    flag=1;
                end
            end
        end
    end
end
aver_phase(aver_phase==0)=[];
mean_phase=max(aver_phase);
end



