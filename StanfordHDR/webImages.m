% Script to create images and plots used for the high dynamic range image
% web-page. 
%
% The script produces an image measuring the luminance intensity, a
% thumbnail (rgb) of the image compressed by a power function, a histogram
% of the luminance intensity, and a plot of the illuminant spectral power
% distribution in a bright and dark part of the image
%
% To run, invoke this file from within the the "PDCDATA\HDR Images"
% directory
%
% This script requires radread.m (written by Feng Xiao and Jeff DiCarlo)
% Data collected by Feng Xiao and Joyce Farrell
% 

% Find all of the high dynamic range files and put them in a cell array
fileList = dir('*.hdr');
nFiles = length(fileList);
for ii=1:nFiles, fNames{ii} = fileList(ii).name; end

% The best 1 by 3 matrix to transform sensor RGB data into luminance value.
% To avoid negative luminance value, we constrain it to be non-negative.
RGB2Y = [ 0.2552  1.0834  0];
subSample = 3;      % Spatial sub-sampling of the thumbnail
gam = 0.2;          % Used for compressing the RGB thumbnail
tSize = 128;

close all

% Loop through all of the HDR files
for ii=1:nFiles

    [p,outName] = fileparts(fNames{ii});
    illum = []; sensor = []; hdr = [];

    % get the HDRI data, sensor sensitivity function and illumination
    % information
    [hdr, sensor, illum] = radread(fNames{ii});
    if isempty(illum),  disp(['No illuminant information in ',fNames{ii}]); end
    if isempty(sensor), disp(['No sensor information in ',fNames{ii}]); end

    % luminance value
    lum = hdr(:,:,1)*RGB2Y(1) + hdr(:,:,2)*RGB2Y(2) + hdr(:,:,3)*RGB2Y(3);

    % Image dynamic range
    DR = max(lum(:))/min(lum(:));

    % plot luminance map as a color image in log scale.  The levels run
    % from 10^0 to 10^5, so we show the image as 50 x in order to see the color
    % clearly
    figure(1); colormap(hot(256)); clf;
    lumImage = log10(lum);
    [r,c] = size(lumImage);
    lumImage = imresize(lumImage,[tSize,round(tSize*(c/r))]);
    image((lumImage*50)); axis off; axis image; colorbar('vertical'); 
    title(outName); axis image;  
    outFile = fullfile('lumImages',[outName,'.png']);
    print('-dpng',outFile);

    % plot histogram of luminance value in log scale
    figure(1); clf; 
    logLum = log10(lum(:));
    hist(logLum,128);
    xlabel('Log_{10} luminance')
    ylabel('No. pixels')
    xlim = get(gca,'xlim'); ylim = get(gca,'ylim');
    txt = [];
    txt = sprintf('DR: %.2e\n\n',DR);
    txt = addText(txt,sprintf('Max:  %.2e\n',max(lum(:))));
    txt = addText(txt,sprintf('Min:  %.2e\n',min(lum(:))));
    txt = addText(txt,sprintf('Mode: %.2e\n',mode(lum(:))));
    txt = addText(txt,sprintf('Mean: %.2e\n',mean(lum(:))));
    txt = addText(txt,sprintf('Units:  cd/m^2'));
    text(xlim(2) - 1.5, ylim(2) - (ylim(2) - ylim(1))/4 ,txt);
    outFile = fullfile('lumHistograms',[outName,'.pdf']);
    print('-dpdf',outFile)
    
    % original image is 1024 x 1280, here we subsample it to make a
    % thumbnail
    close(1); figure(1); clf;
    hdrS = imresize(hdr,[tSize,round(tSize*(c/r))]);
    rgbImage = imagescRGB(hdrS,gam); title(outName); 
    outFile = fullfile('rgbImages',[outName,'.png']);
    imwrite(rgbImage,outFile,'png');

    % Illuminant spectral composition
    close(1); figure(1); clf;
    hold on; color=['r','g','b','y','m'];
    for ind=1:length(illum)
        plot(illum(ind).wavelength,illum(ind).spectral,color(ind));
        set(gca,'xtick',(400:100:800));
    end
    set(gca,'yscale','log'); 
    hold off
    title(['Illuminants: ',outName])
    xlabel('Wavelength (nm)'); ylabel('Relative energy');
    outFile = fullfile('illuminants',[outName,'.pdf']);
    print('-dpdf',outFile);

end

% Build an html file containing the list of links.  We copy and paste this
% into the hdr.html file 
clear txt
txt = sprintf('<ol>\n');

for ii=1:nFiles
    [p,thisName] = fileparts(fNames{ii});
    
    txt = addText(txt,'<li>');
    txt = addText(txt,sprintf('%s\n',thisName));
    tmp = sprintf('<br> <a href="lumHistograms/%s.pdf"> Luminance histogram </a>\n',thisName);
    txt = addText(txt,tmp);
    tmp = sprintf('<br> <a href="illuminants/%s.pdf">   Illuminant SPD </a>\n',thisName);
    txt = addText(txt,tmp);
    txt = addText(txt,sprintf('<br>\n'));
    tmp = sprintf('<a href="%s">',thisName); txt = addText(txt,tmp);
    tmp = sprintf('<img border=1 src="rgbImages/%s.png">',thisName);
    txt = addText(txt,tmp);
    txt = addText(txt,sprintf('</a>\n'));
    txt = addText(txt,sprintf('<a href="%s_lum">',thisName));
    tmp = sprintf('<img border=0 src="lumImages/%s.png"></a>\n',thisName);
    txt = addText(txt,tmp);
    txt = addText(txt,sprintf('</li>\n\n'));
end

txt = addText(txt,sprintf('</ol>\n'));

fid = fopen('temp.html','w');
fprintf(fid,'%s',txt);
fclose(fid);

% Save out the Q-Imaging sensor spectral QE.
[p,outName] = fileparts(fNames{1});
[hdr, sensor, illum] = radread(fNames{ii});
comment = 'QImaging sensor spectral QE. To plot use plot(sensor(ii).wavelength,sensor(ii).spectral)';
save('SensorQE','sensor','comment');
