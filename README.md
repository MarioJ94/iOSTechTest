# TechTest

<div align="center">

![Warning](https://img.shields.io/badge/⚠️_ADVERTENCIA-Desarrollado_en_VM_macOS-red?style=for-the-badge)

**Esta prueba técnica se realizó desde una máquina virtual de macOS en Linux.  
No se garantiza el correcto funcionamiento de los tests debido a la excesiva lentitud del sistema**

**Entorno de desarrollo:**
<br>
Xcode 26.6<br>
Swift 6 (6.3.3)<br>
Simulador iPhone Air 26.5

</div>

## Descripción

Aplicación iOS que muestra personajes de *Rick y Morty* con búsqueda paginada y detalle de personaje.

Implementado con SwiftUI, arquitectura CLEAN, inyección de dependencias mediante protocolos, caché local en memoria y cancelación de tareas para optimizar el uso de red.

## Arquitectura

Separación de responsabilidades:

- **Presentation** (SwiftUI + MVVM): Vistas, ViewModels, NavigationCoordinator y Factories.
- **Domain**: Modelos, Use Cases y protocolos de Repositorios.
- **Data**: Repositorios, Data Sources (remoto/local), Mappers y API client.

Uso de **protocolos** en todas las capas para inyección de dependencias y testabilidad (implementando mocks en tests).

## API Pública (Rick and Morty)

Documentación: https://rickandmortyapi.com/documentation  
Base URL: `https://rickandmortyapi.com/api`

- **Búsqueda de personajes**: `GET {baseUrl}/character?name={name}&page={page}`  
  Filtra por nombre y pagina resultados.
- **Detalle de personaje**: `GET {baseUrl}/character/{id}`  
  Obtiene información completa de un personaje por su ID.

## Ejecución

Abrir `TechTest.xcodeproj` en Xcode y ejecutar.

## Decisiones de implementación

### Caché con expiración y límite

Implementada con genéricos (`Cache<Key, Model>`) como un actor para asegurar accesos/modificaciones de forma ordenada:
- Clave (`Hashable & Sendable`) y modelo (`Sendable`).
- Expiración por tiempo (`maxAge`: 120s por defecto).
- Limpieza automática al alcanzar `maxEntries` (100): elimina entradas expiradas; si no hay, elimina la más antigua.
- Usada en `SearchLocalDataSource` y `CharacterDetailLocalDataSource`.

### Cancelación de tareas

Al usar Swift concurrency con Task y async/await, se permite la cancelación de tareas de forma sencilla.

Evita escrituras innecesarias si la tarea fue cancelada (ej. usuario cambia de búsqueda o navega fuera), liberando recursos y evitando estados inconsistentes.

Se comprueba el estado cancelado tanto en SearchScreenViewModel como en los repositorios.

Simplemente usando lo siguiente es suficiente:
```swift
// Cancela una tarea gestionada
let search = Task ...
search.cancel()
// Dentro de la tarea, en los puntos de interés
try Task.checkCancellation()
```

### Separación de responsabilidades e inyección de dependencias

- Cada capa expone **protocolos** (`*Protocol`).
- Las **Factories** componen la estructura de dependencias (API → RemoteDataSource → LocalDataSource → Mapper → Repository → UseCase). Deben implementar sus respectivos protocolos.
- Los ViewModels reciben Use Cases por protocolo; NavigationCoordinator por protocolo.
- Permite sustituir implementaciones en tests (mocks) sin tocar código de producción.

### Tests

- Se han implementado tests de SearchScreenViewModel para demostrar gestión de la información tras eventos en la pantalla. 
- Se han implementado tests de Cache para demostrar comportamiento de almacenamiento y purgado de datos expirados.