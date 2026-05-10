# STATA_PACKAGE_STYLE_RULES.md

## 0. Propósito

Reglas de estilo, estructura, interfaz pública y limpieza editorial para que `qresid` sea apto para repositorio público, SSC y eventual Stata Journal.

Regla central: ningún claim de soporte debe aparecer en el paquete si no existe implementación, help, ejemplo y test/certificación correspondiente.

---

## 1. Estructura esperada del paquete

| Ruta/archivo | Propósito | Regla obligatoria | Error a evitar |
|---|---|---|---|
| `qresid.ado` | Comando principal de postestimación | Primera línea ejecutable `version #`; `program qresid, rclass` | Código exploratorio o variables fijas |
| `qresid.sthlp` | Ayuda oficial del comando | Sintaxis, opciones, ejemplos, limitaciones | Teoría larga o promesas sin soporte |
| `qresid.pkg` | Archivo de instalación SSC | Listar archivos finales necesarios | Incluir scratch/tests pesados por error |
| `stata.toc` | Índice Stata | Descripción breve y limpia | Texto interno del proyecto |
| `README.md` | Presentación pública | Estado de soporte y ejemplos mínimos | Claims no certificados |
| `LICENSE` | Licencia del paquete | Licencia clara antes de distribución | Datasets sin licencia |
| `examples/` | Ejemplos reproducibles | Sin rutas absolutas; `version`; `set seed` si aplica | Ejemplos que dependen de archivos locales |
| `tests/` | Unit/integration tests | Separar unit, integration, r_benchmarks | Mezclar outputs temporales |
| `certification/` | Evidencia reproducible release/SJ | Logs, outputs, reportes, master scripts | Archivos generados manualmente |

---

## 2. Reglas de ado-style

- `ESTÁNDAR OFICIAL`: la primera línea ejecutable del programa debe ser `version #`.
- `ESTÁNDAR OFICIAL`: `qresid` debe ser comando de postestimación y declararse `program qresid, rclass` salvo rediseño explícito.
- `ESTÁNDAR OFICIAL`: usar `syntax`, no macros posicionales.
- `ESTÁNDAR OFICIAL`: usar `marksample` y cruzar con `e(sample)`.
- `ESTÁNDAR OFICIAL`: usar `tempvar`, `tempname`, `tempfile` para todo objeto interno.
- `ESTÁNDAR OFICIAL`: validar `e(cmd)` antes de calcular.
- `ESTÁNDAR OFICIAL`: usar `display as err` y `exit #` con códigos claros.
- `RECOMENDACIÓN OPERATIVA`: para modelos fuera de fase, devolver `exit 198` con mensaje explícito de no soporte.
- `RECOMENDACIÓN OPERATIVA`: mantener el ado principal delgado; mover cálculos pesados a subrutinas o Mata cuando estén estables.

Snippet mínimo:

```stata
program qresid, rclass
    version 19.0
    syntax newvarname [if] [in] [, SEED(integer) UVAR(varname numeric) ///
        SAVEU(name) SAVEFLO(name) SAVEFHI(name) ]

    if "`e(cmd)'" == "" {
        display as err "qresid requires an active supported estimation result"
        exit 301
    }

    tempvar touse
    marksample touse
    quietly replace `touse' = 0 if !e(sample)
end
```

---

## 3. Interfaz pública

| Opción | Estado recomendado | Regla |
|---|---|---|
| `newvarname` | Preferida Fase 1 | Sintaxis estilo `qresid rq` para generar residuo principal |
| `generate()` | Alternativa si se decide arquitectura explícita | No usar simultáneamente con `newvarname` sin regla clara |
| `seed()` | Fase 1 | Reproducibilidad interna Stata; no prometer igualdad con R |
| `uvar()` | Fase 1 | Uniformes externos para benchmarks exactos |
| `saveu()` | Recomendado | Guardar `U` final si el usuario lo solicita |
| `saveflo()` | Recomendado | Guardar `F_low` para auditoría |
| `savefhi()` | Recomendado | Guardar `F_high` para auditoría |
| `family()` / `distribution()` | Condicional | Solo si el comando activo no permite inferencia segura; evitar contradicción con `e(family)` |
| `replace` | Opcional | Solo si se permite sobrescribir variable existente con confirmación clara |
| `force` | No recomendado Fase 1 | No usar para saltar validaciones numéricas |

Reglas:

