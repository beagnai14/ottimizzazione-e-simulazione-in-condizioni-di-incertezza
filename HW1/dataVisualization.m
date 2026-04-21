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
CR = results.config.CR; 
sample_size = results.config.sample_size;

figure_directory = fullfile(pwd, 'figures');
if ~exist(figure_directory, 'dir')
    mkdir(figure_directory);
end

% FIGURA 1: Baseline
figure(1)
clf
semilogx(N, results.exp1.profit_ratio, '-b', 'LineWidth', 2)
hold on; grid on;
semilogx(N, results.exp2.profit_ratio, '-r', 'LineWidth', 2)
xticks(sample_size)
xlabel('Campioni storici (N)')
ylabel('Rapporto Profitto')
title(sprintf('Baseline: r fisso vs r incerto - CR = %.1f%%', CR*100))
legend('r fisso', 'r incerto', 'Location', 'southeast')

saveas(gcf, fullfile(figure_directory, 'fig1_baseline.png'));


% FIGURA 2: Scan Costi (Marginalità)
figure(2)
clf

leg_cr = cell(length(cr_scan), 1);
for i = 1:length(cr_scan)
    leg_cr{i} = [' C_u / C_o = ', num2str(cr_scan(i))];
end

% ylim comune per i due subplot
y_cost = [results.exp3.profit_ratio(:); results.exp4.profit_ratio(:)];
y_cost = y_cost(~isnan(y_cost));
yl_cost = [min(y_cost), max(y_cost)];
pad = 0.02 * (yl_cost(2) - yl_cost(1));
if pad == 0
    pad = 1e-3;
end
yl_cost = yl_cost + [-pad, pad];

subplot(1,2,1)
semilogx(N, results.exp3.profit_ratio, 'LineWidth', 1.5)
xticks(sample_size)
grid on
xlabel('Campioni storici (N)')
ylabel('Profitto')
title('Scan Costi (r fisso)')
legend(leg_cr, 'Location', 'southeast')
ylim(yl_cost)

subplot(1,2,2)
semilogx(N, results.exp4.profit_ratio, 'LineWidth', 1.5)
xticks(sample_size)
grid on
xlabel('Campioni storici (N)')
title('Scan Costi (r incerto)')
legend(leg_cr, 'Location', 'southeast')
ylim(yl_cost)

saveas(gcf, fullfile(figure_directory, 'fig2_scan_costi.png'));


% FIGURA 3: Scan Volatilità Domanda
figure(3)
clf

leg_cv = cell(length(cv_scan), 1);
for i = 1:length(cv_scan)
    leg_cv{i} = ['CV = ', num2str(cv_scan(i))];
end

% ylim comune per i due subplot
y_vol = [results.exp5.profit_ratio(:); results.exp6.profit_ratio(:)];
y_vol = y_vol(~isnan(y_vol));
yl_vol = [min(y_vol), max(y_vol)];
pad = 0.02 * (yl_vol(2) - yl_vol(1));
if pad == 0
    pad = 1e-3;
end
yl_vol = yl_vol + [-pad, pad];

subplot(1,2,1)
semilogx(N, results.exp5.profit_ratio, 'LineWidth', 1.5)
xticks(sample_size)
grid on
xlabel('Campioni storici (N)')
ylabel('Profitto')
title(sprintf('Scan Volatilità (r fisso) - CR = %.1f%%', CR*100))
legend(leg_cv, 'Location', 'southeast')
ylim(yl_vol)

subplot(1,2,2)
semilogx(N, results.exp6.profit_ratio, 'LineWidth', 1.5)
xticks(sample_size)
grid on
xlabel('Campioni storici (N)')
title(sprintf('Scan Volatilità (r incerto) - CR = %.1f%%', CR*100))
legend(leg_cv, 'Location', 'southeast')
ylim(yl_vol)

saveas(gcf, fullfile(figure_directory, 'fig3_scan_volatilita.png'));


% FIGURA 4: Convergenza Errore
figure(4)
clf
semilogx(N, results.exp5.relsigma, 'LineWidth', 1.5)
xticks(sample_size)
grid on
xlabel('Campioni storici (N)')
ylabel('Errore relativo su \sigma')
title('Convergenza stima deviazione standard')
legend(leg_cv, 'Location', 'northeast')

saveas(gcf, fullfile(figure_directory, 'fig4_convergenza_sigma.png'));


end