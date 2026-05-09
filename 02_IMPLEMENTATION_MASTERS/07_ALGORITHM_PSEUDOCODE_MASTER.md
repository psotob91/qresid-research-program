<!--
Este documento describe algoritmos de implementación para residuos cuantílicos aleatorizados (RQR) en `qresid`.
Sigue rigurosamente la teoría de Dunn–Smyth y las recomendaciones de los informes maestros del proyecto.
Las referencias numeradas remiten a las fuentes en los documentos obligatorios; obsérvese que las citas se incorporan en el texto mediante identificadores persistentes.
-->

# Algoritmos de implementación para `qresid`

## 1 Algoritmo general de RQR

La construcción de Dunn–Smyth consiste en uniformizar cada observación bajo la CDF condicional ajustada y luego transformarla mediante el inverso de la normal estándar.  Para respuestas continuas se aplica directamente la CDF; para discretas se aleatoriza dentro del salto de la CDF【filecite†L39-L48】.  El algoritmo genérico debe cubrir ambos casos y permitir parámetros estimados, offsets/exposures, valores ausentes y pesos.

### 1.1 Definiciones generales

- **Entrada común:** para cada observación \(i=1,\dots,n\), dispóngase de la respuesta \(y_i\), el vector de covariables \(\mathbf{x}_i\), las estimaciones de parámetros \(\hat\theta\), un posible **offset**/exposición \(o_i\) (log-exposición), un peso \(w_i\) y, si la respuesta es discreta, un valor uniforme \(V_i\sim\mathrm{Unif}(0,1)\).
- **Fitted values:** calcúlese el valor ajustado \(\hat\mu_i\) y otros parámetros necesarios (p. ej. varianza, tamaño para NB).
- **CDF condicional:** defínase \(F_i(y;\hat\theta) = P(Y_i\leq y\mid \mathbf{x}_i, o_i; \hat\theta)\), continua o discreta según la familia【filecite†L39-L48】.
- **Límites en discretas:** para discretas defínanse \(\hat a_i = F_i(y_i^-;\hat\theta)\) y \(\hat b_i = F_i(y_i;\hat\theta)\)【filecite†L39-L48】.
- **Uniformización:** si la respuesta es continua, \(\hat U_i = \hat b_i\); si es discreta, \(\hat U_i = \hat a_i + V_i (\hat b_i - \hat a_i)\).
- **Transformación normal:** el residuo cuantílico es \(\hat r_i = \Phi^{-1}(\hat U_i)\). Para familias continuas equivale a \(\Phi^{-1}(F_i(y_i;\hat\theta))\); para discretas incorpora la aleatorización【filecite†L39-L48】.

### 1.2 Algoritmo computacional agnóstico de lenguaje

```
para cada observación i en 1..n
    si y_i es missing o cualquier covariable necesaria es missing entonces
        asignar r_i = missing
        continuar al siguiente i
    fin si
    calcular predictor lineal eta_i = x_i * beta_hat + offset_i
    derivar parámetros de la distribución a partir de eta_i (ej.: mu_i = g^{-1}(eta_i), theta_hat)
    calcular F_i_low  = F_i(y_i - epsilon; theta_hat)  // límite izquierdo (y_i^-)
    calcular F_i_high = F_i(y_i; theta_hat)
    si F_i_high < F_i_low entonces // validación numérica
        lanzar advertencia
        intercambiar valores para asegurar F_i_low ≤ F_i_high
    fin si
    si F_i_high == F_i_low entonces
        U_i = F_i_high
    de lo contrario
        generar o leer V_i ~ U(0,1)
        U_i = F_i_low + V_i * (F_i_high - F_i_low)
    fin si
    r_i = inverse_normal_cdf(U_i)
    si se usan pesos w_i entonces
        r_i = sqrt(w_i) * r_i  // conforme a la convención de beta-regresión
    fin si
fin para
```

**Validaciones:**

