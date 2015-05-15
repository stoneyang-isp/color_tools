% RADWRITE: Writes a Radiance image.
%
% radwrite( IM, FILE, TYPE, BITS, SENSOR, ILLUMINANT )
%
% Writes a Radiance RGBE or XYZE image.
%
% IM  : Image.
% FILE: Filename.
% TYPE: Format.
%       Either 'rgbe' or 'xyze'.
% BITS: Bits per pixel per channel 
%       Either '8-bit' or '16-bit'
% SENOSR:     Spectral sensitivity function of camera sensors
% ILLUMINANT: Extra information about illuminant 
%      
% 
% Written by: Feng Xiao & Jeffrey DiCarlo
% Last Updated: 08-08-2002

function radwrite( im, file, type, bits , sensor, illuminant)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Format inputs.

if (nargin < 2)
  	error('First two arguments are required');
end

if (nargin == 2)
   type = 'xyze';
end

if (strcmp(type,'xyze') ~= 1 & strcmp(type,'rgbe') ~= 1)
   error('TYPE parameter is invalid.');
end

if ~exist('bits','var')
    bits='8-bit';
end

switch lower(bits)
case '8-bit'
    bit=8;
case '16-bit'
    bit=16;
otherwise
    error(['Bit depth  ' bits ' not supported, choose 8-bit or 16-bit']);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize important data.

[sy sx sc] = size( im );

if (sc == 1)
   if (strcmp(type,'xyze')==1)
      im(:,:,2) = im(:,:,1);
   	im(:,:,3) = zeros( sy, sx );
   	im(:,:,1) = zeros( sy, sx );
   else
      im(:,:,2) = im(:,:,1);
      im(:,:,3) = im(:,:,1);
   end
end

im = permute(im,[2 1 3]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write out data file.

fid = fopen( file, 'w' );

% Write out header information.

fprintf( fid, '#?RADIANCE\n' );
if bit ==8
    fprintf( fid, ['FORMAT=32-bit_rle_' type '\n']);
else 
    fprintf( fid, ['FORMAT=64-bit_rle_' type '\n']);
end    


if exist('sensor','var')
    writeSensor(fid,sensor);
end

if exist('illuminant','var')
    writeIlluminant(fid,illuminant);
end

fprintf( fid, ['Created by Stanford Programmable Digital Camera Project \n\n']);
fprintf( fid, '-Y %d +X %d\n', sy, sx );

% Write out data information.

tmp_im  = reshape( im, sy*sx, 3 );
tmp_max = max( tmp_im' )';
tmp_max = (tmp_max > 0).*tmp_max + (tmp_max == 0).*(2.^(-129));
exp     = repmat( floor(log2(tmp_max))+1, 1, 3 );

tmp_im  = floor ( tmp_im .* 2.^(bit-exp)  );

if bit ==8
    file_im = uint8 ([tmp_im (exp(:,1)+2^(bit-1))]);
    fwrite( fid, file_im', 'uint8' );
else 
    file_im = uint16 ([tmp_im (exp(:,1)+2^(bit-1))]);
    fwrite( fid, file_im', 'uint16' );
end

fclose( fid );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% function writeSensor(fid, sensor)
%%      Save sensor sensitivity information

function writeSensor(fid, sensor)

for i=1:length(sensor)
    fprintf(fid,'SENSOR=');
    wavelength = sensor(i).wavelength;
    fprintf(fid,'wavelength %d %d %d ',wavelength(1),wavelength(2)-wavelength(1),length(wavelength));
    mmax = max(sensor(i).spectral);
    data = round(sensor(i).spectral/mmax*999);
    fprintf(fid,'maximum %f unit %d ',mmax,999);
    for k=1:length(data)
        fprintf(fid,'%d ',data(k));
    end
    fprintf(fid,'\n');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% function writeIlluminant(fid, illuminant)
%%      Save illumination information

function writeIlluminant(fid, illuminant)

for i=1:length(illuminant)
    fprintf(fid,'ILLUMINANT=');
    wavelength = illuminant(i).wavelength;
    fprintf(fid,'wavelength %d %d %d ',wavelength(1),wavelength(2)-wavelength(1),length(wavelength));
    mmax = max(illuminant(i).spectral);
    data = round(illuminant(i).spectral/mmax*999);
    fprintf(fid,'maximum %f unit %d ',mmax,999);
    for k=1:length(data)
        fprintf(fid,'%d ',data(k));
    end
    fprintf(fid,'\n');
end
