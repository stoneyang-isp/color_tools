% create simulated macbeth images at different temperatures/mirad
mired = [118:23.5:400]';
T = cbmired2temp(mired);
T = [cbmired2temp(400-4*23.5)]

for i = 1:length(T)
    temp = T(i);
    %% s_SimulateSystem.m
    %
    % This script introduces how to create the full array of elements that make
    % up the image simulation steps.  The script begins by creating a full
    % spectral scene. The radiance data are passed through the optics to create
    % an irradiance image at the sensor surface.  The irradiance is then
    % captured by a simulated sensor, resulting in an array of output voltages.
    %
    % To learn more about a particular function, type "help function" as in
    % "help sensorCreate".  There are also online descriptions of the functions
    % at http://www.imageval.com/public/Products/ISET/Manual/ISET_Functions.htm
    %
    % Copyright ImagEval Consultants, LLC, 2010.
    
    %% Init
    % We will use this wavelength, which is a bit odd, just to illustrate that
    % we can read everything at the correct wavelengths
    wave = 400:5:710;
    
    %% SCENE
    %
    % There are several ways to create a scene.  One is to use the sceneCreate
    % function.  Two examples are listed here.
    %
    %    scene = sceneCreate('slantedEdge');
    %    scene = sceneCreate('macbeth',32);
    
    % A second method for creating a scene is to read data from a file.  ISET
    % has some files as part of the distribution
    fullFileName = ...
        fullfile('Images','Flowers','MorningGlory','sr506x759','MorningGlory-hdrs.mat');
    scene = sceneFromFile(fullFileName,'multispectral');
%     scene = sceneCreate('macbeth',32);
    
%     patchSize = 8;
    spectrum.wave = (380:4:1068)';
