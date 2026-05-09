# 01_THEORY_RQR_MASTER.md

## Estado del contexto requerido

No pude inspeccionar `PROJECT_BRIEF_QRESID.md` desde las fuentes documentales accesibles en esta conversación. Por tanto, este documento maestro se ha construido únicamente con la literatura y documentación pública que sí pude verificar directamente. Todas las afirmaciones de acceso están explicitadas en la tabla de fuentes; cuando solo pude ver resumen, metadata o documentación de paquete, lo indico expresamente.

## Núcleo teórico

La idea central de los residuos cuantílicos aleatorizados de entity["people","Peter K. Dunn","estadístico; coautor de Randomized Quantile Residuals"] y entity["people","Gordon K. Smyth","estadístico; coautor de Randomized Quantile Residuals"] es uniformizar primero la observación bajo el modelo ajustado mediante una transformación integral de probabilidad y, después, llevar esa cantidad a escala normal estándar aplicando \(\Phi^{-1}\). En el caso ideal de respuestas independientes, modelo correctamente especificado y parámetros verdaderos conocidos, el residuo resultante es exactamente normal estándar; cuando los parámetros se estiman, esa exactitud se pierde y queda sustituida por una normalidad aproximada o asintótica. Dunn y Smyth presentan esta construcción como una generalización práctica de los residuos para regresión no normal, especialmente útil cuando los residuos de Pearson o devianza son manifiestamente no normales y exhiben granularidad por la naturaleza discreta de la respuesta. citeturn14view0turn16view0turn33search4

La relación estructural con el probability integral transform es directa. Para una variable continua \(Y\) con CDF \(F\), el PIT clásico afirma que \(F(Y)\sim \mathrm{Unif}(0,1)\). Para variables discretas, esa uniformidad exacta no vale si se usa solo \(F(Y)\); hay que “repartir” la masa puntual en el salto de la CDF introduciendo una variable uniforme auxiliar. Esa es precisamente la función de la aleatorización en los residuos de Dunn–Smyth. Esta formulación enlaza también con los resultados clásicos de David y Johnson sobre PIT con parámetros estimados y para variables discontinuas, y con la exposición posterior de Warton, Thibaut y Wang, que vuelve a presentar el PIT aleatorizado como cantidad pivotal para datos discretos. citeturn24view0turn24view1turn41view0turn41view1

En relación con entity["people","D. R. Cox","estadístico; coautor de A General Definition of Residuals"] y entity["people","E. J. Snell","estadístico; coautor de A General Definition of Residuals"], Dunn y Smyth dicen explícitamente que, en el caso continuo, su definición es un caso especial de los “crude residuals” de Cox–Snell. La diferencia es de objetivo: Cox–Snell enfatizan correcciones de media y varianza o transformaciones hacia una distribución de referencia conveniente; Dunn–Smyth fijan como referencia la normal estándar porque es la escala gráfica más interpretable para diagnóstico. En ese sentido, el residuo cuantílico aleatorizado puede verse como una versión “normal-score” del PIT: no basada en rangos empíricos, sino en cuantiles normales asociados a la CDF modelizada. Esta última frase es una interpretación operativa de la fórmula, no una etiqueta formal separada en el artículo original. citeturn23view0turn14view0turn39search2

La comparación con los diagnósticos clásicos es nítida. En modelos lineales normales, Pearson, devianza y residuo cuantílico coinciden esencialmente. En GLM no gaussianos, y en particular cuando la respuesta toma pocos valores distintos —Bernoulli, binomial con \(m\) pequeño, Poisson con medias bajas—, Pearson y devianza suelen ser sesgados respecto de la normalidad, con colas y curvaturas artificiales en los gráficos. Feng, Li y Sadeghpour muestran además que, para regresión de conteos, los RQR tienen menor error tipo I y mejor potencia diagnóstica que las alternativas más tradicionales en varios escenarios de mala especificación. citeturn14view0turn10view0turn11view0

## Teoría matemática

### Respuesta continua

Sea \(Y_i\) una respuesta continua, independiente condicionalmente en \(x_i\), con CDF condicional
\[
F_i(y;\theta)=P(Y_i\le y\mid X_i=x_i;\theta).
\]
Si \(\theta\) es el parámetro verdadero y \(F_i\) es continua, entonces por PIT
\[
U_i = F_i(Y_i;\theta)\sim \mathrm{Unif}(0,1),
\]
y el residuo cuantílico es
\[
r_i^{Q}=\Phi^{-1}(U_i)=\Phi^{-1}\!\left(F_i(Y_i;\theta)\right)\sim N(0,1).
\]
Con parámetros estimados por \(\hat\theta\), el residuo de plug-in es
\[
\hat r_i^{Q}=\Phi^{-1}\!\left(F_i(y_i;\hat\theta)\right).
\]
Dunn y Smyth remarcan que, aparte de la variabilidad muestral introducida por \(\hat\theta\), estos residuos son exactamente normales; además, si los estimadores son consistentes, la distribución converge a \(N(0,1)\). citeturn14view0turn23view0

### Respuesta discreta y por qué hace falta aleatorización

