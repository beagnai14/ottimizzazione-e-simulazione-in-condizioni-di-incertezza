clc; clear; close all;

%% 1. CARICAMENTO DATI
try
    load('all_results.mat');
    disp('Dati caricati con successo da all_results.mat');
catch
    error('File all_results.mat non trovato. Esegui prima lo script di simulazione.');
end

%% 2. CARTELLA FIGURE
figure_directory = fullfile(pwd, 'figures');
if ~exist(figure_directory, 'dir')
    mkdir(figure_directory);
end

%% 3. VARIABILI DI COMODO
N = results.config.sample_size;
cr_scan = results.scans.CuCo;
cv_scan = results.scans.MuSigma;

%% 4. LEGENDE DINAMICHE
leg_cr = cell(length(cr_scan), 1);
for i = 1:length(cr_scan)
    leg_cr{i} = ['CR = ', num2str(cr_scan(i))];
end

leg_cv = cell(length(cv_scan), 1);
for i = 1:length(cv_scan)
    leg_cv{i} = ['CV = ', num2str(cv_scan(i))];
end

%% 5. LIMITI Y CONDIVISI PER FIGURE ACCOPPIATE

% Figura 2: scan costi
y2_all = [results.exp3.profit_ratio(:); results.exp4.profit_ratio(:)];
y2_min = min(y2_all);
y2_max = max(y2_all);
y2_margin = 0.02 * (y2_max - y2_min);
if y2_margin == 0
    y2_margin = 0.001;
end
ylim_fig2 = [y2_min - y2_margin, y2_max + y2_margin];

% Figura 3: scan volatilità
y3_all = [results.exp5.profit_ratio(:); results.exp6.profit_ratio(:)];
y3_min = min(y3_all);
y3_max = max(y3_all);
y3_margin = 0.02 * (y3_max - y3_min);
if y3_margin == 0
    y3_margin = 0.001;
end
ylim_fig3 = [y3_min - y3_margin, y3_max + y3_margin];

%% FIGURA 1: BASELINE
figure(1)
semilogx(N, results.exp1.profit_ratio, '-o', 'LineWidth', 2, 'MarkerSize', 6)
hold on
semilogx(N, results.exp2.profit_ratio, '-o', 'LineWidth', 2, 'MarkerSize', 6)
grid on

xlabel('Campioni storici (N)')
ylabel('Rapporto di profitto')
title('Baseline: r fisso vs r incerto')
legend('r fisso', 'r incerto', 'Location', 'southeast')

xticks(N)
xticklabels(string(N))
xlim([min(N), max(N)])

exportgraphics(gcf, fullfile(figure_directory, 'figura1_baseline.png'), 'Resolution', 300);

%% FIGURA 2: SCAN COSTI
figure(2)

subplot(1,2,1)
semilogx(N, results.exp3.profit_ratio, '-', 'LineWidth', 1.5)
grid on
xlabel('Campioni storici (N)')
ylabel('Rapporto di profitto')
title('Scan Costi (r fisso)')
legend(leg_cr, 'Location', 'southeast')
xticks(N)
xticklabels(string(N))
xlim([min(N), max(N)])
ylim(ylim_fig2)

subplot(1,2,2)
semilogx(N, results.exp4.profit_ratio, '-', 'LineWidth', 1.5)
grid on
xlabel('Campioni storici (N)')
ylabel('Rapporto di profitto')
title('Scan Costi (r incerto)')
legend(leg_cr, 'Location', 'southeast')
xticks(N)
xticklabels(string(N))
xlim([min(N), max(N)])
ylim(ylim_fig2)

exportgraphics(gcf, fullfile(figure_directory, 'figura2_scan_costi.png'), 'Resolution', 300);

%% FIGURA 3: SCAN VOLATILITA DOMANDA
figure(3)

subplot(1,2,1)
semilogx(N, results.exp5.profit_ratio, '-', 'LineWidth', 1.5)
grid on
xlabel('Campioni storici (N)')
ylabel('Rapporto di profitto')
title('Scan Volatilità (r fisso)')
legend(leg_cv, 'Location', 'southeast')
xticks(N)
xticklabels(string(N))
xlim([min(N), max(N)])
ylim(ylim_fig3)

subplot(1,2,2)
semilogx(N, results.exp6.profit_ratio, '-', 'LineWidth', 1.5)
grid on
xlabel('Campioni storici (N)')
ylabel('Rapporto di profitto')
title('Scan Volatilità (r incerto)')
legend(leg_cv, 'Location', 'southeast')
xticks(N)
xticklabels(string(N))
xlim([min(N), max(N)])
ylim(ylim_fig3)

exportgraphics(gcf, fullfile(figure_directory, 'figura3_scan_volatilita.png'), 'Resolution', 300);

%% FIGURA 4: CONVERGENZA ERRORE SU SIGMA
figure(4)
semilogx(N, results.exp5.relsigma, '-o', 'LineWidth', 1.5, 'MarkerSize', 5)
grid on

xlabel('Campioni storici (N)')
ylabel('Errore relativo su \sigma')
title('Convergenza della stima della deviazione standard')
legend(leg_cv, 'Location', 'northeast')

xticks(N)
xticklabels(string(N))
xlim([min(N), max(N)])

exportgraphics(gcf, fullfile(figure_directory, 'figura4_convergenza_sigma.png'), 'Resolution', 300);

disp('Tutte le figure sono state generate e salvate nella cartella "figures".');