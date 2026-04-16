clc;clear all;

%seed = 420;

%rng(seed);

p = 20;
c = 10;
r_truth = 5; % in realtà questa è la media della normale usata per valutare l'incertezza sulla stima del costo di recupero


r_uncertainty_flag = true; %se è True viene modellato r come una variabile casuale distribuita normalmente attorno a r_truth. Altrimenti costante
CuCo_ratio_scan_flag = false; %se True fa lo scan a diversi rapporti di costo di overage e underage
MuSigma_ratio_scan_flag = false; %se True fa lo scan a diversi rapporti di mu e sigma

% vedere se gestire il caso cuco true e musigma true... altrimenti va bene
% così.

mu_truth = 120;
sigma_truth = 30;

sample_size = [5, 10, 20, 50, 100, 500, 1000];


n_iter = 10000;

if CuCo_ratio_scan_flag && MuSigma_ratio_scan_flag == false
    scan = 0.1:0.1:0.9;
    p = 20 * ones(length(scan),1);
    r_truth = 5  * ones(length(scan),1);
    c = p - scan' .* (p - r_truth);
    profit_ratio_mean = zeros(length(sample_size), length(scan));
    relmu_mean = zeros(length(sample_size), length(scan));
    relsigma_mean = zeros(length(sample_size), length(scan));

    for i=1:length(scan)
        [profit_ratio_mean(:,i),relmu_mean(:,i),relsigma_mean(:,i)]=newsvendorMontecarlo(n_iter,sample_size,p(i),c(i),r_truth(i),mu_truth,sigma_truth,r_uncertainty_flag);
    end

elseif MuSigma_ratio_scan_flag && CuCo_ratio_scan_flag == false
    scan = 0.05:0.05:0.4; % per evitare casi in cui domanda negativa sia non trascurabile
    mu_truth = mu_truth * ones(length(scan),1); 
    sigma_truth = mu_truth .* scan'; 
    profit_ratio_mean = zeros(length(sample_size), length(scan));
    relmu_mean = zeros(length(sample_size), length(scan));
    relsigma_mean = zeros(length(sample_size), length(scan));

    for i = 1:length(scan)
        [profit_ratio_mean(:,i),relmu_mean(:,i),relsigma_mean(:,i)]  = newsvendorMontecarlo(n_iter, sample_size, p, c, r_truth, mu_truth(i), sigma_truth(i), r_uncertainty_flag);
    end
elseif MuSigma_ratio_scan_flag == false && CuCo_ratio_scan_flag == false
    [profit_ratio_mean,relmu_mean,relsigma_mean] = newsvendorMontecarlo(n_iter,sample_size,p,c,r_truth,mu_truth,sigma_truth,r_uncertainty_flag);
end








