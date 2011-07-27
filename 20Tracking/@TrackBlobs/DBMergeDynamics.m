function DBMergeDynamics(obj)
    % length of db is dynamically changed according to merge operation
    dbIndex = 1;    
    while dbIndex < length(obj.DB) - 1        
        nEntry = length(obj.DB{dbIndex});        
        if nEntry < 2   
%             obj.DBSortByFrame;
            findDynamcisIdenticalInSameFrame(obj, dbIndex);                        
        end
        dbIndex = dbIndex + 1;
    end
end

function findDynamcisIdenticalInSameFrame(obj, dbIndex)
    queryEntry = obj.DB{dbIndex};
    testIndex = dbIndex + 1;
%     timeNow = queryEntry.timeIDX;
%     testIndex = unique(structField2Vector(obj.DBbyFrames{timeNow}, 'ID'));
    while testIndex < length(obj.DB) && ...
            queryEntry.timeIDX(end) >= obj.DB{testIndex}.timeIDX(1)        
        testEntry = obj.DB{testIndex};
        isBegin = checkIsBegin(queryEntry, testEntry);
        if isBegin
            kHankel = DynamicsHankelConstruction(queryEntry, testEntry);
            [~, S, ~] = svd(kHankel);
            isDynamicsQualify = checkDynamics(diag(S));

            if isDynamicsQualify
                obj.mergeTrajectory(dbIndex, testIndex);
%                 obj.DBSrotByFrame;
            else
                testIndex = testIndex + 1;
            end
        else
            testIndex = testIndex + 1;
        end
    end
end

function isBegin = checkIsBegin(queryEntry, testEntry)
    isBegin = queryEntry.timeIDX(end) == testEntry.timeIDX(1);
end

function kHankel = DynamicsHankelConstruction(queryEntry, testEntry)
    tmpCoordinateArray = [queryEntry.Centroid' testEntry.Centroid'];
    hankelWindowSize = calculateHankelWindowSize(tmpCoordinateArray);
    kHankel = hankelConstruction(tmpCoordinateArray, hankelWindowSize);
end

function hankelWindowSize = calculateHankelWindowSize(inputFeature)
    hankelWindowSize = ceil(size(inputFeature, 2) / 3);
end


function isDynamicsQualify = checkDynamics(S)
    isDynamicsQualify = 0;
    rankOrder = sum(S > mean(S) + std(S));
    if rankOrder == 1
        isDynamicsQualify = 1;
    end
end    