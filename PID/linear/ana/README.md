# PID/linear/ana

Variante **ANA** dos coeficientes aerodinâmicos do DH (alternativa à SATO).

Contém `MATRIZES_DH.m`, gerado automaticamente por `../utilitarios/DH_build_model.m`.

O arquivo populates no workspace, entre outras coisas:

- `Ve`, `he`, `gammae` — ponto de trim
- `Ue`, `Xe` — entradas e estados no trim
- `A_long`, `B_long`, `C_long`, `D_long` — modelo linear longitudinal
- `A_lat`,  `B_lat`,  `C_lat`,  `D_lat`  — modelo linear látero-direcional
- `sys_DH`, `sys_long`, `sys_lat` — objetos `ss` correspondentes

Para usar esta variante, em `../../DH_inicializacao.m`:

```matlab
coef_choice = 'ana';
```

> Não edite `MATRIZES_DH.m` à mão — ele é regenerado pelo `DH_build_model` toda vez que mudar `coef_DH.m`, parâmetros físicos ou o ponto de trim.
