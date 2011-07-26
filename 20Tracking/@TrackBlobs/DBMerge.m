function DBMerge(obj)
    % length of db is dynamically changed according to merge operation
    dbIndex = 1;
    while dbIndex < length(obj.DB) - 1        
        nEntry = length(obj.DB{dbIndex});        
        if nEntry < 3            
            findNeighborTrajectory(obj, dbIndex);                        
        end
        dbIndex = dbIndex + 1;
    end
end

function findNeighborTrajectory(obj, dbIndex)
    dbEntry = obj.DB{dbIndex};
    beginTimeIDX = dbEntry.timeIDX(end);
    testIndex = dbIndex + 1;    
    while testIndex < length(obj.DB) && obj.DB{testIndex}.timeIDX(1) <= ...
            beginTimeIDX + obj.timeSearchScope && ...
            obj.DB{testIndex}.timeIDX(1) > beginTimeIDX
            
        
        isLocationQualify = checkLocation(obj, dbIndex, testIndex);
        if isLocationQualify
            mergeTrajectory(obj, dbIndex, testIndex);
        else
            testIndex = testIndex + 1;
        end
    end
end

function isLocationQualify = checkLocation(obj, dbIndex, testIndex)
    query = obj.DB{dbIndex};
    test  = obj.DB{testIndex};
    mov = norm(abs(query.Centroid(end, :) - test.Centroid(1, :)));
    isLocationQualify = 0;
    if mov < obj.searchRadius
        isLocationQualify = 1;
    end
end

function mergeTrajectory(obj, dbIndex, testIndex)
    query = obj.DB{dbIndex};
    test = obj.DB{testIndex};
    query.timeIDX = vertcat(query.timeIDX, test.timeIDX);
    query.BoundingBox = vertcat(query.BoundingBox, test.BoundingBox);
    query.Centroid = vertcat(query.Centroid, test.Centroid);
    query.Area = vertcat(query.Area, test.Area);
    obj.DB{dbIndex} = query;
    obj.DB{testIndex} = [];
    obj.DB = removeEmptyCell(obj.DB);
end




