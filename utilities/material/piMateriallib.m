function [materiallib] = piMateriallib
% Not sure whether we will use this anymore --Zhenyi
% A library of material properties (deprecated)
%
% Syntax:
%  materiallib = piMaterialib;
%
% Brief description:
%  All of the material definitions that we use in ISET3d are
%  represented in the materiallib.  This function creates the material
%  lib with the specific parameters for each type of material.
%
% Inputs:
%  N/A
%
% Outputs:
%  materiallib:  A structure with the different material definitions
%
% Description:
%
%  The PBRT material properties include the specular and diffuse and
%  transparency material properties.  The parameters to achieve these
%  effects are stored in this library for about a dozen different
%  material types.  The definitions of the slots are defined on the
%  PBRT web-site (https://www.pbrt.org/fileformat-v3.html#materials)
%
%  For the imported Cinema 4D scenes we know the material types of
%  each part, and ISET3d specifies in the recipe for each object an
%  object-specific name and a material type.  The reflectance and
%  other material properties are stored in this material library.
%
%  For example, if we want a particular part to look like, say
%  carpaint, we assign the materiallib.carpaint properties to that
%  object.
%
% Zhenyi Liu Scien Stanford, 2018
%
% See also
%   piMaterial*


% Examples:
%{

%}

%% carpaintmix
%
% A mixture of a specular (mirror like) material and a substrate
% material that looks like a car.

materiallib.carpaintmix.paint_mirror.stringtype = 'mirror';
materiallib.carpaintmix.paint_mirror.rgbkr = [.1 .1 .1];
materiallib.carpaintmix.paint_base.stringtype='substrate';
materiallib.carpaintmix.paint_base.colorkd = piColorPick('random');
materiallib.carpaintmix.paint_base.colorks =[.1 .1 .1];
materiallib.carpaintmix.paint_base.floaturoughness=0.01;
materiallib.carpaintmix.paint_base.floatvroughness=0.01;
materiallib.carpaintmix.carpaint.stringtype = 'mix';
materiallib.carpaintmix.carpaint.amount = 0.5;
materiallib.carpaintmix.carpaint.stringnamedmaterial1 = 'paint_mirror';
materiallib.carpaintmix.carpaint.stringnamedmaterial2 = 'paint_base';

% materiallib.carpaintmix.paint_mirror=piMaterialCreate('paint_mirror', ...
%     'type', 'mirror', ...
%     'kr value', [0.1 0.1 0.1]);
% materiallib.carpaintmix.paint_base = piMaterialCreate
%% carpaint
%
% Typical car paint without much specularity.  Some people define it
% this way rather than as carpaintmix.
%

materiallib.carpaint.stringtype='substrate';
materiallib.carpaint.rgbkd = piColorPick('random');
materiallib.carpaint.rgbks =[.15 .15 .15];
materiallib.carpaint.floaturoughness =0.0005;
materiallib.carpaint.floatvroughness=0.00051;

%% silver
%
% This the chrome metal appearance.
%
materiallib.silver_measured.type='measured';
materiallib.silver_measured.filename='spds/ilm_l3_37_metallic_spec.bsdf';

materiallib.silver.type='coateddiffuse';
materiallib.silver.reflectance = [ 0.64 0.64 0.64 ];
materiallib.silver.eta =1;
materiallib.silver.roughness = 0.075;

%% blackrubber

% Good for tires
materiallib.blackmat.type = 'coateddiffuse';
materiallib.blackmat.reflectance = [ 0.03 0.03 0.032 ];
materiallib.blackmat.eta = 1.3;
materiallib.blackmat.roughness = 5.8;

%% mirror

materiallib.mirror.type      ='conductor';
materiallib.mirror.roughness = 0;
materiallib.mirror.eta       = 'metal-Ag-eta';
materiallib.mirror.k         = 'metal-Ag-k';

%% matte

% Standard matte surface.  Only diffuse.
materiallib.matte.stringtype = 'diffuse';

%% plastic

% Standard plastic appearance
%
materiallib.plastic.stringtype = 'plastic';
materiallib.plastic.rgbkd = [0.25 0.25 0.25];
materiallib.plastic.rgbks = [0.25 0.25 0.25];
materiallib.plastic.floatroughness = 0.1;

%% glass
% Standard glass appearance
materiallib.glass_measured.type = 'dielectric';
materiallib.glass_measured.eta  = 'glass-BK7';
%% normal glass
materiallib.glass.type = 'dielectric';
materiallib.glass.eta  = '1.3';

%% Retroreflective

% materiallib.retroreflective.stringtype = 'retroreflective';

%% Uber
%{
materiallib.uber.stringtype = 'uber';

%% translucent

materiallib.translucent.stringtype = 'translucent';
materiallib.translucent.colorreflect = [0.5 0.5 0.5];
materiallib.translucent.colortransmit = [0.5 0.5 0.5];

%% Human skin

% Human skin is assigned this material.
materiallib.skin.stringtype = 'kdsubsurface';
% The mean free path--the average distance light travels in the medium before scattering.
% mfp = inverse sigma_t value of Jensen's skin1 parameters (in meters)
materiallib.skin.colormfp = [1.2953e-03 9.5238e-04 6.7114e-04];
materiallib.skin.floaturoughness = 0.05;
materiallib.skin.floateta = 1.333;
materiallib.skin.floatvroughness = 0.05;
materiallib.skin.boolremaproughness = 'false';

%% TotalReflect
materiallib.totalreflect = piMaterialCreate('totalReflect',...
                            'type', 'diffuse', 'spectrum reflectance', [400 1 800 1]);

%%

% materiallib_updated = piMaterialEmptySlot(materiallib);
%}
end
function materiallib = piMaterialEmptySlot(materiallib)
% Empty the unused material slot for certain type of material, for example,
% mirror is only defined by reflectivity, since the default material
% includes values for unused parameters, in this case, we should empty the
% slots except Kr(reflectivity) to avoid errors when rendering.
thisMaterial = fieldnames(materiallib);
for ii = 1: length(thisMaterial)
    if isfield(materiallib.(thisMaterial{ii}), 'string')
    switch materiallib.(thisMaterial{ii}).stringtype
        case 'glass'
            materiallib.(thisMaterial{ii}).floatroughness = [];
            materiallib.(thisMaterial{ii}).rgbkr = [];
            materiallib.(thisMaterial{ii}).rgbks = [];
            materiallib.(thisMaterial{ii}).rgbkd = [];
            materiallib.(thisMaterial{ii}).rgbkt = [];
        case 'metal'
            materiallib.(thisMaterial{ii}).floatroughness = [];
            materiallib.(thisMaterial{ii}).rgbkr = [];
            materiallib.(thisMaterial{ii}).rgbks = [];
            materiallib.(thisMaterial{ii}).rgbkd = [];
            materiallib.(thisMaterial{ii}).rgbkt = [];
        case 'mirror'
            materiallib.(thisMaterial{ii}).floatroughness = [];
            materiallib.(thisMaterial{ii}).rgbkr = [];
            materiallib.(thisMaterial{ii}).rgbks = [];
            materiallib.(thisMaterial{ii}).rgbkd = [];
            materiallib.(thisMaterial{ii}).rgbkt = [];
        case 'skin'
            materiallib.(thisMaterial{ii}).floatroughness = [];
            materiallib.(thisMaterial{ii}).rgbkr = [];
            materiallib.(thisMaterial{ii}).texturekr = [];
            materiallib.(thisMaterial{ii}).texturebumpmap = [];
            materiallib.(thisMaterial{ii}).rgbkt = [];
            materiallib.(thisMaterial{ii}).stringnamedmaterial1 = [];
            materiallib.(thisMaterial{ii}).stringnamedmaterial2 = [];
        case 'fourier'
            materiallib.(thisMaterial{ii}).floatroughness = [];
            materiallib.(thisMaterial{ii}).rgbkr = [];
            materiallib.(thisMaterial{ii}).rgbks = [];
            materiallib.(thisMaterial{ii}).rgbkd = [];
            materiallib.(thisMaterial{ii}).rgbkt = [];
        case 'translucent'
            materiallib.(thisMaterial{ii}).floatroughness = [];
            materiallib.(thisMaterial{ii}).rgbkr = [];
            materiallib.(thisMaterial{ii}).rgbkt = [];
        case 'mix'
            materiallib.(thisMaterial{ii}).floatroughness = [];
            materiallib.(thisMaterial{ii}).rgbkr = [];
            materiallib.(thisMaterial{ii}).rgbks = [];
            materiallib.(thisMaterial{ii}).rgbkd = [];
            materiallib.(thisMaterial{ii}).rgbkt = [];
    end
    else
        continue
    end
end
end
