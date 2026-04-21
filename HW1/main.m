% SIMULAZIONE NEWSVENDOR (MAIN SCRIPT)
% =========================================================================
% Questo script esegue massivamente tutti gli scenari (esperimenti) di 
% simulazione del modello Newsvendor, raccogliendo i dati in un'unica 
% struttura centralizzata e plottando i risultati.
% =========================================================================

clc;
clear all;

seed = 4406;
rng(seed);

% Avvia il cronometro per valutare l'efficienza computazionale del batch
total_time = tic;

%P ARAMETRI DI BASE (GROUND TRUTH)
p = 20;             % Prezzo di vendita unitario
c = 12.5;           % Costo di acquisto unitario (Scelto per avere CR = 0.5)
r = 5;        % Valore di recupero medio

% Calcolo del Critical Ratio di base (Livello di servizio ottimo al 50%)
CR = (p - c) / (p - r); 

mu_truth = 120;     % Valore atteso della domanda
sigma_truth = 30;   % Deviazione standard della domanda

% Vettore delle dimensioni campionarie (storico dati a disposizione)
sample_size = [5, 10, 20, 50, 100, 500, 1000];

% Iterazioni Monte Carlo 
n_iter = 10000;     

fprintf('Inizio esecuzione esperimenti... (CR = %.1f%%)\n\n', CR*100);

% Legenda degli indici degli esperimenti:
% 1 = r fisso, nessuno scan
% 2 = r incerto, nessuno scan
% 3 = r fisso, scan del rapporto Cu/Co
% 4 = r incerto, scan del rapporto Cu/Co
% 5 = r fisso, scan del rapporto sigma/mu
% 6 = r incerto, scan del rapporto sigma/mu
% 7 = scan del livello di incertezza su r



% ESPERIMENTO 1: Mercato deterministico per r (r_truth fisso)
[profit_ratio_mean1, relmu_mean1, relsigma_mean1, ~] = newsvendorMontecarlo(n_iter, sample_size, p, c, r, mu_truth, sigma_truth, false);
fprintf('Esperimento 1 completato: r fisso, nessuno scan.\n');



% ESPERIMENTO 2: Mercato incerto per r 
[profit_ratio_mean2, relmu_mean2, relsigma_mean2, r_estimation_err_mean2] = newsvendorMontecarlo(n_iter, sample_size, p, c, r, mu_truth, sigma_truth, true);
fprintf('Esperimento 2 completato: r incerto, nessuno scan.\n');



% ESPERIMENTO 3: Mercato deterministico per r e sensibilità dei costi
% Generiamo il dominio di spazzolamento per il Critical Ratio (0.1 -> 0.9)
scan_CuCo = 0.1:0.1:0.9;
p_scan = p * ones(length(scan_CuCo), 1);
r_scan = r * ones(length(scan_CuCo), 1);
c_scan = (p_scan + scan_CuCo' .* r_scan) ./ (1 + scan_CuCo');

% Pre-allocazione per esperimento 3
profit_ratio_mean3 = zeros(length(sample_size), length(scan_CuCo));
relmu_mean3 = zeros(length(sample_size), length(scan_CuCo));
relsigma_mean3 = zeros(length(sample_size), length(scan_CuCo));

for i = 1:length(scan_CuCo)
    [profit_ratio_mean3(:,i), relmu_mean3(:,i), relsigma_mean3(:,i), ~] = newsvendorMontecarlo(n_iter, sample_size, p_scan(i), c_scan(i), r_scan(i), mu_truth, sigma_truth, false);
end
fprintf('Esperimento 3 completato: r fisso, scan del rapporto Cu/Co.\n');



% Pre-allocazione per esperimento 4
profit_ratio_mean4 = zeros(length(sample_size), length(scan_CuCo));
relmu_mean4 = zeros(length(sample_size), length(scan_CuCo));
relsigma_mean4 = zeros(length(sample_size), length(scan_CuCo));

% ESPERIMENTO 4: Mercato incerto per r e sensibilità dei costi
for i = 1:length(scan_CuCo)
    [profit_ratio_mean4(:,i), relmu_mean4(:,i), relsigma_mean4(:,i), ~] = newsvendorMontecarlo(n_iter, sample_size, p_scan(i), c_scan(i), r_scan(i), mu_truth, sigma_truth, true);
end
fprintf('Esperimento 4 completato: r incerto, scan del rapporto Cu/Co.\n');



