% plot_PID.m
% =============================================================
% Plota os resultados de uma simulacao do modelo NL closed-loop
% (modelo_NL_DH_CL.slx) em 10 paineis 5x2 (mesmo layout do scope
% do LQR do Mirko, mas com SEU controle PID).
%
% Paineis (linha por linha, esquerda -> direita):
%   q          | r
%   theta+ref  | ail
%   elev       | psi+ref
%   h = -xD    | p
%   phi+ref    | rud
%
% O script le tres coisas do workspace:
%   1) resultados da simulacao, em uma destas formas:
%        a) variavel "out" (Simulink.SimulationOutput) — produzida por
%           sim('modelo_NL_DH_CL') OU pelo botao Run com "Single
%           Simulation Output" ligado.
%        b) variaveis soltas Y, U, tout (+ theta_ref opcional) — botao
%           Run com "Single Simulation Output" desligado, os blocos
%           To Workspace salvam direto no base.
%   2) K_heading       - ganho da malha de heading (de DH_inicializacao)
%   3) psi_ref_init/final/t - parametros do step de psi (de DH_inicializacao)
%
% Uso tipico:
%   DH_inicializacao           % carrega refs/ganhos default
%   % (opcional: excitar alguma malha, ex h_ref = he + 50)
%   % roda o Simulink (botao Run em modelo_NL_DH_CL  ou  out = sim(...))
%   plot_PID
% =============================================================

%% ---------- checagens ----------
% Aceita resultados em "out" ou em Y/U/tout soltos no base workspace.
if ~exist('out','var')
    if exist('Y','var') && exist('U','var') && exist('tout','var')
        out = struct();
        out.tout = tout;
        out.Y    = Y;
        out.U    = U;
        if exist('theta_ref','var')
            out.theta_ref = theta_ref;
        end
    else
        error(['Nenhum resultado de simulacao encontrado no workspace.\n' ...
               'Rode o modelo Simulink (Run em modelo_NL_DH_CL) ou:\n' ...
               '    out = sim(''modelo_NL_DH_CL'');\n' ...
               'antes de chamar plot_PID.']);
    end
end
if ~exist('K_heading','var')
    warning(['K_heading nao definido — vou assumir 0 (sem malha de heading). ' ...
             'Rode DH_inicializacao antes para ter o valor correto.']);
    K_heading = 0;
end

%% ---------- sinais da planta ----------
t = out.tout;
Y = out.Y.signals.values;     % [VT alpha beta gamma p q r phi theta psi ax ay az xN h mi lambda qdot]
U = out.U.signals.values;     % [throttle elevator aileron rudder]

R2D = 180/pi;
p_deg     = Y(:,5)  * R2D;
q_deg     = Y(:,6)  * R2D;
r_deg     = Y(:,7)  * R2D;
phi_deg   = Y(:,8)  * R2D;
theta_deg = Y(:,9)  * R2D;
psi_deg   = Y(:,10) * R2D;
h         = Y(:,15);
elev_deg  = U(:,2)  * R2D;
ail_deg   = U(:,3)  * R2D;
rud_deg   = U(:,4)  * R2D;

%% ---------- referencias ----------
% psi_ref: construida do step parametrico (psi_ref_init/final/t)
psi_ref = zeros(size(t));
if exist('psi_ref_init','var') && exist('psi_ref_final','var') && exist('psi_ref_t','var')
    psi_ref(t <  psi_ref_t) = psi_ref_init;
    psi_ref(t >= psi_ref_t) = psi_ref_final;
end
psi_ref_deg = psi_ref * R2D;

% phi_ref: saida da malha de heading = K_heading*(psi_ref - psi)
phi_ref_deg = K_heading * (psi_ref - Y(:,10)) * R2D;

% theta_ref: vem direto do modelo via ToWorkspace
if isfield(out,'theta_ref') || isprop(out,'theta_ref')
    theta_ref_deg = out.theta_ref.signals.values * R2D;
else
    warning('out.theta_ref nao encontrado — theta_ref nao sera plotado.');
    theta_ref_deg = nan(size(t));
