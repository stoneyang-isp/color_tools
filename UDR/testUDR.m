clear all; close all; 

fname = 'trafficLight.raw'; 

fp = fopen(fname,'rb'); 
raw = fread(fp,[1920 1088],'uint16')';
fclose(fp); 

maxValue = max(raw(:)); 
minValue = 3;% min(raw(:)); 

%%% Since Matlab's demosaic function only supports up to 16 bits, we have
%%% to play a simple trick here (demosaic on UDR format first then decode)

bayer = demosaic(uint16(raw),'rggb'); 
bayer(bayer>maxValue)=maxValue; 
bayer(bayer<minValue)=minValue; 

%%% decode to linear 24 bits data
udrRGB = udrDecode(double(bayer)); 

a = udrRGB/2^24; 
figure; imshow((udrRGB/2^24).^(1/10));
