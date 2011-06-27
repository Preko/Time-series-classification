function results = looper(names,wmethod,wparams,measure,k)
%looper - Loops over some datasets with different weighting methods and several
%parameters and calculates k-nearest neighbor error
%
% Syntax:  [results] = looper(names,wmethod,wparams,measure,k)
%
% Inputs:
%    names - Names of the datasets, the path and filename is set for
%           Keogh's dataset being in a directory called 'dataset'
%    wmethod - Weighting method used ('ones','mahalanobis' or 'gmahalanobis')
%    wparams - Array of parameters of the weighting method that should be
%           looped over (not used by every method)
%    measure - Measure used for comparision ('manhattan','euc' or 'dtw'),
%           weighting is not used with dtw 
%    k - Number of nearest neighbors used for evaluation
%
% Outputs:
%    results - matrix with error of each datasets in rows and each
%           parameters in column
%
% Example: 
%    looper(data(4),'ones',0,'euc',1)
%    looper(data(4),'mahalanobis',[Inf 0],'euc',1)
%    looper(data(4),'ones',0,'dtw',1)
%
% Other m-files required: TSValidate.m
% MAT-files required: data.mat (names of Keogh's datasets)
%
% See also: looper_lmnn2

% Author: Zoltan Prekopcsak
% Budapest University of Technology and Economics
% email: prekopcsak@tmit.bme.hu
% Website: http://www.prekopcsak.com
% May 2010; Last revision: 05-Oct-2010


nlen=length(names);
plen=length(wparams);

results = zeros(nlen,plen);
alldist = [];

global eigenL;
%global eigenD;
%global eigenDF;

eigenL = [];

for i=1:nlen
    for j=1:plen
        disp(['Testing name #',num2str(i),' out of ',num2str(nlen),', param #',num2str(j),' out of ',num2str(plen),'.'])
        TRAIN=load(char(strcat('dataset/',names(i), '/', names(i),'_TRAIN')));
        TEST=load(char(strcat('dataset/',names(i), '/', names(i),'_TEST')));
        %cov(TRAIN(:,2:size(TRAIN,2)))
        [results(i,j),avgdist]=TSValidate(TRAIN,TEST,wmethod,wparams(j),measure,k);
        alldist = [alldist; avgdist];
    end
end

eigenL
%eigenD
%eigenDF

%dlmwrite('eigens.txt',[eigenL eigenD eigenDF]);
dlmwrite('dets.txt',eigenL);

alldist
