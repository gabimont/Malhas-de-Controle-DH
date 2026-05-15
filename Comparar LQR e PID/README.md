# Comparar LQR e PID

Scripts pra rodar e comparar os dois controladores do projeto **DH (Drone Híbrido)** na mesma planta não-linear e nas mesmas condições.

- **PID** (cascata): mora em [`../PID/`](../PID/)
- **LQR** (state-feedback): mora em [`../LQR/`](../LQR/)

A planta NL é a mesma nos dois (S-Function `sfunction_DH`, mesmos coeficientes, mesmo trim). A única coisa que muda entre os dois ramos é o controlador.

---

## Pré-requisitos

- MATLAB R2025b ou superior
- Simulink
- As pastas [`../PID/`](../PID/) e [`../LQR/`](../LQR/) presentes no mesmo nível (já é o caso no repositório).

---

## Início rápido

```matlab
cd .../Malhas-de-Controle-DH/'Comparar LQR e PID'
comparar_PID_vs_LQR
```

Isso roda o teste padrão (step de θ = 5° em t = 5 s) nas duas configurações e abre uma janela com **10 painéis** sobrepondo:

- **LQR** (ciano)
- **PID** (laranja)
- **Referência** (branco tracejado)

Os painéis são (5×2): `q`, `r`, `theta`, `ail`, `elev`, `psi`, `h`, `p`, `phi`, `rud`.

---

## Arquivos

| Arquivo | Descrição |
|---|---|
| `comparar_PID_vs_LQR.m` | Script wrapper: roda os dois `.slx` e chama o plot |
| `plot_PID_vs_LQR.m` | Função: recebe `(out_PID, out_LQR)` e gera os 10 painéis |

---

## O que o wrapper faz internamente

1. **Roda o PID** — entra em `../PID`, chama `DH_inicializacao`, força `att_alt = 1` (modo theta-step direto), simula `modelo_NL_DH_CL.slx`.
2. **Roda o LQR** — entra em `../LQR`, carrega `DH.mat`, força `att_alt = 0` (modo theta-step direto da config do LQR), simula `Close_loop_nao_linear.slx`.
3. **Plota** — chama `plot_PID_vs_LQR(out_PID, out_LQR)`.

Os arquivos intermediários ficam em `tempdir`:
- `out_PID.mat`
- `out_LQR.mat`

Se você já tiver eles, pode pular as simulações e só plotar:
```matlab
load(fullfile(tempdir,'out_PID.mat'))
load(fullfile(tempdir,'out_LQR.mat'))
plot_PID_vs_LQR(out_PID, out_LQR)
```

---

## Variar o teste

A referência de pitch é um Step block dentro de cada modelo:

| Onde está | Bloco | Default |
|---|---|---|
| PID | `modelo_NL_DH_CL/controle/theta_step` | `Time=5, After=deg2rad(5)` |
| LQR | `Close_loop_nao_linear/theta2` | `Time=5, After=5` |

Pra mudar (ex: step de 3° em t=10s):
- PID: `Time=10`, `After=deg2rad(3)`
- LQR: `Time=10`, `After=3` (já em graus, há um `deg2rad` downstream)

Depois roda `comparar_PID_vs_LQR` de novo.
