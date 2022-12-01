% Q-LEARNING FOR PATH PLANNING
% The source of this code is Nikhil Nagraj Rao
% PID: n3621940
clc
clear all;
close all;

experimentnumber = 30;

experimentTime = zeros(experimentnumber,1);%时间数组
stepNumber = zeros(experimentnumber,1);%步数数组
angleNumber = zeros(experimentnumber,1);%转角角度数组

for k = 1:experimentnumber

    %t1=clock;
    arena = importArena('arena20x20irregular8.txt', 22, 22);
    alpha = 0.2;
    gamma = 0.8;
    nrEpisodes = 500;%迭代次数
    stepsPerEpsd = 500;%步数
    learnPolicy = 'greedy';
    epsilonProbability = 90;  %epsilon greedy概率*100
    learn = 1;
    
    goalState = sub2ind(size(arena.arena_m), arena.des(1), arena.des(2));
    R = generateRewards(arena);
    
    %WOA初始Q-learning
    Q = PWOAlearnQ(arena, R, alpha, gamma, stepsPerEpsd);
    csvwrite('Q.txt',Q);%保存Q矩阵成Q.txt文档形式
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
            stepNumber(k,1) = stepNumber(k,1) + 1;%步数计算
        end
        
        %转角计算
        xbeforeState = ceil(beforeState / size(arena.arena_m,1) );%beforeState横坐标
        xcurrState = ceil(currState / size(arena.arena_m,1) );%currState横坐标
        xnextState = ceil(nextState / size(arena.arena_m,1) );%goalState横坐标
        ybeforeState = rem(beforeState,size(arena.arena_m,1) );%beforeState纵坐标
        ycurrState = rem(currState,size(arena.arena_m,1) );%currState纵坐标
        ynextState = rem(nextState,size(arena.arena_m,1) );%goalState纵坐标
        %         a2 = (xbeforeState-xcurrState)*(xbeforeState-xcurrState)+(ybeforeState-ycurrState)*(ybeforeState-ycurrState);
        %         b2 = (xnextState-xcurrState)*(xnextState-xcurrState)+(ynextState-ycurrState)*(ynextState-ycurrState);
        %         c2 = (xbeforeState-xnextState)*(xbeforeState-xnextState)+(ybeforeState-ynextState)*(ybeforeState-ynextState);
        %         a = sqrt(a2);
        %         b = sqrt(b2);
        %         c = sqrt(c2);
        %         realangle = -(acos((a2+b2-c2)/(2*a*b))*180/pi-180);%真实度数减180
        %
        %         angleNumber(k,1) = angleNumber(k,1) + realangle;
        if (xbeforeState ~= xcurrState) && (xcurrState == xnextState)
            angleNumber(k,1) = angleNumber(k,1)+90;
        elseif (ybeforeState ~= ycurrState) && (ycurrState == ynextState)
            angleNumber(k,1) = angleNumber(k,1)+90;
        end
        beforeState = currState;
        currState = nextState;
        %currState = stochasticWorld(arena, currState, nextState, epsilonProbability);%路径规划时选择epsilon贪婪探索策略
        
    end
    
    t2=clock;
    experimentTime(k,1)=etime(t2,t1);
    %delete('qMatrix.mat')%删除mat文件
end

timemean = mean(experimentTime);fprintf('运行时间平均值=%f',timemean);%对N行1列的line数组进行平均值计算
timesd = std(experimentTime);fprintf('运行时间标准差=%f\n',timesd);%标准差计算

stepmean = mean(stepNumber);fprintf('路径步数平均值=%f',stepmean);%步数平均值
stepsd = std(stepNumber);fprintf('路径步数标准差=%f\n',stepsd);%步数标准差

anglemean = mean(angleNumber);fprintf('路径转角平均值=%f',anglemean);%步数平均值
anglesd = std(angleNumber);fprintf('路径转角标准差=%f\n',anglesd);%步数标准差
