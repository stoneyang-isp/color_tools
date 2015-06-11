function imgOut = contrast_thresholding(img, lowerThresh, upperThresh, outputMax, outputMin, mode)
%CONTRAST_THRESHOLDING Thresholding contrast of gray level image
%
%   img:         input image
%   lowerThresh: lower threshold
%   upperThresh: upper threshold
%   outputMax:   maximum intensity of pixels in the range of the above two 
%                thresholds in output image
%   outputMin:   minimum intensity of pixels out the range of the above two 
%                thresholds in output image
%   mode:        mode of thresholding, 
%                1 for general mode; 
%                2 for binary mode
%
%   imgOut:      output image

%   Copyright @2015 Yang Fan $ 20150611 14:57:21

if (~exist('mode', 'var'))
    mode = 1;
end

% allocate spaces for output image
imgOut = zeros(size(img));

switch mode
    case 1
        disp('General threshold mode.');
        imgOut = img;
        % between the thresholds
        idx = find((img >= lowerThresh) & (img < upperThresh));
        imgOut(idx) = outputMax;
    case 2
        disp('Binary threshold mode.');
        % between the thresholds
        idx = find((img >= lowerThresh) & (img < upperThresh));
        imgOut(idx) = outputMax;
        % beyond the thresholds
        idx = find((img < lowerThresh) & (img > upperThresh));
        imgOut(idx) = outputMin;
end

imgOut = uint8(imgOut);

end