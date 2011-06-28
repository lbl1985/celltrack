function [status, result] = git(varargin)

cmd = '"c:\Program Files (x86)\Git\cmd\git.cmd"';
for i = 1:numel(varargin)
    cmd = [cmd ' ' varargin{i}];
end
switch nargout
    case 0, system(cmd);
    case 1, [status] = system(cmd);
    case 2, [status, result] = system(cmd);
end