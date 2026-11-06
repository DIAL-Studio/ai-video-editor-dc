# Editor de video IA · DC

Base de herramientas para editar videos locales con Codex. Los videos originales, marcas, audios, proyectos de clientes, claves y exportaciones se guardan por separado y no forman parte de este repositorio.

## Empezar

Abre esta carpeta en Codex y pídele que revise `AGENTS.md`, compruebe el sistema operativo y prepare el entorno. Los scripts existentes fueron diseñados para macOS con Bash; la compatibilidad con Windows todavía no está verificada. Requisitos: Node.js 22+, Git, Python 3.13, FFmpeg y FFprobe. Ejecuta `npm run setup` y `npm run doctor` después de instalar los requisitos. Las dependencias y modelos requieren internet y espacio en disco.

La skill reutilizable se encuentra en https://github.com/DIAL-Studio/editar-reels . Sigue su README para instalarla en `.agents/skills/editar-reels`.

## Proyectos existentes

Un video MP4 final no contiene una línea de tiempo editable. Para continuar San Blas se necesitan los originales, música, recursos, instrucciones, guiones, archivos intermedios y scripts específicos de su edición, entregados por separado. Los archivos de producción procedentes de otro equipo pueden contener rutas absolutas, fuentes o pasos específicos de macOS y deben validarse y adaptarse antes de usarlos. Este repositorio por sí solo no reproduce San Blas.

No subas `.env`, claves, material de clientes ni archivos personales a un repositorio público. `.gitignore` incluye las carpetas de medios y trabajo.

## Licencias

Cada herramienta y recurso externo conserva su propia licencia. Verifica la licencia de música y material antes de publicar un video.
