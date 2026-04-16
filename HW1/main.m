% =========================================================================
% SIMULAZIONE MONTE CARLO: MODELLO NEWSVENDOR CON INCERTEZZA
% =========================================================================
% Questo script valuta l'impatto dell'incertezza parametrica (stima della
% domanda tramite dati storici limitati) sulle performance del decisore.
% Permette di spazzolare (scan) due scenari analitici:
% 1. Variazione del rapporto dei costi (Critical Ratio).
% 2. Variazione dell'incertezza della domanda (Coefficiente di Variazione).
% =========================================================================


<<<<<<< Updated upstream
r_uncertainty_flag = true; %se è True viene modellato r come una variabile casuale distribuita normalmente attorno a r_truth. Altrimenti costante
CuCo_ratio_scan_flag = false; %se True fa lo scan a diversi rapporti di costo di overage e underage
MuSigma_ratio_scan_flag = false; %se True fa lo scan a diversi rapporti di mu e sigma
=======
% DEFINIZIONE DEI PARAMETRI FISICI ED ECONOMICI
% Parametri di base del prodotto
p = 20;        % Prezzo di vendita unitario
c = 12.5;      % Costo di acquisto/produzione unitario
r_truth = 5;   % Valore di recupero (salvage value) medio per l'invenduto
>>>>>>> Stashed changes

% Parametri "Ground Truth" della Domanda (Realtà del mercato)
mu_truth = 120;      % Valore atteso (media) della domanda reale
sigma_truth = 30;    % Deviazione standard della domanda reale

CR = (p-c)/(p-r_truth);

% CONFIGURAZIONE DELLA SIMULAZIONE
% Array delle dimensioni campionarie (N): simula quanti dati storici ha a 
% disposizione il decisore per stimare la forma della campana della domanda.
sample_size = [5, 10, 20, 50, 100, 500, 1000];

% Numero di iterazioni Monte Carlo
n_iter = 10000;


% Legenda degli indici degli esperimenti:
% 1 = r fisso, nessuno scan
% 2 = r incerto, nessuno scan
% 3 = r fisso, scan del rapporto Cu/Co
% 4 = r incerto, scan del rapporto Cu/Co
% 5 = r fisso, scan del rapporto sigma/mu
% 6 = r incerto, scan del rapporto sigma/mu

<<<<<<< Updated upstream
elseif MuSigma_ratio_scan_flag && CuCo_ratio_scan_flag == false
    scan = 0.05:0.05:0.4; % per evitare casi in cui domanda negativa sia non trascurabile
    mu_truth = mu_truth * ones(length(scan),1); 
    sigma_truth = mu_truth .* scan'; 
    profit_ratio_mean = zeros(length(sample_size), length(scan));
    relmu_mean = zeros(length(sample_size), length(scan));
    relsigma_mean = zeros(length(sample_size), length(scan));
=======
fprintf('Inizio esecuzione esperimenti... (CR = %.1f%%)\n\n', CR*100);
>>>>>>> Stashed changes

% 1
[profit_ratio_mean1, relmu_mean1, relsigma_mean1] = newsvendorMontecarlo(n_iter, sample_size, p, c, r_truth, mu_truth, sigma_truth, false);
fprintf('Esperimento 1 completato: r fisso, nessuno scan.\n');

% 2
[profit_ratio_mean2, relmu_mean2, relsigma_mean2] = newsvendorMontecarlo(n_iter, sample_size, p, c, r_truth, mu_truth, sigma_truth, true);
fprintf('Esperimento 2 completato: r incerto, nessuno scan.\n');

% 3
scan_CuCo = 0.1:0.1:0.9;
p_scan = p * ones(length(scan_CuCo), 1);
r_truth_scan = r_truth * ones(length(scan_CuCo), 1);
c_scan = p_scan - scan_CuCo' .* (p_scan - r_truth_scan);

profit_ratio_mean3 = zeros(length(sample_size), length(scan_CuCo));
relmu_mean3 = zeros(length(sample_size), length(scan_CuCo));
relsigma_mean3 = zeros(length(sample_size), length(scan_CuCo));

for i = 1:length(scan_CuCo)
    [profit_ratio_mean3(:,i), relmu_mean3(:,i), relsigma_mean3(:,i)] = newsvendorMontecarlo(n_iter, sample_size, p_scan(i), c_scan(i), r_truth_scan(i), mu_truth, sigma_truth, false);
