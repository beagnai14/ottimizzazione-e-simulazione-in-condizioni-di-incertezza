function [x] = expected_profit_function(Cu,Co,q,mu,sigma)
    z=(q-mu)/sigma;
    loss=normpdf(z)-z*(1-normcdf(z));
    x=Cu * mu - Co * (q-mu) - (Cu + Co) * sigma * loss;
end