Si \(Y_i\) es discreta, \(F_i\) tiene saltos y \(F_i(Y_i;\theta)\) ya no es uniforme. Sea
\[
a_i = F_i(y_i^-;\theta)=\lim_{y\uparrow y_i}F_i(y;\theta),\qquad
b_i = F_i(y_i;\theta),
\]
y sea \(V_i\sim \mathrm{Unif}(0,1)\) independiente. Entonces la uniformización exacta se logra definiendo
\[
U_i = a_i + V_i\,(b_i-a_i)
     = F_i(y_i^-;\theta)+V_i\,P(Y_i=y_i\mid X_i=x_i;\theta).
\]
Equivalentemente,
\[
U_i \sim \mathrm{Unif}(a_i,b_i).
\]
El residuo cuantílico aleatorizado es
\[
r_i^{Q} = \Phi^{-1}(U_i).
\]
Esta es la definición formal de Dunn–Smyth para el caso discreto. La aleatorización no es un adorno computacional: es lo que convierte el salto discreto de la CDF en una variable continua uniforme y elimina la granularidad espuria del gráfico de residuos. Dunn y Smyth subrayan que esta es la “mínima” aleatorización necesaria para que desaparezca la granulación; Feng et al. muestran además que remplazarla por una versión de punto medio pierde la uniformidad exacta y puede reintroducir estructuras en líneas. citeturn16view0turn11view0

### Caso unificado

Bai et al. presentan una notación unificada muy útil para implementación:
\[
F_i^{*}(y_i;\theta,V_i)=
\begin{cases}
F_i(y_i;\theta), & \text{si \(F_i\) es continua en } y_i,\\[4pt]
F_i(y_i^-;\theta)+V_i\,p_i(y_i;\theta), & \text{si \(F_i\) es discreta en } y_i,
\end{cases}
\]
donde \(p_i(y_i;\theta)\) es la PMF. Entonces
\[
r_i^Q=\Phi^{-1}\!\big(F_i^{*}(y_i;\theta,V_i)\big).
\]
Esa expresión cubre a la vez distribuciones continuas, discretas y mixtas con átomo discreto. citeturn36view0

### Parámetros estimados

En práctica no se conoce \(\theta\), y se usa una estimación \(\hat\theta\). La versión implementable es
\[
\hat U_i
=
F_i(y_i^-;\hat\theta)+V_i\left[F_i(y_i;\hat\theta)-F_i(y_i^-;\hat\theta)\right],
\qquad
\hat r_i^{Q}=\Phi^{-1}(\hat U_i).
\]
Para \(F_i\) continua,
\[
\hat U_i = F_i(y_i;\hat\theta),\qquad
\hat r_i^{Q}=\Phi^{-1}(F_i(y_i;\hat\theta)).
\]
Bajo especificación correcta e inferencia regular, Dunn–Smyth afirman que la distribución converge a la normal estándar si \(\hat\theta\) es consistente. Warton et al. formulan la idea equivalente en lenguaje PIT: la única dependencia restante entre \(u_i\) viene de \(\hat\theta\), y esa dependencia se desvanece cuando \(n\to\infty\); por ello, en muestras grandes, los \(u_i\) son aproximadamente i.i.d. y pivotales. citeturn14view0turn40view0turn41view1

### CDF condicional y extensiones dependientes

La teoría original de Dunn–Smyth se formula para respuestas independientes. Sin embargo, el objeto matemático esencial no es la independencia per se, sino disponer de una CDF adecuada del dato observado. Si existe una CDF condicional correcta,
\[
F_i(y_i\mid \mathcal G_i;\theta)=P(Y_i\le y_i\mid \mathcal G_i;\theta),
\]
donde \(\mathcal G_i\) representa la información condicionante relevante —covariables, historia pasada, estado latente, efecto aleatorio conocido o integración marginal—, entonces puede definirse
\[
U_i \sim \mathrm{Unif}\!\left(F_i(y_i^-\mid \mathcal G_i;\theta),\,F_i(y_i\mid \mathcal G_i;\theta)\right)
\]
y transformar después con \(\Phi^{-1}\). Warton et al. observan además que, si las \(F_i\) especifican distribuciones condicionales respecto de respuestas previas, el PIT puede extenderse a respuestas dependientes. Dunn–Smyth ya indicaban brevemente al final de su artículo que las ideas podían extenderse a respuestas dependientes, aunque sin desarrollar allí una teoría completa. citeturn14view0turn41view1

### Residuos PIT simulados tipo DHARMa

En diagnósticos modernos para modelos jerárquicos complejos, la CDF exacta puede ser intratable. Ahí entra la construcción simulada tipo entity["software","DHARMa","paquete de R para diagnóstico de residuos en modelos jerárquicos"]. Si del modelo ajustado se generan \(S\) réplicas \(y_i^{(1)},\dots,y_i^{(S)}\), la versión empírica de la banda PIT se define por
\[
\hat a_i = \frac{1}{S}\sum_{s=1}^S \mathbf 1\{y_i^{(s)}<y_i\},\qquad
\hat b_i = \frac{1}{S}\sum_{s=1}^S \mathbf 1\{y_i^{(s)}\le y_i\}.
\]
DHARMa implementa entonces
\[
\hat U_i^{\text{sim}} \sim \mathrm{Unif}(\hat a_i,\hat b_i),
\]
y si \(\hat a_i=\hat b_i\) usa simplemente ese valor. En su implementación por defecto, el paquete trabaja en escala uniforme; la transformación a escala normal es opcional mediante una función cuantílica como \(qnorm\). Matemáticamente, esto es una aproximación Monte Carlo del PIT aleatorizado, no la misma cantidad exacta basada en una CDF cerrada. citeturn37view0turn38view0turn29view1

## Parámetros estimados, normalidad aproximada y validez diagnóstica

