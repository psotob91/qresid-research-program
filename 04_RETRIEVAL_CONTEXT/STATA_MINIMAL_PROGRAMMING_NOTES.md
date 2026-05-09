## Overall overview
### 1. `syntax`
* **Regla:** Usar siempre `syntax` para parsear la entrada del usuario en lugar de usar macros posicionales `1`, `2`, etc. en el código principal. ESTÁNDAR OFICIAL.
* **Patrón seguro:** 
  ```stata
  syntax varlist [if] [in] [fweight pweight] [, Level(cilevel) Robust]
  ```
 . ESTÁNDAR OFICIAL.
* **Error común:** Usar comillas simples regulares para strings que pueden contener comillas internas. Usar comillas compuestas `` `""' `` al evaluar expresiones del usuario: `` if `"`if'"' != "" ``. ESTÁNDAR OFICIAL.

### 2. `marksample` y 3. `if/in`
* **Regla:** Determinar y marcar la muestra válida al inicio del programa usando `marksample`. ESTÁNDAR OFICIAL.
* **Regla:** Si se usan variables adicionales a la `varlist` principal (ej. variable de cluster o pesos), usar `markout` para excluir observaciones con valores faltantes. ESTÁNDAR OFICIAL.
* **Patrón seguro:**
  ```stata
  marksample touse
  markout `touse' `clustervar'
  ```
 . ESTÁNDAR OFICIAL.
* **Advertencia:** En todas las operaciones estadísticas, incluir siempre la condición `if \`touse'` para evitar usar la muestra incorrecta. ESTÁNDAR OFICIAL.

### 4. `e(sample)` y 9. `predict` / postestimation
* **Regla:** Los comandos de postestimación (como cálculo de residuos) deben restringirse por defecto a la muestra de estimación usando `if e(sample)`. ESTÁNDAR OFICIAL.
* **Regla:** Un comando de postestimación DEBE verificar siempre que el comando de estimación previo es el correcto leyendo `e(cmd)`. ESTÁNDAR OFICIAL.
* **Checklist Postestimación:**
  - [ ] Verificar `if "`e(cmd)'" != "qresid" { error 301 }`. ESTÁNDAR OFICIAL.
  - [ ] Proveer una función `predict` para los residuos. RECOMENDACIÓN OPERATIVA.

