function [Sstar,lambda] = cov_shrink( mx )

[row,len]=size(mx);
R = corrcoef(mx);

% CALC standardized mx
meanvec = mean(mx);
stdvec = std(mx);
smx = mx - repmat(meanvec,row,1);
smx = smx ./ repmat(stdvec,row,1);

% CALC correlation variance
W = zeros(row,len,len);
for i=1:row
    W(i,:,:) = smx(i)'*smx(i);
end

AW = zeros(len,len);
for i=1:len
    for j=1:len
        AW(i,j) = mean(mean(W(:,i,j)));
    end
end

VarR = zeros(len,len);
for i=1:len
    for j=1:len
        VarR(i,j) = (len/(len-1)^3)*sum((W(:,i,j)-AW(i,j)).^2);
    end
end


% CALC lambda
sumVarR = sum(sum(VarR))-sum(diag(VarR));
sumRR = sum(sum(R.^2))-sum(diag(R).^2);

lambda = sumVarR/sumRR


% CALC Rstar
if (lambda>=1)
    multipl = 0;
else
    multipl = 1 - lambda;
end

Rstar = zeros(len, len);
for i=1:len
    for j=1:len
        if i==j
            Rstar(i,j) = 1;
        else
            Rstar(i,j) = R(i,j)*multipl;
        end
    end
end


% CALC Sstar
Sstar = zeros(len, len);
stdvec = std(mx);
for i=1:len
    for j=1:len
        Sstar(i,j) = Rstar(i,j)*sqrt(stdvec(i)*stdvec(j));
    end
end


end