Con parámetros verdaderos conocidos y respuestas independientes, la interpretación “normal estándar” es literal. Con parámetros estimados, deja de ser exacta incluso bajo el modelo correcto, porque los residuos comparten la misma estimación \(\hat\theta\) y por eso ya no son independientes ni exactamente \(N(0,1)\) en muestra finita. El mejor lenguaje aquí es “aproximadamente normales” o “asintóticamente normales”, nunca “exactamente normales” salvo en el escenario oracle. Dunn–Smyth lo dicen de forma explícita y Warton et al. precisan la fuente de dependencia. citeturn14view0turn40view0

Esto tiene consecuencias prácticas importantes. Un QQ-plot frente a la normal o una prueba de normalidad sobre RQR no son teoremas finito-muestrales universales para cualquier GLM ajustado, sino herramientas diagnósticas de referencia. Feng et al. aportan evidencia empírica fuerte de que, en modelos de conteos, esta referencia funciona bien: baja tasa de falso rechazo bajo el modelo correcto y buena potencia frente a no linealidad, sobredispersión y cero-inflación. Bai et al. encuentran resultados análogos para GLMM de conteos cero-inflados y hurdle ajustados con efectos aleatorios. Pero esos trabajos son evidencia de simulación y calibración, no una normalidad exacta finito-muestral general. citeturn10view0turn11view0turn8search1turn36view0

Otra limitación importante es que la validez del residuo depende de que la CDF usada sea la correcta. Si falla la familia de respuesta, el enlace, la estructura de media, la dispersión o la mezcla cero-inflada, el residuo ya no debe parecer \(N(0,1)\) o uniforme. Eso es precisamente lo que lo hace útil como diagnóstico, pero también significa que su comportamiento no separa automáticamente qué componente del modelo falla. Los gráficos de residuos muestran que “el modelo no parece correcto”; descubrir si el problema es enlace, no linealidad, heterogeneidad, exceso de ceros, truncación o dependencia residual requiere leer esos gráficos junto con conocimiento del modelo y, a menudo, con pruebas complementarias. citeturn10view0turn11view0turn29view1

En datos correlacionados la cautela debe ser mayor. Si se aplica una CDF marginal o simulaciones incondicionales sin tratar la correlación residual, el residuo puede parecer no uniforme simplemente porque la estructura de dependencia está siendo transportada al espacio PIT. La documentación de DHARMa insiste en este punto y propone dos estrategias: simular condicionalmente sobre los efectos aleatorios ajustados o rotar el espacio residual antes del cálculo PIT. Esa rotación es ya una aproximación adicional y, según la propia documentación, puede tener error apreciable en GLMM de alta dimensión. Por tanto, en modelos correlacionados la frase correcta no es “el residuo es normal estándar”, sino “el residuo PIT/simulado debería ser aproximadamente uniforme —o normal tras transformación— si la simulación reproduce la estructura estocástica relevante y el manejo de la dependencia es adecuado”. citeturn29view1turn30view0turn37view0

## Familias, extensiones y zonas grises

### GLM estándar

La teoría de Dunn–Smyth es directamente aplicable a cualquier modelo de respuestas independientes para el que pueda evaluarse la CDF condicional correcta. Eso cubre inmediatamente familias GLM estándar como Gaussian, binomial, Poisson, Gamma, inverse Gaussian y, por extensión computacional, negative binomial y Tweedie si se dispone de la CDF correspondiente. La documentación oficial de `statmod::qresiduals` implementa precisamente Gaussian/gaussiana, binomial, Poisson, negative binomial, Gamma, inverse Gaussian y Tweedie; para Gamma e inverse Gaussian admite parámetro de dispersión conocido o estimado, y para Tweedie aporta una implementación específica. En Gaussian, Gamma e inverse Gaussian puramente continuas no se necesita aleatorización; en binomial, Poisson y negative binomial sí; en Tweedie de tipo compuesto Poisson–Gamma la respuesta puede tener masa en cero, de modo que la aleatorización es conceptualmente necesaria en el átomo discreto. citeturn42search2turn5search1turn39search8

### Conteos sobredispersos, infradispersos, zero-inflated y hurdle

Para negative binomial el soporte teórico es directo y la práctica computacional está madura. Para modelos zero-inflated y hurdle, la teoría sigue siendo la misma, pero exige construir la CDF correcta del modelo compuesto. Bai et al. escriben explícitamente la PMF y CDF para ZIP, ZINB, ZMP y ZMNB/Poisson o NB truncados, y luego insertan esa CDF en la fórmula general del RQR. Eso muestra que, al menos para estas familias, no hace falta una teoría especial distinta: basta con disponer de la CDF del modelo mixto o truncado y aplicar la definición general. La advertencia importante es que el “saturated model” para deviance residuals puede ser difícil o ambiguo en estos modelos, lo que hace todavía más atractivos los RQR. citeturn35view0turn36view0

### COM-Poisson, generalized Poisson y otras familias de conteo flexibles

Aquí la situación es más desigual. Desde el punto de vista abstracto, la teoría genérica de Dunn–Smyth sigue valiendo si la respuesta es independiente y la CDF es computable con suficiente precisión. Eso favorece a familias como Conway–Maxwell–Poisson y generalized Poisson, para las que existen implementaciones de PMF/CDF en R. La documentación de entity["software","COMPoissonReg","paquete de R para regresión Conway–Maxwell–Poisson"] expone funciones `dcmp`, `pcmp`, `qcmp`, `rcmp` e incluso soporte para modelos zero-inflated CMP; la documentación de entity["software","VGAM","paquete de R para modelos lineales generalizados vectoriales"] y otros paquetes ofrece implementaciones de generalized Poisson y de su función de distribución. Además, entity["software","glmmTMB","paquete de R para modelos lineales generalizados mixtos"] soporta `compois`, `genpois`, variantes truncadas y zero-inflation. Todo ello hace factible construir RQR. Lo que falta con frecuencia no es la definición matemática básica, sino una literatura específica y madura sobre su comportamiento finito-muestral familia por familia, especialmente cuando la CDF requiere sumas truncadas, normalizantes costosos o aproximaciones numéricas. citeturn26search8turn26search6turn27search5turn25search0turn25search2turn28search0

