# LQR — Drone Híbrido (DH) modo asa-fixa

Controle por **realimentação de estados (LQR)** no modo asa-fixa do drone híbrido.

Autor: Huascar Mirko Montecinos Cortez (ITA / EEC-D)

## Requisitos

- MATLAB R2025b ou superior
- Simulink

## Como rodar

Execute o script:

```matlab
LQRy_nonlinear
```

Ele carrega o workspace via `DH.mat` (matrizes, ganhos LQR e parâmetros pré-computados) e abre/simula `Close_loop_nao_linear.slx`. O teste é sempre um **step de θ** (referência de pitch) — o instante e a amplitude são editados direto no bloco Step dentro do `Close_loop_nao_linear.slx`.

## Comparar com o PID

Os scripts que comparam este controle com o PID do colega ficam em
`../Comparar LQR e PID/`.
