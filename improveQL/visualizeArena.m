function visualizeArena(matrix)
% figure()
% axis off
% %  xlabel('Q-learning for path planning');
% % %xlabel('Black: Obstacle, Red: Source, Blue: Destination, White: Space, Green: Path');
% hold on

for i = 1:size(matrix, 1)
    for j = 1:size(matrix, 2)
        switch matrix(i, j)
            case 0
                rectangle('position', [j, size(matrix, 1)-i+1, 1, 1], 'FaceColor', 'w');
            case 1
                rectangle('position', [j, size(matrix, 1)-i+1, 1, 1], 'FaceColor', 'k');
            case 2
                rectangle('position', [j, size(matrix, 1)-i+1, 1, 1], 'FaceColor', 'r');
            otherwise
                rectangle('position', [j, size(matrix, 1)-i+1, 1, 1], 'FaceColor', 'b');
        end
    end
    
end
end