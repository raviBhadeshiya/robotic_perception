function [cim, r, c] = harris(im, sigma, k, varargin)
    
    if ~isa(im,'double')
	im = double(im);
    end

    % Compute derivatives and the elements of the structure tensor.
    [Ix, Iy] = derivative5(im, 'x', 'y');
    Ix2 = gaussfilt(Ix.^2,  sigma);
    Iy2 = gaussfilt(Iy.^2,  sigma);    
    Ixy = gaussfilt(Ix.*Iy, sigma);    

    % Compute Harris corner measure. 
    cim = (Ix2.*Iy2 - Ixy.^2) - k*(Ix2 + Iy2).^2; 

    if length(varargin) > 0
        [thresh, radius, N, subpixel, disp] = checkargs(varargin);
        if disp
            [r,c] = nonmaxsuppts(cim, 'thresh', thresh, 'radius', radius, 'N', N, ...
                                 'subpixel', subpixel, 'im', im);
        else
            [r,c] = nonmaxsuppts(cim, 'thresh', thresh, 'radius', radius, 'N', N, ...
                                 'subpixel', subpixel, 'im', []);
        end
    else
        r = [];
        c = [];
    end
    
%---------------------------------------------------------------
function [thresh, radius, N, subpixel, disp] = checkargs(v)
    
    p = inputParser;
    p.CaseSensitive = false;
    
    % Define optional parameter-value pairs and their defaults    
    addParameter(p, 'thresh',       0, @isnumeric);  
    addParameter(p, 'radius',       1, @isnumeric);  
    addParameter(p, 'N',          Inf, @isnumeric);  
    addParameter(p, 'subpixel', false, @islogical);  
    addParameter(p, 'display',  false, @islogical);  

    parse(p, v{:});
    
    thresh   = p.Results.thresh;
    radius   = p.Results.radius;
    N        = p.Results.N;
    subpixel = p.Results.subpixel;
    disp     = p.Results.display;    