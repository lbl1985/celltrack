function updateTmpTrajArr(obj, pattern, i)
%UPDATETMPTRAJARR Summary of this function goes here
%   Detailed explanation goes here
tmpId = length(obj.tmpTrajArrCurrFrame) + 1;
switch pattern
    case 'traj'
        tmpVar = obj.trajArrCurrFrame(i);
    case 'blob'
        tmpVar = obj.trajArrInVideo(i);
end

if tmpId == 1
    obj.tmpTrajArrCurrFrame = tmpVar;
else
    obj.tmpTrajArrCurrFrame(tmpId + 1) = tmpVar;
end

end

