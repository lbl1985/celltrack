function DBMergeDynamics(obj)
    % length of db is dynamically changed according to merge operation
    dbIndex = 1;
    while dbIndex < length(obj.DB) - 1        
        nEntry = length(obj.DB{dbIndex});        
        if nEntry < 3            
            findDynamcisIdenticalInSameFrame(obj, dbIndex);                        
        end
        dbIndex = dbIndex + 1;
    end
end

function findDynamcisIdenticalInSameFrame(obj, dbIndex)
    queryEntry = obj.DB{dbIndex};
    testIndex = dbIndex + 1;
    while queryEntry.timeIDX(end) >= obj.DB{testIndex}.timeIDX(1)
        testEntry = obj.DB{testIndex};
        isAtBegin = checkIsConsecutiveTrajectories(obj, queryEntry, testEntry);
        if isAtBegin == 1
            tmpCoordinateArray = [queryEntry.timeIDX' testEntry.timeIDX'];
            hankelWindowSize = calculateHankelWindowSize(tmpCoordinateArray);
            kHankel = hankelConstruction(tmpCoordinateArray, hankelWindowSize);
            [~, S, ~] = svd(kHankel);
            isDynamicsQualify = checkDynamics(S);
        end
        if isDynamicsQualify
            obj.mergeTrajectory(obj, dbIndex, testIndex);
        else
            testIndex = testIndex + 1;
        end
    end
end
