function [expected_profit] = expected_profit_function(Cu, Co, q, mu, sigma)
    % Calcola il profitto atteso del Newsvendor per una domanda normale.
    % Supporta in input sia valori scalari che vettori/matrici.

    % Standardizzazione della quantità (operazione element-wise)
    z = (q - mu) ./ sigma;
    
    % Funzione di perdita normale standard L(z)
    % normpdf e normcdf in MATLAB gestiscono automaticamente i vettori
    loss = normpdf(z) - z .* (1 - normcdf(z));
    
    % Calcolo del profitto atteso con operatori vettoriali (.*)
    expected_profit = Cu .* mu - Co .* (q - mu) - (Cu + Co) .* sigma .* loss;
    
end
