clear; close all;
main_class;
trackBlobsObj = TrackBlobs(blobDetector.inputVideoData);
trackBlobsObj.OpenClosingProcess();
trackBlobsObj.blobTrackingFunc();

trackBlobsObj.DBMergeLocation();
trackBlobsObj.DBMergeLocation();
% TODO Dynamics
trackBlobsObj.DBMergeDynamics();
trackBlobsObj.DBSortByFrame();
trackBlobsObj.playTrackingBlobs();
trackBlobsObj.videoName = 'trial6.avi';
trackBlobsObj.saveTrackingBlobs;