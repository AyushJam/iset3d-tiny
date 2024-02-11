function newMat = parseBlockMaterial(currentLine)
% Parse a line in a scene pbrt file to interpret the material
%
% See also
%

%
thisLine = strrep(currentLine,'[','');
thisLine = strrep(thisLine,']','');
if iscell(thisLine)
    thisLine = thisLine{1};
end

% Substitute the spaces in material name with _
dQuotePos = strfind(thisLine, '"');
thisLine(dQuotePos(1):dQuotePos(2)) = strrep(thisLine(dQuotePos(1):dQuotePos(2)), ' ', '_');

% Continue processing
thisLine = strsplit(thisLine, {' "', '" ', '"', '  '});
switch thisLine{1}
    case 'Material'
        matName = '';
        matType = thisLine{2};
    case 'MakeNamedMaterial'
        matName = thisLine{2};
        matType = piParameterGet(currentLine,'string type');
end
newMat = piMaterialCreate(matName, 'type', matType);

% Split the text line with ' "', '" ' and '"' to get key/val pair

thisLine = thisLine(~cellfun('isempty',thisLine));

% For strings 3 to the end, parse
for ss = 3:2:numel(thisLine)-1
    % Get parameter type and name
    keyTypeName = strsplit(thisLine{ss}, ' ');
    keyType = ieParamFormat(keyTypeName{1});
    keyName = ieParamFormat(keyTypeName{2});

    if piContains(keyName,'.')
        keyName = strrep(keyName,'.','');
    end

    % Some corner cases
    % "index" should be replaced with "eta"
    switch keyName
        case 'index'
            keyName = 'eta';
    end

    switch keyType
        case {'string', 'texture'}
            if ~strcmp(keyName, 'materials')
                thisVal = thisLine{ss + 1};
            else
                thisVal = {thisLine{ss+1},thisLine{ss+2}};
            end
        case {'float', 'rgb', 'color', 'photolumi'}
            % Parse a float number from string
            % str2num can convert string to vector. str2double can't.
            thisVal = str2num(thisLine{ss + 1});
        case {'spectrum'}
            [~, ~, e] = fileparts(thisLine{ss + 1});
            if isequal(e, '.spd')
                % Is a file
                thisVal = thisLine{ss + 1};
            else
                % Is vector
                thisVal = str2num(thisLine{ss + 1});
            end
        case 'bool'
            if isequal(strrep(thisLine{ss + 1},' ',''), 'true')
                thisVal = true;
            elseif isequal(strrep(thisLine{ss + 1},' ',''), 'false')
                thisVal = false;
            end
        case ''
            continue
        otherwise
            warning('Could not resolve the parameter type: %s', keyType);
            continue;
    end

    newMat = piMaterialSet(newMat, sprintf('%s value', keyName),...
        thisVal);

end
end
