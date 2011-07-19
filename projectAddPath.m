function projectAddPath(startingPath, projectName)

switch projectName
    case 'celltrack'
        addpath(genpath(fullfile(startingPath)));
        rmpath(genpath(fullfile(startingPath, '90support', 'TFOCS_v1', 'demo')));
        rmpath(genpath(fullfile(startingPath, '90support', 'TFOCS_v1', 'TFOCS')));
        rmpath(genpath(fullfile(startingPath, 'Results')));
        addpath(fullfile(startingPath, '90support', 'TFOCS_v1', 'TFOCS'));
        addpath(fullfile(startingPath, 'Results', 'vivo', 'batchRun_object'));
%         addpath(genpath(fullfile(startingPath, '01database')));
%         addpath(genpath(fullfile(startingPath, '10BackgroundSubtraction')));
%         addpath(genpath(fullfile(startingPath, '15PostProcessing')));
%         addpath(genpath(fullfile(startingPath, '16HankelDecision')));
%         addpath(genpath(fullfile(startingPath, '20Tracking')));
%         addpath(genpath(fullfile(startingPath, '21CellIDGen')));
%         addpath(fullfile(startingPath, '90support'));
%         addpath(genpath(fullfile(startingPath, '90support', 'CvBSLib')));
%         addpath(genpath(fullfile(startingPath, '90support', 'mmread')));
%         addpath(genpath(fullfile(startingPath, '90support', 'mmwrite')));
%         addpath(fullfile(startingPath, '90support', 'TFOCS_v1', 'TFOCS'));
end