end

%% ---------- helpers ----------
LW   = 1.4;
cSig = [1.0 0.55 0.0];      % laranja (PID)
cRef = [1.0 1.0 1.0];       % branco tracejado

set_dark = @() set(gca,'Color','k','XColor','w','YColor','w', ...
                       'GridColor','w','GridAlpha',0.3);

%% ---------- figura ----------
figure('Color','k','Position',[100 100 1100 1400]);

% --- (1,1) q ---
subplot(5,2,1); plot(t,q_deg,'Color',cSig,'LineWidth',LW); grid on;
title('q','Color','w'); ylabel('deg/s','Color','w');
ylim(pad_ylim(q_deg)); set_dark();

% --- (1,2) r ---
subplot(5,2,2); plot(t,r_deg,'Color',cSig,'LineWidth',LW); grid on;
title('r','Color','w'); ylabel('deg/s','Color','w');
ylim(pad_ylim(r_deg)); set_dark();

% --- (2,1) theta + ref ---
subplot(5,2,3); hold on;
plot(t,theta_ref_deg,'--','Color',cRef,'LineWidth',LW);
plot(t,theta_deg,'Color',cSig,'LineWidth',LW);
grid on; title('theta','Color','w'); ylabel('deg','Color','w');
legend({'ref','theta'},'TextColor','w','Color','k','Box','off');
ylim(pad_ylim([theta_deg; theta_ref_deg(~isnan(theta_ref_deg))]));
set_dark();

% --- (2,2) ail ---
subplot(5,2,4); plot(t,ail_deg,'Color',cSig,'LineWidth',LW); grid on;
title('ail','Color','w'); ylabel('deg','Color','w');
ylim(pad_ylim(ail_deg)); set_dark();

% --- (3,1) elev ---
subplot(5,2,5); plot(t,elev_deg,'Color',cSig,'LineWidth',LW); grid on;
title('elev','Color','w'); ylabel('deg','Color','w');
ylim(pad_ylim(elev_deg)); set_dark();

% --- (3,2) psi + ref ---
subplot(5,2,6); hold on;
plot(t,psi_ref_deg,'--','Color',cRef,'LineWidth',LW);
plot(t,psi_deg,'Color',cSig,'LineWidth',LW);
grid on; title('psi','Color','w'); ylabel('deg','Color','w');
legend({'ref','psi'},'TextColor','w','Color','k','Box','off');
ylim(pad_ylim([psi_deg; psi_ref_deg])); set_dark();

% --- (4,1) h = -xD ---
subplot(5,2,7); plot(t,h,'Color',cSig,'LineWidth',LW); grid on;
title('h = -xD','Color','w'); ylabel('m','Color','w');
ylim(pad_ylim(h)); set_dark();

% --- (4,2) p ---
subplot(5,2,8); plot(t,p_deg,'Color',cSig,'LineWidth',LW); grid on;
title('p','Color','w'); ylabel('deg/s','Color','w');
ylim(pad_ylim(p_deg)); set_dark();

% --- (5,1) phi + ref ---
subplot(5,2,9); hold on;
plot(t,phi_ref_deg,'--','Color',cRef,'LineWidth',LW);
plot(t,phi_deg,'Color',cSig,'LineWidth',LW);
grid on; title('phi','Color','w'); ylabel('deg','Color','w');
xlabel('t [s]','Color','w');
legend({'ref','phi'},'TextColor','w','Color','k','Box','off');
ylim(pad_ylim([phi_deg; phi_ref_deg])); set_dark();

% --- (5,2) rud ---
subplot(5,2,10); plot(t,rud_deg,'Color',cSig,'LineWidth',LW); grid on;
title('rud','Color','w'); ylabel('deg','Color','w');
xlabel('t [s]','Color','w');
ylim(pad_ylim(rud_deg)); set_dark();

%% ---------- local function ----------
function ylims = pad_ylim(y)
    y = y(~isnan(y));
    a = min(y); b = max(y);
    span = max(b-a, 1);
    ylims = [a-0.1*span, b+0.1*span];
end