- `ESTÁNDAR OFICIAL`: no cambiar sintaxis pública sin actualizar `.sthlp`, tests y changelog.
- `RECOMENDACIÓN OPERATIVA`: mantener nombres de opciones cortos, estables y alineados con Stata.
- `RECOMENDACIÓN OPERATIVA`: si se cambia una opción, mantener alias de compatibilidad durante al menos una versión menor.

---

## 4. Reglas del `.sthlp`

El help file debe incluir, en este orden:

1. Title.
2. Syntax.
3. Description breve.
4. Options.
5. Remarks mínimos.
6. Examples ejecutables.
7. Stored results.
8. Methods and formulas breve.
9. Limitations.
10. References.
11. Author/contact.

Reglas editoriales:

- `ESTÁNDAR OFICIAL`: no incluir teoría extensa.
- `ESTÁNDAR OFICIAL`: cada modelo declarado como soportado debe tener ejemplo ejecutable.
- `ESTÁNDAR OFICIAL`: declarar limitaciones: parámetros estimados, RNG, modelos no soportados.
- `RECOMENDACIÓN OPERATIVA`: incluir una sección breve sobre `uvar()` para reproducibilidad R–Stata.
- `ESTÁNDAR OFICIAL`: no incluir prompts, notas internas ni lenguaje de agentes.

---

## 5. Reglas de ejemplos

| Regla | Estado |
|---|---|
| Usar datasets oficiales o datos simulados pequeños | ESTÁNDAR OFICIAL |
| Comenzar con `version #` | ESTÁNDAR OFICIAL |
| Usar `set seed` si hay aleatorización | ESTÁNDAR OFICIAL |
| No usar rutas absolutas | ESTÁNDAR OFICIAL |
| No depender de paquetes externos para ejemplos básicos | RECOMENDACIÓN OPERATIVA |
| Mostrar `uvar()` en un ejemplo de benchmark | RECOMENDACIÓN OPERATIVA |
| No mezclar demostraciones Fase 2 con Fase 1 | RECOMENDACIÓN OPERATIVA |

Ejemplo mínimo:

```stata
version 19.0
clear
set obs 100
set seed 12345
generate double x = rnormal()
generate double mu = exp(0.2 + 0.5*x)
generate y = rpoisson(mu)
poisson y x
qresid rq, seed(12345)
qnorm rq
```

---

## 6. Reglas de certification

- `ESTÁNDAR OFICIAL`: `certification/master.do` debe correr desde sesión limpia.
- `ESTÁNDAR OFICIAL`: todo script debe abrir/cerrar log con `capture log close` y `log using ..., replace text`.
- `ESTÁNDAR OFICIAL`: tests deben fallar con `assert`, no solo imprimir discrepancias.
- `ESTÁNDAR OFICIAL`: benchmarks contra R deben comparar por capas.
- `RECOMENDACIÓN OPERATIVA`: guardar tablas de discrepancia cuando falle un benchmark.
- `RECOMENDACIÓN OPERATIVA`: separar outputs permanentes de outputs temporales.
- `ESTÁNDAR OFICIAL`: no incluir logs gigantes en el paquete SSC final si no son necesarios para instalación.

Estructura recomendada:

```text
certification/
  master.do
  master_R.R
  logs/
  outputs/
  reports/
```

---

## 7. Reglas editoriales generales

- `ESTÁNDAR OFICIAL`: no prompts.
- `ESTÁNDAR OFICIAL`: no lenguaje de agente.
- `ESTÁNDAR OFICIAL`: no notas internas de desarrollo asistido.
- `ESTÁNDAR OFICIAL`: no archivos scratch en release.
- `ESTÁNDAR OFICIAL`: no referencias inventadas.
- `ESTÁNDAR OFICIAL`: no claims de soporte sin tests.
- `RECOMENDACIÓN OPERATIVA`: todo texto público debe sonar como documentación técnica de software estadístico, no como plan de trabajo.
- `RECOMENDACIÓN OPERATIVA`: mover discusiones largas de teoría a documentación técnica separada, no al `.sthlp`.

---

## 8. Reglas de publicación

### 8.1 SSC readiness

Checklist mínimo:

- [ ] `qresid.ado` instala y corre desde carpeta limpia.
- [ ] `qresid.sthlp` abre sin errores.
- [ ] `qresid.pkg` lista solo archivos necesarios.
- [ ] `stata.toc` actualizado.
- [ ] El repositorio GitHub conserva README, docs, examples, tests,
      benchmarks, `qresid.pkg`, `stata.toc`, changelog y evidencia pública
      limpia para instalación/documentación.
