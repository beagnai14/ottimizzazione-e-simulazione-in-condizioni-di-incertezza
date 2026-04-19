% STRUTTURAZIONE E SALVATAGGIO DEI RISULTATI
% =========================================================================
% Questa funzione astrae la logica di input/output dal motore di calcolo
% principale. Riceve in ingresso i metadati, i vettori di spazzolamento
% e l'output degli esperimenti, aggregandoli in un'unica struttura dati
% centralizzata pronta per l'esportazione su disco (.mat).
% =========================================================================

function results = saveNewsvendorResults(p, c, r_truth, mu_truth, sigma_truth, sample_size, n_iter, ...
                                         scan_CuCo, scan_MuSigma, p_scan, c_scan, r_truth_scan, mu_truth_scan, sigma_truth_scan, ...
                                         profit_ratio_mean1, relmu_mean1, relsigma_mean1, ...
                                         profit_ratio_mean2, relmu_mean2, relsigma_mean2, ...
                                         profit_ratio_mean3, relmu_mean3, relsigma_mean3, ...
                                         profit_ratio_mean4, relmu_mean4, relsigma_mean4, ...
                                         profit_ratio_mean5, relmu_mean5, relsigma_mean5, ...
                                         profit_ratio_mean6, relmu_mean6, relsigma_mean6)


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

% Salva i risultati fisicamente sul disco
save('all_results.mat', 'results');
fprintf('\nRisultati salvati correttamente in all_results.mat\n');

end