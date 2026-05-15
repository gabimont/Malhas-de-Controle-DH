# PID/linear

Análise linear da planta DH (modo asa-fixa).

Esta pasta contém:

- **Modelos lineares de validação** (em [`utilitarios/`](utilitarios/)).
- **Matrizes A,B,C,D pré-computadas** para duas variantes de coeficientes aerodinâmicos:
  - [`sato/`](sato/) — variante baseada em Sato (default).
  - [`ana/`](ana/) — variante alternativa.

> Volte ao [README do PID](../README.md) para o fluxo de uso completo.

---

## Como as matrizes são geradas

Ambos os arquivos `<variante>/MATRIZES_DH.m` são **gerados automaticamente** por:

```matlab
cd ../utilitarios
DH_build_model
```

`DH_build_model` faz trim com `fsolve` e linearização para as duas variantes, e grava cada `MATRIZES_DH.m` no diretório correspondente.

---

## Como uma variante é escolhida

No início de `../DH_inicializacao.m`:

```matlab
coef_choice = 'sato';   % ou 'ana'
```

O `DH_inicializacao` então faz `addpath` da pasta da variante escolhida e roda o `MATRIZES_DH.m` dela, populando o workspace com `A_long`, `B_long`, `A_lat`, `B_lat`, `Ue`, `Xe`, etc.

---

## Validação linear vs não-linear

Os modelos `.slx` em [`utilitarios/`](utilitarios/) rodam a planta linearizada lado a lado com a planta NL para inspecionar a divergência das duas em torno do trim:

- `Comparation_L_and_NL_Long.slx` — eixo longitudinal.
- `Comparation_L_and_NL_Lat.slx` — eixo látero-direcional.
- `modelo_linear_DH_CL.slx` — closed-loop linear (mesmo PID, A,B,C,D no lugar da S-Function).
