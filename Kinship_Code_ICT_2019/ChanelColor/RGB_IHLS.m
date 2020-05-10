function J = RGB_IHLS(I,varargin);
%Improved HLS color space transformation.
%   RGB_IHLS converts RGB truecolor images to YSH (Luminance Saturation
%   Hue) images with:
%       Y = 0.2126*R + 0.7152*G + 0.0722*B ;
%       S = max(R,G,B) - min(R,G,B) ;
%       H = 0 if R=G=B,
%       H = acos((R - 0.5*G - 0.5*B)) / ((R^2 + G^2 + B^2 - R*G - R*B - G*B)^0.5) if B<=G,
%       H = 2*pi - acos((R - 0.5*G - 0.5*B)) / ((R^2 + G^2 + B^2 - R*G - R*B - G*B)^0.5) if B>G.
%
%   YSH = RGB_IHLS(RGB) converts the RGB color image to the YSH
%   color image using an independent coding scheme (default).
%
%	YSH = RGB_IHLS(RGB,CODING_SCHEME) uses different coding schemes.
%   CODING_SCHEME is a string that can have one of these values:
%
%       'ind'       converts the RGB truecolor image to a YSH uint8 image
%                   using an independent coding scheme (default).
%
%       'double'    converts the RGB truecolor image to a YSH double
%                   image.
%
%   Class Support
%   -------------
%   The input image must be uint8.
%   The output image is uint8 or double depending on the used coding scheme.
%
%   Example
%   -------
%       RGB = imread('mire.tif');
%       YSH = RGB_IHLS(RGB);
%       figure, imshow(YSH);
%
%   References
%   ----------
%   [1] A. Hanbury and J. Serra, "A 3D-polar coordinate colour
%       representation well adapted to image analysis", Lecture Notes in
%       Computer Science, vol. 2749, pp. 112-125, 2003.
%   [2] N. Vandenbroucke and L. Macaire and J.-G. Postaire, "Color systems
%       coding for color image processing", in proceedings of the
%       International Conference on Color in Graphics and Image Processing,
%       pp. 180-185, 2000.
%
%   See also RGB_HSV, RGB_HLS, RGB_ISH.

if nargin < 1, error('Not enough input arguments.'); end

if((ndims(I) ~= 3) | (~isa(I,'uint8')))
    error('No 8 bits unsigned integer color image!\n Please use a 8 bits unsigned integer color image...');
end

J = zeros(size(I));

R = double(I(:,:,1));
G = double(I(:,:,2));
B = double(I(:,:,3));

% Luminance
C1 = 0.2126*R + 0.7152*G + 0.0722*B;

% Saturation
C2 = max(max(R,G),B) - min(min(R,G),B); % if R=G=B, then C2=0

% Hue
C3 = acos((R - 0.5*G - 0.5*B) ./ ((R.^2 + G.^2 + B.^2 - R.*G - R.*B - G.*B).^0.5));
C3(B>G) = 2*pi - C3(B>G);
C3(~C2) = 0;

J(:,:,1) = C1;
J(:,:,2) = C2;
J(:,:,3) = 255*C3/(2*pi);
J = uint8(J);

if (~isempty(varargin))
    switch varargin{1}
        case 'double'
            J = double(J);
            J(:,:,1) = C1/255;
            J(:,:,2) = C2/255;
            J(:,:,3) = C3;
        otherwise
            error(['Last argument' ' "' varargin{1} '" ' 'not recognized.'])
    end
end
