I = imread('E:\yangfan\DATA\Gonzallez\DIP3E_CH06_Original_Images\Fig0631(a)(strawberries_coffee_full_color).tif');
[I_rows, I_cols, I_channels] = size(I);
figure; imshow(I);

% RGB
I_R = im2double(I(:,:,1));
I_G = im2double(I(:,:,2));
I_B = im2double(I(:,:,3));

figure; imshow(I_R);
figure; imshow(I_G);
figure; imshow(I_B);

% color slicing on three channels
I_Rnew = zeros(size(I_R)); 
I_Gnew = zeros(size(I_G)); 
I_Bnew = zeros(size(I_B));

I_Rnew2 = zeros(size(I_R)); 
I_Gnew2 = zeros(size(I_G)); 
I_Bnew2 = zeros(size(I_B));

a = [0.6863, 0.1608, 0.1922];
W = 0.2549;
R_0 = 0.1765;

% square or cube
for i = 1:1:I_rows 
    for j = 1:1:I_cols 
        if I_R(i,j) - a(1) > W/2 || I_R(i,j) - a(1) < -W/2 
            I_Rnew(i,j) = 0.5; 
        else
            I_Rnew(i,j) = I_R(i,j);
        end
    end
end

for i = 1:1:I_rows 
    for j = 1:1:I_cols 
        if I_G(i,j) - a(2) > W/2 || I_G(i,j) - a(2) < -W/2 
            I_Gnew(i,j) = 0.5; 
        else
            I_Gnew(i,j) = I_G(i,j);
        end
    end
end

for i = 1:1:I_rows
    for j = 1:1:I_cols 
        if I_B(i,j) - a(3) > W/2 || I_B(i,j) - a(3) < -W/2 
            I_Bnew(i,j) = 0.5; 
        else
            I_Bnew(i,j) = I_B(i,j);
        end
    end
end

I_new = zeros(I_rows, I_cols, I_channels);
I_new(:,:,1) = I_Rnew;
I_new(:,:,2) = I_Gnew;
I_new(:,:,3) = I_Bnew;

figure; imshow(I_Rnew);
figure; imshow(I_Gnew);
figure; imshow(I_Bnew);
figure; imshow(I_new);

% circle or sphere
for i = 1:1:I_rows 
    for j = 1:1:I_cols 
        if (I_R(i,j) - a(1))^2 > R_0^2
            I_Rnew2(i,j) = 0.5; 
        else
            I_Rnew2(i,j) = I_R(i,j);
        end
    end
end

for i = 1:1:I_rows 
    for j = 1:1:I_cols 
        if (I_G(i,j) - a(2))^2 > R_0^2 
            I_Gnew2(i,j) = 0.5; 
        else
            I_Gnew2(i,j) = I_G(i,j);
        end
    end
end

for i = 1:1:I_rows
    for j = 1:1:I_cols 
        if (I_B(i,j) - a(3))^2 > R_0^2 
            I_Bnew2(i,j) = 0.5; 
        else
            I_Bnew2(i,j) = I_B(i,j);
        end
    end
end

I_new2 = zeros(I_rows, I_cols, I_channels);
I_new2(:,:,1) = I_Rnew2;
I_new2(:,:,2) = I_Gnew2;
I_new2(:,:,3) = I_Bnew2;

figure; imshow(I_Rnew2);
figure; imshow(I_Gnew2);
figure; imshow(I_Bnew2);
figure; imshow(I_new2);