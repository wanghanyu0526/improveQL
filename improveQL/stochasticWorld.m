function currState = stochasticWorld(arena, currState, nextState, goalState, epsilon)

randn = randi(100);
eepsilon = epsilon;
xxcurrState = ceil(currState / size(arena.arena_m,1) );%currStateºá×ø±ê
xxgoalState = ceil(goalState / size(arena.arena_m,1) );%goalStateºá×ø±ê
yycurrState = rem(currState,size(arena.arena_m,1) );%currState×Ý×ø±ê
yygoalState = rem(goalState,size(arena.arena_m,1) );%goalState×Ý×ø±ê

if (randn <= eepsilon) || (arena.arena_m(currState) == 1)
    currState = nextState;
    % elseif(randn > 90)
    % Do Nothing
else
    if((xxcurrState <= xxgoalState) && (yycurrState < yygoalState))
        
        errChoice = randi(2);
        if (errChoice == 1 && arena.arena_m(currState - 1) ~= 1)
            currState = currState - 1; % go up
        elseif(errChoice == 2 && arena.arena_m(currState + size(arena.arena_m, 1)) ~= 1)
            currState = currState + size(arena.arena_m, 1); % go right
        end
        
    elseif((xxcurrState < xxgoalState) && (yycurrState >= yygoalState))
        
        errChoice = randi(2);
        if (errChoice == 1 && arena.arena_m(currState + 1) ~= 1)
            currState = currState + 1; % go down
        elseif(errChoice == 2 && arena.arena_m(currState + size(arena.arena_m, 1)) ~= 1)
            currState = currState + size(arena.arena_m, 1); % go right
        end
        
    elseif((xxcurrState > xxgoalState) && (yycurrState <= yygoalState))
        
        errChoice = randi(2);
        if (errChoice == 1 && arena.arena_m(currState + 1) ~= 1)
            currState = currState + 1; % go down
        elseif(errChoice == 2 && arena.arena_m(currState - size(arena.arena_m, 1)) ~= 1)
            currState = currState - size(arena.arena_m, 1); % go left
        end
        
    elseif((xxcurrState >= xxgoalState) && (yycurrState >= yygoalState))
        
        errChoice = randi(2);
        if (errChoice == 1 && arena.arena_m(currState - 1) ~= 1)
            currState = currState - 1; % go up
        elseif( errChoice == 2 && arena.arena_m(currState - size(arena.arena_m, 1)) ~= 1)
            currState = currState - size(arena.arena_m, 1); % go left
        end
    end
end