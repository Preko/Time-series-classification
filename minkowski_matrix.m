function matrix = minkowski_matrix(trn,tst,trn_labels,cls_wghts,p)

[rowt,~]=size(tst);
[rown,~]=size(trn);

matrix = zeros(rown,rowt);

if (ndims(cls_wghts)<3)
    for i = 1 : rown
        class = trn_labels(i);
        for j = 1 : rowt
            matrix(i,j) = sum((abs(trn(i,:)-tst(j,:)).^p).*cls_wghts(class+1,:))^(1/p);
        end
    end
elseif (p==2)
    for i = 1 : rown
        class = trn_labels(i);
        M = squeeze(cls_wghts(class+1,:,:));
        for j = 1 : rowt
            matrix(i,j) = (trn(i,:)-tst(j,:))*M*(trn(i,:)-tst(j,:))';
        end
    end
else    
    disp('Non-euc ellipsoid distance!');
    error('Non-euc ellipsoid distance!');
end

end

