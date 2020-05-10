function J = RGB_ISH(I,varargin);
%Triangle model transformation.
%   RGB_ISH converts RGB truecolor images to ISH (Brightness Saturation Hue)
%   images with:
%       I = (R + G + B) / 3 ;
%       S = 0 if I=0,
%       S = 1 - 3*(min(R,G,B) / (R + G + B)) ;
%       H = 0 if R=G=B,
%       H = acos((R - 0.5*G - 0.5*B)) / ((R^2 + G^2 + B^2 - R*G - R*B - G*B)^0.5) if B<=G,
%       H = 2*pi - acos((R - 0.5*G - 0.5*B)) / ((R^2 + G^2 + B^2 - R*G - R*B - G*B)^0.5) if B>G.
%
%   ISH = RGB_ISH(RGB) converts the RGB color image to the ISH
%   color image using an independent coding scheme (default).
%
%	ISH = RGB_ISH(RGB,CODING_SCHEME) uses different coding schemes.
%   CODING_SCHEME is a string that can have one of these values:
%
%       'ind'       converts the RGB truecolor image to a ISH uint8 image
%                   using an independent coding scheme (default).
%
%       'double'    converts the RGB truecolor image to a RGB_ISH double
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
%       ISH = RGB_ISH(RGB);
%       figure, imshow(ISH);
%
%   References
%   ----------
%   [1] T.-Y. Shih, "The reversibility of six geometric color spaces",
%       Photogrammetric Engineering and Remote Sensing, vol. 61, nb. 10,
%       pp. 1223-1232, 1995.
%   [2] N. Vandenbroucke and L. Macaire and J.-G. Postaire, "Color systems
%       coding for color image processing", in proceedings of the
%       International Conference on Color in Graphics and Image Processing,
%       pp. 180-185, 2000.
%
%   See also RGB_IHLS, RGB_HLS, RGB_HSV.

if nargin < 1, error('Not enough input arguments.'); end

if((ndims(I) ~= 3) | (~isa(I,'uint8')))
    error('No 8 bits unsigned integer color image!\n Please use a 8 bits unsigned integer color image...');
end

J = zeros(size(I));

R = double(I(:,:,1));
G = double(I(:,:,2));
B = double(I(:,:,3));

D = max(max(R,G),B) - min(min(R,G),B); % if R=G=B, then D=0

% Brightness
C1 = (R + G + B) / 3;

% Saturation
C2 = 1 - (min(min(R,G),B) ./ C1);
C2(~C1) = 0;

% Hue
C3 = acos((R - 0.5*G - 0.5*B) ./ ((R.^2 + G.^2 + B.^2 - R.*G - R.*B - G.*B).^0.5));
C3(B>G) = 2*pi - C3(B>G);
C3((R==G)&(R==B)&(G==B)) = 0;

J(:,:,1) = C1;
J(:,:,2) = 255*C2;
J(:,:,3) = 255*C3/(2*pi);
J = uint8(J);

if (~isempty(varargin))
    switch varargin{1}
        case 'double'
            J = double(J);
            J(:,:,1) = C1/255;
            J(:,:,2) = C2;
            J(:,:,3) = C3;
        otherwise
            error(['Last argument' ' "' varargin{1} '" ' 'not recognized.'])
    end
end
