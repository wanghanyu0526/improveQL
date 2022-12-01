% Q-LEARNING FOR PATH PLANNING
% The source of this code is Nikhil Nagraj Rao
% PID: n3621940
clc
clear all;
close all;

experimentnumber = 30;

experimentTime = zeros(experimentnumber,1);%ʱ������
stepNumber = zeros(experimentnumber,1);%��������
angleNumber = zeros(experimentnumber,1);%ת�ǽǶ�����

for k = 1:experimentnumber

    %t1=clock;
    arena = importArena('arena20x20irregular8.txt', 22, 22);
    alpha = 0.2;
    gamma = 0.8;
    nrEpisodes = 500;%��������
    stepsPerEpsd = 500;%����
    learnPolicy = 'greedy';
    epsilonProbability = 90;  %epsilon greedy����*100
    learn = 1;
    
    goalState = sub2ind(size(arena.arena_m), arena.des(1), arena.des(2));
    R = generateRewards(arena);
    
    %WOA��ʼQ-learning
    Q = PWOAlearnQ(arena, R, alpha, gamma, stepsPerEpsd);
    csvwrite('Q.txt',Q);%����Q�����Q.txt�ĵ���ʽ
    %     figure();
    %     image(Q,'CDataMapping','scaled');colorbar;
    
    t1=clock;
    
    if learn == 1
        Q = learnQMatrix(arena, R, Q, alpha, gamma, nrEpisodes, stepsPerEpsd, learnPolicy, epsilonProbability);
        save('qMatrix.mat', 'Q');
    else
        load('qMatrix.mat');
    end
    
    currState = sub2ind(size(arena.arena_m), arena.src(1), arena.src(2));
    visualizeArena(arena.arena_m);
    beforeState = currState;
    
    while(currState ~= goalState)
        nextState = find(Q(currState, :) == max(Q(currState, :)));
        if size(nextState, 2)~=1
            nextState = nextState(unidrnd(size(nextState, 2)));
        end
        if nextState ~= goalState
            [nxtR, nxtC] = ind2sub(size(arena.arena_m), nextState);
            rectangle('position', [nxtC, size(arena.arena_m, 1)-nxtR + 1, 1, 1], 'FaceColor', 'g');
            stepNumber(k,1) = stepNumber(k,1) + 1;%��������
        end
        
        %ת�Ǽ���
        xbeforeState = ceil(beforeState / size(arena.arena_m,1) );%beforeState������
        xcurrState = ceil(currState / size(arena.arena_m,1) );%currState������
        xnextState = ceil(nextState / size(arena.arena_m,1) );%goalState������
        ybeforeState = rem(beforeState,size(arena.arena_m,1) );%beforeState������
        ycurrState = rem(currState,size(arena.arena_m,1) );%currState������
        ynextState = rem(nextState,size(arena.arena_m,1) );%goalState������
        %         a2 = (xbeforeState-xcurrState)*(xbeforeState-xcurrState)+(ybeforeState-ycurrState)*(ybeforeState-ycurrState);
        %         b2 = (xnextState-xcurrState)*(xnextState-xcurrState)+(ynextState-ycurrState)*(ynextState-ycurrState);
        %         c2 = (xbeforeState-xnextState)*(xbeforeState-xnextState)+(ybeforeState-ynextState)*(ybeforeState-ynextState);
        %         a = sqrt(a2);
        %         b = sqrt(b2);
        %         c = sqrt(c2);
        %         realangle = -(acos((a2+b2-c2)/(2*a*b))*180/pi-180);%��ʵ������180
        %
        %         angleNumber(k,1) = angleNumber(k,1) + realangle;
        if (xbeforeState ~= xcurrState) && (xcurrState == xnextState)
            angleNumber(k,1) = angleNumber(k,1)+90;
        elseif (ybeforeState ~= ycurrState) && (ycurrState == ynextState)
            angleNumber(k,1) = angleNumber(k,1)+90;
        end
        beforeState = currState;
        currState = nextState;
        %currState = stochasticWorld(arena, currState, nextState, epsilonProbability);%·���滮ʱѡ��epsilon̰��̽������
        
    end
    
    t2=clock;
    experimentTime(k,1)=etime(t2,t1);
    %delete('qMatrix.mat')%ɾ��mat�ļ�
end

timemean = mean(experimentTime);fprintf('����ʱ��ƽ��ֵ=%f',timemean);%��N��1�е�line�������ƽ��ֵ����
timesd = std(experimentTime);fprintf('����ʱ���׼��=%f\n',timesd);%��׼�����

stepmean = mean(stepNumber);fprintf('·������ƽ��ֵ=%f',stepmean);%����ƽ��ֵ
stepsd = std(stepNumber);fprintf('·��������׼��=%f\n',stepsd);%������׼��

anglemean = mean(angleNumber);fprintf('·��ת��ƽ��ֵ=%f',anglemean);%����ƽ��ֵ
anglesd = std(angleNumber);fprintf('·��ת�Ǳ�׼��=%f\n',anglesd);%������׼��
