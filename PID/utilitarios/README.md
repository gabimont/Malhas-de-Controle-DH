# PID/utilitarios

Código compartilhado da **planta NL** + ferramentas de **trim/linearização** usadas pelo controle PID.

A planta aqui é a mesma S-Function que está em [`../LQR/`](../../LQR/) — replicada para que cada pasta seja auto-suficiente.

> Volte ao [README do PID](../README.md) para o fluxo de uso completo.

---

## Arquivos

| Arquivo | Função |
|---|---|
| `DH_build_model.m` | **Entry point**. Faz trim com `fsolve` e linearização para as duas variantes (`sato`, `ana`). Grava `linear/<variante>/MATRIZES_DH.m`. Rode **uma vez** por projeto (ou quando mudar coef/trim). |
| `sfunction_DH.m` | S-Function nível 1 da planta NL (flag 0=size, 1=derivs, 3=output). |
| `dyn_rigidbody_DH.m` | Equações de estado (`xdot = f(x,u)`), chamada pela S-Function em flag=1. |
| `obs_rigidbody_DH.m` | Equações de saída (`y = g(x,u)`), chamada pela S-Function em flag=3. |
| `modelo_DH.m` | Forças e momentos aerodinâmicos + propulsivos (parâmetros físicos: massa, S, b, c, inércia). |
| `coef_DH.m` | Coeficientes aerodinâmicos (variante SATO por default). |
| `aerodynamics.m`, `aerodynamics2.m` | Helpers para forças aerodinâmicas. |
| `propulsion.m` | Modelo da propulsão. |
| `ISA.m` | Atmosfera padrão (densidade vs altitude). |
| `trimagem_DH.m` | Função de trim via `fsolve` (chamada pelo `DH_build_model`). |

---

## Quando re-rodar `DH_build_model`

Sempre que mudar:

- coeficientes em `coef_DH.m`
- velocidade/altitude/gama de trim (`Ve`, `he`, `gammae` definidos dentro do `DH_build_model`)
- parâmetros físicos em `modelo_DH.m`

O re-build regrava `../linear/sato/MATRIZES_DH.m` e `../linear/ana/MATRIZES_DH.m`.