1. **Dominio de la CDF:** \(F_i\) debe estar en \([0,1]\).  Si alguna evaluación numérica produce valores fuera de este intervalo, debe truncarse y emitirse advertencia.
2. **Compatibilidad de parámetros:** la implementación debe verificar que los parámetros estimados respetan restricciones (p. ej. dispersión positiva).
3. **Integridad de `offset` y `weight`:** el `offset` debe sumarse a la parte lineal antes de invertir el enlace, y los pesos se aplican multiplicando por \(\sqrt{w_i}\) cuando así lo define la familia.
4. **Ausencia de valores faltantes:** si \(\hat\mu_i\) no puede calcularse porque \(\mathbf{x}_i\) o \(\hat\theta\) están incompletos, el residuo debe declararse `missing`.
5. **Dependencia del RNG:** en discretas, la elección de \(V_i\) determina el residuo final.  Para reproducibilidad se debe permitir fijar semilla global y/o suministrar un vector de uniformes por el usuario; sin embargo, las comparaciones entre Stata y R deben basarse en los límites de la CDF y no en el residuo aleatorizado【filecite†L15-L17】.

### 1.3 Consideraciones específicas

#### Parámetros estimados y normalidad aproximada

Cuando los parámetros se estiman, los residuos cuantílicos ya no son exactamente \(N(0,1)\); sólo convergen a normalidad estándar de forma aproximada【filecite†L120-L129】.  Por ello, el algoritmo debe advertir al usuario que la interpretación es **aproximada** y que los QQ‑plots se usan como diagnóstico, no como prueba exacta.

#### Offset y exposición

Los modelos de tasas (p. ej. Poisson con exposición) incorporan un **offset** \(o_i = \log(E_i)\) aditivo en la predicción.  El algoritmo debe añadir \(o_i\) a la parte lineal antes de aplicar el enlace inverso.  En Stata la variable `offset()` se incorpora en el comando `glm`/`poisson`; al calcular los RQR debe recuperarse este término para reproducir el valor ajustado y la CDF correctos.

#### Valores ausentes y submuestras (`if`/`in`)

El pseudocódigo general trata valores ausentes propagando `missing`.  En un contexto Stata, el programador debe respetar las condiciones `if` y `in` vigentes: calcular residuos sólo para las observaciones activas y dejar `.` en las demás.

#### Pesos

En familias como la beta-regresión, la definición de residuos cuantílicos incluye el multiplicador \(\sqrt{w_i}\).  El algoritmo general permite pesos multiplicando el residuo normalizado; para otras familias los pesos afectan la estimación de parámetros pero no la transformación PIT.

#### RNG y comparabilidad R–Stata

El generador de números aleatorios de Stata puede diferir del de R.  Para comparar resultados discretos exactamente se recomienda comparar **parámetros, fitted values y límites de la CDF** antes de comparar el residuo aleatorizado【filecite†L15-L17】.  El algoritmo debe por defecto registrar la semilla utilizada y, opcionalmente, aceptar un vector de uniformes externos para permitir benchmarking exacto.

## 2 Algoritmos por familia

La implementación debe despachar diferentes cálculos de CDF en función de la familia.  A continuación se describen las entradas necesarias, la fórmula de la CDF, advertencias de implementación y posibles comparaciones con R.  Las familias marcadas como “NO IMPLEMENTAR EN FASE 1” requieren teoría o CDF no disponible y deben diferirse【filecite†L39-L48】.

### 2.1 Familias continuas

#### 2.1.1 Gaussian (Normal)

- **Entrada:** \(y_i\), predictor lineal \(\eta_i\), estimación de dispersión \(\hat\sigma^2\).
- **Parámetros:** media \(\hat\mu_i = \eta_i\) si enlace identidad; para `glm` con enlace diferente se invertirá `link`.
- **CDF:** \(F_i(y) = \Phi\left((y - \hat\mu_i)/\hat\sigma\right)\).
- **End points:** \(F(y_i^-)=F(y_i)\) dado que la CDF es continua.
- **Salida:** \(r_i = \Phi^{-1}(F_i(y_i))\).
- **Validación:** comprobar \(\hat\sigma > 0\); si la familia se estimó con pesos, multiplicar el residuo por \(\sqrt{w_i}\).
- **Comparación con R:** los valores son deterministas y deben coincidir con `statmod::qresiduals()` dentro de tolerancia numérica.

#### 2.1.2 Gamma

- **Entrada:** \(y_i>0\), \(\eta_i\), parámetro de dispersión \(\hat\phi\).
- **Parámetros:** media \(\hat\mu_i = g^{-1}(\eta_i)\) y forma \(k = 1/\hat\phi\); escala \(s = \hat\mu_i / k\).
- **CDF:** \(F_i(y) = \mathrm{PGamma}(y; k, s)\) utilizando la CDF gamma estándar.
- **Salida:** \(r_i = \Phi^{-1}(F_i(y_i))\).
- **Advertencias:** asegurar que \(y_i>0\) y que la CDF se calcula con precisión; en Stata puede usarse `gammap()`.
- **Comparación con R:** exacta con `statmod::qres.gamma()`.

