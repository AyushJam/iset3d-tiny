function modifiedBranch = piAssetScale(thisR, assetInfo, scaleFactor, varargin)
%% Scale the size of an asset
%
% Synopsis:
%   piAssetScale(thisR, assetInfo, scaleFactor, varargin)
%
% Brief description:
%   Scale an asset size.
%
% Inputs:
%   thisR       - recipe.
%   assetInfo   - asset name or id
%   rotation    - scaling vector [x-axis, y-axis, z-axis] (deg)
%
% Returns:
%   newBranch       - modified recipe.
%
% Description:
%   If the asset is a branch node, insert a new branch node with the
%   scaling below.
%
%   If the asset is an object or light, insert a branch node representing
%   the scaling between the node and its parent.
%
% ZL, Vistasoft Team, 2018
% ZLY, Vistasoft Team, 2020
%
% See also
%   piAsset*
%

% Example:
%{
ieInit;
thisR = piRecipeDefault('scene name', 'Simple scene');
% thisR.show;
piWRS(thisR);

assetName = '0014ID_figure_3m_B';
thisR.set('asset', assetName, 'scale', 1.5);
% thisR.show;
piWRS(thisR);
%}
%% Parse input
p = inputParser;
p.addRequired('thisR', @(x)isequal(class(x),'recipe'));
p.addRequired('assetInfo', @(x)(ischar(x) || isscalar(x)));
p.addRequired('scaleFactor', @isvector);
p.parse(thisR, assetInfo, scaleFactor, varargin{:});

%%
% If assetInfo is a name, find the id
if ischar(assetInfo)
    assetInfo = piAssetFind(thisR.assets, 'name', assetInfo);
    if isempty(assetInfo)
        warning('Could not find an asset with name %s:', assetInfo);
        return;
    end
end

thisNode = thisR.assets.get(assetInfo);

%%
if isempty(thisNode)
    warning('Could not find an asset with name %d:', assetInfo);
    return;
end

% If a scalar, turn into a 3 vector
if numel(scaleFactor) == 1
    scaleFactor = repmat(scaleFactor,1,3);
end

if isequal(thisNode.type, 'branch')
    % Insert the scale factor into the existing scale factor cell array,
    % and store the order
    thisNode.scale{end+1} = scaleFactor;
    thisNode.transorder(end+1) = 'S';
    [~, modifiedBranch] = thisR.set('asset', assetInfo, thisNode);
else
    parentNodeID = thisR.assets.getparent(assetInfo);
    modifiedBranch = piAssetScale(thisR, parentNodeID, scaleFactor);
end

%{
newBranch = piAssetCreate('type', 'branch');
newBranch.name   = strcat(thisR.assets.stripID(assetID), '_', 'S');
newBranch.scale = scaleFactor;

if isequal(thisNode.type, 'branch')
    % The node sent in is a branch node.  Get a list of the ids of its
    % children
    childID = thisR.assets.getchildren(assetID);

    % Add the new node, which is also a branch, as child of the input branch
    % node.
    thisR.set('asset', thisNode.name, 'add', newBranch);

    % Set the children of the original branch node will now be children of
    % this new branch node
    for ii=1:numel(childID)
        thisR.set('asset', childID(ii), 'parent',...
                thisR.get('asset', thisR.assets.nnodes, 'name'));
    end
else
    % The node sent in is an object or light.  We create a new node between
    % thisNode and its parent.
    thisR.set('asset', assetID, 'insert', newBranch);
end
%}
end
