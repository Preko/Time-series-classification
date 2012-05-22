function results = looper_synth(name,sizes,wmethod,wparams,measure,k)

slen=length(sizes);
repeat = 10;

results = zeros(repeat,slen);

for cnt=1:repeat
    for i=1:slen
        disp(['Testing size #',num2str(slen*(cnt-1)+i),' out of ',num2str(repeat*slen),'.']);
        TRAIN=load(char(strcat('synthdata/',name,num2str(cnt),'_',num2str(sizes(i)),'/', name,num2str(cnt),'_',num2str(sizes(i)),'_TRAIN')));
        TEST=load(char(strcat('synthdata/',name,'_TEST')));
        results(cnt,i)=TSValidate(TRAIN,TEST,wmethod,wparams(1),measure,k);
    end
end
