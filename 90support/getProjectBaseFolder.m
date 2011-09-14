function projectBaseFolder = getProjectBaseFolder
projectBaseFolder = which('celltrackFlag.m');
projectBaseFolder = projectBaseFolder(1:strfind(projectBaseFolder, 'celltrackFlag.m') - 1);
 