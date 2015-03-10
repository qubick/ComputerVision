function [r, J] = Jacobian_Finite(x, ctx)
    r = residual(x, ctx);
    J = FiniteDiff(@residual, x, ctx);
end