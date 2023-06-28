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

% Show a random scanning pattern
freehand.N = [256,256]; % size in pixels of image
freehand.F = 3;         % frequency-filter width
[freehand.X,freehand.Y] = ndgrid(1:freehand.N(1),1:freehand.N(2));
freehand.i = min(freehand.X-1,freehand.N(1)-freehand.X+1);
freehand.j = min(freehand.Y-1,freehand.N(2)-freehand.Y+1);
freehand.H = exp(-.5*(freehand.i.^2+freehand.j.^2)/freehand.F^2);
freehand.S = real(ifft2(freehand.H.*fft2(randn(freehand.N))));
freehand.S = freehand.S - min(freehand.S(:));
freehand.S = freehand.S/max(freehand.S(:));
freehand.z_m = 3e-2*(freehand.S-0.5);
freehand.x_m = 1e-3*(-127:128);
[freehand.x_m,freehand.y_m] = ndgrid(freehand.x_m,freehand.x_m);

figure
scatter3(freehand.x_m,freehand.y_m,freehand.z_m,'k')
title("Freehand Scanning Pattern")

cd(string(fileparts(which('cutout_EMPM.m'))));
addpath(genpath("results"));

disp("Opening Efficient 3-D Near-Field MIMO-SAR Imaging for Irregular Scanning Geometries");