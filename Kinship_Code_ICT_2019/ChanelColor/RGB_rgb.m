function J = RGB_rgb(I,varargin);
%Normalized RGB color space transformation.
%   RGB_rgb converts RGB truecolor images to rgb images with:
%       r = R / (R + G + B) ; g = G / (R + G + B) ; b = B / (R + G + B),
%       r = g = b = 0 if R+G+B=0.
%
%   rgb = RGB_rgb(RGB) converts the RGB color image to the rgb color image
%   using an independent coding scheme (default).
%
%	rgb = RGB_rgb(RGB,CODING_SCHEME) uses different coding schemes.
%   CODING_SCHEME is a string that can have one of these values:
%
%       'ind'       converts the RGB truecolor image to a rgb uint8 image
%                   using an independent coding scheme (default).
%
%       'double'    converts the RGB truecolor image to a rgb double image.
%
%   Class Support
%   -------------
%   The input image must be uint8.
%   The output image is uint8 or double depending on the used coding scheme.
%
%   Example
%   -------
%       RGB = imread('mire.tif');
%       rgb = RGB_rgb(RGB);
%       figure, imshow(rgb);
%
%   References
%   ----------
%   [1] N. Vandenbroucke and L. Macaire and J.-G. Postaire, "Color systems
%       coding for color image processing", in proceedings of the
%       International Conference on Color in Graphics and Image Processing,
%       pp. 180-185, 2000.
%
%   See also RGB_I1I2I3.

if nargin < 1, error('Not enough input arguments.'); end

if((ndims(I) ~= 3) | (~isa(I,'uint8')))
    error('No 8 bits unsigned integer color image!\n Please use a 8 bits unsigned integer color image...');
end

R = double(I(:,:,1));
G = double(I(:,:,2));
B = double(I(:,:,3));

S = R + G + B;

C1 = R ./ S;
C1(~S) = 0;
C2 = G ./ S;
C2(~S) = 0;
C3 = B ./ S;
C3(~S) = 0;

J(:,:,1) = 255*C1;
J(:,:,2) = 255*C2;
J(:,:,3) = 255*C3;
J = uint8(J);

if (~isempty(varargin))
    switch varargin{1}
        case 'double'
            J = double(J);
            J(:,:,1) = C1;
            J(:,:,2) = C2;
            J(:,:,3) = C3;
        otherwise
            error(['Last argument' ' "' varargin{1} '" ' 'not recognized.'])
    end
end

