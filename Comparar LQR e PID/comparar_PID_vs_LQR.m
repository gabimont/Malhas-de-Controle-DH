% comparar_PID_vs_LQR.m
% =============================================================
% Roda o teste de step em theta nas duas configuracoes:
%   - PID  (cascata, em ../PID/modelo_NL_DH_CL.slx)
%   - LQR  (state-feedback, em ../LQR/Close_loop_nao_linear.slx)
% e plota nos 10 paineis (Referencia / LQR / PID).
%
% Uso:
%   cd /caminho/.../DH/atual/'Comparar LQR e PID'
%   comparar_PID_vs_LQR
% =============================================================

bdclose all; close all;

%% --------- 1) PID (../PID/, att_alt = 1) ---------
fprintf('\n>>> Rodando PID (att_alt=1) ...\n');
thisDir = fileparts(mfilename('fullpath'));     % atual/Comparar LQR e PID/
rootPID = fullfile(fileparts(thisDir),'PID');
addpath(thisDir);                                % deixa plot_PID_vs_LQR visivel
run(fullfile(rootPID,'DH_inicializacao.m'));     % faz clear; depois redefino
thisDir = fileparts(mfilename('fullpath'));
rootPID = fullfile(fileparts(thisDir),'PID');
addpath(thisDir);
% Modo theta-step (igual ao teste do LQR): step 0 -> 5 deg em t=5s
att_alt          = 1;
theta_step_init  = 0;
theta_step_final = deg2rad(5);
theta_step_t     = 5;
cd(fullfile(rootPID,'nao_linear'));
out_PID = sim('modelo_NL_DH_CL');
save(fullfile(tempdir,'out_PID.mat'),'out_PID','-v7.3');
cd(thisDir);
fprintf('   PID OK (%d amostras, t=%.1fs)\n', numel(out_PID.tout), out_PID.tout(end));

%% --------- 2) LQR (../LQR/, att_alt = 0) ---------
fprintf('\n>>> Rodando LQR (att_alt=0) ...\n');
bdclose all; clear;
thisDir = fileparts(mfilename('fullpath'));
rootLQR = fullfile(fileparts(thisDir),'LQR');
addpath(thisDir);
cd(rootLQR);
load('DH.mat');
att_alt = 0;
out_LQR = sim('Close_loop_nao_linear');
thisDir = fileparts(mfilename('fullpath'));
save(fullfile(tempdir,'out_LQR.mat'),'out_LQR','-v7.3');
cd(thisDir);
fprintf('   LQR OK (%d amostras, t=%.1fs)\n', numel(out_LQR.tout), out_LQR.tout(end));

%% --------- 3) Plot conjunto ---------
fprintf('\n>>> Plotando ...\n');
clear;
thisDir = fileparts(mfilename('fullpath'));
addpath(thisDir);
load(fullfile(tempdir,'out_PID.mat'));
load(fullfile(tempdir,'out_LQR.mat'));
plot_PID_vs_LQR(out_PID, out_LQR);
fprintf('\nPronto.\n');
