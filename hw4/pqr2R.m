function [ R ] = pqr2R( pqr )
% pqr2R
%   Create a rotation matrix from Euler roll-pitch-yaw angles
%
%   pqr - a 3x1 set of Euler angles
%         roll  - rotation about the +z-axis (forward)
%         pitch - rotation about the +x-axis (right)
%         yaw   - rotation about the +y-axis (down)
%
%   R   - a 3x3 rotation matrix
%
% NOTE:  This has been modified from assignment 1.  Yaw was rotating
%        in the incorrect direction - left hand instead of right hand

    % Create individual rotation matrices for each axis
    Rx = [[1.0,          0.0,         0.0];
          [0.0,  cos(pqr(2)), sin(pqr(2))];
          [0.0, -sin(pqr(2)), cos(pqr(2))]];
        
    Ry = [[ cos(pqr(3)), 0.0, sin(pqr(3))];
          [         0.0, 1.0,         0.0];
          [-sin(pqr(3)), 0.0, cos(pqr(3))]];
        
    Rz = [[ cos(pqr(1)), sin(pqr(1)), 0.0];
          [-sin(pqr(1)), cos(pqr(1)), 0.0];
          [         0.0,         0.0, 1.0]];        
        
    % Create the rotation matrix by rotating about x, then y, then z
    R=Ry*Rx*Rz;
    
end

