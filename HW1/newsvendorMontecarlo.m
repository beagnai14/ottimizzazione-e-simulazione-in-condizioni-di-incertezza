function [profit_ratio_mean,relmu_mean,relsigma_mean] = newsvendorMontecarlo(n_iter,sample_size,p,c,r_truth,mu_truth,sigma_truth,r_uncertainty_flag)
% =====================================================================
    % FUNZIONE DI SIMULAZIONE 
% =====================================================================

% PARAMETRI DI RIFERIMENTO (Ground Truth)
Cu_truth = p - c;
Co_truth = c - r_truth;
CR_truth = Cu_truth / (Cu_truth + Co_truth);

% Quantità ottima teorica (se conoscessimo perfettamente mu e sigma)
q_star = norminv(CR_truth, mu_truth, sigma_truth);

% Calcolo del massimo profitto teoricamente raggiungibile
expected_profit_truth = expected_profit_function(Cu_truth, Co_truth, q_star, mu_truth, sigma_truth);



% INIZIALIZZAZIONE DELLA SIMULAZIONE
n_samples = length(sample_size);
profit_ratio_mean = zeros(n_samples,1);
relmu_mean = zeros(n_samples,1);
relsigma_mean = zeros(n_samples,1);

% Inizializzo vettori temporanei per il ciclo n_iter
q = zeros(n_iter,1);
expected_profit = zeros(n_iter,1);
profit_ratio = zeros(n_iter,1);
relmu = zeros(n_iter,1);
relsigma = zeros(n_iter,1);

for i = 1:n_samples
    for j = 1:n_iter
        
        % FASE DI STIMA (Il Newsvendor decide)
        % Il Newsvendor usa i dati storici per stimare la domanda
        historical_demand = normrnd(mu_truth, sigma_truth, [sample_size(i),1]);
        [mu_hat, sigma_hat] = normfit(historical_demand);
        
        % DECISIONE: Il Newsvendor calcola q basandosi sulla sua stima (mu_hat, sigma_hat)
        % e sul valore di recupero atteso (r_truth), NON quello che cambierà oggi.
        Co_decision = c - r_truth; 
        CR_decision = Cu_truth / (Cu_truth + Co_decision);
        
        q(j) = norminv(CR_decision, mu_hat, sigma_hat);
        
        % FASE DI REALIZZAZIONE (Il Mercato risponde) 
        % Se c'è incertezza, il valore di recupero REALE oggi fluttua
        if r_uncertainty_flag
            r_hat = min(c*0.9, max(0, normrnd(r_truth, 0.2*r_truth)));
        else
            r_hat = r_truth;
        end
        
        % Il costo di "Overstock" reale per questa iterazione
        Co_hat = c - r_hat;
        
        % CALCOLO PRESTAZIONI
        % Il profitto atteso si calcola sulla q decisa, ma con i costi reali del mercato
        expected_profit(j) = expected_profit_function(Cu_truth, Co_hat, q(j), mu_truth, sigma_truth);
        
        profit_ratio(j) = expected_profit(j) / expected_profit_truth;
        relmu(j) = abs(mu_hat - mu_truth) / mu_truth;
        relsigma(j) = abs(sigma_hat - sigma_truth) / sigma_truth;
    end
    
    % Medie per la dimensione del campione corrente
    profit_ratio_mean(i) = mean(profit_ratio);
    relmu_mean(i) = mean(relmu);
    relsigma_mean(i) = mean(relsigma);
end
end