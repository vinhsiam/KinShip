function J = RGB_I1I2I3(I,varargin);
%OHTA color space transformation.
%   RGB_I1I2I3 converts RGB truecolor images to I1I2I3 images with:
%       I1 = (R + G + B) / 3 ; I2 = (R - B) / 2 ; I3 = (2G - R - B) / 4,
%   or :
%       | I1 |   |  1/3  1/3  1/3 |   | R |
%       | I2 | = |  1/2   0  -1/2 | * | G |
%       | I3 |   | -1/4  1/2 -1/4 |   | B |
%
%   I1I2I3 = RGB_I1I2I3(RGB) converts the RGB color image to the I1I2I3
%   color image using an independent coding scheme (default).
%
%	I1I2I3 = RGB_I1I2I3(RGB,CODING_SCHEME) uses different coding schemes.
%   CODING_SCHEME is a string that can have one of these values:
%
%       'ind'       converts the RGB truecolor image to a I1I2I3 uint8 image
%                   using an independent coding scheme (default).
%
%       'double'    converts the RGB truecolor image to a I1I2I3 double
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
%       I1I2I3 = RGB_I1I2I3(RGB);
%       figure, imshow(I1I2I3);
%
%   References
%   ----------
%   [1] Y. I. Ohta and T. Kanade and T. Sakai, "Color information for
%       region segmentation", Computer Graphics and Image Processing, vol.
%       13, pp. 222-241, 1980.
%   [2] N. Vandenbroucke and L. Macaire and J.-G. Postaire, "Color systems
%       coding for color image processing", in proceedings of the
%       International Conference on Color in Graphics and Image Processing,
%       pp. 180-185, 2000.
%
%   See also RGB_rgb.

if nargin < 1, error('Not enough input arguments.'); end

if((ndims(I) ~= 3) | (~isa(I,'uint8')))
    error('No 8 bits unsigned integer color image!\n Please use a 8 bits unsigned integer color image...');
end

J = zeros(size(I));

R = double(I(:,:,1));
G = double(I(:,:,2));
B = double(I(:,:,3));

C1 = 1/3*R + 1/3*G + 1/3*B;
C2 = 1/2*R - 1/2*B;
C3 = -1/4*R + 1/2*G - 1/4*B;

J(:,:,1) = C1;
J(:,:,2) = C2 + 127.5;
J(:,:,3) = C3 + 127.5;
J = uint8(J);

if (~isempty(varargin))
    switch varargin{1}
        case 'double'
            J = double(J);
            J(:,:,1) = C1/255;
            J(:,:,2) = C2/255;
            J(:,:,3) = C3/255;
        otherwise
            error(['Last argument' ' "' varargin{1} '" ' 'not recognized.'])
    end
end
