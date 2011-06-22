nd = 4; 
method = 'MoG';
% nd = 1;
% method = 'MEAN';
% for id = 8
%     CellTrajectory(id, nd, method);
% end

for id = 8
    CellTrajectory_WindowCombine(id, nd, method);
end