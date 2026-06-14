# Predicción de Partidos Mundial 2026 

## Objetivo
Utilizar la distribución de Poisson para predecir la cantidad de goles 
y el ganador de los partidos del Mundial 2026.

## ¿Qué es la distribución de Poisson?
La distribución de probabilidad de Poisson da la probabilidad 
de que se produzca un número de eventos en un intervalo fijo de tiempoo espacio 
si estos eventos se producen con una tasa promedio conocida.
Los eventos son independientes del tiempo transcurrido desde el último evento, en este caso 
goles en un partido de fútbol. Se basa en un parámetro λ (lambda) 
que representa el promedio de goles esperados por equipo.

## Datos
- **Fuente:** [Kaggle - International Football Results](https://www.kaggle.com/datasets/martj42/international-football-results-from-1872-to-2017)
- **Contenido:** Resultados históricos de selecciones nacionales en 
  diferentes torneos incluyendo el Mundial
- **Filtro aplicado:** Partidos desde 2022 en adelante

## Metodología
1. Calcular la ventaja de local con partidos no neutrales
2. Calcular la fuerza de ataque y defensa de cada selección
3. Estimar los goles esperados (λ) 
4. Construir la matriz de probabilidades con `dpois()`
5. Obtener probabilidades de victoria, empate y derrota

## Ejemplo de predicción
**Australia vs Turkey**
- λ Australia: 2.901
- λ Turkey: 0.937
- Australia gana: 70% | Empate: 13.4% | Turkey gana: 9.1%

## Recursos
- Video de inspiración: [YouTube](https://www.youtube.com/watch?v=cvPeS0qAikw)
