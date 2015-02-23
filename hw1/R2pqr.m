function pqr = R2pqr(R)

    if(R(1,3) > 0)
        q = pi - asin(R(2,3));
    else
        q = asin(R(2,3));
    end
    
    pqr(2,1) = q;
    pqr(1,1) = acos(R(2,2)/cos(q));
    pqr(3,1) = acos(R(3,3)/cos(q));
end