### Modelos multinivel, GLMM y datos longitudinales

En modelos mixtos, jerárquicos o longitudinales, el dilema principal es qué CDF usar. Si existe una CDF marginal integrada
\[
F_i^{\text{marg}}(y)=\int F(y\mid b_i,x_i;\theta)\,dG(b_i;\psi),
\]
y puede evaluarse con precisión, entonces el RQR marginal queda teóricamente justificado por la construcción PIT habitual. Si se usa una CDF condicional en \(b_i\), la interpretación es condicional y depende de conocer o fijar esos efectos. En muchos GLMM reales esa CDF no es cerrada o es costosa, por lo que la práctica dominante pasa a ser simulación desde el modelo ajustado. Bai et al. proporcionan evidencia metodológica y de simulación para GLMM de conteos cero-inflados con `glmmTMB`; DHARMa generaliza el enfoque vía PIT empírico simulado. Pero esto no convierte todos esos residuos en “exactamente normales”: los hace diagnósticamente útiles bajo mecanismos de simulación bien especificados. citeturn8search1turn36view0turn29view1turn30view0

### Qué está matemáticamente bien justificado y qué es más heurístico

Está bien justificado, en sentido fuerte, lo siguiente: usar \(r_i=\Phi^{-1}(U_i)\) con \(U_i\) obtenido por PIT o PIT aleatorizado desde la CDF correcta de observaciones independientes y con parámetros verdaderos; usar la misma fórmula con estimadores consistentes como aproximación asintótica; y aplicar la definición también a modelos compuestos discretos —zero-inflated, hurdle, truncados— cuando su CDF está correctamente construida. Está razonablemente justificado, pero ya con ingredientes Monte Carlo, usar PIT empírico a partir de simulaciones del modelo ajustado. Es más heurístico tratar el residuo resultante como exactamente \(N(0,1)\) en GLMM complejos, con simulaciones escasas, efectos aleatorios re-simulados de forma discutible o rotaciones aproximadas del espacio residual. También es heurístico extrapolar “si el QQ-plot parece bien, el modelo está bien” en presencia de fuerte dependencia, alta dimensionalidad o CDFs numéricas mal aproximadas. citeturn14view0turn40view0turn29view1turn30view0turn37view0

### Zonas sin teoría suficiente

La primera zona gris es la teoría finito-muestral general con parámetros estimados en modelos discretos complejos. Sabemos mucho asintóticamente y sabemos bastante por simulación, pero no existe una distribución nula exacta universal para \(\hat r_i^Q\) una vez que se han estimado muchos componentes del modelo. La segunda es el caso correlacionado de alta dimensión: PIT-trap y DHARMa ofrecen caminos útiles, pero la interpretación ya depende de la forma en que se simula y/o se reescala la dependencia. La tercera es la de familias flexibles con CDF difícil —COM-Poisson, generalized Poisson, Tweedie en algunos regímenes, modelos con censura o semicontinuos— donde la teoría genérica existe, pero el cuello de botella real es computacional y numérico. La cuarta es la detección de outliers en modelos con masa en cero y soporte continuo positivo: la propia literatura de regresión zero-adjusted ha propuesto residuos alternativos porque el RQR puede no ser el más sensible para ciertos atípicos pegados al cero. citeturn21search2turn20search3turn26search8turn27search5turn29view1

## Matemática mínima implementable

La matemática mínima implementable para RQR en un software como entity["software","Stata","software estadístico"] es corta y exacta en su esencia. Para cada observación \(i\), hay que fijar la CDF condicional correcta del modelo ajustado:
\[
F_i(y)=P(Y_i\le y\mid X_i=x_i;\hat\theta).
\]
Después se calculan
\[
\hat a_i = F_i(y_i^-),\qquad
\hat b_i = F_i(y_i).
\]
Si la respuesta es continua y \(F_i\) no tiene salto en \(y_i\), entonces \(\hat a_i=\hat b_i\) y
\[
\hat U_i = \hat b_i,\qquad
\hat r_i=\Phi^{-1}(\hat U_i).
\]
Si la respuesta es discreta,
\[
\hat U_i \sim \mathrm{Unif}(\hat a_i,\hat b_i),
\qquad
\hat r_i=\Phi^{-1}(\hat U_i).
\]
Eso es todo. El residuo no requiere derivadas ni matrices “hat”; requiere una CDF correcta y, en el caso discreto, una PMF implícita a través del salto \(\hat b_i-\hat a_i\). Esto es exactamente lo que implementan `statmod::qresiduals` para GLM clásicos y lo que generalizan después otros paquetes y artículos a familias más complejas. citeturn42search2turn16view0turn36view0

Para una implementación robusta, la parte crítica no es la transformación normal sino la evaluación numérica de \(F_i(y_i)\) y \(F_i(y_i^-)\). En Poisson, binomial, negative binomial, Gamma, inverse Gaussian y muchas mezclas/hurdles esto es directo. En Tweedie, COM-Poisson, generalized Poisson y algunos GLMM, la dificultad es numérica: o bien hay que integrar, o bien truncar sumas, o bien aproximar la CDF por simulación. Luego, para diagnóstico, se recomiendan tres vistas complementarias: QQ-plot contra \(N(0,1)\), gráfico residuos vs. valores ajustados, y residuos vs. covariables relevantes. En discreto, conviene fijar semilla si se desea reproducibilidad de la aleatorización. citeturn42search2turn26search8turn27search5turn29view1

