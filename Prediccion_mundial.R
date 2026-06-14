library(tidyverse)

datos <- read.csv(file.choose())
datos$date <- as.Date(datos$date)

df <- datos %>% filter(lubridate::year(date) >= 2022)

df_local     <- df[df$neutral == FALSE, ]
df_visitante <- df[df$neutral == TRUE,  ]

promedio_local     <- mean(df_local$home_score, na.rm = TRUE)
promedio_visitante <- mean(df_local$away_score,  na.rm = TRUE)
ventaja_local      <- promedio_local / promedio_visitante
promedio_general   <- mean(c(df_local$home_score, df_local$away_score), na.rm = TRUE)

# STATS POR EQUIPO 
stats_local <- df_local %>%
  group_by(equipo = home_team) %>%
  summarise(
    partidos_local = n(),
    goles_favor_L  = sum(home_score, na.rm = TRUE),
    goles_contra_L = sum(away_score,  na.rm = TRUE)
  )

stats_visita <- df_local %>%
  group_by(equipo = away_team) %>%
  summarise(
    partidos_visita = n(),
    goles_favor_V   = sum(away_score,  na.rm = TRUE),
    goles_contra_V  = sum(home_score, na.rm = TRUE)
  )

stats <- full_join(stats_local, stats_visita, by = "equipo") %>%
  replace_na(list(partidos_local=0, goles_favor_L=0, goles_contra_L=0,
                  partidos_visita=0, goles_favor_V=0, goles_contra_V=0)) %>%
  mutate(
    total_partidos = partidos_local + partidos_visita,
    total_favor    = goles_favor_L  + goles_favor_V,
    total_contra   = goles_contra_L + goles_contra_V,
    ataque         = (total_favor  / total_partidos) / promedio_general,
    defensa        = (total_contra / total_partidos) / promedio_general
  )

# ──  PREDICCION ──────────────────────────────────────────────────────────────
equipo_local  <- "Australia"
equipo_visita <- "Turkey"

if (!equipo_local  %in% stats$equipo) stop(paste("❌ No encontrado:", equipo_local))
if (!equipo_visita %in% stats$equipo) stop(paste("❌ No encontrado:", equipo_visita))

lambda_local <- stats$ataque[stats$equipo == equipo_local] *
  stats$defensa[stats$equipo == equipo_visita] *
  promedio_general * ventaja_local

lambda_visita <- stats$ataque[stats$equipo == equipo_visita] *
  stats$defensa[stats$equipo == equipo_local] *
  promedio_general

cat("\nGoles esperados:\n")
cat(" Australia (local):", round(lambda_local,  3), "\n")
cat(" Turkey   (visita):", round(lambda_visita, 3), "\n")

# ──  MATRIZ DE POISSON ───────────────────────────────────────────────────────
max_goles <- 5

matriz <- outer(
  0:max_goles, 0:max_goles,
  FUN = function(h, a) dpois(h, lambda_local) * dpois(a, lambda_visita)
)

rownames(matriz) <- paste("Australia", 0:max_goles)
colnames(matriz) <- paste("Turkey",    0:max_goles)

print(round(matriz * 100, 2))

# ── PROBABILIDADES FINALES ──────────────────────────────────────────────────
#sumatoria
prob_local  <- sum(matriz[lower.tri(matriz)])
prob_empate <- sum(diag(matriz))
prob_visita <- sum(matriz[upper.tri(matriz)])

cat("\n── Probabilidades del partido ──\n")
cat(" Australia gana:", round(prob_local  * 100, 1), "%\n")
cat(" Empate:        ", round(prob_empate * 100, 1), "%\n")
cat(" Turkey gana:   ", round(prob_visita * 100, 1), "%\n")


cat("lambda Australia:", round(lambda_local, 3), "\n")
cat("lambda Turkey:   ", round(lambda_visita, 3), "\n")