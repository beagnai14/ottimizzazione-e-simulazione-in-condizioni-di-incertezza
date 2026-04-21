% DATA VISUALIZATION: ANALISI RISULTATI NEWSVENDOR
% =========================================================================
% Questo script carica i dati salvati dalla simulazione batch e genera
% visualizzazioni comparative utili per il report.
% =========================================================================

function dataVisualization(results)

% Estrazione variabili per i grafici
N = results.config.sample_size;
cr_scan = results.scans.CuCo;
cv_scan = results.scans.MuSigma;
CR = results.config.CR; 
sample_size = results.config.sample_size;

% Livello base di incertezza su r usato negli scenari standard "r incerto"
r_unc_default = 0.2;

figure_directory = fullfile(pwd, 'figures');
if ~exist(figure_directory, 'dir')
    mkdir(figure_directory);
end

%% FIGURA 1: Baseline
figure(1)
clf
semilogx(N, results.exp1.profit_ratio, '-b', 'LineWidth', 2)
hold on
grid on
semilogx(N, results.exp2.profit_ratio, '-r', 'LineWidth', 2)
xticks(sample_size)
xlabel('Campioni storici (N)')
ylabel('Rapporto Profitto')
title(sprintf('Baseline: r fisso vs r incerto (\\sigma_r / r = %.1f) (CR = %.1f%%)', ...
    r_unc_default, CR*100))
legend('r fisso', 'r incerto', 'Location', 'southeast')

saveas(gcf, fullfile(figure_directory, 'fig1_baseline.png'));


%% FIGURA 2: Scan Costi (Marginalità)
figure(2)
clf
set(gcf, 'Position', [100, 100, 1100, 500])
sgtitle('Scan Costi (scan del rapporto C_u / C_o)')

leg_cr = cell(length(cr_scan), 1);
for i = 1:length(cr_scan)
    leg_cr{i} = ['C_u / C_o = ', num2str(cr_scan(i))];
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
ylabel('Rapporto Profitto')
title('r fisso')
legend(leg_cr, 'Location', 'southeast')
ylim(yl_cost)

subplot(1,2,2)
semilogx(N, results.exp4.profit_ratio, 'LineWidth', 1.5)
xticks(sample_size)
grid on
xlabel('Campioni storici (N)')
title(sprintf('r incerto, \\sigma_r / r = %.1f', r_unc_default))
legend(leg_cr, 'Location', 'southeast')
ylim(yl_cost)

saveas(gcf, fullfile(figure_directory, 'fig2_scan_costi.png'));


%% FIGURA 3: Scan Volatilità Domanda
figure(3)
clf
set(gcf, 'Position', [100, 100, 1100, 500])
sgtitle(sprintf('Scan Volatilità Domanda (CR = %.1f%%)', CR*100))

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
ylabel('Rapporto Profitto')
title('r fisso')
legend(leg_cv, 'Location', 'southeast')
ylim(yl_vol)

subplot(1,2,2)
semilogx(N, results.exp6.profit_ratio, 'LineWidth', 1.5)
xticks(sample_size)
grid on
xlabel('Campioni storici (N)')
title(sprintf('r incerto, \\sigma_r / r = %.1f', r_unc_default))
legend(leg_cv, 'Location', 'southeast')
ylim(yl_vol)

saveas(gcf, fullfile(figure_directory, 'fig3_scan_volatilita.png'));


%% FIGURA 4: Convergenza Errore
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


%% FIGURA 5: Scan incertezza su r
figure(5)
clf

r_unc_scan = results.scans.rUncertainty;

leg_r = cell(length(r_unc_scan), 1);
for i = 1:length(r_unc_scan)
    leg_r{i} = ['\sigma_r / r = ', num2str(r_unc_scan(i))];
end

semilogx(N, results.exp7.profit_ratio, 'LineWidth', 1.5)
xticks(sample_size)
grid on
xlabel('Campioni storici (N)')
ylabel('Rapporto Profitto')
title(sprintf('Impatto dell''incertezza su r (CR = %.1f%%)', CR*100))
legend(leg_r, 'Location', 'southeast')

