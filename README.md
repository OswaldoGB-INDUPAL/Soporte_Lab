# SoporteLab

Aplicación iOS para registrar solicitudes de soporte, asignar técnicos y consultar el avance de los tickets. Tema 22 — Clean Architecture / VIPER adaptado (ETPS4, UTEC).

Autor: **Oswaldo Guevara — 2946452022**.

## Arquitectura

```
Presentation  →  Domain  ←  Data
View → Presenter → Interactor → Repository (protocolo)
             Presenter → Router → Builder
```

Domain define las entidades y contratos. Data implementa los contratos con SwiftData o en memoria. Presentation agrupa cada pantalla en un módulo con responsabilidades definidas.

| Pieza | Responsabilidad |
| --- | --- |
| View | Presenta datos y delega los eventos. |
| Presenter | Mantiene el estado de la pantalla y coordina acciones. |
| Interactor | Aplica reglas de negocio usando contratos de repositorio. |
| Entity | Representa los datos del dominio. |
| Router | Construye el destino de navegación. |
| Builder | Conecta las dependencias del módulo. |

## Reglas principales

1. Un ticket necesita técnico para comenzar la atención.
2. No se puede quitar el técnico mientras el ticket está en proceso.
3. Al resolver se registra la fecha y al reabrir se elimina.
4. Los cambios de estado y asignación generan seguimiento.
5. No se elimina un técnico con tickets en proceso.
6. El título debe tener de 3 a 80 caracteres, ubicación obligatoria y descripción de hasta 500 caracteres.
7. Nombre, especialidad y correo válido son obligatorios para técnicos.
8. La lista ordena por prioridad y fecha descendentes.
9. Un ticket nuevo se crea abierto con seguimiento inicial.
10. Asignar un técnico durante la creación conserva el estado abierto.

## Requisitos

macOS, Xcode 15 o superior y simulador de iPhone con iOS 17 o superior.

### Opción A — XcodeGen

1. Instalar XcodeGen con `brew install xcodegen`.
2. Ejecutar `xcodegen generate` en esta carpeta.
3. Abrir `SoporteLab.xcodeproj`, seleccionar un simulador de iPhone y pulsar **Cmd+R**.
4. Ejecutar las pruebas con **Cmd+U**.

### Opción B — proyecto manual

En Xcode crear un proyecto iOS App llamado SoporteLab, con interfaz SwiftUI, almacenamiento None e Include Tests. Eliminar los archivos ContentView.swift y SoporteLabApp.swift creados por la plantilla. Añadir las carpetas App, Domain, Data, Presentation y Resources al target de la app mediante Create groups. Añadir el contenido de SoporteLabTests al target de pruebas y establecer iOS 17.0 como destino mínimo.

## Almacenamiento en memoria

Cambiar `AppContainer.storage` a `.inMemory` y ejecutar de nuevo, o añadir `-inMemory` en los argumentos de lanzamiento del esquema. El modo en memoria se reinicia al cerrar la app.

## Capturas previstas

`docs/screenshots/01-lista.png` · `02-detalle.png` · `03-formulario.png` · `04-tecnicos.png` · `05-tecnico.png` · `06-resumen.png`.

## Guion de demostración

Explicar las capas y el flujo View → Presenter → Interactor → Repository. Crear un ticket, intentar iniciar atención sin técnico, asignar uno y resolverlo. Mostrar el seguimiento, el resumen y el cambio a almacenamiento en memoria. Explicar qué prueba comprueba cada regla y ejecutar Cmd+U.

El archivo `.gitignore` conserva comentada la exclusión de proyectos Xcode. Puede activarse si se usa XcodeGen como fuente única del proyecto.

## Resultado de verificación

El 15 de noviembre de 2026, Xcode 26.2 compiló el proyecto y ejecutó 19 pruebas sin fallos en el simulador de iOS 26.2. La captura docs/screenshots/01-lista.png corresponde a la lista ejecutada en ese simulador.

El primer arranque del almacén registró un error de creación de directorio, seguido de una recuperación exitosa por Core Data. La ejecución incluyó pruebas de persistencia entre contenedores y reglas de eliminación en SwiftData. El recorrido de interfaz también pasó y produjo seis capturas de las pantallas principales.
