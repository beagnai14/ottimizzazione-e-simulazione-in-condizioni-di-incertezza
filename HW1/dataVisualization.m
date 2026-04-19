% DATA VISUALIZATION: ANALISI RISULTATI NEWSVENDOR
% =========================================================================
% Questo script carica i dati salvati dalla simulazione batch e genera
% visualizzazioni comparative utili per il report.
% =========================================================================

function dataVisualization(results)

% Estrazione variabili per i grafici
N = results.config.sample_size;
N(:);
cr_scan = results.scans.CuCo;
cv_scan = results.scans.MuSigma;

figure_directory = fullfile(pwd, 'figures');
if ~exist(figure_directory, 'dir')
    mkdir(figure_directory);
end

% FIGURA 1: Baseline
figure(1)
semilogx(N, results.exp1.profit_ratio, '-b', 'LineWidth', 2)
hold on; grid on;
semilogx(N, results.exp2.profit_ratio, '-r', 'LineWidth', 2)
xlabel('Campioni storici (N)')
ylabel('Rapporto Profitto')
title('Baseline: r fisso vs r incerto')
legend('r fisso', 'r incerto', 'Location', 'southeast')

% FIGURA 2: Scan Costi (Marginalità)
figure(2)
% Preparo la legenda dinamicamente
leg_cr = cell(length(cr_scan), 1);
for i=1:length(cr_scan)
    leg_cr{i} = ['CR = ', num2str(cr_scan(i))];
end

subplot(1,2,1)
% Plot diretto dell'intera matrice (MATLAB gestisce i colori da solo)
semilogx(N, results.exp3.profit_ratio, 'LineWidth', 1.5)
grid on; xlabel('Campioni storici (N)'); ylabel('Profitto')
title('Scan Costi (r fisso)')
legend(leg_cr, 'Location', 'southeast')

subplot(1,2,2)
semilogx(N, results.exp4.profit_ratio, 'LineWidth', 1.5)
grid on; xlabel('Campioni storici (N)')
title('Scan Costi (r incerto)')
legend(leg_cr, 'Location', 'southeast')

% FIGURA 3: Scan Volatilità Domanda
figure(3)
leg_cv = cell(length(cv_scan), 1);
for i=1:length(cv_scan)
    leg_cv{i} = ['CV = ', num2str(cv_scan(i))];
end

subplot(1,2,1)
semilogx(N, results.exp5.profit_ratio, 'LineWidth', 1.5)
grid on; xlabel('Campioni storici (N)'); ylabel('Profitto')
title('Scan Volatilità (r fisso)')
legend(leg_cv, 'Location', 'southeast')

subplot(1,2,2)
semilogx(N, results.exp6.profit_ratio, 'LineWidth', 1.5)
grid on; xlabel('Campioni storici (N)')
title('Scan Volatilità (r incerto)')
legend(leg_cv, 'Location', 'southeast')

% FIGURA 4: Convergenza Errore
figure(4)
semilogx(N, results.exp5.relsigma, 'LineWidth', 1.5)
grid on; xlabel('Campioni storici (N)'); ylabel('Errore relativo su \sigma')
title('Convergenza stima deviazione standard')
legend(leg_cv, 'Location', 'northeast')

end