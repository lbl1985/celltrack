classdef saveVideo < handle
    %SAVEVIDEO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        movieFile
        M
        fbeg = 1;
        fend
        frameRate
        clrmap
        aviobj
        fig
    end
    
    methods
        function obj = saveVideo(requiredName, requiredFrameRate, varargin)
            obj.movieFile = requiredName;
            obj.frameRate = requiredFrameRate;
            obj.aviobj = avifile(obj.movieFile, 'fps', obj.frameRate, ...
                'copression', 'none');
            if isempty(varargin)
                obj.fbeg = 1;   obj.fend = size(input, ndims(inputVideo));
            else
                obj.fbeg = varargin{1}; obj.fend = varargin{2};
            end
        end
        
        function obj = saveProcess(obj, inputVideo)
            obj.M = inputVideo;     nd = ndims(obj.M);
            obj.fig = figure;
            
            for t = obj.fbeg : obj.fen
                figure(obj.fig);
                if nd == 3
                    imshow(obj.M(:, :, t));
                else
                    imshow(obj.M(:, :, :, t));
                end
                saveCore();
            end
            obj.aviobj = close(obj.aviobj);
        end
        
        function obj = saveCore(obj)
            frame = getframe(obj.fig);
            obj.aviobj = addframe(obj.aviobj, frame);
        end
        
    end
    
end

