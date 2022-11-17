function Q = learnQMatrix(arena, R, Q, alpha, gamma, nrEpisodes, stepsPerEpsd, learnPolicy, epsilonProbability)

[arSizeR, arSizeC] = size(arena.arena_m);
goalState = sub2ind([arSizeR arSizeC], arena.des(1), arena.des(2));
%%%%%%%%%%%%%%%%%%%%%%%����WOA%%%%%%%%%%%%%%%%%%%%%%%
%Q = zeros(arSizeR*arSizeC);
%Q = WOAlearnQ(arena, R, alpha, gamma, stepsPerEpsd);

epsilon = epsilonProbability;

for episode = 1:nrEpisodes
    currState = randi(arSizeR*arSizeC);
    
    %     Make sure init state does not land on a
    %     corner obstacle which has no plaussible next states.
    while(arena.arena_m(currState) == 1)
        currState = randi(arSizeR*arSizeC);
    end
    nextState = 0;
    stepCnt = 0;
    while((nextState ~= goalState) && (stepCnt < stepsPerEpsd))
        stepCnt = stepCnt + 1;
        psblNxtStates = find(R(currState, :) >= 0);
        nextState = psblNxtStates(randi(size(psblNxtStates, 2)));
        if (strcmp(learnPolicy, 'greedy'))
            %             randepsilon = rand();
            %             if (epsilon > randepsilon)
            qAdd = max(Q(nextState, :));
            %             else
            %                 randnextState = randi([1,4]);
            %                 qAdd = Q(randnextState,currState);
            %             end
        end
        Q(currState, nextState) = (1-alpha)*Q(currState , nextState) + alpha*(R(currState, nextState) + gamma*qAdd);
        % Stochastic World
        %%%%%%%%%%%%%%%%%%epsilonProbability��̬�仯%%%%%%%%%%%%%%%%%%
        %���Զ�̬�仯
        %epsilon = epsilonProbability + ((stepCnt * (100-epsilonProbability)) / stepsPerEpsd);
        %�����Զ�̬�仯
        epsilon = epsilonProbability + (100-epsilonProbability)/(1+exp(5-(1/stepsPerEpsd)*10*stepCnt));
        currState = stochasticWorld(arena, currState, nextState, goalState, epsilon);
    end
end