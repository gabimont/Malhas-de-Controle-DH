# Controle LQR — Drone Híbrido (DH) modo asa-fixa

Controle por **realimentação de estados (LQR)** no modo asa-fixa do drone híbrido (DH), com ganhos pré-computados e carregados a partir de `DH.mat`.

> **Comparação com PID:** os scripts que comparam este controle com o PID ficam em [`../Comparar LQR e PID/`](../Comparar%20LQR%20e%20PID/).

Autor original do código LQR: **Huascar Mirko Montecinos Cortez** (ITA / EEC-D).

---

## Pré-requisitos

- MATLAB R2025b ou superior
- Simulink

---

## Início rápido

```matlab
cd .../Malhas-de-Controle-DH/LQR
LQRy_nonlinear
```

O script:
1. Limpa o workspace e fecha modelos abertos.
2. Carrega `DH.mat` (matrizes da planta, ganhos LQR, parâmetros pré-computados).
3. Define o modo de teste em `att_alt`.
4. Abre e simula `Close_loop_nao_linear.slx`.

---

## Modos de teste

No topo de `LQRy_nonlinear.m`:

```matlab
att_alt = 0;   % 0 = step direto em theta
               % 1 = comando de altitude
```

Para mudar o tamanho/instante do degrau, edite o bloco **Step** correspondente dentro de `Close_loop_nao_linear.slx`:

| Modo | Bloco no Simulink |
|---|---|
| `att_alt = 0` (theta-step direto) | `Close_loop_nao_linear/theta2` |
| `att_alt = 1` (comando de altitude) | bloco do step de altitude no mesmo modelo |

---

## Estrutura

```
LQR/
├── LQRy_nonlinear.m            ★ Script de entrada
├── Close_loop_nao_linear.slx   ★ Modelo NL com realimentação LQR
├── DH.mat                      Workspace pré-computado (matrizes, ganhos LQR, trim)
├── README.md                   Este arquivo
│
├── modelo_DH.m                 Forças e momentos
├── coef_DH.m                   Coeficientes aerodinâmicos
├── aerodynamics.m              Cálculo de forças aerodinâmicas
├── aerodynamics2.m             Variante
├── propulsion.m                Modelo de propulsão
├── ISA.m                       Atmosfera padrão
│
├── dyn_rigidbody_DH.m          Derivadas (flag=1) da S-Function
├── obs_rigidbody_DH.m          Saídas (flag=3) da S-Function
├── sfunction_DH.m              S-Function da planta NL
│
├── modelo_linear_DH.m          Modelo linear (sys_DH, sys_long, sys_lat)
├── lin_DH.m                    Linearização numérica
└── trimagem_DH.m               Trim via fsolve
```

> **Nota:** o conteúdo desta pasta é independente do `PID/` (cada uma roda sozinha). A planta NL (S-Function `sfunction_DH`, coeficientes e parâmetros físicos) é a mesma nas duas, replicada localmente em cada pasta para que cada pasta seja auto-suficiente.

---

## Comparar com o PID

```matlab
cd ../"Comparar LQR e PID"
comparar_PID_vs_LQR
```

---

## Referências

- STEVENS, B. L.; LEWIS, F. L. *Aircraft Control and Simulation*, 3rd ed. Wiley, 2016.
- SANTOS, M. *Modelagem e Controle de Aeronaves*, ITA, 2018.
- SATO, F. C. Y. C. *Modelo matemático completo não-linear DH*, ITA / EEC-D.
