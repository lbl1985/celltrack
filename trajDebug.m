clear; 
main_class;
trackBlobsObj = TrackBlobs(blobDetector.inputVideoData);
trackBlobsObj.OpenClosingProcess();
trackBlobsObj.blobTrackingFunc();
trackBlobsObj.DBSortByFrame();
trackBlobsObj.playTrackingBlobs();
