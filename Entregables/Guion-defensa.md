# Guion de defensa individual — SoporteLab

Oswaldo Guevara · 2946452022. Tema Clean Architecture / VIPER adaptado. Duración objetivo 15 minutos.

Este guion sirve de apoyo para una presentación propia. Antes de grabar, comprobar que la app y las pruebas funcionan y ajustar las afirmaciones a lo observado.

## 0:00–1:00 Presentación

Presentar el tema y el caso. SoporteLab propone organizar solicitudes de soporte técnico. El objetivo es explicar cómo se dividen las responsabilidades y mostrar el flujo de un ticket.

## 1:00–2:15 Problema y alcance

Describir una falla de proyector o red que debe registrarse, asignarse y seguirse hasta su resolución. Explicar que los datos de ejemplo son ficticios y que la versión se plantea para almacenamiento local en un dispositivo.

## 2:15–4:00 Clean Architecture

Presentar las capas. Domain contiene entidades y contratos. Data implementa la persistencia y convierte modelos a entidades. Presentation organiza la interacción. La regla de dependencia mantiene el dominio independiente de SwiftUI y SwiftData. Explicar que los protocolos permiten sustituir implementaciones.

## 4:00–5:30 VIPER adaptado

Mostrar los papeles de View, Presenter, Interactor, Entity y Router. Explicar que Builder conecta las dependencias. Seguir un evento concreto desde el botón de la vista, pasando por el Presenter y el Interactor, hasta el repositorio.

## 5:30–7:00 Pantallas y datos

Mostrar las pestañas Tickets, Técnicos y Resumen. Explicar los campos del ticket, la asignación opcional de un técnico y la relación con sus seguimientos.

## 7:00–10:30 Demostración funcional

1. Crear un ticket con título, ubicación y clasificación.
2. Abrir el detalle e intentar iniciar atención sin técnico.
3. Mostrar el mensaje de validación, asignar técnico e iniciar atención.
4. Agregar un seguimiento y marcar el ticket resuelto.
5. Mostrar la fecha de resolución y el seguimiento automático.
6. Consultar el resumen y comprobar que los conteos reflejan el cambio.

Si algún paso falla, describir lo observado en vez de presentar el resultado esperado como si hubiera ocurrido.

## 10:30–12:30 Persistencia y pruebas

Explicar que SwiftData usa un ModelContainer y que los repositorios convierten modelos a entidades. Mostrar AppContainer y el argumento de lanzamiento -inMemory. Explicar la diferencia entre el almacenamiento persistente y los datos que se reinician al cerrar la app en memoria.

Ejecutar Cmd+U si las pruebas ya se prepararon y señalar el resultado real. Mostrar los casos de iniciar sin técnico, resolver y borrar técnicos con tickets activos.

## 12:30–14:00 Arquitectura aplicada

Abrir TicketDetailInteractor y señalar la validación antes de cambiar a En proceso. Mostrar el protocolo TicketRepository y explicar cómo el Interactor depende del contrato. Mostrar TicketDetailRouter y TicketDetailBuilder para explicar la navegación y la conexión de dependencias.

## 14:00–15:00 Cierre

Explicar qué aporta la separación al mantenimiento y las pruebas, y mencionar el costo de tener más archivos. Indicar los límites de la versión, como ausencia de sincronización y autenticación. Cerrar con una pregunta para promover comentarios de compañeros.

## Fuentes para estudiar

- Robert C. Martin, The Clean Architecture Dependency Rule. https://www.informit.com/articles/article.aspx?p=2832399
- Jeff Gilbert y Conrad Stoll, Architecting iOS Apps with VIPER. https://www.objc.io/issues/13-architecture/viper/
- Apple Developer, ModelContainer. https://developer.apple.com/documentation/swiftdata/modelcontainer

## Publicación y defensa

Grabar la explicación individual con audio claro y la app visible. Revisar el video antes de subirlo a YouTube. Compartir el enlace según las instrucciones del docente y solicitar comentarios reales de compañeros. La publicación y la defensa requieren intervención del estudiante.
