% cutout_EMPM - A demo of the Efficient Multiplanar Multistatic (EMPM)
% algorithm for a solid target of a metal sheet with shapes cutout. 
%
% Copyright (C) 2023 Josiah W. Smith
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.

%% Include Necessary Directories
addpath(genpath("../THz and Sub-THz Imaging Toolbox"))
addpath(genpath("./"))

%% Create the Objects
wav = THzWaveformParameters();
ant = THzAntennaArray(wav);
scanner = THzScanner(ant);
target = THzTarget(wav,ant,scanner);
im = THzImageReconstruction(wav,ant,scanner,target);

%% Set Waveform Parameters
wav.Nk = 32;
wav.f0 = 77e9;
wav.fS = 2000e3;
wav.fC = 79*1e9;
wav.B = 4e9;
wav.Compute();

%% Set Antenna Array Properties
ant.isEPC = false;
ant.z0_m = 0;
% Large MIMO Array
ant.tableTx = [
    0   0   1.5   5   1
    0   0   3.5   5   1];
ant.tableRx = [
    0   0   0   0   1
    0   0   0.5 0   1
    0   0   1   0   1
    0   0   1.5 0   1];
ant.Compute();
ant.Display();

%% Set Scanner Parameters
scanner.method = "Rectilinear";
scanner.xStep_m = wav.lambda_m/8;
scanner.numX = 512;
scanner.yStep_m = wav.lambda_m*2;
scanner.numY = 32;

scanner.Compute();

% Sample z-planes from normal distribution around 0
freehand.z_m = 1e-2*randn(size(scanner.tx.xyz_m(:,3)));

% Use "planned" motion
freehand.N = [512,256]; % size in pixels of image
freehand.F = 3;         % frequency-filter width
[freehand.X,freehand.Y] = ndgrid(1:freehand.N(1),1:freehand.N(2));
freehand.i = min(freehand.X-1,freehand.N(1)-freehand.X+1);
freehand.j = min(freehand.Y-1,freehand.N(2)-freehand.Y+1);
freehand.H = exp(-.5*(freehand.i.^2+freehand.j.^2)/freehand.F^2);
freehand.S = real(ifft2(freehand.H.*fft2(randn(freehand.N))));
freehand.S = freehand.S - min(freehand.S(:));
freehand.S = freehand.S/max(freehand.S(:));
freehand.z_m = reshape(3e-2*(freehand.S-0.5),[],1);

scanner.tx.xyz_m(:,3) = freehand.z_m;
scanner.rx.xyz_m(:,3) = freehand.z_m;
scanner.vx.xyz_m(:,3) = freehand.z_m;

scanner.Display();

%% Set Target Parameters
target.isAmplitudeFactor = true;

target.png.fileName = 'cutout2.png';
target.png.xStep_m = 5e-4;
target.png.yStep_m = 5e-4;
target.png.xOffset_m = 0;
target.png.yOffset_m = 0;
target.png.zOffset_m = 0.3;
target.png.reflectivity = 1;
target.png.downsampleFactor = 1;

% Which to use
target.isTable = false;
target.isPNG = true;
target.isSTL = false;
target.isRandomPoints = false;

target.Get();

% Display the target
target.Display();

%% Compute the Beat Signal
target.isGPU = false;
target.Compute();

%% Set Image Reconstruction Parameters and Create RadarImageReconstruction Object
im.nFFTx = 512;
im.nFFTy = 512;
im.nFFTz = 512;

im.xMin_m = -0.05;
im.xMax_m = 0.05;

im.yMin_m = -0.05;
im.yMax_m = 0.05;

im.zMin_m = 0.25;
im.zMax_m = 0.35;

im.numX = 400;
im.numY = 400;
im.numZ = 4;

im.isGPU = false;
im.zSlice_m = 0.3; % Use if reconstructing a 2-D image
% im.method = "Uniform 2-D SAR 2-D FFT";
im.method = "Uniform 2-D SAR 2-D FFT EMPM";
% im.method = "Uniform 2-D SAR 3-D RMA";
% im.method = "Uniform 2-D SAR 3-D RMA EMPM";

im.isMult2Mono = true;
im.zRef_m = 0.3;

% Reconstruct the Image
im.Compute();

% Display the Image
im.dBMin = -10;
im.fontSize = 25;
im.Display();

%% Save All
THzToolboxSaveAll(wav,ant,scanner,target,im,"./results/cutout_EMPM.mat")

%% Load All
[wav,ant,scanner,target,im] = THzToolboxLoadAll("./results/cutout_EMPM.mat");
