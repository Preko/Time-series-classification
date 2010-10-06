function matrix = dtw_matrix(trn,tst,trn_labels,cls_wghts)

[rowt,~]=size(tst);
[rown,~]=size(trn);

matrix = zeros(rown,rowt);

for i = 1 : rown
    for j = 1 : rowt
        [Dist,D,k,w,d] = dtw(trn(i,:),tst(j,:));
        matrix(i,j)=Dist;
    end
    disp([num2str(i), '/', num2str(rown)]);
end

end

