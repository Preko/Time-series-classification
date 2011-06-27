function [error_rate, avgdist]=TSValidate(trn,tst,wmethod,wparam1,measure,k)

%%%%%%%%%%%%%%%%%%%%%
%%% PREPROCESSING %%%
%%%%%%%%%%%%%%%%%%%%%

TRAIN=znorm(trn);
TEST=znorm(tst);
%TRAIN=trn;
%TEST=tst;

[rowt,lent]=size(TEST);
[rown,lenn]=size(TRAIN);


%%% If the labels are -1/1, we change -1 to 0
for i=1:rown
   if(TRAIN(i,1)==-1) 
       TRAIN(i,1)=0; 
   end
end

for i=1:rowt
    if(TEST(i,1)==-1) 
        TEST(i,1)=0; 
    end
end

%%% If the labels are 1..n then we change to 0...n-1
if (min(TRAIN(:,1))~=0)
    for i=1:rown
        TRAIN(i,1)=TRAIN(i,1)-1;
    end
end

if (min(TEST(:,1))~=0)
    for i=1:rowt
        TEST(i,1)=TEST(i,1)-1;
    end
end

%%% Find the number of classes
clsnro=max(TRAIN(:,1))+1;


%%%%%%%%%%%%%%%%%
%%% WEIGHTING %%%
%%%%%%%%%%%%%%%%%

switch lower(wmethod)
    
    case {'ones'}
        %cls_wghts=ones(clsnro,lenn-1);
        cls_wghts=zeros(clsnro,lenn-1,lenn-1);
        for i = 1 : clsnro
            cls_wghts(i,:,:) = eye(lenn-1);
        end

            
    %case {'regular','methoda','global_regular','global_methoda','diff','global_diff'}
    %    cls_wghts=inout_weighter(TRAIN,wmethod,wparam1,wparam2);
        
    %case {'relieff'}
    %    cls_wghts=relieff(TRAIN(:,2:lenn),TRAIN(:,1),wparam1,wparam2);
        
    case {'mahalanobis'}
        %cls_wghts=ishikawa(TRAIN,Inf,wparam1);
        cls_wghts=ishikawa(TRAIN,wparam1);
        
    case {'pairinverse'}
        cls_wghts=pairinverse(TRAIN);
        
    case {'gmahalanobis'}
        TRAIN_2 = TRAIN;
        TRAIN_2(:,1) = zeros(size(TRAIN_2,1),1);
        global_wght = ishikawa(TRAIN_2,wparam1);
        cls_wghts=zeros(clsnro,lenn-1,lenn-1);
        for i = 1 : clsnro
            cls_wghts(i,:,:) = global_wght;
        end
        
    case {'manual'}
        cls_wghts=manual_wghts();
        
    %case {'interclass'}
    %    cls_wghts=interclassw(TRAIN);
    
    case {'halfsparse','halfsparsemah'}
        if (mod(lenn-1,2) == 1)
            TRAIN = [TRAIN zeros(rown,1)];
            TEST = [TEST zeros(rowt,1)];
        end;
        
        TRAIN = [TRAIN(:,1) TRAIN(:,2:2:end)+TRAIN(:,3:2:end)];
        TEST = [TEST(:,1) TEST(:,2:2:end)+TEST(:,3:2:end)];
        
        [rowt,lent]=size(TEST);
        [rown,lenn]=size(TRAIN);
        if (strcmp(wmethod,'halfsparsemah'))
            cls_wghts=ishikawa(TRAIN,wparam1);
        else
            cls_wghts=zeros(clsnro,lenn-1,lenn-1);
            for i = 1 : clsnro
                cls_wghts(i,:,:) = eye(lenn-1);
            end    
        end
        
    otherwise
        disp('Unknown weighting method!');
        return;
 
end

%%%%%%%%%%%%%%%%%%%%%%
%%% CLASSIFICATION %%%
%%%%%%%%%%%%%%%%%%%%%%

%%% Calculating distance matrix
disp(['Calculating ', measure, ' distance matrix...']);
switch lower(measure)

    case {'manhattan'}
        dist_matrix = minkowski_matrix(TRAIN(:,2:lenn),TEST(:,2:lent),TRAIN(:,1),cls_wghts,1);
        
    case {'euc'}
        dist_matrix = minkowski_matrix(TRAIN(:,2:lenn),TEST(:,2:lent),TRAIN(:,1),cls_wghts,2);
        
    case {'dtw'}
        dist_matrix = dtw_matrix(TRAIN(:,2:lenn),TEST(:,2:lent),TRAIN(:,1),cls_wghts);
        
    otherwise
        disp('Unknown measure!');
        return;
    
end
disp(['Running ', num2str(k), '-NN with ', measure, ' measure...']);

%%% Running k-NN
correct = 0;
testmx = zeros(clsnro,clsnro);
for i = 1 : rowt
    votes = zeros(clsnro,1);
    [values,order] = sort(dist_matrix(:,i),'ascend');
    %values(1)
    for j = 1 : k
        votes(TRAIN(order(j),1)+1) = votes(TRAIN(order(j),1)+1) + 1; 
    end
    [~,maxindex] = max(votes);
    %ans = [ maxindex(1)-1 TEST(i,1) ]
    testmx(maxindex(1),TEST(i,1)+1) = testmx(maxindex(1),TEST(i,1)+1) + 1;
    if (TEST(i,1) == (maxindex(1)-1))
        correct = correct + 1;
    end
end
error_rate=(rowt-correct)/rowt;
testmx
for c=1:clsnro
    trndistmx = minkowski_matrix(TRAIN(TRAIN(:,1)==c-1,2:lenn),TRAIN(TRAIN(:,1)==c-1,2:lenn),TRAIN(TRAIN(:,1)==c-1,1),cls_wghts,2);
    avgdist(c,1) = mean(mean(trndistmx));
end
avgdist

