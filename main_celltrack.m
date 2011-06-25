% Working Log:
% main_celltrackin will be the general all-in-one console for the whole project. 
% Adding output argument: fg for CellTrajectory Function.
% Binlong Li    25 June 2011    07:51AM

% Parameter Setting Section
close all; 
% method = 'MEAN';
method = 'MoG';
isSliding = 'OFF';
% Recording 
debugRecord = 0;

switch isSliding
    case 'OFF'
        if strcmp(method, 'MoG')
            nd = 4;        
        else
            nd = 1;
        end
        for id = 8
            fg = CellTrajectory(id, nd, method, debugRecord);
        end
        
    case 'ON'
        if strcmp(method, 'MoG')
            nd = 4;        
        else
            nd = 1;
        end
        for id = 8
            CellTrajectory_WindowCombine(id, nd, method);
        end
end

% Post Processing, median filter and close-opening operations.
isVis = 1;  isSpec = 0;
pPro_celltrack(fg, isVis, isSpec);
