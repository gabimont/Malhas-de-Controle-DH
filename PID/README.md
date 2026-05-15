# Controle PID — Drone Híbrido (DH) modo asa-fixa

Modelo da planta + piloto automático em **PID cascata** para o drone híbrido (DH) voando em modo asa-fixa.

> **Comparação com LQR:** os scripts que comparam este controle com o LQR ficam em [`../Comparar LQR e PID/`](../Comparar%20LQR%20e%20PID/).

---

## Início rápido

```matlab
% 1. Entre no diretório
cd .../Malhas-de-Controle-DH/PID

% 2. Inicialize o workspace (todas as refs no trim por default)
DH_inicializacao

% 3. (opcional) Excite alguma malha — ver seção "Excitar o sistema"
%    Ex: h_ref = he + 50;
%        psi_ref_final = deg2rad(20);

% 4. Simule  (Run no Simulink em modelo_NL_DH_CL  ou  sim(...))
out = sim('modelo_NL_DH_CL');

% 5. Veja os resultados
plot_PID
```

> **Sem excitação**, o sistema fica no equilíbrio (saída convergindo para o trim). Para ver alguma resposta, sobrescreva uma das referências antes de rodar `sim(...)`. Ver [Excitar o sistema](#3-opcional-excitar-o-sistema).

---

## Pré-requisitos

- MATLAB R2025b ou superior
- Simulink
- Optimization Toolbox (para o `fsolve` do trim)

---

## Estrutura

```
PID/
│
├── DH_inicializacao.m         ★ Setup do workspace (rode TODA sessão)
├── plot_PID.m                 ★ Plot dos sinais (após uma sim)
├── README.md                  Este arquivo
│
├── utilitarios/               ← código compartilhado da planta + ferramentas
│   ├── DH_build_model.m         Trim + linearização (gera as MATRIZES_DH)
│   ├── sfunction_DH.m           S-Function da planta NL
│   ├── dyn_rigidbody_DH.m       Derivadas (flag=1)
│   ├── obs_rigidbody_DH.m       Saídas (flag=3)
│   ├── modelo_DH.m              Forças e momentos
│   ├── coef_DH.m                Coeficientes aerodinâmicos
│   ├── trimagem_DH.m            Trim via fsolve
│   ├── aerodynamics.m
│   ├── propulsion.m
│   └── ISA.m                    Atmosfera padrão
│
├── linear/                    ← análise linear
│   ├── utilitarios/             Código/modelos compartilhados entre variantes
│   │   ├── lin_DH.m                  Função de linearização numérica
│   │   ├── modelo_linear_DH.m        Constrói sys_DH, sys_long, sys_lat
│   │   ├── modelo_linear_DH_CL.slx   Closed-loop linear
│   │   ├── Comparation_L_and_NL_Long.slx
│   │   └── Comparation_L_and_NL_Lat.slx
│   ├── sato/MATRIZES_DH.m       ↳ Entre aqui pra usar variante SATO
│   └── ana/MATRIZES_DH.m        ↳ Entre aqui pra usar variante ANA
│
└── nao_linear/                ← simulação NL
    ├── sfunction_DH.m
    ├── modelo_NL_DH_OL.slx      Planta NL standalone (open-loop)
    └── modelo_NL_DH_CL.slx      Closed-loop NL com PID
```

---

## Fluxo de uso

### 1. Build do modelo (uma vez no projeto, ou se mudou trim/coef)

```matlab
DH_build_model
```

Faz trim com `fsolve` e linearização **para as duas variantes** (`sato` e `ana`). Grava:
- `linear/sato/MATRIZES_DH.m`
- `linear/ana/MATRIZES_DH.m`

Re-rodar sempre que mudar:
- coeficientes em `utilitarios/coef_DH.m`
- velocidade/altitude/gama de trim (`Ve`, `he`, `gammae`)
- parâmetros físicos (massa, S, b, c, inércia) em `utilitarios/modelo_DH.m`

### 2. Inicialização (toda sessão, é rápido)

```matlab
DH_inicializacao
```

Escolha qual variante usar no topo do script:
```matlab
coef_choice = 'sato';   % ou 'ana'
```

Carrega `linear/<coef_choice>/MATRIZES_DH.m`, define ganhos do piloto automático e referências.

### 3. (Opcional) Excitar o sistema

> ⚠️ **Por default, todas as referências ficam no trim — o sistema fica em equilíbrio, sem step nenhum.**
> Pra excitar uma malha, sobrescreva a variável **depois** de `DH_inicializacao` e **antes** de `sim(...)`.

Cheat sheet das excitações disponíveis:

```matlab
DH_inicializacao              % carrega defaults (todas refs no trim)

% --- Escolha UMA ou MAIS das excitacoes abaixo, ou nenhuma ---

%% Step de altitude (+50 m)
h_ref = he + 50;

%% Step de velocidade (+6 m/s)
VT_ref = Ve + 6;

%% Step de heading (vira 20° pra direita em t=5s)
psi_ref_init  = 0;
psi_ref_final = deg2rad(20);
psi_ref_t     = 5;

%% Step direto em theta (bypassa malha de altitude, igual ao teste do LQR)
att_alt          = 1;            % liga o modo de comando direto de theta
theta_step_init  = 0;
theta_step_final = deg2rad(5);   % step de 5 deg
theta_step_t     = 5;

out = sim('modelo_NL_DH_CL');    % roda
plot_PID                         % visualiza
```

Resumo de quais variáveis ativam o quê:

| Quero excitar... | Variáveis | Default (sem step) |
|---|---|---|
| **Altitude** | `h_ref` | `h_ref = he` |
| **Velocidade** | `VT_ref` | `VT_ref = Ve` |
| **Heading** | `psi_ref_init`, `psi_ref_final`, `psi_ref_t` | tudo `0` |
| **Pitch direto** (sem malha de altitude) | `att_alt=1` + `theta_step_*` | `att_alt=0`, steps `0` |

### 4. Simular

```matlab
% Não-linear (planta completa + PID cascata)
out = sim('modelo_NL_DH_CL');     plot_PID

% Linear (mesmo CL, com A,B,C,D no lugar da S-Function)
open modelo_linear_DH_CL.slx

% Validação linear vs não-linear (open-loop, eixo a eixo)
open Comparation_L_and_NL_Long
open Comparation_L_and_NL_Lat
```

### 5. Comparar com o LQR

```matlab
cd ../"Comparar LQR e PID"
comparar_PID_vs_LQR
```

(Esse wrapper força automaticamente `att_alt=1` + step de θ = 5° em t=5s pra bater com o teste do LQR. Você não precisa setar nada à mão.)

---

## Configurações em `DH_inicializacao.m`

| Variável | Descrição | Default |
|---|---|---|
| `coef_choice` | Variante aerodinâmica | `'sato'` |
| `att_alt` | `0`=altitude (cascata) · `1`=theta-step direto | `0` |
| `h_ref` | Referência de altitude | `he` (trim) |
| `VT_ref` | Referência de velocidade | `Ve` (trim) |
| `psi_ref_init`, `psi_ref_final`, `psi_ref_t` | Step de heading | `0`, `0`, `5 s` |
| `theta_step_init`, `theta_step_final`, `theta_step_t` | Step direto de theta (só age com `att_alt=1`) | `0`, `0`, `5 s` |
| `C_alt`, `C_theta`, `C_vel`, `C_phi` | Estruturas com ganhos PID das malhas | configurado no script |
| `K_heading` | Ganho heading P | configurado no script |
| `Kq`, `Kp`, `Kr` | SAS dampers (rate damping) | `0` |

> **Por default todas as referências ficam no trim — o sistema fica em equilíbrio, sem step nenhum.** Para excitar, ver [3. (Opcional) Excitar o sistema](#3-opcional-excitar-o-sistema) acima.

---

## Arquitetura do controle (cascata PID)

### Longitudinal

```
                    Altitude Hold (PID lento)
h_ref ───►(+)───► PID ───► theta_ref ───┐
[h] ──────┘                              │
                                         ▼
                Pitch Attitude Hold (PID rápido, forma PI-D)
theta_ref ───►(+)───► PID ───► delta_e
[theta] ─────┘

                Velocity Hold (PIDF)
VT_ref ───►(+)───► PID ───► delta_T
[VT] ─────┘
```

> **Nota:** o PID de pitch está em forma **PI-D** (derivada na medida, não no erro) — evita "derivative kick" em steps de referência.

### Latero-direcional

```
            Heading Hold (P)
psi_ref ───►(+)───► K_psi ───► phi_ref ───┐
[psi] ─────┘                                │
                                            ▼
            Bank Angle Hold (PID, ganhos negativos)
phi_ref ───►(+)───► PID ───► delta_a
[phi] ─────┘
```

Rudder: washout filter `s/(s+1)` em `r` (yaw damper).

> **Nota:** os ganhos de roll têm sinal negativo porque `Cl_da < 0` (logo `B_lat(p, aileron) < 0`).

---

## Topologia de comandos no modelo NL

A `S-Function` espera o vetor de entrada nessa ordem:

```
U = [throttle, elevator, aileron, rudder, wind_x, wind_y, wind_z]
     U(1)     U(2)      U(3)     U(4)    U(5..7)
```

No `modelo_NL_DH_CL.slx`, o piloto automático produz **delta** (perturbação em torno do trim). A soma com o trim absoluto acontece **antes** dos saturadores:

```
PID_out (delta) ───►(+)───► Sat ───► canal absoluto da S-Function
                     ▲
                  TrimInput(k) = Ue(k)
```

**Saturadores (limites físicos):**
- Throttle: `[0, 1]`
- Elevator/Aileron/Rudder: `[-25°, +25°] = [-0.4363, +0.4363] rad`

---

## Referências

- STEVENS, B. L.; LEWIS, F. L. *Aircraft Control and Simulation*, 3rd ed. Wiley, 2016.
- SANTOS, M. *Modelagem e Controle de Aeronaves*, ITA, 2018.
- SATO, F. C. Y. C. *Modelo matemático completo não-linear DH*, ITA / EEC-D.
