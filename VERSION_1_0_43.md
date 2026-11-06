# Baseball Heroes 1.0.43

Publicado y comprobado en Railway. Bateador reconstruido con las diez poses de la lámina RGBA proporcionada por el usuario. Ambos PNG originales se conservan sin regrabarlos. Se usa el casco nativo ilustrado y se monta la misma cara guardada del héroe, con los colores del personaje/equipo y su equipamiento. La cara permanece visible durante el seguimiento del swing. Los dieciséis estilos de rostro se comprobaron en una matriz visual.

ReferenceBatterArtwork separa materiales y regiones al cargar cada pose; usa cachés acotadas para las variaciones de paleta. No genera archivos raster derivados ni dibuja un cuerpo de reemplazo con formas geométricas. Los contornos y sombreados salen de la lámina. Fuente y metadatos en assets/sprites/v1043. La lámina de gorra se guarda como referencia; la de casco se integra en el SWF.

La carga de la pichada mantiene la pierna levantada hasta el input. Se miden de nuevo cuello, pie y barrel; se evita el número flotante de la espalda sobre el nuevo uniforme. La estela anterior se vacía durante la pausa de contacto. Reloj, ventanas Rookie, probabilidades, velocidad, audio y progreso permanecen como en 1.0.42. El renderer anterior queda para perfiles de arte legado; los personajes actuales del creador usan el cuerpo nuevo.

Cuatro suites locales y recorrido público con SWF final: poses, contacto, pausa Derby, matriz de dieciséis rostros, reutilización de caché, Rookie, LINEUP, compras y guardado. Partido completo con nueve entradas y estadísticas conciliadas. Paquete de 242 archivos auditado; diagnósticos privados excluidos. Sin reinicio. Copia SQLite consistente y comparación de perfiles/guardados dentro del servidor; cuenta QA retirada. Se conserva la biblioteca activa anterior 1.0.42 para rollback; la primera candidata inactiva de 1.0.42 se archiva localmente con hashes verificados.

Build 2247ac23bbf3cd34; SWF f534299a86400b75a95b953e6fe828a727e30bc86f015ebd76930074c5d506e7.
