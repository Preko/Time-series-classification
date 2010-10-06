function results = looper_lmnn2(names,wmethod,wparams)
%looper_lmnn2 - Loops over some datasets and runs LMNN
%
% Syntax:  [results] = looper_lmnn2(names,wmethod,wparams)
%
% Inputs:
%    names - Names of the datasets, the path and filename is set for
%           Keogh's dataset being in a directory called 'dataset'
%    wmethod - Type of LMNN used ('global' or 'local')
%    wparams - Number of nearest neighbors used for evaluation (can be an array)
%
% Outputs:
%    results - matrix with error of each datasets in rows and each
%           parameters in column
%
% Example: 
%    looper_lmnn2(data(4),'global',1)
%    looper_lmnn2(data(4),'local',1)
%    looper_lmnn2(data(4),'global',[1 2])
%
% Other m-files required: LMNN2 package
% MAT-files required: data.mat (names of Keogh's datasets)
%
% See also: looper

% Author: Zoltan Prekopcsak
% Budapest University of Technology and Economics
% email: prekopcsak@tmit.bme.hu
% Website: http://www.prekopcsak.com
% May 2010; Last revision: 05-Oct-2010


nlen=length(names);
plen=length(wparams);

results = zeros(nlen,plen);

for i=1:nlen
    for j=1:plen
        disp(['Testing name #',num2str(i),' out of ',num2str(nlen),', param #',num2str(j),' out of ',num2str(plen),'.'])
        trn=load(char(strcat('dataset/',names(i), '/', names(i),'_TRAIN')));
        tst=load(char(strcat('dataset/',names(i), '/', names(i),'_TEST')));
        TRAIN=znorm(trn);
        TEST=znorm(tst);
        trn_labels = TRAIN(:,1);
        tst_labels = TEST(:,1);
        TRAIN(:,1) = [];
        TEST(:,1) = [];
        switch lower(wmethod)
            
            case {'global'}
                [L,Det] = lmnn2(TRAIN',trn_labels',wparams(j),'quiet',1);%,'maxiter',1000);        
                knnerrL=knnclassify(L,TRAIN',trn_labels',TEST',tst_labels',wparams(j));
                %knnerrI=knnclassify(eye(size(L)),TRAIN',trn_labels',TEST',tst_labels',wparams(j))
                results(i,j)=knnerrL(2);
                
            case {'local'}
                [Ls,Dets]=MMlmnn(TRAIN',trn_labels',wparams(j),'quiet',1);%,'maxiter',300,'noatlas',1);
                knnerrLs=MMknnclassify(Ls,TRAIN',trn_labels',TEST',tst_labels',wparams(j));
                results(i,j)=knnerrLs(2);
        
            otherwise
                disp('Unknown weighting method!');
                return;
        end
    end
end
