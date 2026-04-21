% FUNZIONE DI SIMULAZIONE 
% =========================================================================
% Questa funzione implementa la logica di stima e decisione del modello 
% Newsvendor. Simula iterativamente la generazione di campioni storici, 
% la stima dei parametri e la valutazione del profitto atteso reale 
% rispetto allo scenario teorico ottimo (Ground Truth).
% =====================================================================

function [profit_ratio_mean,relmu_mean,relsigma_mean] = newsvendorMontecarlo(n_iter,sample_size,p,c,r,mu_truth,sigma_truth,r_uncertainty_flag)

% PARAMETRI DI RIFERIMENTO 
Cu = p - c;
Co = c - r;
CR = Cu / (Cu + Co);

% Quantità ottima teorica (se conoscessimo perfettamente mu e sigma)
q_star = norminv(CR, mu_truth, sigma_truth);

% Calcolo del massimo profitto teoricamente raggiungibile
expected_profit_truth = ComputeExpectedProfit(Cu, Co, q_star, mu_truth, sigma_truth);



% INIZIALIZZAZIONE DELLA SIMULAZIONE
n_samples = length(sample_size);
profit_ratio_mean = zeros(n_samples,1);
relmu_mean = zeros(n_samples,1);
relsigma_mean = zeros(n_samples,1);

% Inizializzo vettori per il ciclo
q = zeros(n_iter,1);
expected_profit = zeros(n_iter,1);
profit_ratio = zeros(n_iter,1);
relmu = zeros(n_iter,1);
relsigma = zeros(n_iter,1);

for i = 1:n_samples
    N = sample_size(i);
    
    % FASE DI STIMA (Il Newsvendor decide)
    % Il Newsvendor usa i dati storici per stimare la domanda, Creiamo una matrice [N righe x n_iter colonne]
    historical_demand = normrnd(mu_truth, sigma_truth, [N, n_iter]);

    % normfit lavora automaticamente sulle colonne della matrice.
    % mu_hat e sigma_hat saranno vettori riga [1 x n_iter]
    [mu_hat, sigma_hat] = normfit(historical_demand);

    % DECISIONE
    q = norminv(CR, mu_hat, sigma_hat);

    % FASE DI REALIZZAZIONE
    % Se c'è incertezza, il valore di recupero REALE oggi fluttua
    if r_uncertainty_flag
        % Generiamo 10.000 valori casuali in un colpo solo
        r_hat_raw = normrnd(r, 0.2 * r, [1, n_iter]);
        r_hat = min(c * 0.9, max(0, r_hat_raw)); 
    else
        % Se non c'è incertezza, creiamo un vettore costante per mantenere le dimensioni
        r_hat = r * ones(1, n_iter); 
    end
    
    % Il costo di "Overstock" reale per questa iterazione
    Co_hat = c - r_hat;
    
    % CALCOLO PRESTAZIONI (MERCATO VS DECISIONI)
    % Usiamo i valori Truth per la domanda e i valori Hat per i costi
    expected_profit = ComputeExpectedProfit(Cu, Co_hat, q, mu_truth, sigma_truth);
    
    % Vettori di scostamento
    profit_ratio = expected_profit ./ expected_profit_truth;
    relmu = abs(mu_hat - mu_truth) ./ mu_truth;
    relsigma = abs(sigma_hat - sigma_truth) ./ sigma_truth;
    
    % Medie per la dimensione del campione corrente
    profit_ratio_mean(i) = mean(profit_ratio);
    relmu_mean(i) = mean(relmu);
    relsigma_mean(i) = mean(relsigma);

end

end






