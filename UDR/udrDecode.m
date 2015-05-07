function udr = udrDecode(raw)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  
%%%    function to decode Starlight UDR raw image
%%%  
%%%    Feng Xiao 05/06/2015
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MappedValues = [0 2.^(2:14)];
BreakPoints = [0 2.^(0:2:24)];

index = ceil(log2(raw));

LowBreakPoint = BreakPoints(index-1);
HighBreakPoint = BreakPoints(index); 
LowMappedValue = MappedValues(index-1);
HighMappedValue = MappedValues(index); 

slope = (HighBreakPoint-LowBreakPoint)./(HighMappedValue-LowMappedValue); 

udr = LowBreakPoint + (raw-LowMappedValue).*slope;
udr = round(udr); 
