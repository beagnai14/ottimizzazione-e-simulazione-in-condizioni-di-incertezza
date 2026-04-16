% =========================================================================
% SIMULAZIONE MONTE CARLO: MODELLO NEWSVENDOR CON INCERTEZZA
% =========================================================================
% Questo script valuta l'impatto dell'incertezza parametrica (stima della
% domanda tramite dati storici limitati) sulle performance del decisore.
% Permette di spazzolare (scan) due scenari analitici:
% 1. Variazione del rapporto dei costi (Critical Ratio).
% 2. Variazione dell'incertezza della domanda (Coefficiente di Variazione).
% =========================================================================

%seed = 420;
%rng(seed);

% DEFINIZIONE DEI PARAMETRI FISICI ED ECONOMICI
% Parametri di base del prodotto
p = 20;        % Prezzo di vendita unitario
c = 12.5;        % Costo di acquisto/produzione unitario
r_truth = 5;   % Valore di recupero (salvage value) medio per l'invenduto

% Parametri "Ground Truth" della Domanda (Realtà del mercato)
mu_truth = 120;           % Valore atteso (media) della domanda reale
sigma_truth_base = 30;    % Deviazione standard della domanda reale

%%%%%%%%%%CR = (p-c)/(p-r_truth);

% CONFIGURAZIONE DELLA SIMULAZIONE
% Array delle dimensioni campionarie (N): simula quanti dati storici ha a 
% disposizione il decisore per stimare la forma della campana della domanda.
sample_size = [5, 10, 20, 50, 100, 500, 1000];

% Numero di iterazioni Monte Carlo
n_iter = 10000;


% FLAG DI COMPORTAMENTO: Controllano l'attivazione dei diversi scenari
r_uncertainty_flag = true;      % Se TRUE: il valore di recupero effettivo fluttua casualmente.
CuCo_ratio_scan_flag = false;   % Se TRUE: esegue l'analisi di sensibilità sui costi (Margini).
MuSigma_ratio_scan_flag = true; % Se TRUE: esegue l'analisi di sensibilità sulla varianza della domanda.


% Controllo di sicurezza: impedisce di attivare entrambi gli scan contemporaneamente,
% garantendo che i grafici 2D finali abbiano senso logico.
if CuCo_ratio_scan_flag && MuSigma_ratio_scan_flag
    error('Errore logico: attiva solo uno scan alla volta (CuCo_ratio oppure MuSigma_ratio).');
end


% ESECUZIONE DEGLI SCENARI DI SCAN

if CuCo_ratio_scan_flag && MuSigma_ratio_scan_flag == false
    scan = 0.1:0.1:0.9;
    scan_label = 'Critical Ratio (Cu / (Cu+Co))';

    p_arr = p * ones(length(scan),1);
    r_truth_arr = r_truth  * ones(length(scan),1);
    c_arr = p_arr - scan' .* (p_arr - r_truth_arr);

    % Pre-allocazione matrici per ottimizzare la memoria e la velocità
    profit_ratio_mean = zeros(length(sample_size), length(scan));
    relmu_mean = zeros(length(sample_size), length(scan));
    relsigma_mean = zeros(length(sample_size), length(scan));
    
    disp('Esecuzione Scan Rapporto Costi in corso...');
    for i=1:length(scan)
        [profit_ratio_mean(:,i),relmu_mean(:,i),relsigma_mean(:,i)]=newsvendorMontecarlo(n_iter, sample_size, p_arr(i), c_arr(i), r_truth_arr(i), mu_truth,sigma_truth, r_uncertainty_flag);
    end

elseif MuSigma_ratio_scan_flag && CuCo_ratio_scan_flag == false
    scan = 0.05:0.05:0.3;
    scan_label = 'Coefficiente di Variazione (\sigma / \mu)';

    % La media rimane fissa, la deviazione standard cresce linearmente con lo scan
    mu_truth = mu_truth * ones(length(scan),1); 
    sigma_truth = mu_truth .* scan'; 

    profit_ratio_mean = zeros(length(sample_size), length(scan));
    relmu_mean = zeros(length(sample_size), length(scan));
    relsigma_mean = zeros(length(sample_size), length(scan));

    disp('Esecuzione Scan Incertezza Domanda in corso...');
    for i = 1:length(scan)
        [profit_ratio_mean(:,i),relmu_mean(:,i),relsigma_mean(:,i)]  = newsvendorMontecarlo(n_iter, sample_size, p, c, r_truth, mu_truth(i), sigma_truth(i), r_uncertainty_flag);
    end

elseif MuSigma_ratio_scan_flag == false && CuCo_ratio_scan_flag == false
    disp('Esecuzione Singola (Nessuno scan attivo)...');
    [profit_ratio_mean,relmu_mean,relsigma_mean] = newsvendorMontecarlo(n_iter,sample_size,p,c,r_truth,mu_truth,sigma_truth,r_uncertainty_flag);
end

disp('Simulazione completata. Generazione grafici...');

