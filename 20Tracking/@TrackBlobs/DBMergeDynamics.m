function DBMergeDynamics(obj)
    sameFrameDynamicsMerge(obj);
    differentFrameDynamicsMerge(obj);
end

function sameFrameDynamicsMerge(obj)
    dbIndex = 1;    
    while dbIndex < length(obj.DB) - 1        
        nEntry = length(obj.DB{dbIndex}.timeIDX);        
        if nEntry < 2   
            obj.DBSortByFrame;
            dbIndex = findDynamcisIdenticalInSameFrame(obj, dbIndex);                        
        end
        dbIndex = dbIndex + 1;
    end
end

function differentFrameDynamicsMerge(obj)
    dbIndex = 1;
    while dbIndex < length(obj.DB) - 1
        findDynamicsIdenticalInDiffFrame(obj, dbIndex);
        dbIndex = dbIndex + 1;
    end
end
    
function findDynamicsIdenticalInDiffFrame(obj, dbIndex)
    queryEntry = obj.DB{dbIndex};
    testIndex = dbIndex + 1;
    while testIndex < length(obj.DB) - 1
        testEntry = obj.DB{testIndex};
        kHankel = DiffFrameDynamics([queryEntry.Centroid' testEntry.Centroid']);
        kHankel.mainCheckDynamics;
        if kHankel.isDynamicsQualify
            obj.mergeTrajectory(dbIndex, testIndex);
        else
            testIndex = testIndex + 1;
        end
    end
        
end



function dbIndex = findDynamcisIdenticalInSameFrame(obj, dbIndex)
    timeNow = obj.DB{dbIndex}.timeIDX;
    testIndex = getTestIndex(obj, dbIndex, timeNow);
    nTestIndex = length(testIndex);
    for i = 1 : nTestIndex
        isMerge = checkEachTestIndex(obj, dbIndex, testIndex(i));
        if isMerge, 
            [testIndex dbIndex] = updateTestIndex(testIndex, dbIndex, testIndex(i)); 
        end
    end
end

function testIndex = getTestIndex(obj, dbIndex, timeNow)
    testIndex = unique(structField2Vector(obj.DBbyFrame{timeNow}, 'ID'));
    ind = testIndex ~= dbIndex;
    testIndex = testIndex(ind);
end

function isDynamicsQualify = checkEachTestIndex(obj, dbIndex, testIndex)
    queryEntry = obj.DB{dbIndex};
    testEntry = obj.DB{testIndex};
    isBegin = checkIsBegin(queryEntry, testEntry);
    isDynamicsQualify = 0;
    if isBegin
        kHankel = SameFrameDynamics([queryEntry.Centroid' testEntry.Centroid']);
        kHankel.mainCheckDynamics;
        if kHankel.isDynamicsQualify
            obj.mergeTrajectory(dbIndex, testIndex);
        end
    end
end

function isBegin = checkIsBegin(queryEntry, testEntry)
    isBegin = queryEntry.timeIDX(end) == testEntry.timeIDX(1);
end  

function [testIndex dbIndex] = updateTestIndex(testIndex, dbIndex, mergeIndex)
    if mergeIndex < dbIndex
        dbIndex = dbIndex - 1;
    end
    testIndex = testIndex - 1;
end