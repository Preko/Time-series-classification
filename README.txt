HOWTO for reproducing the results in the paper
Zoltan Prekopcsak, Daniel Lemire: Time Series Classification by Class-Based Mahalanobis Distances

Preliminaries:
- the Keogh benchmark[1] should be placed in a directory called 'dataset'
- the mLMNN package[2] should be in the Matlab path (File/Set path)
- the data.mat file has to be loaded to Matlab

The results in Table 1 can be reproduced by the following commands column by column:
looper(data,'gmahalanobis',Inf,'euc',1)
looper(data,'mahalanobis',Inf,'euc',1)
looper(data,'gmahalanobis',0,'euc',1)
looper(data,'mahalanobis',0,'euc',1)

The results in Table 2 can be reproduced by the following commands column by column:
looper(data,'ones',0,'euc',1)
looper(data,'ones',0,'dtw',1)
looper(data,'mahalanobis',0,'euc',1)
looper_lmnn2(data(2:20),'global',1)
looper_lmnn2(data(2:20),'local',1)

[1] http://www.cs.ucr.edu/~eamonn/time_series_data/
[2] http://www.cse.wustl.edu/~kilian/Downloads/LMNN.html