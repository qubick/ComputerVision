function [ cart ] = T2Cart( T )
% T2Cart
%   Create a 6x1 cartesian pose vector from a transformation matrix
%
%   T -     a 4x4 transformation matrix
%
%   cart -  a 6x1 cartesian pose vector
%

    % extract the translation vector, [x,y,z] from T
    t = T(1:3,4);
    
    % extract the rotation matrix
    R = T(1:3,1:3);
    
    % calculate pqr
    pqr = R2pqr(R);
    
    % construct the pose vector
    cart = [t; pqr];

end
