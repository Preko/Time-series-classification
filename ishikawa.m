function cls_wghts = ishikawa(trn,band)

[row,len]=size(trn);
trn_labels = trn(:,1); 
clsnro=max(trn_labels)+1;
n = len-1;

cls_wghts=zeros(clsnro,n,n);

for c = 1 : clsnro
    cmx = [];
    dmx = [];
    for j = 1 : row
        if (trn(j,1)==c-1)
            cmx = [cmx;trn(j,2:len)];
        else
            dmx = [dmx;trn(j,2:len)];
        end
    end
    if (size(cmx,1)>1)
        covmx = cov(cmx);
    else
        covmx = eye(n);
    end
    for i = 1:size(covmx,1)
        for j = 1:size(covmx,2)
            if (abs(i-j)>band) 
                covmx(i,j) = 0;
            end;
        end
    end
    
%     for i = 1:size(covmx,1)
%         start = i - rem(i,band+1);
%         for j = 1:size(covmx,2)
%             if (j<start || j>start+band) 
%                 covmx(i,j) = 0;
%             end;
%         end
%     end
    
    if (band==0)
        w = 1./diag(covmx);
        w = w./prod(w.^(1/size(w,1)));
        M = diag(w);
    else
        sval = svd(covmx);
        limit = max(size(covmx))*norm(covmx)*eps;
        sval = sval(sval>limit);
        normal = prod(sval.^(1/size(sval,1)));
        M = normal*pinv(covmx);
    end
    
    cls_wghts(c,:,:) = M;
end

%cls_wghts = normdist(trn,cls_wghts);
%cls_wghts = optscale(trn,cls_wghts);
%cls_wghts = bestscale(trn,cls_wghts);

end
