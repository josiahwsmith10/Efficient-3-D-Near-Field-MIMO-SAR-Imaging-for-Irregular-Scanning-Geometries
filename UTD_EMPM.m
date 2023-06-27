% UTD_EMPM - A demo of the Efficient Multiplanar Multistatic (EMPM)
% algorithm for point targets in the shape of the letters UTD for The
% University of Texas at Dallas. 
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
scanner.method = "Linear";
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
[~,freehand.indMax] = max(freehand.S(:));
[freehand.indX,freehand.indY] = ind2sub(freehand.N,freehand.indMax);
freehand.S = freehand.S(freehand.indX,:);
freehand.z_m = 3e-2*(freehand.S-0.5);

scanner.tx.xyz_m(:,3) = freehand.z_m;
scanner.rx.xyz_m(:,3) = freehand.z_m;
scanner.vx.xyz_m(:,3) = freehand.z_m;

scanner.Display();

%% Set Target Parameters
target.isAmplitudeFactor = false;

% Create UTD Pattern
X = [1,1,1,2,3,3,3,5,6,6,6,6,7,9,9,9,9,10,10,11,11]'*15e-3;
X = X - mean(X);
Y = [6,5,4,3,4,5,6,6,6,5,4,3,6,6,5,4,3,6,3,5,4]'*45e-3;
Y = Y - mean(Y);
target.tableTarget = [zeros(size(X)),X,Y + 300e-3,ones(size(X))];

% Which to use
target.isTable = true;
target.isPNG = false;
target.isSTL = false;
target.isRandomPoints = false;

target.Get();

target.Display();
view(target.fig.h,-90,0)
target.fig.h.FontSize = 20;

%% Compute the Beat Signal
target.isGPU = false;
target.Compute();

%% Set Image Reconstruction Parameters and Create RadarImageReconstruction Object
im.nFFTy = 512;
im.nFFTz = 512;

im.yMin_m = -0.1;
im.yMax_m = 0.1;

im.zMin_m = 0.1;
im.zMax_m = 0.5;

im.numY = 200;
im.numZ = 200;

im.isGPU = false;

% Using EMPM emthod from Smith "Efficient 3-D ..." IEEE Access Paper
im.method = "Uniform 1-D SAR 2-D RMA EMPM";

% Using BPA method
% im.method = "1-D SAR 2-D BPA";

im.isMult2Mono = true;
im.zRef_m = 0.355;

% Reconstruct the Image
im.Compute();

% Display the Image
im.dBMin = -15;
im.fontSize = 20;
im.Display();

%% Save All
THzToolboxSaveAll(wav,ant,scanner,target,im,"./results/UTD_EMPM.mat")

%% Load All
[wav,ant,scanner,target,im] = THzToolboxLoadAll("./results/UTD_EMPM.mat");