## Matemática avanzada y extensión futura

La extensión más limpia consiste en reemplazar una CDF cerrada por una CDF condicional o marginal más general. En un GLMM, por ejemplo, puede definirse un residuo marginal con
\[
F_i^{\text{marg}}(y_i)=\int P(Y_i\le y_i\mid b_i,x_i;\theta)\,dG(b_i;\psi),
\]
o un residuo condicional si el diagnóstico que interesa es “condicionado” a los efectos aleatorios ya ajustados. Esta distinción no es cosmética: cambia el objeto que se está chequeando. La documentación de DHARMa insiste precisamente en decidir si la simulación debe ser condicional o incondicional sobre efectos aleatorios, porque ambos diagnósticos contestan preguntas distintas y pueden tener potencia distinta frente a problemas de dispersión o estructura jerárquica. citeturn29view1turn30view0

La extensión simulation-based adopta la forma
\[
\hat a_i=\frac{1}{S}\sum_{s=1}^S\mathbf 1\{y_i^{(s)}<y_i\},\qquad
\hat b_i=\frac{1}{S}\sum_{s=1}^S\mathbf 1\{y_i^{(s)}\le y_i\},\qquad
\hat U_i\sim \mathrm{Unif}(\hat a_i,\hat b_i).
\]
Si se desea una escala normal,
\[
\hat r_i^{\text{sim}}=\Phi^{-1}(\hat U_i).
\]
Esa formulación es conceptualmente la misma que RQR, solo que la CDF verdadera se sustituye por su versión empírica simulada. Cuando el número de simulaciones \(S\) es pequeño, aparece error Monte Carlo; cuando la dependencia residual es fuerte, puede ser necesario rotar el espacio residual o cambiar el régimen de simulación. Todo esto es matemáticamente defendible, pero ya no debe venderse como la teoría exacta de Dunn–Smyth, sino como una aproximación PIT basada en simulación. citeturn37view0turn38view0turn29view1

Una extensión todavía más ambiciosa es la de PIT residuals para resampling en datos multivariados o correlacionados. Warton, Thibaut y Wang muestran que, si se dispone de marginales correctas \(F(y;\theta_j,x_i)\) y estimadores consistentes, el PIT-trap preserva asintóticamente la distribución marginal y puede preservar correlación mediante remuestreo por filas. Esa teoría es muy relevante para futuras extensiones de RQR a escenarios donde el interés no es solo diagnóstico gráfico sino bootstrap de inferencia. En cambio, eso ya está un paso más allá del residuo individual tipo Dunn–Smyth clásico. citeturn31search0turn41view1

## Tablas de fuentes y de modelos

### Tabla de fuentes

