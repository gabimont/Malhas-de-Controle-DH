# PID/linear/utilitarios

Código e modelos lineares compartilhados entre as variantes (`sato`, `ana`).

> Volte ao [README de PID/linear](../README.md) ou ao [README do PID](../../README.md).

---

## Arquivos

| Arquivo | Função |
|---|---|
| `lin_DH.m` | Função de linearização numérica em torno de um ponto de trim (chamada pelo `DH_build_model`). |
| `modelo_linear_DH.m` | Constrói os `ss` objects do MATLAB: `sys_DH` (completo), `sys_long`, `sys_lat`. |
| `modelo_linear_DH_CL.slx` | Closed-loop **linear** com o mesmo piloto automático PID — útil para checar margens de estabilidade. |
| `Comparation_L_and_NL_Long.slx` | Open-loop, eixo longitudinal: planta linear lado a lado com a NL. |
| `Comparation_L_and_NL_Lat.slx` | Open-loop, eixo látero-direcional: planta linear lado a lado com a NL. |

---

## Uso típico

Após `DH_inicializacao` (que carrega `A_long`, `B_long`, `A_lat`, `B_lat`, `Ue`, `Xe`, ...):

```matlab
% Comparar resposta linear vs NL em malha aberta
open Comparation_L_and_NL_Long
open Comparation_L_and_NL_Lat

% Rodar o closed-loop linear
out_lin = sim('modelo_linear_DH_CL');
```
