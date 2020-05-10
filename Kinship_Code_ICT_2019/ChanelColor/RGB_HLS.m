function J = RGB_HLS(I,varargin);
%Double hexcone model transformation.
%   RGB_HLS converts RGB truecolor images to HLS (Hue Lightness Saturation)
%   images with:
%       L = (max(R,G,B) + min(R,G,B)) / 2 ;
%       S = 0 if L=0,
%       S = (max(R,G,B) - min(R,G,B)) / (max(R,G,B) + min(R,G,B)) if L<=0.5,
%       S = (max(R,G,B) - min(R,G,B)) / (2 - max(R,G,B) - min(R,G,B)) if L>0.5;
%       H = 0 if V=R=G=B,
%       H = (G-B)/(max(R,G,B)-min(R,G,B)) if V=R,
%       H = 2 + (B-R)/(max(R,G,B)-min(R,G,B)) if V=G,
%       H = 4 + (R-G)/(max(R,G,B)-min(R,G,B)) if V=B,
%       H = 6 + H if H<0.
%
%   HLS = RGB_HLS(RGB) converts the RGB color image to the HLS
%   color image using an independent coding scheme (default).
%
%	HLS = RGB_HLS(RGB,CODING_SCHEME) uses different coding schemes.
%   CODING_SCHEME is a string that can have one of these values:
%
%       'ind'       converts the RGB truecolor image to a HLS uint8 image
%                   using an independent coding scheme (default).
%
%       'double'    converts the RGB truecolor image to a RGB_HLS double
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
%       HLS = RGB_HLS(RGB);
%       figure, imshow(HLS);
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
%   See also RGB_IHLS, RGB_HSV, RGB_ISH.

if nargin < 1, error('Not enough input arguments.'); end

if((ndims(I) ~= 3) | (~isa(I,'uint8')))
    error('No 8 bits unsigned integer color image!\n Please use a 8 bits unsigned integer color image...');
end

J = zeros(size(I));

R = double(I(:,:,1));
G = double(I(:,:,2));
B = double(I(:,:,3));

S = max(max(R,G),B) + min(min(R,G),B);
D = max(max(R,G),B) - min(min(R,G),B); % if R=G=B, then D=0
M = max(max(R,G),B);

% Lightness
C1 = S / 2;

% Saturation
C2 = zeros(size(C1));
C2(C1<=127.5) = D(C1<=127.5) ./ S(C1<=127.5);
C2(~S) = 0;
C2(C1>127.5) = D(C1>127.5) ./ (510-S(C1>127.5));
C2(~(510-S)) = 0;

% Hue
C3 = zeros(size(C1));
C3(M==R) = (G(M==R) - B(M==R)) ./ D(M==R);
C3(M==G) = 2 + (B(M==G) - R(M==G)) ./ D(M==G);
C3(M==B) = 4 + (R(M==B) - G(M==B)) ./ D(M==B);
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
