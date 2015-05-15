input = {'dog.png','flower.tif','lily.png','hawaii.png','nemo.jpg','sculpture.png','sky.png','zipline.png','cathedral.jpg'};
% input = {'zipline.png'}
for i = 1:length(input)
    a = input{i}
    filename = ['Images/' a];
    outfile = ['Output/' a(1:end-4)];
    
    catType = 'bradford';
    grayWorld(filename,[outfile '-GW-' catType '.png'],catType,1,0);
    simplestColorBalance(filename,[outfile '-Simple.png'],.01,1);
    robustAWB(filename,[outfile '-RAWB.png'],'RB',catType,.3,1000,1);
    sensorCorrelation(filename,[outfile '-SC-' catType '.png'],catType,1);
    close all
end

%%
input = {'vonKries','bradford','sharp','cmccat2000','cat02','xyz'};
for i = 1:length(input)
    a = input{i}
    filename = ['Images/dog.png'];
    outfile = ['Output/dog'];
    
    catType = a;
    grayWorld(filename,[outfile '-GW-' catType '.png'],catType,1,0);
%     simplestColorBalance(filename,[outfile '-Simple.png'],.01,0);
    robustAWB(filename,[outfile '-RAWB-' catType '.png'],'cat',catType,.3,1000,0);
    sensorCorrelation(filename,[outfile '-SC-' catType '.png'],catType,0);
    
end