#### 2.1.3 Inverse Gaussian

- **Entrada:** \(y_i>0\), \(\eta_i\), parámetro de dispersión \(\hat\phi\).
- **Parámetros:** media \(\hat\mu_i = g^{-1}(\eta_i)\); parámetro de forma \(\lambda = \hat\mu_i^3/\hat\phi\).
- **CDF:** \(F_i(y) = \mathrm{PInvGauss}(y; \hat\mu_i, \lambda)\).  Stata no implementa la CDF de la inversa gaussiana de forma nativa; se requerirá una función de Mata o un plugin.
- **Salida:** \(r_i = \Phi^{-1}(F_i(y_i))\).
- **Advertencias:** implementarla sólo si se dispone de una función de CDF verificable; de lo contrario, marcar “requiere Mata/plugin/aproximación validada”.

#### 2.1.4 Tweedie

- **Entrada:** \(y_i\ge 0\), \(\eta_i\), parámetro de potencia \(p\) y dispersión \(\phi\).
- **Parámetros:** media \(\hat\mu_i\), varianza \(\operatorname{Var}(Y_i)=\phi \hat\mu_i^p\).
- **CDF:** no existe en forma cerrada para \(1<p<2\) y sólo algunas implementaciones en R (`statmod`, `tweedie`) la aproximan; Stata no la provee.
- **Estado:** **NO IMPLEMENTAR EN FASE 1**; requiere plugin o aproximación validada para la CDF.

### 2.2 Familias discretas clásicas

#### 2.2.1 Bernoulli/Binomial (agrupada)

- **Entrada:** respuestas \(y_i\in\{0,1,\dots,m_i\}\), número de ensayos \(m_i\), predictor \(\eta_i\).
- **Parámetros:** probabilidad de éxito \(\hat\pi_i = g^{-1}(\eta_i)\).
- **CDF:** para \(y\le m_i\), \(F_i(y) = \sum_{k=0}^{y} \binom{m_i}{k} \hat\pi_i^k (1-\hat\pi_i)^{m_i-k}\).  En Stata se evalúa con `binomial(m_i, p)` o `ibinomial()`.
- **End points:** \(a_i = F_i(y_i-1)\), \(b_i = F_i(y_i)\).
- **Residuo:** \(U_i\sim \mathrm{Unif}(a_i,b_i)\); \(r_i=\Phi^{-1}(U_i)\).
- **Validaciones:** garantizar que \(0\le y_i\le m_i\) y que los parámetros satisfacen \(0<\hat\pi_i<1\).
- **Comparación con R:** exacta con `statmod::qres.binom()` y `VGAM::residualsvglm(type="rquantile")`.

#### 2.2.2 Poisson

- **Entrada:** respuestas \(y_i \in \{0,1,2,\dots\}\), predictor \(\eta_i\).
- **Parámetros:** media \(\hat\mu_i = \exp(\eta_i)\) si enlace log.
- **CDF:** \(F_i(y) = P(Y_i \le y) = \mathrm{PPois}(y; \hat\mu_i)\).  En Stata se utiliza `poisson()` para la CDF acumulada.
- **End points:** \(a_i = F_i(y_i-1)\), \(b_i = F_i(y_i)\).
- **Residuo:** aleatorizado como en la fórmula general.
- **Advertencias:** para \(\hat\mu_i\) extremadamente grande o pequeña, la CDF puede requerir aproximación numérica cuidadosa; usar funciones de precisión extendida.
- **Comparación con R:** exacta con `statmod::qres.pois()`.

#### 2.2.3 Negative Binomial (NB1/NB2)

