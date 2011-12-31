function cls_wghts = ishikawa(trn,band,lambda)

%global eigenD;
%global eigenDF;
%global eigenL;

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
    
    if (size(cmx,1)<=2)
        covmx = eye(n);
    elseif (band>0)
        %covmx = cov_lambda(cmx,lambda);
        [covmx,lambda] = cov_shrink(cmx);
    else
        covmx = cov(cmx);
        for i = 1:size(covmx,1)
            for j = 1:size(covmx,2)
                if (abs(i-j)>band) 
                    covmx(i,j) = 0;
                end;
            end
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
    
    %figure(c);

    if (band==0)
        w = 1./diag(covmx);
        w = w./prod(w.^(1/size(w,1)));
        M = diag(w);
        
         %figure(c);
         %subplot(2,3,6);
         %set(0,'DefaultImageCreateFcn','axis image')
         %colorspy(covmx);%xlabel('Diagonal covariance');
         %set(gca,'XTick',[]);
         %set(gca,'YTick',[]);
         %set(gcf, 'PaperPositionMode', 'manual');
         %set(gcf, 'PaperPosition', [0 0 3 3]);
         %subplot(3,3,9);
         %colorspy(M);xlabel('Diagonal inverse covariance');        
         
    elseif (band<Inf)
        [invcovmx,covmx] = spmlcdvec(covmx,band,2,0.1,2,'nest');
        M = invcovmx;
               
         %subplot(3,3,5);
         %colorspy(inv(invcovmx));xlabel('Sparse covariance');
         %subplot(3,3,8);
         %colorspy(invcovmx);xlabel('Sparse inverse covariance');
    else
        alpha = 0;
        extra = alpha*eye(size(covmx));
        covmx = covmx+extra;
        sval = svd(covmx);
        %svdF = svd(cov(cmx));
        %svdD = svd(diag(diag(cov(cmx))));
        %svdFlast = svdF(n);
        %svdDlast = svdD(n);
        %svdDFlast = sval(n);
        dete = det(covmx);
        limit = max(size(covmx))*norm(covmx)*eps;
        sval = sval(sval>limit);
        normal = prod(sval.^(1/size(sval,1)));
        M = normal*pinv(covmx);
        
        shouldzero = pinv(covmx)*covmx-eye(n);
        check = sum(sum(abs(shouldzero)));
        ot = shouldzero(1:3,1:3)
%        eigenL = [eigenL; lambda];
%        eigenD = [eigenD; svdDlast];
%        eigenDF = [eigenDF; svdDFlast];
        %dete = det(M);
        %eigenL = [eigenL; check];
        
         %subplot(3,2,1:2);
         %p = plot(cmx');
         %set(gca,'XTick',[]);
         %set(p,'Color','blue');
         %axis([1 n -Inf Inf]);
         %set(gca,'YTick',[]);
         %subplot(3,2,3:6);
         %colorspy(cov(cmx));%xlabel('Full covariance');
         %set(gca,'XTick',[]);
         %set(gca,'YTick',[]);
         %subplot(2,3,5);
         %colorspy(covmx);xlabel('Shrinked covariance');
         %set(gca,'XTick',[]);
         %set(gca,'YTick',[]);
         %subplot(3,3,7);
         %colorspy(M);xlabel('Full inverse covariance');
         
         %figure(2*c);
         %set(0,'DefaultImageCreateFcn','axis image')
         %colorspy(cov(cmx));
         %set(gca,'XTick',[]);
         %set(gca,'YTick',[]);
         %figure(2*c+1)
         %colorspy(covmx);
         %set(gca,'XTick',[]);
         %set(gca,'YTick',[]);
    end
    
    cls_wghts(c,:,:) = M;
end

%cls_wghts = normdist(trn,cls_wghts);
%cls_wghts = optscale(trn,cls_wghts);
%cls_wghts = bestscale(trn,cls_wghts);

end