end

fprintf('Esperimento 3 completato: r fisso, scan del rapporto Cu/Co.\n');

% 4
profit_ratio_mean4 = zeros(length(sample_size), length(scan_CuCo));
relmu_mean4 = zeros(length(sample_size), length(scan_CuCo));
relsigma_mean4 = zeros(length(sample_size), length(scan_CuCo));

for i = 1:length(scan_CuCo)
    [profit_ratio_mean4(:,i), relmu_mean4(:,i), relsigma_mean4(:,i)] = newsvendorMontecarlo(n_iter, sample_size, p_scan(i), c_scan(i), r_truth_scan(i), mu_truth, sigma_truth, true);
end

fprintf('Esperimento 4 completato: r incerto, scan del rapporto Cu/Co.\n');

% 5
scan_MuSigma = 0.05:0.05:0.4; % per evitare casi in cui la domanda negativa sia non trascurabile
mu_truth_scan = mu_truth * ones(length(scan_MuSigma), 1);
sigma_truth_scan = mu_truth_scan .* scan_MuSigma';

profit_ratio_mean5 = zeros(length(sample_size), length(scan_MuSigma));
relmu_mean5 = zeros(length(sample_size), length(scan_MuSigma));
relsigma_mean5 = zeros(length(sample_size), length(scan_MuSigma));

for i = 1:length(scan_MuSigma)
    [profit_ratio_mean5(:,i), relmu_mean5(:,i), relsigma_mean5(:,i)] = newsvendorMontecarlo(n_iter, sample_size, p, c, r_truth, mu_truth_scan(i), sigma_truth_scan(i), false);
end

fprintf('Esperimento 5 completato: r fisso, scan del rapporto sigma/mu.\n');

% 6
profit_ratio_mean6 = zeros(length(sample_size), length(scan_MuSigma));
relmu_mean6 = zeros(length(sample_size), length(scan_MuSigma));
relsigma_mean6 = zeros(length(sample_size), length(scan_MuSigma));

for i = 1:length(scan_MuSigma)
    [profit_ratio_mean6(:,i), relmu_mean6(:,i), relsigma_mean6(:,i)] = newsvendorMontecarlo(n_iter, sample_size, p, c, r_truth, mu_truth_scan(i), sigma_truth_scan(i), true);
end

fprintf('Esperimento 6 completato: r incerto, scan del rapporto sigma/mu.\n');
fprintf('\nTutti gli esperimenti sono stati completati correttamente.\n');

% Salvo tutto in una struct e poi in un .mat

results.p = p;
results.c = c;
results.r_truth = r_truth;
results.mu_truth = mu_truth;
results.sigma_truth = sigma_truth;
results.sample_size = sample_size;
results.n_iter = n_iter;
results.scan_CuCo = scan_CuCo;
results.scan_MuSigma = scan_MuSigma;
results.p_scan = p_scan;
results.c_scan = c_scan;
results.r_truth_scan = r_truth_scan;
results.mu_truth_scan = mu_truth_scan;
results.sigma_truth_scan = sigma_truth_scan;
results.profit_ratio_mean1 = profit_ratio_mean1;
results.relmu_mean1 = relmu_mean1;
results.relsigma_mean1 = relsigma_mean1;
results.profit_ratio_mean2 = profit_ratio_mean2;
results.relmu_mean2 = relmu_mean2;
results.relsigma_mean2 = relsigma_mean2;
results.profit_ratio_mean3 = profit_ratio_mean3;
results.relmu_mean3 = relmu_mean3;
results.relsigma_mean3 = relsigma_mean3;
results.profit_ratio_mean4 = profit_ratio_mean4;
results.relmu_mean4 = relmu_mean4;
results.relsigma_mean4 = relsigma_mean4;
results.profit_ratio_mean5 = profit_ratio_mean5;
results.relmu_mean5 = relmu_mean5;
results.relsigma_mean5 = relsigma_mean5;
results.profit_ratio_mean6 = profit_ratio_mean6;
results.relmu_mean6 = relmu_mean6;
results.relsigma_mean6 = relsigma_mean6;

save('all_results.mat', 'results');
fprintf('Risultati salvati in all_results.mat\n');


disp('Simulazione completata. Generazione grafici...');







