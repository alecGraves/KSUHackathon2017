% plot File transfer Speed Graph
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

% Initial data access and exploration
%find the average response file size:
% find some other information
dataDir = 'Travelport Hackathon Data';

paths = GetResponses(dataDir);
sizes = zeros([1 length(paths)], 'double');

for i = 1:length(paths)
    fileInfo = dir(char(paths(i)));
    sizes(i) = fileInfo.bytes;
end

averageFileSize = sum(sizes)/length(sizes)

[maxFileSize, ~] = max(sizes)

% convert to bits
averageFileSize = averageFileSize*8;

maxFileSize = maxFileSize*8;

% plot download speed vs response download time
x = 0.3:0.001:20;
averageFileSize = averageFileSize./[x.*1e6];
maxFileSize = maxFileSize./[x.*1e6];

p1 = plot(x, averageFileSize);

p1.LineWidth = 2;
p1.LineStyle = '-';
p1.Color = 'k';

p1.Marker = '*';
p1.MarkerSize = 7;
p1.MarkerIndices = FindIdx(x, [0.85, 1, 5.6]);

hold on;

p2 = plot(x, maxFileSize);
p2.LineWidth = 2;
p2.Color = 'r';

p2.Marker = '*';
p2.MarkerSize = 7;
p2.MarkerIndices = FindIdx(x, [0.85, 1, 5.6]);

AddLabel(x, maxFileSize, 0.85,...
     '  \leftarrow 3G', 0);
 
 AddLabel(x, maxFileSize, 1,...
     '  \leftarrow KSU Campus Peak Hours', 0);

AddLabel(x, maxFileSize, 5.6,...
     '  \leftarrow Global Average', 0.05);

 
 tripFolders = dir(dataDir);



title('Response Times vs. Download Speed');
xlabel('Download Speed (Mbps)') % x-axis label
ylabel('Response Download Time (s)') % y-axis label
legend('Avg (95 kb)','Max (165kb)', 'Proposed (15kb)')

 print('ResponseGraphXML.png','-dpng','-r1200');% save image as foo.png

%% functions
function [] = AddLabel(x, y, xval, msg, offset)
    % Add a label at a certain point to a graph
    [~, iMin] = min(abs(x-xval));
    y1 = y(iMin)+offset;
    text(xval, y1, msg);
end

function [idx] = FindIdx(x, xval)
    idx = [];
    for i = 1:length(xval)
        [~, newIdx] = min(abs(x-xval(i)));
        idx = [idx newIdx];
    end
end

function [xmlFileNames] = GetResponses(dataDir)
     xmlFileNames = {};

     tripFolders = dir(dataDir);
     tripFolders = tripFolders(3:end);% skip . and ..

     for iTrip = 1:length(tripFolders) 
         pathName = tripFolders(iTrip).name;
         responsePath = fullfile(dataDir, pathName, 'response');
         responseDir = dir(responsePath);
         responseDir = responseDir(3:end);% skip . and ..

         for iResponseDir = 1:length(responseDir)
             xmlFile = convertCharsToStrings(...
                 fullfile(responsePath,  responseDir(iResponseDir).name));
             xmlFileNames = [xmlFileNames; xmlFile];% save the newly discovered xml file path
         end
     end
end