| ID | Referencia completa | Tipo de fuente | Acceso completo sí/no | Qué pude revisar exactamente | Qué no pude revisar | ¿PDF requerido? | Relevancia para implementación Stata |
|---|---|---|---|---|---|---|---|
| S1 | Dunn, P. K., & Smyth, G. K. (1996). *Randomized quantile residuals*. *Journal of Computational and Graphical Statistics*, 5(3), 236–244. DOI: 10.1080/10618600.1996.10474708. citeturn14view0turn12view0 | Artículo metodológico primario | Sí | PDF aceptado completo: definición continua, definición discreta, relación con Cox–Snell, observación sobre parámetros estimados y nota breve sobre respuestas dependientes. citeturn14view0turn16view0 | No tuve capturas visuales del PDF por fallo técnico del screenshot, aunque sí texto parseado. | No | Máxima: es la fuente base de la fórmula que debe codificarse. |
| S2 | Cox, D. R., & Snell, E. J. (1968). *A General Definition of Residuals*. *Journal of the Royal Statistical Society. Series B*, 30(2), 248–265. DOI: 10.1111/j.2517-6161.1968.tb00724.x. citeturn23view0 | Artículo metodológico clásico | No | Resumen oficial y metadata. citeturn23view0 | No pude revisar el PDF completo. | Sí, si se desea una derivación detallada de crude/general residuals. | Alta: contextualiza por qué RQR es una transformación Cox–Snell hacia normalidad. |
| S3 | Loynes, R. M. (1969). *On Cox and Snell’s General Definition of Residuals*. *Journal of the Royal Statistical Society. Series B*, 31(1), 103–106. DOI: 10.1111/j.2517-6161.1969.tb00770.x. citeturn24view2 | Nota metodológica | No | Resumen oficial y metadata. citeturn24view2 | No pude revisar el PDF completo. | Opcional | Media: refuerza la discusión teórica general sobre residuales transformados. |
| S4 | David, F. N., & Johnson, N. L. (1948). *The Probability Integral Transformation When Parameters Are Estimated From the Sample*. *Biometrika*, 35(1–2), 182–190. DOI: 10.1093/biomet/35.1-2.182. citeturn24view0 | Artículo teórico clásico | No | Título, autores, revista y DOI. citeturn24view0 | No pude revisar contenido, fórmulas ni pruebas. | Sí, si se quiere citar con precisión la teoría PIT con plug-in. | Alta para fundamentar el paso “parámetros estimados”; hoy solo pude usarlo como anclaje bibliográfico. |
| S5 | David, F. N., & Johnson, N. L. (1950). *The Probability Integral Transformation When the Variable Is Discontinuous*. *Biometrika*, 37(1–2), 42–49. DOI: 10.1093/biomet/37.1-2.42. citeturn24view1 | Artículo teórico clásico | No | Título, autores, revista y DOI. citeturn24view1 | No pude revisar contenido, fórmulas ni pruebas. | Sí, si se quiere documentar la uniformización exacta de variables discontinuas con total rigor primario. | Alta para justificar completamente la aleatorización en discreto. |
| S6 | Dunn, P. K., & Smyth, G. K. (2018). *Generalized Linear Models With Examples in R*. Springer. DOI: 10.1007/978-1-4419-0118-7. citeturn5search0 | Libro | No | Página del libro, tabla de contenidos y metadata; confirmé que incluye un capítulo de diagnósticos y referencia a randomized quantile residuals. citeturn5search0 | No pude revisar el texto del capítulo. | Sí, si se quieren detalles de exposición pedagógica y ejemplos. | Alta: probable guía práctica para traducir teoría a implementación. |
| S7 | Smyth, G. *qresiduals: Randomized Quantile Residuals* en `statmod`. Documentación CRAN/R. citeturn42search2turn5search1 | Documentación oficial de paquete | Sí | Funciones soportadas, familias implementadas, manejo de dispersión y descripción operativa. citeturn42search2turn5search1 | No revisé el código fuente interno en esta sesión. | No | Máxima: traduce la teoría base a una API concreta replicable en Stata. |
| S8 | Feng, C., Li, L., & Sadeghpour, A. (2020). *A comparison of residual diagnosis tools for diagnosing regression models for count data*. *BMC Medical Research Methodology*, 20, 175. DOI: 10.1186/s12874-020-01055-2. citeturn10view0turn11view0 | Artículo metodológico aplicado | Sí | Texto completo open access: fórmulas de RQR para conteos, comparación con Pearson/devianza, evidencia de simulación. citeturn10view0turn11view0 | No revisé el PDF descargado aparte, pero sí el HTML completo. | No | Muy alta: evidencia práctica sobre calibración de RQR en conteos. |
| S9 | Bai, W., Dong, M., Li, L., Feng, C., et al. (2021). *Randomized quantile residuals for diagnosing zero-inflated generalized linear mixed models with applications to microbiome count data*. *BMC Bioinformatics*, 22, 564. DOI: 10.1186/s12859-021-04371-6. citeturn35view0turn36view0 | Artículo metodológico/aplicado | Sí | Texto completo open access: PMF/CDF de ZIP, ZINB, hurdle; definición general de RQR; simulaciones para GLMM cero-inflados. citeturn35view0turn36view0 | No pude usar PMC por reCAPTCHA, pero sí la versión Springer abierta. | No | Máxima para extensiones mixtas y cero-infladas. |
| S10 | Warton, D. I., Thibaut, L., & Wang, Y. A. (2017). *The PIT-trap—A “model-free” bootstrap procedure for inference about regression models with discrete, multivariate responses*. *PLOS ONE*, 12(7), e0181790. DOI: 10.1371/journal.pone.0181790. citeturn31search0turn41view1turn40view0 | Artículo teórico-metodológico | Sí | Texto completo open access: formulación discreta del PIT con jittering, carácter pivotal, dependencia inducida por estimación, extensión a resampling multivariante. citeturn31search0turn41view0turn40view0 | Algunas ecuaciones quedaron como imágenes en la captura, no siempre parseadas como LaTeX. | No | Muy alta: fundamento moderno para PIT residuals más allá del GLM independiente clásico. |
| S11 | Hartig, F. et al. `simulateResiduals` en `DHARMa`. Documentación CRAN/R. citeturn29view1 | Documentación oficial de paquete | Sí | Detalles sobre simulación condicional/incondicional, método PIT, refit bootstrap, manejo de autocorrelación y escala uniforme. citeturn29view1 | No revisé toda la vignette por timeout, solo documentación accesible y otras páginas del paquete. | No | Muy alta para una futura implementación simulation-based en Stata. |
| S12 | `getQuantile` y `residuals.DHARMa` en `DHARMa` + código fuente `helper.R`. citeturn30view0turn37view0turn38view0 | Documentación + código fuente de paquete | Sí | Fórmula empírica exacta usada por DHARMa: \(\hat a_i,\hat b_i\), randomización uniforme entre ambas, transformación opcional con \(qnorm\). citeturn37view0turn38view0 | No revisé pruebas matemáticas fuera de la documentación. | No | Máxima: aquí está la matemática simulada directamente portable. |
| S13 | `glmmTMB` family functions (`nbinom2`, `compois`, `genpois`, variantes truncadas, `tweedie`, etc.). citeturn25search0turn25search2 | Documentación oficial de paquete | Sí | Familias soportadas y parametrizaciones relevantes para CDF/varianza. citeturn25search0turn25search2 | No revisé todas las funciones de predicción/simulación internas. | No | Alta: indica qué familias complejas ya se usan en R y cuáles serían ambiciosas en Stata. |
| S14 | `COMPoissonReg` package y documentación de `pcmp`. citeturn26search8turn26search6 | Documentación oficial de paquete | Sí | Confirmé existencia de PMF/CDF/cuántiles para COM-Poisson y soporte a ZICMP. citeturn26search8turn26search6 | No revisé teoría completa del paquete ni artículos completos asociados. | No | Alta para valorar factibilidad de RQR en COM-Poisson si se implementa CDF numérica. |
| S15 | Documentación de generalized Poisson en `VGAM`/paquetes relacionados. citeturn27search0turn27search5 | Documentación de paquete | Sí | Parametrización, soporte y existencia de CDF para generalized Poisson. citeturn27search0turn27search5 | No revisé una monografía completa del modelo. | No | Alta: permite clasificar factibilidad en Stata para generalized Poisson. |
| S16 | Scudilio, J., & Pereira, G. H. A. (2020). *Adjusted quantile residual for generalized linear models*. *Computational Statistics*, 35(1), 399–421. DOI: 10.1007/s00180-019-00896-w. citeturn21search0 | Artículo metodológico | No | Resumen y metadata. citeturn21search0 | No pude revisar fórmulas, simulaciones ni recomendaciones operativas. | Sí, si se desea extender el documento a residuos ajustados en Gamma/IG. | Media: importante para extensiones, no indispensable para el RQR canónico. |
| S17 | Pereira, G. H. A. (2019). *On quantile residuals in beta regression*. *Communications in Statistics - Simulation and Computation*, 48(1), 302–316. DOI: 10.1080/03610918.2017.1381740. citeturn20search1 | Artículo metodológico | No | Abstract y metadata. citeturn20search1 | No pude revisar texto completo ni fórmulas. | Sí, si se quiere ampliar fuera del ámbito GLM clásico de conteos/positivos. | Baja–media: más útil para futuras extensiones que para implementación inicial en Stata. |

