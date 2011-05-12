function varargout = databaseFuncCell(t, DB, module, STATS, varargin)
% function to creat and maintain the database. 
% INPUT:
% t: Frame Number. 
% DB: Database varable. 
% module: module for program to work at, it could be: init, add,
% updateConsistent and updateUnConsistent
% STATS: Contains all the region props Infomation to be stored.

% Ref to: databaseFunc for ARC project
% Binlong Li        11 May 2011

switch module
%     case 'init'
%         % initial stands for the Database initialation according to the
%         % starting frame.
%         % Therefore, the detRes and STATS could stand for multiple regions.
%         % Adding another field IMG for DB, therefore, need another input
%         % for img as the working frame orig image        
%         nRegions = length(STATS);
%         DB = cell(nRegions, 1);
%         for i = 1 : nRegions
% %             tdetRes = detRes(i);
% %             tDB.timeIDX = t;
% %             tDB.type = detRes(i).type;
% %             tDB.BoundingBox = STATS(i).BoundingBox;            
% %             tDB.Centroid = STATS(i).Centroid;
% %             tDB.Area = STATS(i).Area;
%             tDB = extract_info(t,STATS(i), i);
%             DB{i} = tDB;
%         end
%         varargout{1} = DB;
    case 'add'
        % Adding new entries into the database, basically, only one entry
        % one time. Therefore, should be no loop included in this module.
        % Adding another field IMG for DB, therefore, need another input
        % for img as the working frame orig image 
        ID = varargin{1};
        tDB = extract_info(t,STATS, ID);
        DB = cat(1, DB, {tDB});
        % Validation part
        if length(DB) ~= ID
            error('Adding Entry should be equals to the ID number');
        end
        varargout{1} = DB;
    case 'cleanUpBeginning'
        nDB = length(DB);
        for i = 1 : nDB
            tDB = DB{i};
            % if duplication shows up in timeIDX, 
            % or, all tDB.timeIDX is less than 7 and number of tDB.timeIDX
            % is less than 3.
            % this should be beginning mass.
            if (length(tDB.timeIDX) > length(unique(tDB.timeIDX))) ...
                    || (all(tDB.timeIDX < 7) && length(tDB.timeIDX < 3))
                DB = databaseFuncCell(t, DB, 'del', STATS, i);
            end
        end
        varargout{1} = DB;
    case 'del'
        i = varargin{1};
        tDB = DB{i};
        tDB.timeIDX = -inf;
        tDB.BoundingBOx = [];
        tDB.Centroid = [-inf -inf];
        tDB.Area = [-inf];
        tDB.color = [];
        DB{i} = tDB;
        varargout{1} = DB;
        
    case 'update'
        % update the Database, if the entry has been tracking consistently.
        % (Meaning, no interruptions, between the tracking entries.
        % Adding another field IMG for DB, therefore, need another input
        % for img as the working frame orig image 
        % Example: DB = databaseFunc(t, DB, 'updateConsistent', ...
        % tdetRes(NewBlobIDX(i)), STATS(NewBlobIDX(i)), img);
        ID = varargin{1};
        tDB = DB{ID};
        tDB.timeIDX = cat(1, tDB.timeIDX, t);        
        tDB.BoundingBox = cat(1, tDB.BoundingBox, STATS.BoundingBox);
        tDB.Centroid = cat(1, tDB.Centroid, STATS.Centroid);
        tDB.Area = cat(1, tDB.Area, STATS.Area);     
        DB{ID} = tDB;
        varargout{1} = DB;
%     case 'updateUnConsistent'
%         % Comparing to updatConsistent, this function is designed for
%         % regions appears un-consistently, which means, the regions have
%         % been found out by databaseFunc search module.
%         % Therefore, we need to adding the gap frames according to timeIDX,
%         % by using the latest BoundingBox, Centroid and Area information.
%         img = varargin{1};
%         tDB = DB{ID};
%         if tDB.timeIDX(end) ~= t
%             for tt = tDB.timeIDX(end) : t
%                 DB = databaseFuncCell(tt, DB, 'updateConsistent', STATS, tDB.ID);
%             end
%         end
%         varargout{1} = DB;
    case 'search'
        % Since output of search is not DB anymore. therefore, need to
        % change the output argument into varargout from DB.
        % Principle for comparing:
        % 1. Comparing current entry with Object's latest appearance.
        % 2. Comparing moving distance
        % 3. Comparing Image Distance. (That's why we need the video
        % handle), since the mp4 is variy frame rate, read(vobj, frameNum)
        % can mess up the whole system. Therefore, need to store the Latest
        % Image of each object...
        % 4. If find mulitple matches. Select by using weight with distance in
        % item 2 and 3. (For future Development)
        % INPUT:
        % detRes:   query entry detection template.
        % STATS:    query entry region props.
        % img:      Current Image frame
        % EXAMPLE 1:detRes = databaseFunc(t, DB, 'search', detRes, STATS, vobj);
        % EXAMPLE 2:tdetRes(NewBlobIDX(i)) = databaseFunc(t, DB, 'search',
        % tdetRes(NewBlobIDX(i)), STATS(NewBloxIDX(i)), vobj);
        
%         nobj = length(DB);
        % Extract query information, only comparing on centroids
        
        Centroid = STATS.Centroid;
        % Define thresholds: movTh is with in the min of BoundingBox(3, 4);
        BoundingBox = STATS.BoundingBox; 
        movTh = 2 * max(BoundingBox(3:4)) ; 
        
        % Only Search for the regions from frame before.
        instancesLastAppearance = structField2Vector(DB, 'timeIDX', 'Matrix', 'cellDatabase');
        ind = find(instancesLastAppearance == t - 1);
        
        showBeforeDB = DB(ind);
        
        if ~isempty(showBeforeDB)
            centroidsBefore = structField2Vector(showBeforeDB, 'Centroid', 'Matrix', 'cellDatabase');
            ID = findingNearestCentroid(Centroid, centroidsBefore, movTh);
            
            if ID ~= 0
                % Get back the ID into the original DB index.
                ID = ind(ID);
            end
        else
            ID = 0;
        end
        
%         for i = nobj : -1 : 1
%             % Comparing entry information
%             entry.img = DB{i}.IMG; entry.BoundingBox = ...
%                 DB{i}.BoundingBox(end, :); entry.Centroid = DB{i}.Centroid(end, :);
%             
%             [movDis imgDis] = regionComparing(query, entry);  
%             
%             display(['movDis: ' num2str(movDis) ' imgDis: ' num2str(imgDis)]);
%             if movDis <= movTh && imgDis <= imgTh
%                 % Find the match, update the detRes, then jump out the loop
%                 detRes.type = DB{i}.TYPE;
%                 detRes.ID = i;
%                 break;
%             end
%         end
        varargout{1} = ID;
end

function tDB = extract_info(t,STATS, ID)
% sub supporting function for extracting informations from informate
% contrainers.
% INPUT:
% t: Working Frame Number
% detRes:   Detection Result Information Contrainer.
% STATS:    region props Result Information Contrainer.
% img:      original image to store into field IMG
tDB.timeIDX = t;
tDB.BoundingBox = STATS.BoundingBox;
tDB.Centroid = STATS.Centroid;
tDB.Area = STATS.Area;
% Assign a unique color for each object.
color = varycolor(10000);
tDB.color = color(ID, :);

function ID = findingNearestCentroid(Centroid, centroidsBefore, movTh)
nBefore = size(centroidsBefore, 1);
% Calculating the distance in x and y
Centroid = repmat(Centroid, nBefore, 1);
dist2D = centroidsBefore - Centroid;

% Calculating the Eculidean Distance
dist = zeros(nBefore, 1);
for i = 1 : nBefore
    dist(i) = norm(dist2D(i, :));
end
% Find the index of moving distance less or equal to the movThreshold. 
% Only keep them to comparing for the minimial one.
ind = find(dist <= movTh);
if ~isempty(ind)
    dist = dist(ind);
    % Find the minimal one w.r.t the ones moving less than the movTh.
    [~, ID] = min(dist);
    % Turn back to the ID of absolute order in DB.
    ID = ind(ID);
else
    ID = 0;
end




function [movDis imgDis] = regionComparing(query, entry)
% Moving Distance
movDis = norm(query.Centroid(1 : 2) - entry.Centroid(1 : 2));
img_query = query.img; img_entry = entry.img;

% Image Distance
% 1. Compairing two BoundingBox, using the bigger BoundingBox.
% [~, query.BoundingBox] = cropImg(query.BoundingBox, img_query);
% [~, entry.BoundingBox] = cropImg(entry.BoundingBox, img_entry);

% if query.BoundingBox(5) > entry.BoundingBox(5), entry.BoundingBox(5) = query.BoundingBox(5);
% else     query.BoundingBox(5) = entry.BoundingBox(5); end
% if query.BoundingBox(4) > entry.BoundingBox(4), entry.BoundingBox(4) = query.BoundingBox(4);
% else     query.BoundingBox(4) = entry.BoundingBox(4); end
[query entry] = adjustBoundingBox(query, entry, img_query);

crop_query = cropImg(query.BoundingBox, img_query, 'onlyCrop');
crop_entry = cropImg(entry.BoundingBox, img_entry, 'onlyCrop');
imgDis = norm(double(rgb2gray(crop_query - crop_entry)));

function [query, entry] = adjustBoundingBox(query, entry, img)
% Supporting Function for regionComparing
% 1. Output the region as large as possible
% 2. Index is validate.

query.BoundingBox = floor(query.BoundingBox);
entry.BoundingBox = floor(entry.BoundingBox);
% As large as possible.
if query.BoundingBox(5) > entry.BoundingBox(5), entry.BoundingBox(5) = query.BoundingBox(5);
else     query.BoundingBox(5) = entry.BoundingBox(5); end
if query.BoundingBox(4) > entry.BoundingBox(4), entry.BoundingBox(4) = query.BoundingBox(4);
else     query.BoundingBox(4) = entry.BoundingBox(4); end
% Access the BoundingBox which can fit into the constrains.
[~, BoundingBox_q] = cropImg(query.BoundingBox, img);
[~, BoundingBox_e] = cropImg(entry.BoundingBox, img);
% Put back the BoundingBox Info
query.BoundingBox(1:2) = BoundingBox_q(1:2);
entry.BoundingBox(1:2) = BoundingBox_e(1:2);
query.BoundingBox(4:5) = BoundingBox_q(3 : 4);
entry.BoundingBox(4:5) = BoundingBox_e(3:4);
% Make the BoudningBox area as small as possible according to the image
% size contrains.
if query.BoundingBox(5) < entry.BoundingBox(5), entry.BoundingBox(5) = query.BoundingBox(5);
else     query.BoundingBox(5) = entry.BoundingBox(5); end
if query.BoundingBox(4) < entry.BoundingBox(4), entry.BoundingBox(4) = query.BoundingBox(4);
else     query.BoundingBox(4) = entry.BoundingBox(4); end

function TYPE = renewTYPE(type)
% Supporting function to renew the type defination of one trajectory. 
% Voting for the type of the trajectory, according to the detection results
% every n frames.
% Ref: detection_everyFrames.m
% INPUT: 
% type:     type information stored in DB.type field SIZE: n x 1
% OUTPUT:
% TYPE:     The final decision of the trajectory.  SIZE: 1 x 1
types = unique(type); 
% Don't count the detection failures... (0s)
if types(1) == 0 && length(types) > 1, types = types(2:end); end
ntype = length(types);
type_ins = zeros(ntype, 1);
for i = 1 : ntype
    type_ins(i) = length(find(type == types(i)));
end
[~, ind] = max(type_ins);
TYPE = types(ind);

