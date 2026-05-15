function plot_PID_vs_LQR(out_PID, out_LQR)
% Plota 10 paineis (layout do scope do Mirko) sobrepondo:
%   PID         (laranja,  out_PID  - modelo_NL_DH_CL com att_alt=1)
%   LQR         (ciano,    out_LQR  - Close_loop_nao_linear do Mirko)
%   Referencia  (branco tracejado)

R2D = 180/pi;

%% --- PID (Kaue) ---
tP   = out_PID.tout;
Y    = out_PID.Y.signals.values;
U    = out_PID.U.signals.values;
p_P     = Y(:,5)*R2D; q_P = Y(:,6)*R2D; r_P = Y(:,7)*R2D;
phi_P   = Y(:,8)*R2D; theta_P = Y(:,9)*R2D; psi_P = Y(:,10)*R2D;
h_P     = Y(:,15);
elev_P  = U(:,2)*R2D; ail_P = U(:,3)*R2D; rud_P = U(:,4)*R2D;

%% --- LQR (Mirko) --- (sinais salvos JA EM GRAUS; xD em metros positivos)
% theta_NL, phi_NL, psi_NL tem 2 cols: [actual, referencia]
tL      = out_LQR.tout;
theta_L = out_LQR.theta_NL.signals.values(:,1);   theta_ref_L = out_LQR.theta_NL.signals.values(:,2);
phi_L   = out_LQR.phi_NL.signals.values(:,1);     phi_ref_L   = out_LQR.phi_NL.signals.values(:,2);
psi_L   = out_LQR.psi_NL.signals.values(:,1);     psi_ref_L   = out_LQR.psi_NL.signals.values(:,2);
p_L     = out_LQR.p_NL.signals.values;
q_L     = out_LQR.q_NL.signals.values;
r_L     = out_LQR.r_NL.signals.values;
ail_L   = out_LQR.ail_NL.signals.values;
elev_L  = out_LQR.elev_NL.signals.values;
rud_L   = out_LQR.rud_NL.signals.values;
h_L     = out_LQR.xD_NL.signals.values;

%% --- Referencias (vem do proprio modelo do Mirko) ---
% h_ref no teste theta-step e constante (sem comando de altitude)
h_ref     = 600 * ones(size(tL));

%% --- Cores ---
cREF = [1.0  1.0  1.0];   % branco
cLQR = [0.0  1.0  1.0];   % ciano
cPID = [1.0  0.55 0.0];   % laranja
lw   = 1.4;

%% --- Figura ---
figure('Color','k','Position',[80 60 1200 1500]);

panel(1,1, {tL,q_L},     {tP,q_P},     'q','deg/s',[-10 10], cLQR, cPID, lw);
panel(1,2, {tL,r_L},     {tP,r_P},     'r','deg/s',[-10 10], cLQR, cPID, lw);
panelRef(2,1, {tL,theta_ref_L}, {tL,theta_L}, {tP,theta_P}, 'theta','deg',[-5 15], cREF, cLQR, cPID, lw);
panel(2,2, {tL,ail_L},   {tP,ail_P},   'ail','deg',[-10 10], cLQR, cPID, lw);
panel(3,1, {tL,elev_L},  {tP,elev_P},  'elev','deg',[-25 25], cLQR, cPID, lw);
panelRef(3,2, {tL,psi_ref_L},   {tL,psi_L},   {tP,psi_P},   'psi','deg',[], cREF, cLQR, cPID, lw);
panelRef(4,1, {tL,h_ref},       {tL,h_L},     {tP,h_P},     'h = -xD','m',[], cREF, cLQR, cPID, lw);
panel(4,2, {tL,p_L},     {tP,p_P},     'p','deg/s',[-10 10], cLQR, cPID, lw);
panelRef(5,1, {tL,phi_ref_L},   {tL,phi_L},   {tP,phi_P},   'phi','deg',[-10 10], cREF, cLQR, cPID, lw);
xlabel('t [s]','Color','w');
panel(5,2, {tL,rud_L},   {tP,rud_P},   'rud','deg',[-10 10], cLQR, cPID, lw);
xlabel('t [s]','Color','w');
end

% ------------------ helpers ------------------

function panel(r,c, dataLQR, dataPID, ttl, ylab, ylims, cLQR, cPID, lw)
    subplot(5,2,(r-1)*2 + c); hold on;
    h = gobjects(2,1);
    h(1) = plot(dataLQR{1}, dataLQR{2}, 'Color', cLQR, 'LineWidth', lw);
    h(2) = plot(dataPID{1}, dataPID{2}, 'Color', cPID, 'LineWidth', lw);
    dressAxes(ttl, ylab, ylims);
    legend(h, {'LQR','PID'}, 'TextColor','w','Color','k','Box','off');
end

function panelRef(r,c, dataREF, dataLQR, dataPID, ttl, ylab, ylims, cREF, cLQR, cPID, lw)
    subplot(5,2,(r-1)*2 + c); hold on;
    h = gobjects(3,1);
    h(1) = plot(dataREF{1}, dataREF{2}, '--', 'Color', cREF, 'LineWidth', lw+0.4);
    h(2) = plot(dataLQR{1}, dataLQR{2},       'Color', cLQR, 'LineWidth', lw);
    h(3) = plot(dataPID{1}, dataPID{2},       'Color', cPID, 'LineWidth', lw);
    dressAxes(ttl, ylab, ylims);
    legend(h, {'Referencia','LQR','PID'}, 'TextColor','w','Color','k','Box','off');
end

function dressAxes(ttl, ylab, ylims)
    grid on; title(ttl,'Color','w'); ylabel(ylab,'Color','w');
    set(gca,'Color','k','XColor','w','YColor','w','GridColor','w','GridAlpha',0.3);
    axis tight;
    if ~isempty(ylims) && all(isfinite(ylims))
        ylim(ylims);
    end
end
