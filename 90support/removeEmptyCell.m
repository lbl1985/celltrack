function outputCell = removeEmptyCell(inputCell)
nCell = length(inputCell);
sizCell = zeros(size(inputCell));
for i = 1 : nCell
    sizCell(i) = length(inputCell{i});
end
ind = sizCell ~= 0;
outputCell = inputCell(ind);