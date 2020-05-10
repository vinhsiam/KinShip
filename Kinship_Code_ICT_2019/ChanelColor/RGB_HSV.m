function J = RGB_HSV(I,varargin);
%Hexcone model transformation.
%   RGB_HSV converts RGB truecolor images to HSV (Hue Saturation Value)
%   images with:
%       V = max(R,G,B) ;
%       S = 0 if V=0,
%       S = (max(R,G,B) - min(R,G,B)) / max(R,G,B) ;
%       H = 0 if V=R=G=B,
%       H = (G-B)/(max(R,G,B)-min(R,G,B)) if V=R,
%       H = 2 + (B-R)/(max(R,G,B)-min(R,G,B)) if V=G,
%       H = 4 + (R-G)/(max(R,G,B)-min(R,G,B)) if V=B,
%       H = 6 + H if H<0.
%
%   HSV = RGB_HSV(RGB) converts the RGB color image to the HSV
%   color image using an independent coding scheme (default).
%
%	HSV = RGB_HSV(RGB,CODING_SCHEME) uses different coding schemes.
%   CODING_SCHEME is a string that can have one of these values:
%
%       'ind'       converts the RGB truecolor image to a HSV uint8 image
%                   using an independent coding scheme (default).
%
%       'double'    converts the RGB truecolor image to a RGB_HSV double
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
%       HSV = RGB_HSV(RGB);
%       figure, imshow(HSV);
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
%   See also RGB_IHLS, RGB_HLS, RGB_ISH.

if nargin < 1, error('Not enough input arguments.'); end

if((ndims(I) ~= 3) | (~isa(I,'uint8')))
    error('No 8 bits unsigned integer color image!\n Please use a 8 bits unsigned integer color image...');
end

J = zeros(size(I));

R = double(I(:,:,1));
G = double(I(:,:,2));
B = double(I(:,:,3));

D = max(max(R,G),B) - min(min(R,G),B); % if R=G=B, then D=0

% Value
C1 = max(max(R,G),B);

% Saturation
C2 = D ./ C1;
C2(~C1) = 0;

% Hue
C3 = zeros(size(C1));
C3(C1==R) = (G(C1==R) - B(C1==R)) ./ D(C1==R);
C3(C1==G) = 2 + (B(C1==G) - R(C1==G)) ./ D(C1==G);
C3(C1==B) = 4 + (R(C1==B) - G(C1==B)) ./ D(C1==B);
C3(C3<0) = 6 + C3(C3<0);
C3(~D) = 0;

J(:,:,1) = C1;
J(:,:,2) = 255*C2;
J(:,:,3) = 255*C3/6;
J = uint8(J);

if (~isempty(varargin))
    switch varargin{1}
        case 'double'
            J = double(J);
            J(:,:,1) = C1/255;
            J(:,:,2) = C2;
            J(:,:,3) = 2*pi*C3/6;
        otherwise
            error(['Last argument' ' "' varargin{1} '" ' 'not recognized.'])
    end
end
