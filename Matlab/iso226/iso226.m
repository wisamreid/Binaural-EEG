function [spl,f] = iso226(phon,fq,sq)
% ISO 226:2003 Normal equal-loudness-level contours
% 
%   [spl,f] = iso226(phon)
%   [spl,f] = iso226(phon,fq)
%   ... = iso226(phon,fq,sq)
%   ... = iso226(phon,[],sq)
%   
%   [SPL,F] = ISO226(PHON) returns the sound pressure level
%   (SPL) (dB) of pure tone frequencies F (Hz) at the
%   loudness level(s) PHON. The values are calculated
%   according to ISO 226:2003 using the reference
%   frequencies specified in the standard. According to the
%   standard, PHON is only valid at all frequencies if
%   20<=PHON<80 (although the function will return SPL
%   values outside of this range).
% 
%   PHON may be an array of any size; SPL and F will be of
%   size [1,29,M,N,P,...] where M,N,P,... are the dimensions
%   of PHON.
%
%   [SPL,F] = ISO226(PHON,FQ) returns the SPL of the pure
%   tone frequencies in FQ at the specified loudness
%   level(s). According to the standard, FQ is only valid
%   below 12.5 kHz (although the function will extrapolate
%   SPL values outside of this range).
% 
%   FQ may be an array of any size; SPL and F will be of
%   size [Q,R,S,...,M,N,P,...] where Q,R,S,... are the
%   dimensions of FQ.
%   
%   ... = iso226(phon,fq,sq) specifies whether singleton
%   dimensions will be removed from the output. With
%   sq=false, singleton dimensions will be retained
%   (default), else they will be removed.
% 
%   ... = iso226(phon,[],sq) uses the standard reference
%   frequencies for SPL calculations.
% 
%   Example
% 
%   % Plot equal-loudness contours between 20 and 80 phon
% 
%   % Calculate SPLs
%   phons = 20:10:80;
%   [spl,f] = iso226(phons,[],true);
% 
%   % plot
%   figure; semilogx(f,spl)
%   set(gca,'xlim',[min(f(:)) max(f(:))])
%   legend(num2str(phons'),'location','southwest');
%   title('Equal loudness contours for different loudness levels (in phons)')
%   xlabel('Frequency [Hz]')
%   ylabel('SPL [dB]')
% 
%   See also LOUD_WEIGHT.

% !---
% ==========================================================
% Last changed:     $Date: 2015-04-09 08:46:01 +0100 (Thu, 09 Apr 2015) $
% Last committed:   $Revision: 355 $
% Last changed by:  $Author: ch0022 $
% ==========================================================
% !---

%% Check input

if phon>=80
    warning('SPL values may not be accurate for loudness levels above 80 phon.')
elseif phon<20
    warning('SPL values may not be accurate for loudness levels below 20 phon.')
end

if nargin>1
    if ~isempty(fq)
        if any(fq(:)>12500)
            warning('ISO 226:2003 defines loudness levels up to 12.5 kHz. SPL values for frequencies above 12.5 kHz may be inaccurate.')
        end
        assert(all(fq(:)>=0),'Frequencies must be greater than or equal to 0 Hz.')
    end
else
    fq = [];
end

if nargin<3
    sq = false;
else
    assert(islogical(sq),'sq must be logical.')
end

%% References

% reference frequencies
f_r = [20 25 31.5 40 50 63 80 100 125 160 200 250 315 400 ...
    500 630 800 1000 1250 1600 2000 2500 3150 4000 5000 ...
    6300 8000 10000 12500];

% exponent of loudness perception
alpha_f = [0.532 0.506 0.480 0.455 0.432 0.409 0.387 ...
    0.367 0.349 0.330 0.315 0.301 0.288 0.276 0.267 0.259...
    0.253 0.250 0.246 0.244 0.243 0.243 0.243 0.242 0.242...
    0.245 0.254 0.271 0.301];

% magnitude of linear transfer function normalized at 1 kHz
L_U = [-31.6 -27.2 -23.0 -19.1 -15.9 -13.0 -10.3 -8.1 ...
    -6.2 -4.5 -3.1 -2.0 -1.1 -0.4 0.0 0.3 0.5 0.0 -2.7 ...
    -4.1 -1.0 1.7 2.5 1.2 -2.1 -7.1 -11.2 -10.7 -3.1];

% threshold of hearing
T_f = [78.5 68.7 59.5 51.1 44.0 37.5 31.5 26.5 22.1 17.9...
    14.4 11.4 8.6 6.2 4.4 3.0 2.2 2.4 3.5 1.7 -1.3 -4.2...
    -6.0 -5.4 -1.5 6.0 12.6 13.9 12.3];

%% Calculate

% determine frequency range
if isempty(fq)
    f = f_r;
else
    f = fq;
end

% output size
out_dims = [size(f) size(phon)];

% independent outputs
f_squeeze = zeros(numel(f),numel(phon));
spl_squeeze = zeros(numel(f),numel(phon));

% iterate through phons
for p = 1:numel(phon)
    % calculate reference SPLs
    A_f = 0.00447*((10^(0.025*phon(p)))-1.15)+((0.4*(10.^(((T_f+L_U)./10)-9))).^alpha_f);
    spl_r = ((10./alpha_f).*log10(A_f)) - L_U + 94;
    % frequencies for phon level
    f_squeeze(:,p) = f(:);
    % calculate SPL
    if nargin>1
        spl_squeeze(:,p) = interp1(f_r,spl_r,f_squeeze(:,p),'pchip','extrap');
    else
        spl_squeeze(:,p) = spl_r';
    end
end

% reshape outputs
f = reshape(f_squeeze,out_dims);
spl = reshape(spl_squeeze,out_dims);

% remove singleton dimensions if requested
if sq
    f = squeeze(f);
    spl = squeeze(spl);
end

% [EOF]