- [ ] El envío SSC se deriva automáticamente desde el repositorio completo con
      `qresid/scripts/build_ssc_submission.ps1`; no se arma a mano.
- [ ] El ZIP SSC contiene solo `qresid.ado`, `qresid.sthlp`,
      `qresid_ssc_cover_note.txt` y, si existe y se aprueba, un ejemplo corto
      sin dependencias externas.
- [ ] README, docs Markdown, tests, certification, benchmarks, assets,
      logs, research audits, `qresid.pkg` y `stata.toc` no entran en el ZIP SSC
      salvo solicitud explícita de SSC/RePEc.

### Help style source

- `ESTÁNDAR OFICIAL`: antes de reestructurar `qresid.sthlp`, cargar `STATA_HELP_STYLE_MASTER.md` y seguir sus patrones SMCL tomados de `predict`, `regress` y `glm`.
- `ESTÁNDAR OFICIAL`: la teoría extensa, reverse engineering de paquetes R, diseño de web Quarto y herramientas MarkDoc/GitHub deben vivir en documentos maestros o web externa, no sobrecargar el help instalado.
- [ ] README breve y consistente.
- [ ] Licencia definida.
- [ ] Ejemplos básicos corren sin rutas absolutas.
- [ ] No hay archivos temporales, logs innecesarios o prompts.
- [ ] Modelos no soportados fallan con mensaje claro.

### 8.2 Stata Journal readiness

Checklist adicional:

- [ ] Certificación completa reproducible.
- [ ] Benchmarks R documentados.
- [ ] Tolerancias justificadas.
- [ ] Casos extremos evaluados.
- [ ] Help file con referencias.
- [ ] Artículo separado del código.
- [ ] Versionado estable y changelog.
- [ ] Evidencia de no duplicación de offset/exposure.
- [ ] Evidencia de `uvar()` para comparación exacta.

---

## 9. Tabla maestra: archivo del paquete → reglas

| Archivo/carpeta | Propósito | Reglas obligatorias | Errores a evitar |
|---|---|---|---|
| `qresid.ado` | Comando principal | `version`, `syntax`, `marksample`, `e(sample)`, `tempvar`, `double` | Calcular fuera de muestra; variables fijas |
| `qresid.sthlp` | Documentación Stata | Sintaxis, opciones, ejemplos, stored results, limitaciones | Teoría larga; claims sin soporte |
| `qresid.pkg` | Instalación | Lista mínima y correcta | Incluir tests pesados/scratch |
| `stata.toc` | Índice | Título y descripción limpia | Texto interno |
| `README.md` | Entrada GitHub | Estado, instalación, ejemplos, limitaciones | Prometer Fase 2 como implementada |
| `LICENSE` | Licencia | Compatible con distribución pública | Ausencia de licencia |
| `examples/` | Casos de uso | Reproducibles, con `version`, sin rutas absolutas | Ejemplos que fallan sin datos privados |
| `tests/unit/` | CDF y PIT | `assert`, casos borde, logs si aplica | Tests sin criterios numéricos |
| `tests/integration/` | Modelos reales | `e(sample)`, offset, familias | Solo probar caso feliz |
| `tests/r_benchmarks/` | Comparación R–Stata | `uvar()`, capas deterministas | Comparar RNG nativo entre lenguajes |
| `certification/` | Evidencia release/SJ | `master.do`, logs, outputs, reports | Outputs manuales o no reproducibles |

---

## 10. Checklist antes de release

- [ ] Todos los archivos públicos están libres de prompts y notas internas.
- [ ] Todas las familias soportadas tienen tests unitarios e integración.
- [ ] Las familias discretas pasan benchmark con `uvar()`.
- [ ] `seed()` reproduce resultados dentro de Stata.
- [ ] `F_low`, `F_high`, `U` pueden guardarse para auditoría.
- [ ] Los modelos Fase 2/3 devuelven error claro.
- [ ] `.sthlp` coincide con la sintaxis real.
- [ ] README no contradice `.sthlp`.
- [ ] `qresid.pkg` instala exactamente lo necesario.
- [ ] `qresid/scripts/build_ssc_submission.ps1` generó y validó el staging SSC.
- [ ] `qresid/release/SSC_SUBMISSION_MANIFEST.md` coincide con el artefacto
      generado y con la política GitHub/SSC vigente.
- [ ] `certification/master.do` corre desde cero.
