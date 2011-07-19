classdef centroidTrajectoryWithGroundTruthVideoSaver < videoSaver
    %CENTROIDTRAJECTORYWITHGROUNDTRUTHVIDEOSAVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        frameId
        caption
        nCells
    end
    
    methods
        function obj = centroidTrajectoryWithGroundTruthVideoSaver(requiredName, requiredFrameRate)
            obj = obj@videoSaver(requiredName, requiredFrameRate);
        end
        
        function saveWithGroundOnCaption(obj, inputVideo, groundTruth)
            obj.M = inputVideo;     nd = ndims(obj.M);
            obj.fig = figure;
            obj.fbeg = 1;   obj.fend = size(inputVideo, ndims(inputVideo));
            obj.nCells = length(groundTruth);
            for t = obj.fbeg : obj.fend   
                obj.caption = [];
                obj.frameId = t;
                figure(obj.fig);
                if nd == 3
                    imshow(obj.M(:, :, t), 'border', 'loose'); 
                else
                    imshow(obj.M(:, :, :, t)); 
                end
%                 obj.caption = {['Frame ' num2str(t) ' Total ' num2str(obj.nCells) ' cells ']};
                obj.caption = ['Frame ' num2str(t) ' Total ' num2str(obj.nCells) ' cells '];
                obj.updateCaption(groundTruth);
                title(obj.caption);   pause(1/22); 
                obj.saveCore();
            end
            obj.aviobj = close(obj.aviobj);
        end
        
        function updateCaption(obj, groundTruth)            
            for i = 1 : obj.nCells
                if (obj.frameId >= groundTruth(i).ff && obj.frameId <= groundTruth(i).lf)
%                     obj.caption = cat(1, obj.caption, {['cell ' num2str(i) ...
%                         ' from ' groundTruth(i).fl ' frame ' num2str(groundTruth(i).ff) ...
%                         ' to ' num2str(groundTruth(i).lf)]});
                    obj.caption = cat(2, obj.caption, ['cell ' num2str(i) ...
                        ' from ' groundTruth(i).fl ' frame ' num2str(groundTruth(i).ff) ...
                        ' to ' num2str(groundTruth(i).lf)]);
                end
            end
        end
    end
end

