% RADREAD: Reads a non-compression Radiance image 
%
% [ IM, SENSOR, ILLUMINANT, TYPE ] = radread( FILE )
%
% Reads in a Radiance RGBE or XYZE image.
%
% Input: 
%   FILE: Filename.
%
% Output:
%   IM  : Image (calibrated)
%   SENSOR: Sensor sensitivity function
%   ILLUMINANT: Illuminant information
%   TYPE: Format.
%         Either 'rgbe' or 'xyze'.
%
%
% Written by: Feng Xiao & Jeffrey DiCarlo
% Modified:   08-24-2002

function [im, sensor, illuminant, type] = radread( file )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Format inputs.

if (nargin < 1)
  	error('First argument is required');
end

im = []; sensor={}; illuminant={}; type={};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read in data file.

% Open the file.

fid = fopen( file, 'r' );

if (fid == -1)
   error('Could not open file specified.');
end

% Read in relevant header information.

[type,bit] = getFormat(fid);
if isempty(type)
    error('Unknown format');
end

sensor = getSensor(fid);
illuminant = getIlluminant(fid);
im = getImageData(fid,bit);
fclose( fid );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read in format of file.

function [type,bit] = getFormat(fid)

type=[];
bit=[];

supported = {'32-bit_rle_rgbe','32-bit_rle_xyze','64-bit_rle_rgbe','64-bit_rle_xyze'};
TYPES = {'rgbe','xyze','rgbe','xyze'};
BITS = [8 8 16 16];

format = getRecord(fid,'FORMAT');

for k=1:length(supported)
    if ~isempty(findstr(format,supported{k}))
        type=TYPES{k};
        bit = BITS(k);
        return;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extract sensor sensitivity function

function sensor = getSensor(fid)

sensor=[];
sensorNo =1;
while 1
    pos = ftell(fid);
    str = getRecord(fid,'SENSOR');
    if isempty(str)
        fseek(fid,pos,'bof');
        return;
    else 
        [name,str] = strtok(str);
        for i=1:3
            [data,str]=strtok(str);
            wave(i)=str2num(data);
        end
        waveNo = wave(3);
        wavelength= wave(1):wave(2):(wave(1)+wave(2)*(waveNo-1));
        [name,str] = strtok(str);
        [maximum,str]=strtok(str);
        maximum = str2num(maximum);
        [name,str] = strtok(str);
        [unit,str] = strtok(str);
        unit = str2num(unit);
        for i=1:waveNo
            [data,str]=strtok(str);
            spectral(i)=str2num(data);
        end
        sensor(sensorNo).wavelength=wavelength;
        sensor(sensorNo).spectral=spectral/unit*maximum;
        sensorNo=sensorNo+1;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extract illumination information

function illuminant = getIlluminant(fid)

illuminant=[];
illumNo =1;
while 1
    pos = ftell(fid);
    str = getRecord(fid,'ILLUMINANT');
    if isempty(str)
        fseek(fid,pos,'bof');
        return;
    else 
        [name,str] = strtok(str);
        for i=1:3
            [data,str]=strtok(str);
            wave(i)=str2num(data);
        end
        waveNo = wave(3);
        wavelength= wave(1):wave(2):(wave(1)+wave(2)*(waveNo-1));
        [name,str] = strtok(str);
        [maximum,str]=strtok(str);
        maximum = str2num(maximum);
        [name,str] = strtok(str);
        [unit,str] = strtok(str);
        unit = str2num(unit);
        for i=1:waveNo
            [data,str]=strtok(str);
            spectral(i)=str2num(data);
        end
        illuminant(illumNo).wavelength=wavelength;
        illuminant(illumNo).spectral=spectral/unit*maximum;
        illumNo=illumNo+1;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extract Radiance Record information

function record = getRecord(fid,name)

maxLine = 20;
record =[];

for i=1:maxLine
    line = fgets( fid );
    if (strncmp( line, name,length(name) ) == 1)
        index = findstr(line,'=');
        if ~isempty(index)
            record = line(index+1:end);
            return;
        end
        return;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read in Radiance RGBE data

function im=getImageData(fid,bit)

line=fgets(fid);
while length(line)~=1
    line=fgets(fid);
end

line = fgets( fid );
locY = findstr(line,'-Y');
locX = findstr(line,'+X');

if (sum(size(locY)) == 0 | sum(size(locX)) == 0)
   error('Only support data in the -Y +X direction.');
end

strsiz = [ line((locY+3):(locX-1)) ...
           line((locX+3):(length(line)-1)) ];
numsiz = str2num(strsiz);

% Read in the data.

if bit ==8
    [file_im len] = fread( fid, inf, 'uint8' );
else 
    [file_im len] = fread( fid, inf, 'uint16' );
end

if (len ~= (prod(numsiz)*4))
   error('Incorrect format.  Use the flat format.');
end

file_im = reshape( file_im, 4, prod(numsiz) )';
tmp_im  = (file_im(:,1:3)./2^bit).*repmat( 2.^(file_im(:,4)-2^(bit-1)), 1, 3 );
im      = reshape(tmp_im, numsiz(2), numsiz(1), 3);

im = permute(im,[2 1 3]);
