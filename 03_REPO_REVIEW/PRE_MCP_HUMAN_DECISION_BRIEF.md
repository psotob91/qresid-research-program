Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load by API decision task

# PRE_MCP_HUMAN_DECISION_BRIEF.md

Fecha: 2026-05-10

## 1. Decision pendiente

`API_01`: elegir API publica final antes de habilitar MCP para cambios de codigo, help, examples o tests publicos.

La arquitectura vigente en `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md` propone:

```stata
qresid newvarname [if] [in] [, seed(integer) uvar(varname numeric) ///
    savev(name) saveflo(name) savefhi(name) saveu(name) family(string) ]
```

## 2. Opcion A: `qresid newvarname, options`

Ejemplo:

```stata
qresid rq, seed(12345) saveflo(flo) savefhi(fhi) saveu(u)
```

Ventajas:

- Estilo Stata simple y natural para comandos que generan una variable principal.
- Alineada con `09`.
- Parser mas directo con `syntax newvarname`.
- Menor superficie para help/tests/examples.

Riesgos:

- Menos explicita que `generate()`.
- Requiere documentar muy bien que `newvarname` es el residuo principal.

Impacto:

- Help/examples compactos.
- Tests de sintaxis simples.
- Menos aliases publicos.

Recomendacion: `RECOMENDADA`.

## 3. Opcion B: `qresid, generate(newvarname) options`

Ejemplo:

```stata
qresid, generate(rq) seed(12345) saveflo(flo) savefhi(fhi) saveu(u)
```

Ventajas:

- Muy explicita para usuarios que buscan una opcion de salida.
- Facil de extender si en el futuro hubiera multiples outputs primarios.

Riesgos:

- Mas verbosa.
- Duplica patrones si tambien existen `save*()`.
- Requiere parser y help mas extensos.
- Se aleja de la sintaxis recomendada en `09`.

Impacto:

- Mas tests de sintaxis.
- Mayor riesgo de confusion entre `generate()` y `saveu()/saveflo()/savefhi()`.

Recomendacion: no elegir salvo preferencia editorial fuerte.

## 4. Opcion C: interfaz hibrida

Ejemplo:

```stata
qresid rq, seed(12345)
qresid, generate(rq) seed(12345)
```

Ventajas:

- Flexible para usuarios con preferencias distintas.
- Permite compatibilidad si ya existieran ejemplos publicos divergentes.

Riesgos:

- Dos APIs publicas que deben mantenerse para siempre.
- Doble superficie de parser, help, examples y tests.
- Mayor probabilidad de shadow rules.

Impacto:

- Tests duplicados.
- Help mas largo.
- Riesgo de inconsistencias entre aliases.

Recomendacion: no elegir para Fase 1 salvo necesidad comprobada.

## 5. Recomendacion final

Elegir Opcion A:

```stata
qresid newvarname [if] [in] [, seed(integer) uvar(varname numeric) ///
    savev(name) saveflo(name) savefhi(name) saveu(name) family(string) ]
```

Motivo: es la API mas simple, la mas alineada con `09`, y minimiza superficie de mantenimiento SSC/Stata Journal.

Decision humana requerida: confirmar si `family()` queda como opcion condicional en Fase 1 o si se posterga hasta que exista un caso real donde `e(family)` no baste.
