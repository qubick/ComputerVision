function R = pqr2R(pqr)

    p = pqr(1);
    q = pqr(2);
    r = pqr(3);
    
    R(1,1) = cos(p)*cos(r)-sin(p)*sin(q)*sin(r);
    R(1,2) = cos(r)*sin(p)+cos(p)*sin(q)*sin(r);
    R(1,3) = -cos(q)*sin(r);

    R(2,1) = -cos(q)*sin(p);
    R(2,2) = cos(p)*cos(q); 
    R(2,3) = sin(q);

    R(3,1) = cos(p)*sin(r)+cos(r)*sin(p)*sin(q); 
    R(3,2) = sin(p)*sin(r)-cos(p)*cos(r)*sin(q); 
    R(3,3) = cos(q)*cos(r);
end