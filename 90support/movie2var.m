function mat = movie2var(filename, isGray, siz)
% isGray could be []. The program will reserve the original format
if ~ispc
    currPath = pwd;
end
if isequal(filename(end - 3 : end), '.avi')
    video = mmread(filename);
    n = length(video.frames);
    
    if isempty(isGray)
        % user dont' specifically require for gray or rgb. Then save it as the
        % original format
        sampleFrame = video.frames(1).cdata;
        if ndims(sampleFrame) > 3
            isGray = 0;
        else
            isGray = 1;
        end
    end
    
%     if siz ~= 1
        dimensions = size(sampleFrame);
        dimensions = dimensions(1:2);
        numrows = ceil(dimensions(1) * siz);
        numcols = ceil(dimensions(2) * siz);
%     end
    
    if ~isGray
        mat = uint8(zeros(numrows, numcols ,3, n));
        for i = 1 : n
            mat(:, :, :, i) = uint8(imresize(video.frames(i).cdata, [numrows numcols]));
        end
    else
        
        mat = uint8(zeros(numrows,numcols, n));
        for i = 1 : n
            mat(:, :, i) = uint8(imresize(rgb2gray(video.frames(i).cdata), [numrows numcols]));
        end
    end
else
    I = imread(filename, 1);
    info = imfinfo(filename);
    n = numel(info);
    
    if isempty(isGray)
        % user dont' specifically require for gray or rgb. Then save it as the
        % original format
        sampleFrame = I;
        if ndims(sampleFrame) > 3
            isGray = 0;
        else
            isGray = 1;
        end
    end
    
%     if siz ~= 1
        dimensions = size(sampleFrame);
        dimensions = dimensions(1:2);
        numrows = ceil(dimensions(1) * siz);
        numcols = ceil(dimensions(2) * siz);
%     end
    
    if ~isGray
        mat = uint16(zeros(numrows, numcols ,3, n));
        for i = 1 : n
            I = imread(filename, i);
            mat(:, :, :, i) = uint16(imresize(I, [numrows numcols]));
        end
    else
        
        mat = uint16(zeros(numrows,numcols, n));
        for i = 1 : n
            I = imread(filename, i);
            if ndims(I) == 3
                mat(:, :, i) = uint16(imresize(rgb2gray(I), [numrows numcols]));
            else
                mat(:, :, i) = uint16(imresize(I, [numrows numcols]));
            end
        end
    end
    
end

if ~ispc
    cd(currPath);
end