% Sb2
% Contact the author: m a i l [at] m i k e t i p p i n g . c o m
%
function SETTINGS = ParameterSettings(varargin)

% Ensure arguments are supplied in pairs
% 
if rem(nargin,2)
  error('Arguments to SB2_ParameterSettings should be (property, value) pairs')
end
% Any settings specified?
numSettings	= nargin/2;

%% Defaults - over-ridden later if requested

% Two options for setting noise level (purely for convenience)
% - if 'beta' set, 'noiseStdDev' will be over-ridden
% 
SETTINGS.beta			= [];
SETTINGS.noiseStdDev	= [];
%
SETTINGS.Relevant	= [];
SETTINGS.Mu			= [];
SETTINGS.Alpha		= [];

%% Requested overrides

% Parse string/variable pairs
for n=1:numSettings
  property_	= varargin{(n-1)*2+1};
  value		= varargin{(n-1)*2+2};
  switch upper(property_)
   case 'BETA',
    SETTINGS.beta			= value;
   case 'NOISESTD',
    SETTINGS.noiseStdDev	= value;
   case 'ALPHA',
    SETTINGS.Alpha			= value;
   case 'WEIGHTS',
    SETTINGS.Mu				= value;
   case 'RELEVANT',
    SETTINGS.Relevant		= value;
   otherwise,
    error('Unrecognised initialisation property: ''%s''\n', property_)
  end
end
