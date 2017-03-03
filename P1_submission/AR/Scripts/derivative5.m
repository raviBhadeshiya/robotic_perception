function varargout = derivative5(im, varargin)

    varargin = varargin(:);
    varargout = cell(size(varargin));
    
    % Check if we are just computing 1st derivatives.  If so use the
    % interpolant and derivative filters optimized for 1st derivatives, else
    % use 2nd derivative filters and interpolant coefficients.
    % Detection is done by seeing if any of the derivative specifier
    % arguments is longer than 1 char, this implies 2nd derivative needed.
    secondDeriv = false;    
    for n = 1:length(varargin)
        if length(varargin{n}) > 1
            secondDeriv = true;
            break
        end
    end
    
    if ~secondDeriv
        % 5 tap 1st derivative cofficients.  These are optimal if you are just
        % seeking the 1st deriavtives
        p = [0.037659  0.249153  0.426375  0.249153  0.037659];
        d1 =[0.109604  0.276691  0.000000 -0.276691 -0.109604];
    else         
        % 5-tap 2nd derivative coefficients. The associated 1st derivative
        % coefficients are not quite as optimal as the ones above but are
        % consistent with the 2nd derivative interpolator p and thus are
        % appropriate to use if you are after both 1st and 2nd derivatives.
        p  = [0.030320  0.249724  0.439911  0.249724  0.030320];
        d1 = [0.104550  0.292315  0.000000 -0.292315 -0.104550];
        d2 = [0.232905  0.002668 -0.471147  0.002668  0.232905];
    end

    % Compute derivatives.  Note that in the 1st call below MATLAB's conv2
    % function performs a 1D convolution down the columns using p then a 1D
    % convolution along the rows using d1. etc etc.
    gx = false;
    
    for n = 1:length(varargin)
      if strcmpi('x', varargin{n})
          varargout{n} = conv2(p, d1, im, 'same');    
          gx = true;   % Record that gx is available for gxy if needed
          gxn = n;
      elseif strcmpi('y', varargin{n})
          varargout{n} = conv2(d1, p, im, 'same');
      elseif strcmpi('xx', varargin{n})
          varargout{n} = conv2(p, d2, im, 'same');    
      elseif strcmpi('yy', varargin{n})
          varargout{n} = conv2(d2, p, im, 'same');
      elseif strcmpi('xy', varargin{n}) | strcmpi('yx', varargin{n})
          if gx
              varargout{n} = conv2(d1, p, varargout{gxn}, 'same');
          else
              gx = conv2(p, d1, im, 'same');    
              varargout{n} = conv2(d1, p, gx, 'same');
          end
      else
          error(sprintf('''%s'' is an unrecognized derivative option',varargin{n}));
      end
    end
    