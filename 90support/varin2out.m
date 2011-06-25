function varargout =  varin2out(varargin)
% only for batch output the varargin into several variables.
% Binlong Li    25 June 2011    08:08AM
n = length(varargin);
for i = 1 : n
    temp = varargin{i};
    varargout{i} = temp{1};
end