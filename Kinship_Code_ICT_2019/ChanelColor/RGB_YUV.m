function J = RGB_YUV(I,varargin);

if nargin < 1, error('Not enough input arguments.'); end

if((ndims(I) ~= 3) | (~isa(I,'uint8')))
    error('No 8 bits unsigned integer color image!\n Please use a 8 bits unsigned integer color image...');
end

J = zeros(size(I));

R = double(I(:,:,1));
G = double(I(:,:,2));
B = double(I(:,:,3));

C1 = 0.299*R + 0.587*G + 0.114*B;
C2 = -0.148*R - 0.289*G + 0.437*B;
C3 = 0.615*R -0.515*G - 0.100*B;

J(:,:,1) = C1;
J(:,:,2) = (255/(111.435*2))*(C2+111.435);
J(:,:,3) = (255/(156.825*2))*(C3+156.825);

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
