function imgOut = contrast_stretching(img, level, r1, r2, s1, s2)
%CONTRAST_STRETCHING Stretching contrast of gray level image
%
%   img:    input image
%   level:  number of gray levels
%   r1:     horizontal coordinates of first point
%   r2:     horizontal coordinates of second point
%   s1:     vertical coordinates of first point
%   s2:     vertical coordinates of second point
%
%   imgOut: output image

%   Copyright @2015 Yang Fan $ 20150611 13:50:21

% allocate spaces for output image
imgOut = zeros(size(img));

% construct transform function
if r1 > r2
    disp('Please input r1 smaller than r2. ');
end

if r1 == r2 % is thresholding?
    disp('Thresholding mode. ');
    % case 1
    idx = find(img <= r1);
    imgOut(idx) = s1;
    % case 2
    idx = find(img > r2);
    imgOut(idx) = s2;
else
    % case 1
    slope1 = s1 / r1;
    idx = find(img <= r1);
    imgOut(idx) = slope1 * img(idx);  
    
    % case 2
    slope2 = (s2 - s1) / (r2 - r1);
    idx = find((img > r1) & (img <= r2));
    imgOut(idx) = slope2 * (img(idx) - r1) + s1;
    
    % case 3
    slope3 = (level - 1 - s2) / (level - 1 - r2);
    idx = find(img > r2);
    imgOut(idx) = slope3 * (img(idx) - r2) + s2;
end

imgOut = uint8(imgOut);

end

