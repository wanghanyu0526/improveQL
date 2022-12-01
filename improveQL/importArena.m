function arena = importArena(filename, arenaWidth, arenaHeight)

arena.arenaWidth = arenaWidth;%结构体变量
arena.arenaHeight = arenaHeight;
fileID = fopen(filename,'r');
formatSpec = [repmat('%d', 1, arena.arenaWidth), '%[^\n\r]'];
dataArray = textscan(fileID, formatSpec, 'Delimiter', ' ', 'MultipleDelimsAsOne', true, 'WhiteSpace', '',  'ReturnOnError', false);
fclose(fileID);

arena.arena_m = [dataArray{1:end-1}];

[srcR, srcC] = find(arena.arena_m == 2);
arena.src = [srcR, srcC];
[desR, desC] = find(arena.arena_m == 3);
arena.des = [desR, desC];

end
