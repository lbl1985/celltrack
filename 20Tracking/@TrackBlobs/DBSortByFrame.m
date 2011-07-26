function DBSortByFrame(obj )
%DATABASESORTBYFRAME Summary of this function goes here
%   Detailed explanation goes here
obj.DBbyFrame = cell(obj.fg.nFrame, 1);
nEntry = length(obj.DB);
for i = 1 : nEntry
    nInstances = length(obj.DB{i}.timeIDX);
    for j = 1 : nInstances
        tmpVar = DB2var(obj, i, j);
        obj.DBbyFrame{tmpVar.timeIDX} = cat(1, obj.DBbyFrame{tmpVar.timeIDX}, tmpVar);
    end
end

end

function tmpVar = DB2var(obj, EntryID, instanceID)
tmpVar.ID = EntryID;
tmpVar.timeIDX = obj.DB{EntryID}.timeIDX(instanceID, :);
tmpVar.BoundingBox = obj.DB{EntryID}.BoundingBox(instanceID, :);
tmpVar.Centroid = obj.DB{EntryID}.Centroid(instanceID, :);
tmpVar.Area = obj.DB{EntryID}.Area(instanceID, :);
tmpVar.color = obj.DB{EntryID}.color;
end

