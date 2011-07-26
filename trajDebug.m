clear; 
main_class;
trackBlobsObj = TrackBlobs(blobDetector.inputVideoData);
trackBlobsObj.OpenClosingProcessFunc();
trackBlobsObj.blobTrackingFunc();
trackBlobsObj.playTrackingBlobs();
