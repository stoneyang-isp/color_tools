clear all; close all; 

% name, dir, suffix
inputFileDir = 'E:\yangfan\DOCS\WDR_raw\';
inputFileSuffix = '*.raw';
outputFileDir = 'E:\yangfan\Data\WDR_raw_tif\';
outputFileSuffix = '.tif';

% read all of the raw files under specified directory and enumerate the 
% number of input files
intputFileList = dir(strcat(inputFileDir, inputFileSuffix));
nFiles = length(intputFileList);

for i = 1:nFiles
    % read the file names and split them by delimiter '_'
    fNames{i} = strcat(inputFileDir, intputFileList(i).name); 
    splitfNames{i} = regexp(fNames{i}, '_', 'split');
    
    % split the file names further to find out the size, ie: row, col
    rawSize{i} = regexp(splitfNames{i}{3}, '\x', 'split');
    rawRow = str2num(rawSize{i}{1});
    rawCol = str2num(rawSize{i}{1});
    
    % split the file names further to find out the bayer pattern
    bayerPattern{i} = regexp(splitfNames{i}{4}, '\.', 'split');
    bayerPattern{i} = bayerPattern{i}{1};

    % read in the raw data from the input raw files
    fp = fopen(fNames{i}, 'rb'); 
    raw = fread(fp, [rawRow rawCol], 'uint16')';
    fclose(fp); 
    
    % find out the max and min among the raw data
    maxValue = max(raw(:)); 
    minValue = 3;% min(raw{i}(:));

    % demosaic the raw respect to its bayer pattern determined before
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
    % bayer value clamping
    bayer(bayer>maxValue) = maxValue; 
    bayer(bayer<minValue) = minValue;
    
    % show demosaiced images
    figure;
    imshow(bayer);
    
    % write out the demosaiced hdr images in the format of tiff
    splitfNames2{i} = regexp(fNames{i}, '\\', 'split');
    outputfNames{i} = regexp(splitfNames2{i}{end}, '\.', 'split');
    outputfNames{i} = outputfNames{i}{1};
    outputfNames{i} = strcat(outputFileDir, outputfNames{i}, outputFileSuffix);
    imwrite(bayer, outputfNames{i});
end