% This program loads travelport xml response data and does various
% procesing on it.
% This was made as part of a 2017 college hackathon
%
%     Copyright (C) 2017  Alec Graves
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
dataDir = 'Travelport Hackathon Data';

%% Initial data access and exploration

%  Grab an example file
exStruct = xml2struct(exFile);
%%

exFile = fullfile( 'Travelport Hackathon Data' , 'roundtrip_den-ord',...
            'response', 'response_2017-06-16.xml');

origFileSize = dir(exFile); origFileSize = origFileSize.bytes

childLengths = arrayfun(@(x) numel(x.Children), exStruct.Children);

numOffers = sum(childLengths == 4)

flightDescriptions = numel(exStruct.Children(end).Children)

save('exStruct.mat', '-struct', 'exStruct');
matlabFileSize = dir('exStruct.mat'); matlabFileSize = matlabFileSize.bytes


% convert to bits
matlabFileSize = matlabFileSize*8
origFileSize = origFileSize*8

x = 0.3:0.001:7;
origTimes = origFileSize./[x.*1e6];
matlabTimes = matlabFileSize./[x.*1e6];

plot(x, origTimes)
hold on;
plot(x, matlabTimes)


%% functions

function [xmlFileNames] = getxmls()
end