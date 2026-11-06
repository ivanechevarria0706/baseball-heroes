# Baseball Heroes 1.0.60

Recorte exclusivo de partido en MatchPortraitView, sin alterar los PNG de cartas. head-layout.json mide 1512 cabezas, conserva la región central de piel detectada y define siluetas y zonas de bat que se borran de una copia de textura. Los retratos compartidos se conservan; la copia se libera al disponer el actor. La deformación de cara usa bandas con matrices explícitas para renderizar igual en Ruffle y Flash, con giro leve, foco y parpadeo. No representa perfiles individuales nuevos.

MatchActorHead transmite orientación y gesto a MLBPlayerArtwork en modo exclusivo de partido. FieldingSprite y PitcherBodySprite reciben el giro de la acción y corrigen el montaje de mandíbula/cuello. RunnerSprite conserva las vistas posteriores con casco y la identidad guardada.

Ocho poses nuevas en assets/sprites/v1060/fielding-detail.png, creadas con imagegen integrado. Prompt: ../research/image1060-prompt.json. El PNG conserva exactamente los bytes generados. MatchPoseStore añade las ocho poses a las dieciséis de fildeo; el tinte y la escala nativa respetan la altura del cuerpo existente. Se miden guante, mano y cuello. Pitcher usa las poses en preparación, recogida, transferencia, tiro, seguimiento y captura alta. El origen del lanzamiento de bateo y sus tiempos se conservan.

Pruebas: análisis de cobertura de 1512 retratos, trece casos visuales en Chrome, escenas controladas, partido completo de nueve entradas, WebMain local y público con registro/compras/sustitución/guardado/partido. p95 local 35 ms; no prueba 60 fps constantes. Paquete verificado, respaldo y comparación de perfiles/partidas previos. Cuenta QA retirada. Sin reinicio; save24, SQLite4, reset38.

Pendientes: perfiles individuales ilustrados, expresiones más amplias y revisión exhaustiva de contornos del catálogo.

Build 4f33fa11c8f267e4; SWF fc3bcfdc2cc997b9c10aa68cb5c80b1a3a240d304676aab96298e92836718db4.