% ESPERIMENTO 5: Mercato deterministico e rapporto mu/sigma
scan_MuSigma = 0.05:0.05:0.4;                                    % per evitare casi in cui la domanda negativa sia non trascurabile
mu_truth_scan = mu_truth * ones(length(scan_MuSigma), 1);
sigma_truth_scan = mu_truth_scan .* scan_MuSigma';

profit_ratio_mean5 = zeros(length(sample_size), length(scan_MuSigma));
relmu_mean5 = zeros(length(sample_size), length(scan_MuSigma));
relsigma_mean5 = zeros(length(sample_size), length(scan_MuSigma));

for i = 1:length(scan_MuSigma)
    [profit_ratio_mean5(:,i), relmu_mean5(:,i), relsigma_mean5(:,i), ~] = newsvendorMontecarlo(n_iter, sample_size, p, c, r, mu_truth_scan(i), sigma_truth_scan(i), false);
end
fprintf('Esperimento 5 completato: r fisso, scan del rapporto sigma/mu.\n');



% ESPERIMENTO 6: Mercato incerto e rapporto mu/sigma
profit_ratio_mean6 = zeros(length(sample_size), length(scan_MuSigma));
relmu_mean6 = zeros(length(sample_size), length(scan_MuSigma));
relsigma_mean6 = zeros(length(sample_size), length(scan_MuSigma));

for i = 1:length(scan_MuSigma)
    [profit_ratio_mean6(:,i), relmu_mean6(:,i), relsigma_mean6(:,i), ~] = newsvendorMontecarlo(n_iter, sample_size, p, c, r, mu_truth_scan(i), sigma_truth_scan(i), true);
end
fprintf('Esperimento 6 completato: r incerto, scan del rapporto sigma/mu.\n');




% ESPERIMENTO 7: Scan del livello di incertezza su r
r_uncertainty_scan = [0.05, 0.10, 0.20, 0.30, 0.40];

profit_ratio_mean7 = zeros(length(sample_size), length(r_uncertainty_scan));
relmu_mean7 = zeros(length(sample_size), length(r_uncertainty_scan));
relsigma_mean7 = zeros(length(sample_size), length(r_uncertainty_scan));
r_estimation_err_mean7 = zeros(length(sample_size), length(r_uncertainty_scan));

for i = 1:length(r_uncertainty_scan)
    [profit_ratio_mean7(:,i), relmu_mean7(:,i), relsigma_mean7(:,i), r_estimation_err_mean7(:,i)] = ...
        newsvendorMontecarlo(n_iter, sample_size, p, c, r, mu_truth, sigma_truth, true, r_uncertainty_scan(i));
end
fprintf('Esperimento 7 completato: scan del livello di incertezza su r.\n');

fprintf('\nTutti gli esperimenti sono stati completati correttamente.\n');


% RACCOLTA E SALVATAGGIO DATI 
results = saveNewsvendorResults(p, c, r, mu_truth, CR, sigma_truth, sample_size, n_iter, ...
                             scan_CuCo, scan_MuSigma, r_uncertainty_scan, ...
                             p_scan, c_scan, r_scan, mu_truth_scan, sigma_truth_scan, ...
                             profit_ratio_mean1, relmu_mean1, relsigma_mean1, ...
                             profit_ratio_mean2, relmu_mean2, relsigma_mean2, r_estimation_err_mean2, ...
                             profit_ratio_mean3, relmu_mean3, relsigma_mean3, ...
                             profit_ratio_mean4, relmu_mean4, relsigma_mean4, ...
                             profit_ratio_mean5, relmu_mean5, relsigma_mean5, ...
                             profit_ratio_mean6, relmu_mean6, relsigma_mean6, ...
                             profit_ratio_mean7, relmu_mean7, relsigma_mean7, r_estimation_err_mean7);


% Ferma il cronometro
elapsed_time = toc(total_time);
fprintf('\nTempo totale di esecuzione batch: %.2f secondi.\n', elapsed_time);

% CARICAMENTO DATI
try
    load('all_results.mat');
    fprintf('\nDati caricati con successo da all_results.mat\n');
catch
    error('\nFile all_results.mat non trovato. Esegui prima lo script di simulazione.\n');
end

% VISUALIZZAZIONE DATI
fprintf('\nGenerazione dei grafici in corso...\n');
dataVisualization(results);
fprintf('\nTutti i grafici sono stati generati correttamente.\n');