### Tabla de distribuciones y modelos

| Familia / modelo | Variable respuesta | CDF requerida | ¿Aleatorización requerida? | Soporte teórico directo | Soporte por analogía | Implementación R existente | Factibilidad en Stata | Riesgos |
|---|---|---|---|---|---|---|---|---|
| Gaussian / normal lineal | Continua | \(\Phi((y-\mu)/\sigma)\) o CDF normal condicional | No | Sí; en normal lineal coincide esencialmente con residuales clásicos. citeturn14view0 | No necesaria | `statmod::qresiduals`. citeturn42search2 | Alta | Confundir con residual crudo; aquí la ventaja diagnóstica extra es pequeña. |
| Bernoulli / binomial | Discreta finita | CDF binomial condicional | Sí | Sí; Dunn–Smyth directo. citeturn16view0turn42search2 | No | `statmod::qresiduals`. citeturn42search2 | Alta | Sensible a medias extremas; sin aleatorización reaparecen líneas. |
| Poisson | Conteo discreto | CDF Poisson condicional | Sí | Sí; directo y muy estudiado. citeturn16view0turn42search2 | No | `statmod::qresiduals`; también soporte práctico en `DHARMa`. citeturn42search2turn29view1 | Alta | Si la media es pequeña, Pearson/devianza son especialmente malos; RQR es preferible. |
| Negative binomial | Conteo discreto sobredisperso | CDF NB condicional | Sí | Sí; por teoría genérica y documentación/uso establecido. citeturn42search2turn10view0 | No | `statmod::qresiduals`; `glmmTMB`. citeturn42search2turn25search0 | Alta | Necesidad de parametrización consistente entre software. |
| Gamma | Continua positiva | CDF Gamma condicional | No | Sí; teoría continua directa. citeturn14view0turn42search2 | No | `statmod::qresiduals`. citeturn42search2 | Alta | Depende de una parametrización correcta de la dispersión/shape. |
| Inverse Gaussian | Continua positiva | CDF inverse Gaussian condicional | No | Sí; teoría continua directa. Dunn–Smyth observan además que el deviance residual es exactamente normal en este caso, aunque RQR sigue siendo válido. citeturn14view0turn42search2 | No | `statmod::qresiduals`. citeturn42search2 | Media–alta | CDF y parametrización pueden ser más delicadas en Stata. |
| Tweedie | Mixta: masa en cero + continuo positivo para \(1<p<2\) | CDF Tweedie completa, incluyendo átomo en cero | Sí en el átomo; no en la parte continua | Parcialmente sí, vía implementación dedicada y teoría genérica. citeturn42search2turn29view1 | Sí, para algunos regímenes complejos | `statmod::qresiduals`; `glmmTMB`. citeturn42search2turn25search0 | Media | La CDF puede requerir aproximación numérica; riesgo de errores cerca del átomo. |
| ZIP / ZINB | Conteo discreto con exceso de ceros | CDF de mezcla zero-inflated | Sí | Sí; Bai et al. escriben PMF/CDF y aplican la fórmula general. citeturn35view0turn36view0 | No | Código suplementario con `glmmTMB`; también simulación vía `DHARMa`. citeturn36view0turn29view1 | Media–alta | Construcción correcta de la CDF compuesta; parametrización distinta según software. |
| Hurdle / zero-modified Poisson–NB | Conteo discreto con truncación en cero | CDF hurdle / truncada | Sí | Sí; PMF/CDF explícitas en Bai et al. citeturn35view0turn36view0 | No | Código suplementario con `glmmTMB`; `DHARMa` por simulación. citeturn36view0turn29view1 | Media–alta | Error frecuente: usar CDF no truncada o tratar mal \(g(0)\). |
| COM-Poisson / ZICMP | Conteo sobre- o infradisperso | CDF COM-Poisson, habitualmente numérica | Sí | Limitado: directo solo por teoría genérica si la CDF es evaluable; no vi un tratamiento primario familia-específico de RQR comparable al de Poisson/NB. citeturn26search8turn28search0 | Sí | `COMPoissonReg`; también `glmmTMB` soporta `compois`. citeturn26search8turn26search6turn25search0 | Media | Coste numérico del normalizante y de la CDF; posible inestabilidad y lentitud. |
| Generalized Poisson | Conteo sobre/infradisperso | CDF generalized Poisson | Sí | Limitado: teoría genérica sí; no vi una literatura primaria madura específica de RQR para esta familia en esta sesión. citeturn27search0turn27search5 | Sí | `VGAM`, `glmmTMB`, otros paquetes con CDF. citeturn27search0turn25search0 | Media | Soporte y parametrización frágiles; la propia documentación advierte sobre convergencia. |
| GLMM de conteos | Conteo con efectos aleatorios | CDF marginal integrada o CDF condicional apropiada | Depende; sí si discreta | Limitado pero creciente; Bai et al. para modelos cero-inflados/hurdle mixtos y teoría PIT genérica. citeturn36view0turn41view1 | Sí | `glmmTMB`, `DHARMa`. citeturn25search0turn29view1 | Media | La CDF marginal puede no ser cerrada; simulación suele sustituir a fórmula exacta. |
| Datos longitudinales / correlacionados / multivariados | Dependiente | CDF condicional o marginal por componente; o PIT simulado | Sí si hay discreción | Parcial: PIT-trap proporciona teoría de resampling y PIT residuals; no equivale a “RQR exacto finito-muestral” para cualquier dependencia. citeturn31search0turn41view1 | Sí | `DHARMa`; PIT-trap conceptual. citeturn29view1turn31search0 | Media–baja | La dependencia residual puede contaminar uniformidad/normalidad si no se maneja bien. |
| Residuos simulados tipo DHARMa/PIT | General, cuando se puede simular del modelo | CDF empírica simulada \((\hat a_i,\hat b_i)\) | Sí si hay empates discretos | Sí como PIT Monte Carlo; no es el mismo resultado exacto que una CDF cerrada. citeturn37view0turn38view0 | No | `DHARMa`. citeturn29view1turn30view0 | Media | Error Monte Carlo, dependencia de \(S\), elección condicional/incondicional, rotación aproximada. |