saveas(gcf, fullfile(figure_directory, 'fig5_scan_incertezza_r.png'));


%% FIGURA 6: Scan Costi (Marginalità) - Versione con meno curve
figure(6)
clf
set(gcf, 'Position', [100, 100, 1100, 500])
sgtitle('Scan Costi (scan del rapporto C_u / C_o)')

% Seleziono solo: seconda, quinta e penultima curva
idx_sel = [2, 5, length(cr_scan)-1];

% Legenda ridotta
leg_cr_sel = cell(length(idx_sel), 1);
for i = 1:length(idx_sel)
    leg_cr_sel{i} = ['C_u / C_o = ', num2str(cr_scan(idx_sel(i)))];
end

% ylim comune per i due subplot
y_cost = [results.exp3.profit_ratio(:,idx_sel); results.exp4.profit_ratio(:,idx_sel)];
y_cost = y_cost(~isnan(y_cost));
yl_cost = [min(y_cost), max(y_cost)];
pad = 0.02 * (yl_cost(2) - yl_cost(1));
if pad == 0
    pad = 1e-3;
end
yl_cost = yl_cost + [-pad, pad];

subplot(1,2,1)
semilogx(N, results.exp3.profit_ratio(:,idx_sel), 'LineWidth', 1.5)
xticks(sample_size)
grid on
xlabel('Campioni storici (N)')
ylabel('Rapporto Profitto')
title('r fisso')
legend(leg_cr_sel, 'Location', 'southeast')
ylim(yl_cost)

subplot(1,2,2)
semilogx(N, results.exp4.profit_ratio(:,idx_sel), 'LineWidth', 1.5)
xticks(sample_size)
grid on
xlabel('Campioni storici (N)')
title(sprintf('r incerto, \\sigma_r / r = %.1f', r_unc_default))
legend(leg_cr_sel, 'Location', 'southeast')
ylim(yl_cost)

saveas(gcf, fullfile(figure_directory, 'fig6_scan_costi_meno_curve.png'));

%% FIGURA 7: Scan Volatilità Domanda - Versione con meno curve
figure(7)
clf
set(gcf, 'Position', [100, 100, 1100, 500])
sgtitle(sprintf('Scan Volatilità Domanda (CR = %.1f%%)', CR*100))

% Seleziono solo: seconda, quinta e ultima curva
idx_sel = [2, 5, length(cv_scan)];

% Legenda ridotta
leg_cv_sel = cell(length(idx_sel), 1);
for i = 1:length(idx_sel)
    leg_cv_sel{i} = ['CV = ', num2str(cv_scan(idx_sel(i)))];
end

% Dati selezionati
Y1 = results.exp5.profit_ratio(:, idx_sel);
Y2 = results.exp6.profit_ratio(:, idx_sel);

% ylim comune per i due subplot
y_vol = [Y1(:); Y2(:)];
y_vol = y_vol(~isnan(y_vol));
yl_vol = [min(y_vol), max(y_vol)];
pad = 0.02 * (yl_vol(2) - yl_vol(1));
if pad == 0
    pad = 1e-3;
end
yl_vol = yl_vol + [-pad, pad];

subplot(1,2,1)
semilogx(N, Y1, 'LineWidth', 1.5)
xticks(sample_size)
grid on
xlabel('Campioni storici (N)')
ylabel('Rapporto Profitto')
title('r fisso')
legend(leg_cv_sel, 'Location', 'southeast')
ylim(yl_vol)

subplot(1,2,2)
semilogx(N, Y2, 'LineWidth', 1.5)
xticks(sample_size)
grid on
xlabel('Campioni storici (N)')
title(sprintf('r incerto, \\sigma_r / r = %.1f', r_unc_default))
legend(leg_cv_sel, 'Location', 'southeast')
ylim(yl_vol)

saveas(gcf, fullfile(figure_directory, 'fig7_scan_volatilita_meno_curve.png'));


end