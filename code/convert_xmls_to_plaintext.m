% Convert data to plaintext
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


%% Initial data access and exploration
%find the average response file size:
% find some other information
dataDir = 'Travelport Hackathon Data';

paths = GetResponses(dataDir);


%%  Grab an example file
exFile = fullfile(char(paths(81)));
exStruct = xml2struct(exFile);

origFileSize = dir(exFile); origFileSize = origFileSize.bytes
% save('exStruct.mat', '-struct', 'exStruct');
% matlabFileSize = dir('exStruct.mat'); matlabFileSize = matlabFileSize.bytes

%% exploring
% for i = 1:length(exStruct.Children)
%     disp(exStruct.Children(i).Name)
% end

% names of child nodes:

%1: ctlg-0600:Identifier
%2: ctlg-0600:DefaultCurrency
%3-30: ctlg-0600:Offer (x30)
%31: ctlg-0600:ReferenceListSegment

%id = exStruct.Children(1).Children.Data; % Info 1: user ID 36 chars
%code =  exStruct.Children(2).Attributes(1).Value; % info2: Currency code ('AUD')
% minorUnit = exStruct.Children(2).Attributes(2); %info 3: Currency minor (1 char)

% the offers are next: 4 structs (2 product lists and 1price and one termsandconditions )
% exStruct.Children(3).Children(1)
% length(exStruct.Children)
mkdir('plaintext');
% Save a bunch of xmls as plaintext
for iPath = 1:length(paths)
    path = paths(iPath);
    disp({iPath, path});
    exFile = char(path);
    exStruct = xml2struct(exFile);
    str = RecurSave(exStruct);
    str = str(34:end); % skip the schema URLs
    txtFile = fopen(fullfile( 'plaintext', [char(num2str(iPath)), exFile(end-19:end)]), 'w');
    for i = 1:length(str)
        fwrite(txtFile,str(i));
    end
    fclose(txtFile);
end
 
%% find some other information about the example file
childLengths = arrayfun(@(x) numel(x.Children), exStruct.Children)

numOffers = sum(childLengths == 4)

flightDescriptions = numel(exStruct.Children(end).Children)

%% functions
function [dataArray] = RecurSave(xStruct, inArray)
%RecurSave sorts through an xml struct and makes a list of datas
    if nargin  == 1
        dataArray = [];
    else
        dataArray = inArray;
    end
    if isfield(xStruct,'Attributes') && ~isempty(xStruct.Attributes)
        for iAttr = xStruct.Attributes
            dataArray = RecurSave(iAttr, dataArray);
        end
    end
    if isfield(xStruct,'Children') && ~isempty(xStruct.Children)
        for iChild = xStruct.Children
            dataArray = RecurSave(iChild, dataArray);
        end
    end
    if isfield(xStruct,'Data') && ~isempty(xStruct.Data)
        dataArray = [dataArray string(xStruct.Data)];
    end
    if isfield(xStruct,'Value') && ~isempty(xStruct.Value)
        dataArray = [dataArray string(xStruct.Value)];
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