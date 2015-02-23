function [ T ] = Cart2T( cart )
% Cart2T
%   Create a 4x4 transformation matrix from a cartesian pose vector
%
%   cart -  a 6x1 cartesian pose vector
%
%   T -     a 4x4 transformation matrix
%

    % calculate the rotation matrix from the pqr values in cart
    R = pqr2R(cart(4:6,1));
        
    % construct the transformation matrx
    T = [R, cart(1:3,1); 0, 0, 0, 1];

end
