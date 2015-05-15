clear all; close all; 

inputFileDir = 'E:\yangfan\DOCS\WDR_raw\';
inputFileSuffix = '*.raw';
outputFileDir = 'E:\yangfan\Data\WDR_raw_tif\';
outputFileSuffix = '.tif';

intputFileList = dir(strcat(inputFileDir, inputFileSuffix));
nFiles = length(intputFileList);
for i = 1:nFiles
    fNames{i} = strcat(inputFileDir, intputFileList(i).name); 
    splitfNames{i} = regexp(fNames{i}, '_' ,'split');
    
    rawSize{i} = regexp(splitfNames{i}{3}, '\x', 'split');
    rawRow = str2num(rawSize{i}{1});
    rawCol = str2num(rawSize{i}{1});
    
    bayerPattern{i} = regexp(splitfNames{i}{4}, '\.', 'split');
    bayerPattern{i} = bayerPattern{i}{1};

    fp = fopen(fNames{i}, 'rb'); 
    raw = fread(fp, [rawRow rawCol], 'uint16')';
    fclose(fp); 
    
    maxValue = max(raw(:)); 
    minValue = 3;% min(raw{i}(:));

    switch bayerPattern{i}
        case 'GB'
            bayer = demosaic(uint16(raw), 'gbrg');
        case 'GR'
            bayer = demosaic(uint16(raw), 'grbg');
        case 'BG'
            bayer = demosaic(uint16(raw), 'bggr');
        case 'RG'
            bayer = demosaic(uint16(raw), 'rggb');
    end
    bayer(bayer>maxValue) = maxValue; 
    bayer(bayer<minValue) = minValue;
    
    figure;
    imshow(bayer);
    
    splitfNames2{i} = regexp(fNames{i}, '\\', 'split');
    outputfNames{i} = regexp(splitfNames2{i}{end}, '\.', 'split');
    outputfNames{i} = outputfNames{i}{1};
    outputfNames{i} = strcat(outputFileDir, outputfNames{i}, outputFileSuffix);
    imwrite(bayer, outputfNames{i});
end