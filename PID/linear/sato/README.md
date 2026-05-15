# PID/linear/sato

Variante **SATO** dos coeficientes aerodinâmicos do DH (default).

Contém `MATRIZES_DH.m`, gerado automaticamente por `../utilitarios/DH_build_model.m`.

O arquivo populates no workspace, entre outras coisas:

- `Ve`, `he`, `gammae` — ponto de trim
- `Ue`, `Xe` — entradas e estados no trim
- `A_long`, `B_long`, `C_long`, `D_long` — modelo linear longitudinal
- `A_lat`,  `B_lat`,  `C_lat`,  `D_lat`  — modelo linear látero-direcional
- `sys_DH`, `sys_long`, `sys_lat` — objetos `ss` correspondentes

Para usar esta variante, em `../../DH_inicializacao.m`:

```matlab
coef_choice = 'sato';
```

> Não edite `MATRIZES_DH.m` à mão — ele é regenerado pelo `DH_build_model` toda vez que mudar `coef_DH.m`, parâmetros físicos ou o ponto de trim.