## Conclusiones operativas

La respuesta breve a las preguntas de investigación es la siguiente. La definición formal de Dunn–Smyth es
\[
r_i^Q=\Phi^{-1}(U_i),\qquad
U_i\sim \mathrm{Unif}(F_i(y_i^-),F_i(y_i)),
\]
con la simplificación \(U_i=F_i(y_i)\) si la CDF es continua. Su relación con el PIT es exacta: RQR es PIT en escala normal; su relación con Cox–Snell es la de una especialización hacia la normal estándar; y su relación con “normal scores” es interpretativa y operativa, en el sentido de que aplica una puntuación normal a un PIT modelizado. Para variables continuas la teoría es exacta con parámetros conocidos; para variables discretas la aleatorización es necesaria para recuperar una uniforme continua; con parámetros estimados la distribución deja de ser exactamente normal y pasa a ser aproximadamente o asintóticamente normal, con dependencia inducida por \(\hat\theta\). citeturn14view0turn16view0turn23view0turn40view0turn41view1

Para GLM estándar la teoría está madura y la implementación en R es directa mediante `statmod::qresiduals`. Para conteos sobredispersos, zero-inflated y hurdle, la definición sigue siendo válida siempre que la CDF del modelo compuesto se construya correctamente; Bai et al. muestran esto de forma explícita en GLMM cero-inflados y hurdle. Para COM-Poisson, generalized Poisson y familias afines, la justificación matemática básica existe por analogía directa con Dunn–Smyth siempre que la CDF sea computable, pero la literatura específica y la experiencia finito-muestral son menos maduras. Para modelos jerárquicos, longitudinales y correlacionados, la interpretación exacta “normal estándar” solo es defendible cuando la CDF condicional o marginal pertinente está bien definida y correctamente evaluada; de lo contrario, lo más sólido es hablar de PIT residuals o residuos simulados tipo DHARMa, que son diagnósticos Monte Carlo de gran utilidad pero no un teorema de normalidad exacta. citeturn42search2turn35view0turn36view0turn26search8turn27search5turn29view1turn37view0

Para una implementación inicial en Stata, la ruta metodológicamente más segura es empezar por Gaussian, binomial/Bernoulli, Poisson, negative binomial, Gamma e inverse Gaussian, donde la CDF es estándar y la teoría está firmemente asentada. En una segunda etapa pueden añadirse ZIP/ZINB y hurdle usando sus CDF compuestas. Una tercera etapa razonable sería un modo simulation-based tipo DHARMa para GLMM y familias sin CDF cómoda. Existe además un paquete comunitario de Stata, urlqresidhttps://github.com/psotob91/qresid, cuya existencia pude verificar indirectamente mediante una discusión reciente en Statalist; en esta sesión no revisé directamente el repositorio, así que cualquier uso de ese paquete debería contrastarse por separado. citeturn42search0

## Preguntas abiertas y limitaciones

Quedan abiertas, o solo parcialmente respaldadas en esta revisión, cuatro cuestiones. La primera es la teoría finito-muestral general de RQR con parámetros estimados en modelos discretos complejos. La segunda es la calibración teórica —no solo por simulación— en GLMM, modelos correlacionados y familias flexibles como COM-Poisson o generalized Poisson. La tercera es la comparación formal entre RQR exactos por CDF y PIT simulados tipo DHARMa cuando ambos están disponibles. La cuarta es la literatura precisa sobre residuos estandarizados o ajustados emparentados con RQR —por ejemplo, las propuestas de Klar–Meintanis y de Scudilio–Pereira—, para la que en varios casos necesitaría que el usuario proporcionase el PDF si desea una sección aún más exhaustiva y totalmente primaria.