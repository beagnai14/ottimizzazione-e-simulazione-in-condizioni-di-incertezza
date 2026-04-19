% PROFIT CALCULATOR: VALUTAZIONE ANALITICA DEL PROFITTO
% =========================================================================
% Calcola il profitto atteso per il modello Newsvendor assumendo una 
% distribuzione Normale della domanda implementando la funzione di perdita 
% standardizzata L(z).
% =========================================================================


function [expected_profit] = ComputeExpectedProfit(Cu, Co, q, mu, sigma)
    
    % Standardizzazione della quantità (operazione element-wise)
    z = (q - mu) ./ sigma;
    
    % Funzione di perdita normale standard L(z)
    % normpdf e normcdf in MATLAB gestiscono automaticamente i vettori
    loss = normpdf(z) - z .* (1 - normcdf(z));
    
    % Calcolo del profitto atteso con operatori vettoriali (.*)
    expected_profit = Cu .* mu - Co .* (q - mu) - (Cu + Co) .* sigma .* loss;
    
end
