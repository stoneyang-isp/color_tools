function rgb = hsi2rgb(hsi)
%HSI2RGB Summary of this function goes here
%   Detailed explanation goes here

% decomposite h, s, i
% hsi = im2double(hsi);
h = hsi(:,:,1) * 2 * pi;
s = hsi(:,:,2);
i = hsi(:,:,3);

% allocate space for rgb
rgb = zeros(size(hsi));
r = rgb(:,:,1);
g = rgb(:,:,2);
b = rgb(:,:,3);

% RG sector: 0 <= h < 120
idx = find((h >= 0) & (h < 2*pi/3));
b(idx) = i(idx) .* (1 - s(idx));
r(idx) = i(idx) .* (1 + s(idx) .* cos(h(idx)) ./ cos(pi/3 - h(idx)));
g(idx) = 3 * i(idx) - (r(idx) + b(idx));

% GB sector: 120 <= h < 240
idx = find((h >= (2*pi/3)) & (h < (4*pi/3)));
h(idx) = h(idx) - 2*pi/3;
r(idx) = i(idx) .* (1 - s(idx));
g(idx) = i(idx) .* (1 + s(idx) .* cos(h(idx)) ./ cos(pi/3 - h(idx)));
b(idx) = 3 * i(idx) - (r(idx) + g(idx));

% BR sector: 240 <= h <= 360
idx = find((h >= (4*pi/3)) & (h <= 2*pi));
h(idx) = h(idx) - 4*pi/3;
g(idx) = i(idx) .* (1 - s(idx));
b(idx) = i(idx) .* (1 + s(idx) .* cos(h(idx)) ./ cos(pi/3 - h(idx)));
r(idx) = 3 * i(idx) - (g(idx) + b(idx));
    
% combine r, g, b
rgb(:,:,1) = r;
rgb(:,:,2) = g;
rgb(:,:,3) = b;

% clip to [0, 1] to compensate for floating-point arithmetic rounding effects.
rgb = max(min(rgb, 1), 0);

end