- **Entrada:** \(y_i\in\{0,1,\dots\}\), predictor \(\eta_i\), parámetro de dispersión \(\hat\theta\) (o tamaño).
- **Parámetros:** media \(\hat\mu_i\) y parámetro de tamaño \(k\).
- **CDF:** \(F_i(y) = \mathrm{PNB}(y; k, p_i)\) con \(p_i = k/(k+\hat\mu_i)\) en la parametrización NB2.  En Stata se evalúa con `nbinomial()` o `nbinomialp()` según la versión.
- **End points:** \(a_i = F_i(y_i-1)\), \(b_i = F_i(y_i)\).
- **Residuo:** \(U_i\sim \mathrm{Unif}(a_i,b_i)\); \(r_i=\Phi^{-1}(U_i)\).
- **Advertencias:** validar que \(\hat\theta\) es positivo; en versiones con diferentes parametrizaciones conviene documentar la fórmula exacta y, en tests, comparar CDFs con R para validar equivalencia.
- **Comparación con R:** exacta con `statmod::qres.nbinom()` y `VGAM::residualsvglm(type="rquantile")`.

### 2.3 Familias compuestas e infladas

#### 2.3.1 Zero‑Inflated Poisson (ZIP)

- **Entrada:** respuesta \(y_i\), predictor \(\eta_i\) para la media, predictor \(\eta_i^{\text{infl}}\) para la probabilidad de exceso de ceros (si procede).
- **Parámetros:** probabilidad de inflación \(\hat\pi_i\) y media condicional \(\hat\mu_i\).
- **CDF:**
  - Para \(y_i = 0\): \(F_i(0) = \hat\pi_i + (1-\hat\pi_i)\cdot\mathrm{PPois}(0;\hat\mu_i)\).
  - Para \(y_i > 0\): \(F_i(y) = \hat\pi_i + (1-\hat\pi_i)\cdot\mathrm{PPois}(y;\hat\mu_i)\).
- **End points:** \(a_i = F_i(y_i-1)\), \(b_i = F_i(y_i)\).
- **Residuo:** \(r_i = \Phi^{-1}(U_i)\) con \(U_i\) aleatorizado entre \(a_i\) y \(b_i\).
- **Validaciones:** asegurar que las probabilidades están en \([0,1]\) y que se adopta la parametrización coherente con el objeto R usado para comparar.
- **Comparación con R:** se puede comparar CDFs con `topmodels::pitresiduals()` o `VGAM`.

#### 2.3.2 Zero‑Inflated Negative Binomial (ZINB)

- **Entrada:** similar a ZIP pero con media \(\hat\mu_i\) y tamaño \(k\).
- **CDF:** análogo a ZIP sustituyendo la CDF de Poisson por la de NB.
- **Estado:** implementable con las mismas advertencias; se requiere función de CDF NB y de combinación con la probabilidad de inflación.

#### 2.3.3 Hurdle models

- **Entrada:** variable respuesta \(y_i\), predictor para la componente de cero-truncamiento y predictor para la parte positiva.
- **Concepto:** la probabilidad de \(Y_i=0\) se modela directamente; la distribución condicional sobre \(Y_i>0\) se modela truncada en 0.
- **CDF:**
  - Para \(y_i = 0\): \(F_i(0) = \hat\pi_i\), donde \(\hat\pi_i\) es la probabilidad de no superar el hurdle.
  - Para \(y_i > 0\): \(F_i(y) = \hat\pi_i + (1-\hat\pi_i)\cdot F_i^+(y)\), donde \(F_i^+\) es la CDF de la distribución positiva truncada en 0.
- **Residuo:** igual que en ZIP/ZINB.
- **Comparación con R:** se utiliza `topmodels::pitresiduals()` o `VGAM`;
  la comparación exacta exige parametrización idéntica.

#### 2.3.4 Generalized Poisson / COM‑Poisson

- **Estado:** la CDF puede evaluarse en R mediante paquetes especializados (`COMPoissonReg`, `VGAM`, `glmmTMB`), pero Stata no la provee de forma nativa.
- **Decisión:** **requiere Mata/plugin/aproximación validada** o esperar a futuras fases; por tanto se documentará la teoría pero no se implementará en Fase 1.

## 3 Pseudocódigo específico para Stata (ado)

La implementación en Stata debe seguir el algoritmo general pero traducido al marco de comandos `program`/`syntax` y utilidades built‑in.  A continuación se bosqueja una estructura de un ado-file `qresid.ado` para familias básicas.