%     scene = sceneCreate('macbethEE_IR',patchSize,spectrum);
    wave = sceneGet(scene,'wave');
    curIlluminant = sceneGet(scene,'illuminant');
    newIlluminant = blackbody(wave,temp);
    % scene = sceneSPDScale(scene,curIlluminant,'divide');
    scene = sceneSPDScale(scene,newIlluminant,'multiply');
    
    % You can also select the file (or many other files) using the command:
    %
    %    fullFileName = vcSelectImage;
    %
    % and navigating to the proper directory and file that contains the scene
    % data.  ISET will interpolate RGB files (such as JPEG files).  The
    % spectral information that it creates, however, is not accurate.
    
    % Once the scene is loaded, you can adjust different properties
    % using the sceneSet command.  Here we adjust the scene mean luminance and
    % field of view.
    scene = sceneAdjustLuminance(scene,200);  % Candelas/m2
    scene = sceneSet(scene,'fov',26.5);       % Set the scene horizontal field of view
    % scene = sceneInterpolateW(scene,wave,1);  % Resample, preserve luminance
    
    % It is often useful to visualize the data in the scene window
    vcAddAndSelectObject('scene',scene); sceneWindow;
    
    % When the window appears, you can scale the window size and adjust the
    % font size as well (Edit | Change Font Size). There are many other options
    % in the pull down menus for cropping, transposing, and measuring scene
    % properties.
    %
    %% OPTICS
    %
    % The next step in the system simulation is to specify the optical image
    % formation process.  The optical image is an important structure, like the
    % scene structure.  We adjust the properties of optical image formation
    % using the oiSet and oiGet routines.
    %
    % The optical image structure contains the irradiance data and a
    % specification of the optics.  The optics itself is so complex that we
    % have created a special optics structure as well that can be manipulated
    % by opticsGet and opticsSet commands.
    %
    % ISET has several optics models that you can experiment with. These
    % include shift-invariant optics, in which there is a different
    % shift-invariant pointspread function for each wavelength, and a ray-trace
    % method, in which we read in data from Zemax and create a shift-variant
    % set of pointspread functions along with a geometric distortion function.
    %
    % The simplest is method of creating an optical image is to use
    % the diffraction-limited lens model.  To create a diffraction-limited
    % optics with an f# of 4, you can call these functions
    
    oi = oiCreate;
    optics = oiGet(oi,'optics');
    optics = opticsSet(optics,'fnumber',4);
    
    % In this example we set the properties of the optics to include cos4th
    % falloff for the off axis vignetting of the imaging lens, and we set the
    % lens focal length to 3 mm.
    optics = opticsSet(optics,'offaxis','cos4th');
    optics = opticsSet(optics,'focallength',3e-3);     % from lens calibration software
    
    % Many other properties can be set as well (type help opticsSet or doc
    % opticsSet).
    
    % We then replace the new optics variable into the optical image structure.
    oi = oiSet(oi,'optics',optics);
    
    % We use the scene structure and the optical image structure to update the
    % irradiance.
    oi = oiCompute(scene,oi);
    
    % We save the optical image structure and bring up the optical image
    % window.
    vcAddAndSelectObject('oi',oi); oiWindow;
    
    % From the window you can see a wide range of options. These include
    % insertion of a birefringent anti-aliasing filter, turning off cos4th
    % image fall-off, adjusting the lens properties, and so forth.
    %
    % You can read more about the optics models by typing "doc opticsGet".
    % You can see an online video about using the ray trace software at:
    %   http://www.imageval.com/public/Products/ISET/ApplicationNotes/ZemaxTutorial.htm
    %
    %% SENSOR
    %
    % There are a very large number of sensor parameters. Here we illustrate
    % the process of creating a simple Bayer-gbrg sensor and setting a few of
    % its basic properties.
    %
    % To create the sensor structure, we call
    sensor = sensorCreate('bayer (gbrg)');
    
    % We set the sensor properties using sensorSet and sensorGet routines.
    %
    % Just as the optical irradiance gives a special status to the optics, the
    % sensor gives a special status to the pixel.  In this section we define
    % the key pixel and sensor properties, and we then put the sensor and pixel
    % back together.
    
    % To get the pixel structure from the sensor we use:
    pixel =  sensorGet(sensor,'pixel');
    
    % Here are some of the key pixel properties
    voltageSwing   = 1.15;  % Volts
    wellCapacity   = 9000;  % Electrons
    conversiongain = voltageSwing/wellCapacity;
    fillfactor     = 0.45;       % A fraction of the pixel area
    pixelSize      = 2.2*1e-6;   % Meters
    darkvoltage    = 1e-005;     % Volts/sec
    readnoise      = 0.00096;    % Volts
    
    % We set these properties here
    pixel = pixelSet(pixel,'size',[pixelSize pixelSize]);
    pixel = pixelSet(pixel,'conversiongain', conversiongain);
    pixel = pixelSet(pixel,'voltageswing',voltageSwing);
    pixel = pixelSet(pixel,'darkvoltage',darkvoltage) ;
    pixel = pixelSet(pixel,'readnoisevolts',readnoise);
    
    %  Now we set some general sensor properties
    exposureDuration = 0.030; % Seconds
    dsnu =  0.0010;           % Volts
    prnu = 0.2218;            % Percent (ranging between 0 and 100)
    analogGain   = 1;         % Used to adjust ISO speed
    analogOffset = 0;         % Used to account for sensor black level
    rows = 466;               % number of pixels in a row
    cols = 642;               % number of pixels in a column
    
    % Set these sensor properties
    sensor = sensorSet(sensor,'exposuretime',exposureDuration);
    sensor = sensorSet(sensor,'rows',rows);
    sensor = sensorSet(sensor,'cols',cols);
    sensor = sensorSet(sensor,'dsnulevel',dsnu);
    sensor = sensorSet(sensor,'prnulevel',prnu);
    sensor = sensorSet(sensor,'analogGain',analogGain);
    sensor = sensorSet(sensor,'analogOffset',analogOffset);
    
    % Stuff the pixel back into the sensor structure
    sensor = sensorSet(sensor,'pixel',pixel);
    sensor = pixelCenterFillPD(sensor,fillfactor);
    
    % It is also possible to replace the spectral quantum efficiency curves of
    % the sensor with those from a calibrated camera.  We include the
    % calibration data from a very nice Nikon D100 camera as part of ISET.
    % To load those data we first determine the wavelength samples for this sensor.
    wave = sensorGet(sensor,'wave');
    
    % Then we load the calibration data and attach them to the sensor structure
    fullFileName = fullfile(isetRootPath,'data','sensor','NikonD100.mat');
    [data,filterNames] = ieReadColorFilter(wave,fullFileName);
    sensor = sensorSet(sensor,'filterspectra',data);
    sensor = sensorSet(sensor,'filternames',filterNames);
    sensor = sensorSet(sensor,'Name','Camera-Simulation');
    
    % We are now ready to compute the sensor image
    sensor = sensorCompute(sensor,oi);
    
    % We can view sensor image in the GUI.  Note that the image that comes up
    % shows the color of each pixel in the sensor mosaic. Also, please be aware
    % that
    %  * The Matlab rendering algorithm often introduces unwanted artifacts
    % into the display window.  You can resize the window to eliminate these.
    %  * You can also set the display gamma function to brighten the appearance
    % in the edit box at the lower left of the window.
    vcAddAndSelectObject('sensor',sensor); sensorImageWindow;
    
    % There are a variety of ways to quantify these data in the pulldown menus.
    % Also, you can view the individual pixel data either by zooming on the
    % image (Edit | Zoom) or by bringing the image viewer tool (Edit | Viewer).
    %
    % Type 'help iexL2ColorFilter' to find out how to convert data from an
    % Excel Spread Sheet to an ISET color filter file or a spectral file/
    %
    % ISET includes a wide array of options for selecting color filters,
    % fill-factors, infrared blocking filters, adjusting pixel properties,
    % color filter array patterns, and exposure modes.
    %% Image Processor
    %
    % The image processing pipeline is managed by the fourth principal ISET
    % structure, the virtual camera image (vci).  This structure allows the
    % user to set a variety of image processing methods, including demosaicking
    % and color balancing.
    vci = vcImageCreate;
    
    % The routines for setting and getting image processing parameters are
    % imageGet and imageSet.
    %
    vci = imageSet(vci,'name',['Unbalanced-' num2str(10^6/temp)]);
    vci = imageSet(vci,'scaledisplay',1);
    vci = imageSet(vci,'renderGamma',0.6);
    
    % The default properties use bilinear demosaicking, no color conversion or
    % balancing.  The sensor RGB values are simply set to the display RGB
    % values.
    vci = vcimageCompute(vci,sensor);
    
    % As in the other cases, we can bring up a window to view the processed
    % data, this time a full RGB image.
    vcAddAndSelectObject(vci); vcimageWindow
    
    % You can experiment by changing the processing parameters in many ways,
    % such as:
    vci2 = imageSet(vci,'name',['More Balanced-' num2str(10^6/temp)])
    vci2 = imageSet(vci2,'internalCS','XYZ');
    vci2 = imageSet(vci2,'colorConversionMethod','MCC Optimized');
%     vci2 = imageSet(vci2,'colorBalanceMethod','Gray World');
    
    % With these parameters, the colors will appear to be more accurate
    vci2 = vcimageCompute(vci2,sensor);
    
    vcAddAndSelectObject(vci2); vcimageWindow
    
    % Again, this window offers the opportunity to perform many parameter
    % changes and to evaluate certain metric properties of the current system.
    % Try the pulldown menu item (Analyze | Create Slanted Bar) and then run
    % the pulldown menu (Analyze | ISO12233) to obtain a spatial frequency
    % response function for the slanted bar image in the ISO standard.
    %
        
end
%% END