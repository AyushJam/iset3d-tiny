function r = piRotationMatrix(varargin)
% The representation of the rotation matrix used to specify assets and
% camera rotations
%
% Syntax:
%     r = piRotationMatrix(varargin)
%
% This parameterization is not a mathematical rotation matrix.  It is a
% matrix used by PBRT.  See piRotate if you want to get a genuine 3D
% rotation matrix.
%
% Input
%   N/A
%
% Key/value pairs
%   xaxis - rotation in degrees
%   yaxis - same
%   zaxis - same
%
% Output
%  The default rotation matrix is a 4x4 that includes the rotation
%  terms and an affine term
%
% See also:
%   piDCM2angle, piGeometryRead, piRotate

% Examples:
%{
  r = piRotationMatrix;
%}
%{
  r = piRotationMatrix('zrot',10);
%}
%{
  r = piRotationMatrix('zrot',10,'yrot',2,'xrot',1);
%}
%%
varargin = ieParamFormat(varargin);

p = inputParser;
p.addParameter('xrot',0,@isscalar);
p.addParameter('yrot',0,@isscalar);
p.addParameter('zrot',0,@isscalar);
p.parse(varargin{:});

xRot = p.Results.xrot;
yRot = p.Results.yrot;
zRot = p.Results.zrot;

%% Initial default rotation angle (0,0,0)
r = [
    0     0     0
    0     0     1
    0     1     0
    1     0     0];

%% Set the correct entries

r(1,1) = zRot;
r(1,2) = yRot;
r(1,3) = xRot;

end
