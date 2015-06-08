function imgOut = convolution(img, mask)
%Convolution Summary of this function goes here
%   Detailed explanation goes here

img = im2double(img);

% get image dimensions
[irows, icols] = size(img);

% get mask dimension
[mrows, mcols] = size(mask);

% allocate spaces for result
imgOut = zeros(irows, icols);

% radius of mask in two dimension
mrhalf = floor(mrows/2);
mchalf = floor(mcols/2);

% convolve with mask
for x = (1 + mchalf):1:(icols - mchalf)
    for y = (1 + mrhalf):1:(irows - mrhalf)
        sum = 0;
        for i = 1:1:mcols
            for j = 1:1:mrows
                sum = sum + img(y - mrhalf - 1 + j, x - mchalf - 1 + i) * mask(j, i);
            end
        end
        imgOut(y, x) = sum;
    end
end

end

