# PID/nao_linear

Modelos Simulink **não-lineares** da planta DH usados pelo controle PID.

> Volte ao [README do PID](../README.md) para o fluxo de uso completo (inicialização, excitação, comparação).

---

## Arquivos

| Arquivo | Descrição |
|---|---|
| `modelo_NL_DH_CL.slx` | **Closed-loop**: planta NL + piloto automático PID em cascata. É o modelo padrão simulado por `out = sim('modelo_NL_DH_CL')`. |
| `modelo_NL_DH_OL.slx` | **Open-loop**: planta NL standalone, sem controle. Útil para validar a planta isolada (entrada manual / step nos atuadores). |
| `sfunction_DH.m` | Cópia local da S-Function da planta (mesma de `../utilitarios/sfunction_DH.m`) — replicada para o modelo encontrar quando rodando direto desta pasta. |

---

## Como rodar

Da pasta raiz do PID (a `DH_inicializacao` adiciona esta pasta ao path):

```matlab
cd ../
DH_inicializacao
out = sim('modelo_NL_DH_CL');
plot_PID
```

## Excitar uma malha

Antes de `sim(...)`, sobrescreva uma das referências — ver seção "Excitar o sistema" no [README do PID](../README.md).