```
program qresid, eclass
    version 18
    syntax [if] [in], GENERATE(string) DISTRIBUTION(string) [OFFSET(varname) WEIGHT(varname) SEED(integer) UVAR(varname)]
    quietly {
        * 1. Preparación
        if c(e(cmd)) == "" {
            di as error "No hay modelo activo. Ajuste primero un modelo GLM apropiado."
            exit 198
        }
        tempvar Fl Flm U rnd
        * 2. Calcular parámetros
        predict double mu, mu
        * ejemplo para Poisson
        if "`distribution'" == "poisson" {
            gen double `Flm' = cond(`y' == 0, 0, poisson(`y' - 1, mu))
            gen double `Fl'  = poisson(`y', mu)
        }
        * 3. Uniformización
        if "`uvar'" != "" {
            gen double `U' = `Flm' + `uvar' * (`Fl' - `Flm')
        }
        else {
            if "`seed'" != "" {
                set seed `seed'
            }
            gen double rnd = runiform()
            gen double `U' = `Flm' + rnd * (`Fl' - `Flm')
        }
        * 4. Transformación normal
        gen double `generate' = invnormal(`U')
        * 5. Aplicar pesos
        if "`weight'" != "" {
            replace `generate' = sqrt(`weight') * `generate'
        }
    }
    exit 0
end
```

**Notas técnicas:**

1. El programa debe recuperar la familia y el enlace del modelo activo (`e(family)`, `e(link)`) para despachar a la CDF correcta.  En el pseudocódigo se muestran fragmentos para Poisson; para binomial se utilizaría `binomial()` o `ibinomial()`, y para NB `nbinomial()`.
2. Para familias continuas (Gaussian, Gamma) no se usa `runiform()`; `Flm` y `Fl` son iguales y `U` se asigna directamente.
3. La opción `seed()` fija la semilla antes de generar uniformes; `uvar()` permite pasar un vector externo con uniformes predefinidos.
4. Cualquier error numérico (por ejemplo, `Fl` < `Flm`) debe controlarse con advertencias y, si procede, intercambiar valores.
5. El help file debe advertir que los residuos generados son **aproximadamente normales** cuando los parámetros se estiman【filecite†L120-L129】.

## 4 Pseudocódigo opcional en Mata

Para familias cuya CDF no esté implementada en Stata, puede ser conveniente programar una función en Mata.  El siguiente esqueleto muestra cómo encapsular el cálculo de RQR en Mata para una familia con CDF disponible en Mata o mediante integración numérica.

```
real matrix qresid_mata(real vector y, real matrix X, real vector beta_hat,
                        real scalar dispersion, string scalar family,
                        real vector offset, real vector u_ext)
{
    real scalar n = rows(y)
    real vector r = J(n,1,.)
    for (i=1; i<=n; i++) {
        if (missing(y[i]) | anymissing(X[i,.])) continue
        real scalar eta = sum(X[i,.] :* beta_hat) + offset[i]
        real scalar mu  = linkinv(eta, family)
        real scalar a, b, U
        if (family == "inverse_gaussian") {
            a = ig_cdf(y[i] - 1e-8, mu, dispersion)
            b = ig_cdf(y[i],         mu, dispersion)
        }
        else if (family == "poisson") {
            a = poisson_cdf(y[i] - 1, mu)
            b = poisson_cdf(y[i], mu)
        }
        // uniformización
        if (b == a) {
            U = b
        } else {
            real scalar v = (u_ext[i] == .) ? runiform() : u_ext[i]
            U = a + v * (b - a)
        }
        r[i] = invnormal(U)
    }
    return(r)
}
```

**Consideraciones:**

1. La función `linkinv()` debe implementar el enlace inverso correspondiente.  
2. Las CDFs de familias no nativas (p. ej. inversa gaussiana, COM‑Poisson) deberán codificarse o llamarse desde librerías externas.  
3. El vector `u_ext` permite reproducir exactamente un conjunto de uniformes; si se pasa `.` se genera uno nuevo con `runiform()`.  
4. Para benchmarks precisos con R es recomendable exportar `u_ext` generado en R y leerlo en Stata/Mata.

## 5 Conclusiones

El presente algoritmo proporciona una guía detallada para implementar residuos cuantílicos aleatorizados en Stata, respetando la definición original de Dunn–Smyth【filecite†L39-L48】 y las recomendaciones de comparar primero parámetros y límites de la CDF antes de comparar el residuo aleatorizado【filecite†L15-L17】.  Para familias sin CDF cerrada o con soporte discreto complejo, se recomienda posponer la implementación o emplear aproximaciones validadas mediante Mata o plugins, marcando explícitamente “requiere Mata/plugin/aproximación validada” o “NO IMPLEMENTAR EN FASE 1”.