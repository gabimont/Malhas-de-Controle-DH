# Malhas de Controle DH

Projetos de controle do **Drone Híbrido (DH)** em modo asa-fixa, com duas implementações independentes do piloto automático sobre a mesma planta não-linear (S-Function `sfunction_DH`, mesmos coeficientes, mesmo trim):

- **PID cascata** (interno → externo, com tuning via `pidtune`)
- **LQR** (realimentação de estados)

Inclui também scripts que rodam as duas leis de controle nas mesmas condições e plotam lado a lado pra inspeção visual.

---

## Pastas

| Pasta | O que tem |
|---|---|
| [`PID/`](PID/) | Planta NL + piloto automático em PID cascata, com análise linear (modelos lineares, validação L vs NL) e ferramentas de trim/linearização. |
| [`LQR/`](LQR/) | Planta NL + piloto automático LQR (state-feedback) com ganhos pré-computados em `DH.mat`. |
| [`Comparar LQR e PID/`](Comparar%20LQR%20e%20PID/) | Wrappers que rodam os dois `.slx` na mesma excitação e geram um plot sobreposto dos dez sinais principais. |

Cada pasta tem seu próprio `README.md` com o passo a passo de uso.

---

## Pré-requisitos

- MATLAB **R2025b** ou superior
- Simulink
- Optimization Toolbox (apenas para o `fsolve` do trim do PID)

---

## Início rápido

```matlab
% PID
cd PID
DH_inicializacao
% rode o Simulink (Run em modelo_NL_DH_CL)  ou  out = sim('modelo_NL_DH_CL');
plot_PID

% LQR
cd ../LQR
LQRy_nonlinear

% Comparar os dois lado a lado
cd "../Comparar LQR e PID"
comparar_PID_vs_LQR
```

---

## Autores

- PID, comparação e organização do repositório — Kaue Martins (ITA / EEC-D)
- LQR — Huascar Mirko Montecinos Cortez (ITA / EEC-D)

---

## Referências

- STEVENS, B. L.; LEWIS, F. L. *Aircraft Control and Simulation*, 3rd ed. Wiley, 2016.
- SANTOS, M. *Modelagem e Controle de Aeronaves*, ITA, 2018.
- SATO, F. C. Y. C. *Modelo matemático completo não-linear DH*, ITA / EEC-D.
