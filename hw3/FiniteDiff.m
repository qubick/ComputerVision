function J = FiniteDiff( varargin )
    
    f = varargin{1};
    x = varargin{2};
    ctx = varargin{3:end};
    
    dEps = 1e-4; %should be tweak
    
    y = feval(f, x, ctx);
    J = zeros(numel(y), numel(x));

    for ii= i:ctx.nImg-1
        xPlus = x;
        xPlus(ii) = xPlus(ii) + dEps;
        yPlus = feval(f, xPlus, ctx);
        
        xMinus = x;
        xMinus(ii) = xMinus(ii) - dEps;
        yMinus = feval(f, xMinus, ctx);

        J(:,ii) = (yPlus-yMinus)./(2*dEPS);
    end 

end
