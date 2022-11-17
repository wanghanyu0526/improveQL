function Q = PWOAlearnQ(arena, R, alpha, gamma, stepsPerEpsd)
[arSizeR, arSizeC] = size(arena.arena_m);
goalState = sub2ind([arSizeR arSizeC], arena.des(1), arena.des(2));
Q = zeros(arSizeR*arSizeC);
%%%%%%%%%%%%%%%%%%%%%%%加入WOA%%%%%%%%%%%%%%%%%%%%%%%
SearchAgents_no = 30;%鲸鱼数量
Max_iter = 500;%迭代次数
lb = 1;%下限1
ub = arSizeR*arSizeC;%上限484
%dim = 1;%变量数量在QLearning+WOA中为1维
Leader_pos = 0;%zeros(1,dim);
Leader_score = -inf;%change this to -inf for maximization problems
Positions = zeros(SearchAgents_no,1);
%初始化种群位置
for i=1:size(Positions,1)
    Positions(i) = unidrnd(arSizeR*arSizeC);%arSizeR*arSizeC=484
    while arena.arena_m(Positions(i))~=0
        Positions(i) = unidrnd(arSizeR*arSizeC);
    end
end
t=0;
while t<Max_iter
    numnum=(size(Positions,1))/2;
    %计算每个初始鲸鱼的适应度并找到leader
    for i=1:numnum%Positions的行数的二分之一
        i2=i+numnum;
        
        %判断一对鲸鱼是否在边界内
        Positions(i)=floor(Positions(i));
        if Positions(i)<lb
            Positions(i)=lb;
        end
        if Positions(i)>ub
            Positions(i)=ub;
        end
        Positions(i2)=floor(Positions(i2));
        if Positions(i2)<lb
            Positions(i2)=lb;
        end
        if Positions(i2)>ub
            Positions(i2)=ub;
        end
        %计算每个鲸鱼的适应度
        currStateWOA1 = Positions(i);
        nextStateWOA1 = 0;
        currStateWOA2 = Positions(i2);
        nextStateWOA2 = 0;
        stepCnt = 0;
        while(nextStateWOA1 ~= goalState && stepCnt < stepsPerEpsd)
            stepCnt = stepCnt + 1;
            psblNxtStatesWOA1 = find(R(currStateWOA1,:) >= 0);
            psblNxtStatesWOA2 = find(R(currStateWOA2,:) >= 0);
            if size(psblNxtStatesWOA1, 2) ~= 0
                nextStateWOA1 = psblNxtStatesWOA1(randi(size(psblNxtStatesWOA1, 2)));
                qAddWOA1 = max(Q(nextStateWOA1, :));
                Q(currStateWOA1,nextStateWOA1) = (1-alpha)*Q(currStateWOA1,nextStateWOA1) + alpha*(R(currStateWOA1, nextStateWOA1) + gamma*qAddWOA1);
                fitness1= Q(currStateWOA1,nextStateWOA1) ;
            else
                fitness1= 0;
            end
            if size(psblNxtStatesWOA2, 2) ~= 0
                nextStateWOA2 = psblNxtStatesWOA2(randi(size(psblNxtStatesWOA2, 2)));
                qAddWOA2 = max(Q(nextStateWOA2, :));
                Q(currStateWOA2,nextStateWOA2) = (1-alpha)*Q(currStateWOA2,nextStateWOA2) + alpha*(R(currStateWOA2, nextStateWOA2) + gamma*qAddWOA2);
                fitness2= Q(currStateWOA2,nextStateWOA2) ;
            else
                fitness2= 0;
            end
        end
       % Update the leader
        if fitness1 < fitness2
            Positions(i2,:)=Positions(i,:);
            if fitness1 < Leader_score % Change this to > for maximization problem
                Leader_score=fitness1; % Update alpha
                Leader_pos=Positions(i,:);
            end
        elseif fitness2 <= fitness1
            Positions(i,:)=Positions(i2,:);
            if fitness2 < Leader_score % Change this to > for maximization problem
                Leader_score=fitness2; % Update alpha
                Leader_pos=Positions(i2,:);
            end
        end
        
    end
    a=2-t*((2)/Max_iter); % a decreases linearly fron 2 to 0 in Eq. (2.3)
    % a2 linearly dicreases from -1 to -2 to calculate t in Eq. (3.12)
    a2=-1+t*((-1)/Max_iter);
    % Update the Position of search agents
    for i=1:size(Positions,1)
        r1=rand(); % r1 is a random number in [0,1]
        r2=rand(); % r2 is a random number in [0,1]
        A=2*a*r1-a;  % Eq. (2.3) in the paper
        C=2*r2;      % Eq. (2.4) in the paper
        b=1;               %  parameters in Eq. (2.5)
        l=(a2-1)*rand+1;   %  parameters in Eq. (2.5)
        p = rand();        % p in Eq. (2.6)
        for j=1:size(Positions,2)
            if p<0.5
                if abs(A)>=1
                    rand_leader_index = floor(SearchAgents_no*rand()+1);%取整
                    X_rand = Positions(rand_leader_index, :);
                    D_X_rand=abs(C*X_rand(j)-Positions(i,j)); % Eq. (2.7)
                    Positions(i,j)=X_rand(j)-A*D_X_rand;      % Eq. (2.8)
                elseif abs(A)<1
                    D_Leader=abs(C*Leader_pos-Positions(i,j)); % Eq. (2.1)
                    Positions(i,j)=Leader_pos-A*D_Leader;      % Eq. (2.2)
                end
            elseif p>=0.5
                distance2Leader=abs(Leader_pos-Positions(i,j));
                Positions(i,j)=distance2Leader*exp(b.*l).*cos(l.*2*pi)+Leader_pos;% Eq. (2.5)
            end
        end
    end
    t=t+1;
end