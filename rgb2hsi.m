function hsi = rgb2hsi(rgb)
%RGB2HSI Converts an RGB image to HSI.
%   HSI = RGB2HSI(RGB) converts an RGB image to HSI. The input image
%   is assumed to be of size M-by-N-by-3, where the third dimension
%   accounts for three image planes: red, green, and blue, in that
%   order. If all RGB component images are equal, the HSI conversion
%   is undefined. The input image can be of class double (with values
%   in the range [0, 1]), uint8, or uint16. 
%
%   The output image, HSI, is of class double, where:
%     hsi(:, :, 1) = hue image normalized to the range [0, 1] by
%                    dividing all angle values by 2*pi. 
%     hsi(:, :, 2) = saturation image, in the range [0, 1].
%     hsi(:, :, 3) = intensity image, in the range [0, 1].

%   Copyright 2015 Fan Yang
%   $Revision: 0.1 $  $Date: 2015/06/09 09:57:04 $

% decomposite rgb into r, g, b
rgb = im2double(rgb);
r = rgb(:,:,1);
g = rgb(:,:,2);
b = rgb(:,:,3);

% eps = 1e-12;

% compute hue
theta_num = 0.5 * ((r - g) + (r - b));
theta_den = sqrt((r - g) .^ 2 + (r - b) .* (g - b));
theta = acos(theta_num ./ (theta_den + eps));

h = theta;
h(b > g) = 2*pi - h(b > g);
h = h / (2*pi);

% compute saturation
s_num = 3 * min(min(r, g), b);
s_den = r + g + b;
s_den(s_den == 0) = eps;
s = 1 - s_num ./ s_den;
h(s == 0) = 0;

% compute intensity
i = (r + g + b) / 3;

% combine h, s, and i
hsi = zeros(size(rgb));
hsi(:,:,1) = h;
hsi(:,:,2) = s;
hsi(:,:,3) = i;

end

