function hsi = rgb2hsi(rgb)
%RGB2HSI Summary of this function goes here
%   Detailed explanation goes here

% decomposite rgb into r, g, b
rgb = im2double(rgb);
r = rgb(:,:,1);
g = rgb(:,:,2);
b = rgb(:,:,3);

[rows, cols, layers] = size(rgb);
eps = 1e-12;

% compute hue
theta_num = 0.5 * ((r - g) + (r - b));
theta_den = sqrt((r - g) .^ 2 + (r - b) .* (g - b));
theta_den(theta_den == 0) = eps;
theta = acos(theta_num ./ theta_den);

h = theta;
h(g > b) = 2 * pi - h(g > b);
h = h / (2 * pi);

% compute saturation
s_num = 3 * min(min(r, g), b);
s_den = r + g + b;
s_den(s_den == 0) = eps;
s = 1 - s_num ./ s_den;
h(s == 0) = 0;

% compute intensity
i = (r + g + b) ./ 3;

% combine h, s, and i
hsi = zeros(rows, cols, layers);
hsi(:,:,1) = h;
hsi(:,:,2) = s;
hsi(:,:,3) = i;

end

