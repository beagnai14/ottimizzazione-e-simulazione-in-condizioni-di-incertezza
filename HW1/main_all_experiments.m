% =========================================================================
% DATA GENERATOR: SIMULAZIONE NEWSVENDOR BATCH
% =========================================================================
% Questo script esegue massivamente tutti gli scenari (esperimenti) di 
% simulazione del modello Newsvendor, raccogliendo i dati in un'unica 
% struttura centralizzata. Rimuove il controllo interattivo per garantire
% che la generazione del dataset sia consistente, replicabile e indipendente 
% dalla fase successiva di plotting.
% =========================================================================

clc;
clear all;

% Avvia il cronometro per valutare l'efficienza computazionale del batch
total_time = tic;

%P ARAMETRI DI BASE (GROUND TRUTH)
p = 20;             % Prezzo di vendita unitario
c = 12.5;           % Costo di acquisto unitario (Scelto per avere CR = 0.5)
r_truth = 5;        % Valore di recupero medio

% Calcolo del Critical Ratio di base (Livello di servizio ottimo al 50%)
CR = (p - c) / (p - r_truth); 

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



% ESPERIMENTO 1: Mercato deterministico per r (r_truth fisso)
[profit_ratio_mean1, relmu_mean1, relsigma_mean1] = newsvendorMontecarlo(n_iter, sample_size, p, c, r_truth, mu_truth, sigma_truth, false);
fprintf('Esperimento 1 completato: r fisso, nessuno scan.\n');



% ESPERIMENTO 2: Mercato incerto per r 
[profit_ratio_mean2, relmu_mean2, relsigma_mean2] = newsvendorMontecarlo(n_iter, sample_size, p, c, r_truth, mu_truth, sigma_truth, true);
fprintf('Esperimento 2 completato: r incerto, nessuno scan.\n');



% ESPERIMENTO 3: Mercato deterministico per r e sensibilità dei costi
% Generiamo il dominio di spazzolamento per il Critical Ratio (0.1 -> 0.9)
scan_CuCo = 0.1:0.1:0.9;
p_scan = p * ones(length(scan_CuCo), 1);
r_truth_scan = r_truth * ones(length(scan_CuCo), 1);
c_scan = p_scan - scan_CuCo' .* (p_scan - r_truth_scan);

% Pre-allocazione per esperimento 3
profit_ratio_mean3 = zeros(length(sample_size), length(scan_CuCo));
relmu_mean3 = zeros(length(sample_size), length(scan_CuCo));
relsigma_mean3 = zeros(length(sample_size), length(scan_CuCo));

for i = 1:length(scan_CuCo)
    [profit_ratio_mean3(:,i), relmu_mean3(:,i), relsigma_mean3(:,i)] = newsvendorMontecarlo(n_iter, sample_size, p_scan(i), c_scan(i), r_truth_scan(i), mu_truth, sigma_truth, false);
end
fprintf('Esperimento 3 completato: r fisso, scan del rapporto Cu/Co.\n');



% Pre-allocazione per esperimento 4
profit_ratio_mean4 = zeros(length(sample_size), length(scan_CuCo));
relmu_mean4 = zeros(length(sample_size), length(scan_CuCo));
relsigma_mean4 = zeros(length(sample_size), length(scan_CuCo));

% ESPERIMENTO 4: Mercato incerto per r e sensibilità dei costi
for i = 1:length(scan_CuCo)
    [profit_ratio_mean4(:,i), relmu_mean4(:,i), relsigma_mean4(:,i)] = newsvendorMontecarlo(n_iter, sample_size, p_scan(i), c_scan(i), r_truth_scan(i), mu_truth, sigma_truth, true);
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
    [profit_ratio_mean5(:,i), relmu_mean5(:,i), relsigma_mean5(:,i)] = newsvendorMontecarlo(n_iter, sample_size, p, c, r_truth, mu_truth_scan(i), sigma_truth_scan(i), false);
end
fprintf('Esperimento 5 completato: r fisso, scan del rapporto sigma/mu.\n');



% ESPERIMENTO 6: Mercato incerto e rapporto mu/sigma
profit_ratio_mean6 = zeros(length(sample_size), length(scan_MuSigma));
relmu_mean6 = zeros(length(sample_size), length(scan_MuSigma));
relsigma_mean6 = zeros(length(sample_size), length(scan_MuSigma));

for i = 1:length(scan_MuSigma)
    [profit_ratio_mean6(:,i), relmu_mean6(:,i), relsigma_mean6(:,i)] = newsvendorMontecarlo(n_iter, sample_size, p, c, r_truth, mu_truth_scan(i), sigma_truth_scan(i), true);
end
fprintf('Esperimento 6 completato: r incerto, scan del rapporto sigma/mu.\n');


fprintf('\nTutti gli esperimenti sono stati completati correttamente.\n');


% 5. RACCOLTA DATI 
fprintf('\nGenerazione dati conclusa. Preparazione salvataggio...\n');

% Strutturiamo il dizionario (struct) dei risultati raggruppando logicamente
% le variabili per facilitare il successivo caricamento nello script di plotting.

% Metadata e Configurazioni Base
results.config.p = p;
results.config.c = c;
results.config.r_truth = r_truth;
results.config.mu_truth = mu_truth;
results.config.sigma_truth = sigma_truth;
results.config.sample_size = sample_size;
results.config.n_iter = n_iter;


%Vettori di Scan
results.scans.CuCo = scan_CuCo;
results.scans.MuSigma = scan_MuSigma;
results.scans.p_array = p_scan;
results.scans.c_array = c_scan;
results.scans.r_array = r_truth_scan;
results.scans.mu_array = mu_truth_scan;
results.scans.sigma_array = sigma_truth_scan;


% 5.3 Dati Simulati (Exp 1 - 2: Baseline)
results.exp1.profit_ratio = profit_ratio_mean1;
results.exp1.relmu = relmu_mean1;
results.exp1.relsigma = relsigma_mean1;

results.exp2.profit_ratio = profit_ratio_mean2;
results.exp2.relmu = relmu_mean2;
results.exp2.relsigma = relsigma_mean2;

% 5.4 Dati Simulati (Exp 3 - 4: Costi)
results.exp3.profit_ratio = profit_ratio_mean3;
results.exp3.relmu = relmu_mean3;
results.exp3.relsigma = relsigma_mean3;

results.exp4.profit_ratio = profit_ratio_mean4;
results.exp4.relmu = relmu_mean4;
results.exp4.relsigma = relsigma_mean4;

% 5.5 Dati Simulati (Exp 5 - 6: Volatilità)
results.exp5.profit_ratio = profit_ratio_mean5;
results.exp5.relmu = relmu_mean5;
results.exp5.relsigma = relsigma_mean5;

results.exp6.profit_ratio = profit_ratio_mean6;
results.exp6.relmu = relmu_mean6;
results.exp6.relsigma = relsigma_mean6;

% Salvataggio del file .mat sul disco
save('all_results.mat', 'results');
fprintf('Risultati salvati in all_results.mat\n');

% Ferma il cronometro 
elapsed_time = toc(total_time);