### 5. `tempvar`, `tempname`, `tempfile`
* **Regla:** Nunca crear variables, escalares, matrices o archivos con nombres fijos. Usar siempre `tempvar`, `tempname` o `tempfile`. ESTÁNDAR OFICIAL.
* **Advertencia:** Al usar las variables temporales en comandos, deben ir entre comillas simples (ej. `` `mivar' ``) porque la macro contiene un nombre autogenerado por Stata. ESTÁNDAR OFICIAL.
* **Regla:** No usar `drop` para destruir variables u objetos temporales al final del programa; Stata realiza la recolección de basura automáticamente. ESTÁNDAR OFICIAL.

### 6. `confirm` y 7. `capture` / `noisily` / `quietly`
* **Regla:** Usar `capture` para interceptar comandos que pueden fallar, suprimiendo la salida y guardando el código de error en la macro `_rc`. ESTÁNDAR OFICIAL.
* **Regla:** Usar `confirm` (generalmente con `capture`) para validar entradas (ej. si es un número, una variable) y emitir mensajes de error adecuados antes de que el programa falle. ESTÁNDAR OFICIAL.
* **Patrón seguro:** Bloques de evaluación silenciosa.
  ```stata
  quietly {
      capture confirm numeric variable `1'
      if _rc != 0 {
          noisily display as err "Variable debe ser numérica"
          exit 7
      }
  }
  ```
 . ESTÁNDAR OFICIAL.

### 8. `rclass` / `eclass`
* **Regla:** Los comandos de estimación DEBEN definirse como `program nombre, eclass` y guardar resultados usando `ereturn post`. ESTÁNDAR OFICIAL.
* **Checklist para comandos de estimación (`eclass`):**
  - [ ] Hacer `ereturn post \`b' \`V', esample(\`touse')` para guardar coeficientes, matriz de covarianza y la función `e(sample)`. ESTÁNDAR OFICIAL.
  - [ ] El último paso del comando de estimación debe ser `ereturn local cmd "nombre_del_comando"`. ESTÁNDAR OFICIAL.
* **Regla:** Los comandos o subrutinas de postestimación/cálculo deben ser `rclass` y devolver resultados usando `return scalar`, `return local`, etc.. ESTÁNDAR OFICIAL.

### 10. Mata dentro de ado
* **Regla:** Usar funciones de interfaz de Stata (`st_view()`, `st_data()`, `st_local()`) para conectar Mata y Stata. ESTÁNDAR OFICIAL.
* **Advertencia de memoria:** Utilizar `st_view()` en lugar de `st_data()` para referenciar grandes datasets sin duplicarlos en memoria. RECOMENDACIÓN OPERATIVA.
* **Patrón seguro:** Para producción, no dejar el código fuente de Mata en el archivo `.ado`. Compilar las funciones de Mata y guardarlas en bibliotecas `.mlib`. RECOMENDACIÓN OPERATIVA.
* **Configuración:** Utilizar `mata set matastrict on` durante el desarrollo de la rutina en Mata para forzar la declaración de tipos de variables. ESTÁNDAR OFICIAL.

### 11. Manejo de errores y warnings
* **Regla:** Usar `display as error` o `as err` para imprimir mensajes de error. Solo con `as err` el mensaje sobrevivirá si el programa fue llamado con `quietly`. ESTÁNDAR OFICIAL.
* **Regla:** Usar `exit #` donde `#` es el código de error correspondiente (ej. `exit 198` para errores de sintaxis). ESTÁNDAR OFICIAL.

### 12. RNG reproducible (Random Number Generator)
* **Regla:** Cualquier operación inherentemente aleatoria (como los residuos de Dunn-Smyth y simulaciones Monte Carlo) requiere controlar el generador de números aleatorios para ser reproducible. Usar `set seed`. ESTÁNDAR OFICIAL.
* **Advertencia en simulaciones:** El comando `sort` puede destruir la reproducibilidad si existen empates en la variable de ordenamiento. Romper empates de forma determinística (ej. `sort var, stable`) o usando una variable generada aleatoriamente con una semilla previa. ESTÁNDAR OFICIAL.
* **Advertencia:** Para capturar el estado interno de la semilla y restaurarlo posteriormente, usar la función `rngstate()` o `c(rngstate)`. ESTÁNDAR OFICIAL.

### 13. Logs y tests
* **Regla:** Incluir comandos `assert` en todo el código analítico y pruebas para validar explícitamente las suposiciones y detener la ejecución ante fallos matemáticos o lógicos (ej. `assert e(sample) == 1`). ESTÁNDAR OFICIAL.
* **Patrón de Logging seguro:**
  ```stata
  capture log close
  log using my_test, replace
  ```
 . ESTÁNDAR OFICIAL.

### 14. Compatibilidad con versiones de Stata
* **Regla:** La primera línea ejecutable de todos los programas en archivos `.ado` o `.do` debe ser `version #` (ej. `version 19.5` o la que corresponda al motor deseado). No debe omitirse nunca. Esto congela la sintaxis y el comportamiento de componentes como el RNG. ESTÁNDAR OFICIAL.
* **Advertencia para Mata:** En la construcción de la librería `.mlib`, usar explícitamente el comando `version` dentro del archivo de origen para garantizar trazabilidad. RECOMENDACIÓN OPERATIVA.

## Reglas operativas para syntax, marksample, if/in, e(sample), tempvar, tempname, tempfile y confirm.

### Checklist Operativo

- [ ] ¿La primera línea ejecutable define `version #`? ESTÁNDAR OFICIAL.
- [ ] ¿Se usa `syntax` para parsear la entrada (ej. `syntax newvarname [if] [in] [, options]`) en lugar de variables posicionales (`1`, `2`)? ESTÁNDAR OFICIAL.
- [ ] ¿Se usa `marksample touse` o `mark` junto con `if` e `in` al inicio del programa para definir la muestra válida? ESTÁNDAR OFICIAL.
- [ ] ¿Todas las operaciones analíticas y de generación de datos incluyen la restricción `if \`touse'`? ESTÁNDAR OFICIAL.
- [ ] ¿Se cruza la muestra del usuario (`touse`) con la muestra original del modelo (`e(sample)`)? ESTÁNDAR OFICIAL.
- [ ] ¿Se usan exclusivamente `tempvar`, `tempname` o `tempfile` para crear variables intermedias, matrices o escalares de cálculo? ESTÁNDAR OFICIAL.
- [ ] ¿Se omiten los comandos `drop` para los objetos temporales al final del script (dejando que Stata los limpie automáticamente)? ESTÁNDAR OFICIAL.
- [ ] ¿Se usa `confirm` (usualmente con `capture`) para validar precondiciones que `syntax` no cubre automáticamente? ESTÁNDAR OFICIAL.

### Snippets Mínimos

**1. Definición inicial y parseo (típico de postestimación)**
```stata
program qresid, rclass
    version 19.0
    syntax newvarname [if] [in] [, Reps(integer 10) ]
    
    // Marcar la muestra solicitada por el usuario
    tempvar touse
    mark `touse' `if' `in'
    
    // Restringir estrictamente a la muestra de estimación
    quietly replace `touse' = 0 if !e(sample)
```
ESTÁNDAR OFICIAL.

**2. Uso de variables y matrices temporales con alta precisión**
```stata
tempvar cdf u
tempname b V

// Usar 'double' para evitar pérdida de precisión en los cálculos
quietly generate double `cdf' = . if `touse'
quietly generate double `u' = runiform() if `touse'

matrix `b' = e(b)
matrix `V' = e(V)
```
RECOMENDACIÓN OPERATIVA.

**3. Validación con confirm y capture**
```stata
capture confirm new variable `varlist'
if _rc != 0 {
    display as err "La variable `varlist' ya existe o el nombre es inválido"
    exit 110
}
```
ESTÁNDAR OFICIAL.

### Errores Comunes

1. **Olvidar las comillas simples al llamar un temporal:** Declarar `tempvar mu` y luego programar `generate mu = ...` en lugar de `generate \`mu' = ...`. Esto crea una variable real en el dataset del usuario en lugar de usar el nombre temporal autogenerado (ej. `__000001`). ESTÁNDAR OFICIAL.
2. **Inconsistencia de la muestra (El error más común de Stata):** Ejecutar comandos matemáticos u obtener estadísticos (ej. `summarize`) sin agregar la condición `if \`touse'`, lo que contamina el cálculo con observaciones que tienen datos faltantes o que el usuario excluyó explícitamente. ESTÁNDAR OFICIAL.
3. **Pérdida de precisión (Floats vs Doubles):** Usar `generate \`tmp' = ...` por defecto (que crea un `float`) en lugar de `generate double \`tmp' = ...` para operaciones intermedias. RECOMENDACIÓN OPERATIVA.
4. **Borrado manual de temporales:** Usar `drop \`tmp'` al final del programa. Es código basura y riesgoso si el programa se interrumpe antes de llegar a esa línea; Stata maneja el ciclo de vida de `tempvar`/`tempname` automáticamente incluso ante errores. ESTÁNDAR OFICIAL.

### Implicancias específicas para `qresid` (Comando de postestimación)

*   **Identidad del comando:** Como paso 0, `qresid` DEBE verificar el contenido de `e(cmd)`. Si el modelo previo no es compatible (ej. no es `poisson`, `nbreg`, o `glm`), debe interrumpir la ejecución inmediatamente con un error claro. ESTÁNDAR OFICIAL.
*   **Muestra rigurosa con `e(sample)`:** Los residuos cuantílicos requieren re-evaluar la distribución predictiva del modelo. Cualquier observación calculada debe pertenecer a `e(sample)` porque las observaciones fuera de la muestra podrían no tener las variables independientes necesarias o haber sido omitidas (ej. por colinealidad). ESTÁNDAR OFICIAL.
*   **Creación de la variable (`syntax newvarname`):** Puesto que `qresid` generará el vector de residuos en el dataset, el parseo primario no es `varlist` (variables existentes), sino `newvarname` (o `newvarlist` si genera varios residuos a la vez). Al hacerlo, `syntax` alojará el nombre provisto por el usuario en la macro local `varlist` (y su tipo en `typlist`). ESTÁNDAR OFICIAL.
*   **Generación de números aleatorios sin contaminar:** Dado que `qresid` calcula residuos cuantílicos aleatorizados (Dunn-Smyth), generará valores uniformes. Esta generación de variables puente obligatoriamente debe anidarse en un `tempvar` para no destruir variables existentes del usuario, y la semilla debe ser informada o controlada. RECOMENDACIÓN OPERATIVA.

## Reglas operativas para rclass, eclass, stored results, predict, postestimation y compatibilidad con modelos estimados previamente.

### Checklist Operativo

- [ ] ¿El programa de estimación está definido con la opción `eclass` y el de postestimación (como `qresid`) con `rclass` o sin clase? ESTÁNDAR OFICIAL.
- [ ] En un comando de estimación, ¿se usa `ereturn post` para guardar el vector de coeficientes (`b`), la matriz de varianzas (`V`) y la función de muestra (`esample`)? ESTÁNDAR OFICIAL.
- [ ] En un comando de estimación, ¿la declaración `ereturn local cmd "nombre_del_comando"` es estrictamente la *última* línea de almacenamiento? ESTÁNDAR OFICIAL.
- [ ] En el comando de postestimación, ¿se verifica primero la identidad del modelo previo comprobando `e(cmd)` (ej. `if "`e(cmd)'" != "..."`)? ESTÁNDAR OFICIAL.
- [ ] ¿Se usa la sintaxis `return add` en programas `rclass` si se desea heredar y devolver resultados previamente almacenados por otro comando interno? ESTÁNDAR OFICIAL.
- [ ] ¿Las operaciones de postestimación restringen sus cálculos a la muestra válida usando `if e(sample)`? ESTÁNDAR OFICIAL.

### Snippets Mínimos

**1. Comando de estimación (`eclass`): Guardado seguro de resultados**
```stata
program mimodelo, eclass
    version 19.0
    // ... cálculos que generan matrices b y V y variable touse ...
    
    // 1. Postear coeficientes, varianzas y muestra
    ereturn post `b' `V', esample(`touse')
    
    // 2. Guardar otros escalares o macros
    ereturn scalar N = `nobs'
    
    // 3. Establecer e(cmd) SIEMPRE al final
    ereturn local cmd "mimodelo"
end
```
. ESTÁNDAR OFICIAL.

**2. Comando de postestimación (`rclass`): Verificación y cálculo**
```stata
program qresid, rclass
    version 19.0
    syntax newvarname [if] [in] [, *]
    
    // 1. Verificar compatibilidad del modelo previo
    if "`e(cmd)'" != "poisson" & "`e(cmd)'" != "glm" {
        display as err "qresid no es válido después de `e(cmd)'"
        exit 301
    }
    
    // 2. Extraer parámetros
    tempname b
    matrix `b' = e(b)
    
    // 3. Generar fitted values usando predict en la muestra de estimación
    tempvar mu
    quietly predict double `mu' if e(sample), xb
    
    // ... cálculos de qresid ...
    return scalar N_qresid = r(N)
end
```
. RECOMENDACIÓN OPERATIVA.

**3. Distinción entre `r()` y `return()` dentro de un programa**
```stata
program calc_stats, rclass
    quietly summarize `1'
    // Leer lo que produjo summarize (r) y preparar lo que devolveremos (return)
    return scalar var_mean = r(mean)
    return scalar calc = return(var_mean) * 2
end
```
. ESTÁNDAR OFICIAL.

### Errores Comunes

1.  **Declarar `e(cmd)` demasiado pronto:** Hacer `ereturn local cmd "mimodelo"` antes de terminar los cálculos. Si el usuario presiona *Break*, Stata considerará que los resultados están completos y válidos cuando en realidad están corruptos, causando fallos en los comandos de postestimación. ESTÁNDAR OFICIAL.
2.  **Modificar `e(b)` o `e(V)` directamente:** Intentar usar `ereturn matrix b = ...` en lugar de `ereturn post` o `ereturn repost`. Los comandos de postestimación asumen validaciones estrictas (nombres de filas/columnas idénticos, matrices simétricas) que solo `ereturn post/repost` garantizan. ESTÁNDAR OFICIAL.
3.  **Confundir `r(name)` con `return(name)` en rutinas `rclass`:** Usar `r(name)` para referirse a un valor que el programa actual *va a devolver*. `r()` solo contiene resultados de un programa previamente finalizado; mientras el programa corre, sus propios resultados pendientes viven en `return()`. ESTÁNDAR OFICIAL.
4.  **Olvidar `esample(varname)`:** Usar `ereturn post b V` omitiendo la opción `esample()`. Esto deja a `e(sample)` vacío (todo en cero), haciendo que comandos posteriores como `predict` o estadísticos condicionados a `if e(sample)` evalúen cero observaciones. ESTÁNDAR OFICIAL.

### Implicancias para extraer fitted values y parámetros desde modelos Stata

*   **Extracción de coeficientes fijos (`e(b)` y `_b[]`):** Dentro de `qresid`, los coeficientes exactos ajustados por el modelo previo se pueden extraer copiando la matriz con `matrix `b' = e(b)` o refiriéndose a coeficientes específicos mediante `_b[varname]` (y errores estándar con `_se[varname]`). ESTÁNDAR OFICIAL.
*   **Obtención de predicciones (`predict`):** Un comando postestimation no debe recalcular el índice lineal manualmente (ej. $X\beta$). Debe invocar a `predict` (ej. `predict double `fitted', xb`), el cual lee automáticamente las matrices activas `e(b)` y el dataset en memoria. Esto maneja automáticamente constantes, omitidos y variables de factor (`i.var`). RECOMENDACIÓN OPERATIVA.
*   **Alineación de Nombres (Row/Col names):** Para que `predict` o cualquier cálculo matricial postestimation funcione, las matrices extraídas (`e(b)`, `e(V)`) dependerán estrictamente de sus nombres de columnas/filas (ej. ecuación y nombre de variable). Si `qresid` manipula estas matrices en Mata, debe preservar o consultar estos *stripes* (nombres de columnas) para asegurar que el modelo coincide con la estructura de variables del dataset. ESTÁNDAR OFICIAL.
*   **Predicciones "Out-of-sample":** Puesto que `predict` calcula valores para cualquier observación con datos válidos, `qresid` debe decidir si genera residuos cuantílicos solo para la muestra de estimación (`predict ... if e(sample)`) o si permite out-of-sample predictions, para lo cual debe omitir `if e(sample)` pero advertir al usuario sobre observaciones con datos faltantes. RECOMENDACIÓN OPERATIVA.

## Reglas operativas para integrar Mata dentro de ado-files.

### Checklist Operativo para Integrar Mata en Ado-files

- [ ] **Cuándo usar Mata:** ¿Se requieren cálculos matriciales, simulaciones Monte Carlo repetitivas o transformaciones matemáticas elemento por elemento (como evaluar CDFs y cuantiles)? Si es así, usar Mata en lugar de bucles `foreach`/`forvalues` en Stata para maximizar la velocidad. RECOMENDACIÓN OPERATIVA.
- [ ] **Declaración de tipos:** ¿Se utiliza `mata set matastrict on` y se declaran explícitamente los tipos (ej. `real colvector`, `string scalar`) en todas las funciones Mata para evitar errores y optimizar la compilación? ESTÁNDAR OFICIAL.
- [ ] **Paso de datos (Stata -> Mata):** ¿Los nombres de variables y macros se pasan a la función Mata como argumentos de tipo `string scalar` (paso por valor de las comillas)? ESTÁNDAR OFICIAL.
- [ ] **Gestión de memoria:** ¿Se utiliza `st_view()` en lugar de `st_data()` para importar datos desde Stata, evitando duplicar el dataset en la memoria RAM? ESTÁNDAR OFICIAL.
- [ ] **Modificación del dataset:** Para crear vectores de resultados en el dataset original (ej. residuos), ¿se pre-genera la variable en Stata y luego se usa `st_view()` en Mata para sobreescribir sus valores directamente? ESTÁNDAR OFICIAL.
- [ ] **Paso por referencia:** ¿Se tiene en cuenta que Mata pasa los argumentos de funciones *por dirección* (referencia)? Si una subrutina modifica una matriz pasada como argumento, el cambio afectará a la matriz original. ESTÁNDAR OFICIAL.
- [ ] **Devolución de escalares/macros:** ¿Se utilizan las funciones de interfaz `st_numscalar()`, `st_local()` o `st_global()` para devolver resultados puntuales a Stata (ej. estadísticos de prueba, flags)? ESTÁNDAR OFICIAL.
- [ ] **Librerías de producción:** Para la versión final del paquete, ¿se compilan las funciones Mata en una librería `.mlib` (o archivos `.mo`) en lugar de dejarlas en código fuente dentro del `.ado`? ESTÁNDAR OFICIAL.

---

### Snippets Mínimos

**1. Interfaz Ado-Mata (Stata side): Preparación y llamada**
```stata
program qresid, rclass
    version 19.0
    syntax varname [if] [in], GENerate(name)
    
    marksample touse
    
    // 1. Crear variable vacía en Stata ANTES de llamar a Mata
    quietly generate double `generate' = . if `touse'
    
    // 2. Llamar a Mata pasando los nombres como strings
    mata: calc_qresid("`varlist'", "`generate'", "`touse'")
end
```
ESTÁNDAR OFICIAL.

**2. Función Mata: Uso seguro de vistas y cálculo elemento por elemento**
```stata
mata:
mata set matastrict on

void calc_qresid(string scalar y_name, string scalar res_name, string scalar touse) {
    real colvector y, r
    
    // 1. Crear vistas (no copias) de los datos de Stata
    st_view(y, ., y_name, touse)
    st_view(r, ., res_name, touse)
    
    // 2. Cálculo vectorizado (ej. transformación genérica)
    // Se usan operadores con dos puntos (:, :+, :*) para operaciones elemento a elemento
    r = y :- mean(y) 
    
    // 3. Devolver un escalar a r() de Stata
    st_numscalar("r(N_calc)", rows(y))
}
end
```
ESTÁNDAR OFICIAL.

---

### Errores Comunes

1. **Pasar variables como valores en lugar de strings:** Escribir `mata: mi_funcion(`varlist')` en lugar de `mata: mi_funcion("`varlist'")`. Mata intentará evaluar el contenido de la macro como una variable matemática en lugar de recibir el nombre de la variable de Stata para pasarlo a `st_view()`. ESTÁNDAR OFICIAL.
2. **Confundir `st_data()` con `st_view()`:** Utilizar `st_data()` para cargar el dataset completo. `st_data()` crea una copia física en la memoria de Mata. Para grandes datasets, esto duplicará el consumo de RAM. `st_view()` actúa como una ventana a los datos de Stata sin costo de memoria. ESTÁNDAR OFICIAL.
3. **Pérdida de precisión al inicializar temporales:** Crear variables puente en Stata usando `generate \`tmp' = .` (crea un `float`) en lugar de `generate double \`tmp' = .`, truncando la precisión antes de que Mata lea o escriba en la variable. RECOMENDACIÓN OPERATIVA.
4. **Operadores matriciales vs. elemento a elemento:** Usar `A * B` o `A / B` intentando hacer operaciones vectoriales en lugar de usar los operadores de colon (`:*`, `:/`, `:+`, `:-`). Esto lanza un error de conformabilidad (código 3200) o realiza álgebra matricial incorrecta. ESTÁNDAR OFICIAL.

---

### Implicancias para calcular CDFs, PIT y residuos cuantílicos (`qresid`)

*   **Soporte nativo de distribuciones:** Mata tiene funciones integradas hiper-optimizadas para cálculos probabilísticos (ej. `normal()`, `invnormal()`, `poisson()`). El cálculo de $r_i = \Phi^{-1}(u_i)$ debe hacerse invocando vectorialmente `invnormal(u)`. ESTÁNDAR OFICIAL.
*   **Manejo del Underflow/Overflow:** Los residuos cuantílicos colapsan hacia $-\infty$ o $+\infty$ si la CDF evaluada es exactamente 0 o 1. Las variables puente (tanto en Stata como en Mata) deben declararse y operarse como `double` (`real colvector` en Mata ya es `double`). Se debe considerar el uso de constantes de precisión de máquina como `epsilon(1)` (aprox. `2.22e-16`) o `smallestdouble()` para delimitar topes numéricos antes de aplicar `invnormal()`. RECOMENDACIÓN OPERATIVA.
*   **Generación de la Uniforme para variables discretas (Dunn-Smyth):** 
    Para implementar la aleatorización $u_i \sim \text{Uniform}(F(y_i^-), F(y_i))$, se debe usar `runiform(rows(y), 1)` dentro de Mata. 
    ```stata
    real colvector u
    u = F_y_minus :+ (F_y :- F_y_minus) :* runiform(rows(y), 1)
    ```
    Dado que esto es inherentemente aleatorio, es estricto invocar `version #` al inicio del `.ado` y controlar `set seed` para garantizar reproducibilidad exacta con el generador (ej. mt64h). RECOMENDACIÓN OPERATIVA.
*   **Sincronización de Vistas (Missings):** Al calcular CDFs para el dataset, si existen valores nulos (`.`, `.a`, `.b`), Mata los procesa según su propia lógica de punto flotante. Pasar la variable de control `touse` desde Stata y usarla en `st_view(..., touse)` es imperativo para evitar que las funciones probabilísticas en Mata colapsen o propaguen `missing` incorrectamente. ESTÁNDAR OFICIAL.

## Reglas operativas para reproducibilidad, RNG, logs, tests y certification scripts en Stata.

### Checklist Operativo

- [ ] ¿El do-file/ado-file incluye `version #` en su primera línea ejecutable para congelar la sintaxis y el comportamiento? ESTÁNDAR OFICIAL.
- [ ] Para cualquier operación inherentemente aleatoria (ej. simulaciones, generación de residuos aleatorizados), ¿se usa `set seed` para asegurar resultados determinísticos? ESTÁNDAR OFICIAL.
- [ ] Al fijar la semilla, ¿se utiliza control de versión explícito (ej. `version 19.0: set seed #`) para garantizar que se usa el mismo generador de números aleatorios (como el Mersenne Twister introducido en Stata 14)? ESTÁNDAR OFICIAL,,.
- [ ] En rutinas que cambian el orden de los datos, ¿los empates (`ties`) al usar `sort` se rompen de forma reproducible (usando la opción `stable` o con variables uniformes sembradas previamente)? ESTÁNDAR OFICIAL,,.
- [ ] ¿Los do-files de prueba generan logs sistemáticamente mediante un patrón de cierre y apertura (`capture log close` seguido de `log using ..., replace`)? ESTÁNDAR OFICIAL,.
- [ ] ¿Se usa intensivamente el comando `assert` a lo largo del código para detener la ejecución y verificar asunciones teóricas y operativas (ej. cruces limpios con `_merge==3`, o rangos válidos)? ESTÁNDAR OFICIAL,,.
- [ ] ¿Existe un script maestro (`master.do`) que llama a los componentes de prueba en orden secuencial para reconstruir todo el análisis analítico desde cero? ESTÁNDAR OFICIAL.
- [ ] ¿La evaluación metodológica de los residuos cuantílicos incluye pruebas formales para reproducir y coincidir razonablemente con las implementaciones de referencia en R? ESTÁNDAR OFICIAL,,.

### Snippets Mínimos

**1. Generación reproducible de números aleatorios uniformes**
```stata
// Congelar la versión del generador (ej. Mersenne Twister mt64)
version 19.0: set seed 123456789
generate double u = runiform()
```
ESTÁNDAR OFICIAL,,.

**2. Estructura estándar y segura para un do-file de prueba (certification script)**
```stata
version 19.0
capture log close
log using test_qresid_poisson, replace
set more off

// Código analítico y pruebas
use mydata, clear
// ... ejecución de qresid ...

// Validaciones estrictas
assert r_qresid < . 
assert e(sample) == 1

log close
exit
```
ESTÁNDAR OFICIAL,,.

**3. Ordenamiento (Sort) reproducible**
```stata
// Forma 1: Opción stable para preservar el orden inicial en los empates
sort varname, stable

// Forma 2: Ruptura de empates controlada por semilla
version 19.0: set seed 98765
generate double u_tie = runiform()
sort varname u_tie
drop u_tie
```
ESTÁNDAR OFICIAL,.

**4. Script maestro de certificación (`master.do`)**
```stata
// Ejecución secuencial y reproducible
do cr_data_setup
do test_qresid_poisson
do test_qresid_binomial
do benchmark_vs_r
exit
```
RECOMENDACIÓN OPERATIVA,.

### Errores Comunes / Cómo evitar resultados no reproducibles

1. **Uso de `sort` con empates (ties):** Ordenar un dataset por una o más variables donde existen valores idénticos en múltiples observaciones sin usar la opción `stable`. Stata internamente "mezcla" (`jumbles`) los datos aleatoriamente antes del ordenamiento para optimizar velocidad. Esto rompe la reproducibilidad si no se controla, ya que en cada ejecución las filas con empates quedarán en posiciones distintas,,.
2. **Generar números aleatorios sin definir `version`:** El motor de números aleatorios (RNG) de Stata cambió radicalmente en la versión 14 (pasó de KISS a 64-bit Mersenne Twister). Si el comando `set seed` se usa sin prefijarlo con una versión, el script usará el RNG de la versión actual del usuario en lugar de la del programador original, arrojando secuencias `runiform()` inconsistentes entre equipos,,.
3. **Exploración interactiva sin `master.do`:** Hacer limpieza de datos o ajustes manuales en consola y guardarlos, en lugar de poner estas reglas operativas directamente en el do-file de prueba. Ningún análisis exploratorio interactivo debe ser oficial hasta automatizarse en el script,.
4. **Falta de logs limpios:** No forzar el sobre-escrito de logs (`replace`) ni interceptar cierres (`capture log close`). Esto detiene la ejecución desatendida si el archivo ya existe o falla si no hay un log abierto,.

### Recomendaciones Operativas para Comparación contra R y Certificación

*   **Benchmarking Directo:** El proceso de simulación para calcular el desempeño de `qresid` frente a simulaciones en R (ej. tipo paquete DHARMa) debe constar en tablas de concordancia generadas mediante un script transversal de Stata (`do benchmark_vs_r.do`),,. 
*   **Aislamiento de tareas (Tests modulares):** Separar los do-files en aquellos que crean o procesan datos simulados (prefijados usualmente con `cr` o `sim`) y aquellos que ejecutan el test y generan aserciones (prefijados con `an` o `test`). Posteriormente, atarlos en el archivo `master.do`,.
*   **Testing pasivo (Assumptions):** Usar el comando `assert` generosamente en las rutinas de certificación de `qresid` para comprobar suposiciones como normalidad teórica o correctas probabilidades (ej. ausencia de missing values y vectores matemáticamente correctos) para que el script falle inmediatamente si se introduce código defectuoso en una fase futura,,.

## Summary adicional

# STATA_MINIMAL_PROGRAMMING_NOTES.md

## 1. Alcance
*   El paquete `qresid` implementará residuos cuantílicos aleatorizados de Dunn y Smyth para modelos probabilísticos, comenzando con variables discretas. ESTÁNDAR OFICIAL.
*   Los modelos iniciales incluyen GLM, Poisson, Quasi-Poisson, Binomial Negativa, Gamma y Binomial. ESTÁNDAR OFICIAL.
*   Los entregables deben incluir la función analítica (`qresid`), rutinas de validación cruzada frente a R y librerías Mata numéricamente estables que manejen underflow/overflow. ESTÁNDAR OFICIAL.
*   Todo el desarrollo debe poder auditarse y no tener rastros de texto autogenerado por agentes. ESTÁNDAR OFICIAL.

## 2. Reglas mínimas de ado programming
*   Todo script, rutina o do-file DEBE comenzar siempre definiendo la versión para congelar la sintaxis y comportamiento del RNG (ej. `version 19.0`). ESTÁNDAR OFICIAL.
*   Evitar macros posicionales (`1`, `2`) en el script principal; usar en su lugar `syntax` para parsear rigurosamente la entrada. ESTÁNDAR OFICIAL.
*   Al definir rutinas `.ado`, estructurar con un borrado preventivo: `capture program drop miprog` seguido de `program miprog`. RECOMENDACIÓN OPERATIVA.
*   Usar comillas compuestas `` `""' `` al evaluar y pasar expresiones de string complejas que el usuario puede ingresar. ESTÁNDAR OFICIAL.

```stata
// Snippet mínimo base
capture program drop qresid
program qresid, rclass
    version 19.0
    syntax newvarname [if] [in] [, Reps(integer 10)]
    // ...
end
```

## 3. Submuestras, if/in y e(sample)
*   Identificar la muestra de trabajo inmediatamente después de `syntax` usando `marksample touse`. ESTÁNDAR OFICIAL.
*   Si se utilizan variables extra o pesos, remover valores perdidos (`.`) utilizando `markout \`touse' \`extravars'`. ESTÁNDAR OFICIAL.
*   **Advertencia rigurosa:** Todos los cálculos, `generate`, y `replace` posteriores DEBEN condicionarse estrictamente con `if \`touse'` para no alterar ni incorporar datos omitidos. ESTÁNDAR OFICIAL.
*   Para postestimación (`qresid`), la nueva variable solo debe procesarse para las observaciones que el modelo base utilizó, filtrando mediante `if e(sample)`. ESTÁNDAR OFICIAL.

## 4. Variables temporales y objetos temporales
*   Nunca crear variables, matrices o escalares fijos durante operaciones intermedias. Usar obligatoriamente `tempvar`, `tempname` y `tempfile`. ESTÁNDAR OFICIAL.
*   Al invocar nombres temporales dentro del código, DEBEN ir entre comillas simples (ej. `` generate double `mi_tmp' = ... ``). ESTÁNDAR OFICIAL.
*   Jamás usar `drop \`mi_tmp'` al final del programa. Stata administra la memoria y limpia los objetos automáticamente, garantizando su borrado incluso si el usuario interrumpe la ejecución (Break). ESTÁNDAR OFICIAL.
*   Declarar las variables temporales de cálculo numérico como `double` para evitar pérdida silenciosa de precisión. RECOMENDACIÓN OPERATIVA.

## 5. Postestimation, predict y stored results
*   Como paso 0, un comando postestimation (`qresid`) debe validar la identidad del modelo previo verificando que `e(cmd)` o `e(cmdline)` contienen el valor correcto. ESTÁNDAR OFICIAL.
*   Para recuperar coeficientes y matrices de varianzas, extraerlos de forma temporal sin destruir `e()`: `matrix \`b' = e(b)` y `matrix \`V' = e(V)`. ESTÁNDAR OFICIAL.
*   En lugar de calcular el índice lineal del modelo ajustado manualmente ( $X\beta$ ), usar el comando `predict \`xb', xb` que invoca la matriz de coeficientes activa y sortea variables omitidas y colinealidad automáticamente. RECOMENDACIÓN OPERATIVA.
*   El comando debe ser `rclass` y devolver métricas y matrices derivadas finalizadas con `return scalar`, `return local` o `return matrix`. ESTÁNDAR OFICIAL.

```stata
// Snippet de postestimación seguro
if "`e(cmd)'" != "poisson" & "`e(cmd)'" != "glm" {
    display as err "qresid no permitido después de `e(cmd)'"
    exit 301
}
tempvar xb
predict double `xb' if `touse', xb
```

## 6. Mata dentro de ado
*   Limitar Mata a cálculos matriciales puros, transformaciones algebraicas vectorizadas o Monte Carlo; no usar para limpieza de datos trivial. RECOMENDACIÓN OPERATIVA.
*   En un flujo Stata-Mata, emplear `st_view()` en lugar de `st_data()` para mapear las variables sin duplicarlas en memoria y afectar la RAM del sistema. ESTÁNDAR OFICIAL.
*   Siempre sincronizar los valores faltantes pasando la macro de muestra de Stata a la vista de Mata: `st_view(V, ., "mivar", "touse")`. ESTÁNDAR OFICIAL.
*   Habilitar `mata set matastrict on` para asegurar control de tipos (`real colvector`, etc.) y prevenir colapsos no documentados. RECOMENDACIÓN OPERATIVA.

```mata
// Snippet Mata seguro
mata:
mata set matastrict on
void calc_qresid(string scalar var_y, string scalar touse) {
    real colvector y
    st_view(y, ., var_y, touse)
    // operaciones vectorizadas con dos puntos (:, :+, :*)
}
end
```

## 7. RNG y reproducibilidad
*   Las transformaciones pseudo-aleatorias (como los residuos Dunn-Smyth) requieren controlar y sembrar el RNG (`set seed`). ESTÁNDAR OFICIAL.
*   Toda semilla debe establecerse tras fijar la versión (`version 19.0: set seed 12345`) porque los motores cambian entre versiones de Stata (Mersenne Twister frente a KISS). ESTÁNDAR OFICIAL.
*   Generación de distribuciones de soporte continuo uniformes obligatoriamente utiliza la función `runiform()` dentro de una evaluación `double`. ESTÁNDAR OFICIAL.
*   Para prevenir resultados no reproducibles por empates ("ties") de sortamiento de datos, utilizar siempre la directiva `sort mivar, stable`. ESTÁNDAR OFICIAL.

## 8. Logs, tests y certification scripts
*   Evitar exploración y cálculos manuales directos; encapsular las validaciones y ejecuciones de testeo en secuencias controladas dentro de scripts maestros (`master.do`). ESTÁNDAR OFICIAL.
*   Estructura obligatoria para logging seguro sin paros por "archivo ya existente":
    ```stata
    capture log close
    log using test_qresid, replace
    ```
   . ESTÁNDAR OFICIAL.
*   Implementar una batería de aserciones (`assert`) silentes para validación de teoremas lógicos matemáticos y datos conformes sin interrumpir o ensuciar el log. ESTÁNDAR OFICIAL.
*   En rutinas comparativas (benchmark vs R), programar los resultados iterativos para ser compilados de manera vectorizada. RECOMENDACIÓN OPERATIVA.

## 9. Errores comunes que debe evitar Codex
1.  **Derrame global de temporales**: Declarar un `tempvar diff` e intentar llenarlo haciendo `gen diff = ...` sin las comillas simples de macro `\``, creando la variable estática `diff` que romperá en llamadas repetidas o pisará datos del usuario.
2.  **Destrucción y Mutación de Data**: Emplear los comandos `drop`, `keep`, o mutar variables originales temporalmente sin incluir un bloque `preserve` al inicio del procesamiento (y sin prever un cierre `restore`).
3.  **Contaminación de Muestra**: Ejecutar transformaciones en variables post-estimación (como `predict`) o funciones resumen (`summarize`) omitiendo `if \`touse'` o `if e(sample)`, generando basura analítica por incluir observaciones de fuera.
4.  **Sobrecarga Operativa Lenta**: Realizar loops (`forvalues` o `foreach`) fila por fila sobre observaciones usando `[_n]`, lo cual bloquea el motor. Stata/Mata se escriben de manera vectorizada en una pasada (`generate / replace`).
5.  **Carencia del Prefijo Eclass/Rclass**: Olvidar poner la directiva `, rclass` en la primera línea de `program mi_comando` para que retorne los vectores generados y la macro esté disponible en `r()`.

## 10. Checklist antes de modificar código
*   [ ] ¿El bloque principal comienza declarando `version 19.0`?
*   [ ] ¿`qresid` empieza con un chequeo de precondición (ej. validación sobre `e(cmd)`) para compatibilidad de distribuciones?
*   [ ] ¿Toda entrada y parseo paramétrico está capturado de manera robusta y estándar vía `syntax` en vez de tokens de posición?
*   [ ] ¿La submuestra activa original es identificada estrictamente bajo un bloque `marksample touse` acoplada con `if e(sample)`?
*   [ ] ¿Existen objetos (variables de apoyo, predictores intermedios, unifomes) que no usen el prefijo macro temporal `tempvar` o `tempname`?
*   [ ] ¿Se está intentando usar el comando `drop` a un temporal evadiendo la autolimpieza asíncrona de Stata?
*   [ ] Para interconexión de matrices Mata, ¿el envío de los componentes se hace eficientemente por referencia (`st_view`) evitando duplicación `st_data()`?
*   [ ] ¿Todos los índices de generación aleatoria (Monte Carlo o Dunn-Smyth) están anidados debajo de inicializaciones `set seed` controladas por el motor correct de Stata?
*   [ ] ¿Se testearon validaciones silenciosas de supuestos matemáticos (`assert xb < .`, ausencia de missing points) a través de scripts iterativos master-log (`master.do`)?




