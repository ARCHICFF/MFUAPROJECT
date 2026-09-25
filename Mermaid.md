## Mermaid

Mermaid - это сильно упрощённый и далёкий аналог UML - специальный язык описания блок-схем, графиков и диограм с их визуализацией.

Блок схемы

```mermaid
flowchart LR
    A[Вопрос: Как сделать список?] --> B["Ответ: `-` или `*`"]
    A --> C["Пример: \n - Пункт 1 \n"]
```
* flowchart - блок-схема
* LR - направление вправа
* A[], B[], C[] - прямоугольник
* --> - стрелка связи
#### Базовая структура 2
```mermaid
flowchart TD
    A[Начало] --> B[Процесс]
    B --> C[Результат]
```
#### Полный синтаксис блок-схем
```mermaid
flowchart TD
    A([Начало]) --> B[Процесс]
    B --> C{Условие?}

    C -->|Да| D[Действие 1]
    C -->|Нет| E[Действие 2]

    D --> F[(База данных)]
    E --> F

    F --> G[/Вывод/]
    G --> H([Конец])

    %% Комментарий
```
### Диаграмма последовательности
```mermaid
sequenceDiagram
    actor User as Пользователь
    participant Client as Клиент
    participant Server as Сервер
    participant DB as База данных

    User->>Client: Нажимает кнопку
    Client->>Server: GET /users
    Server->>DB: Запрос данных
    DB-->>Server: Данные
    Server-->>Client: JSON
    Client-->>User: Показывает результат
```
### Диаграмма класса

```mermaid
classDiagram
    class User {
        +String name
        +String email
        +login()
        +logout()
    }

    class Order {
        +int id
        +Date createdAt
        +create()
        +cancel()
    }

    class Product {
        +String title
        +float price
    }

    User "1" --> "*" Order : создаёт
    Order "*" --> "*" Product : содержит
```

### Диаграмма Ганта

```mermaid
gantt
    title Разработка проекта
    dateFormat YYYY-MM-DD
    axisFormat %d.%m

    section Анализ
    Сбор требований     :a1, 2026-09-01, 5d
    Проектирование      :a2, after a1, 7d

    section Разработка
    Backend             :b1, after a2, 14d
    Frontend            :b2, after a2, 14d

    section Тестирование
    Тестирование        :c1, after b1, 7d
    Исправление ошибок  :c2, after c1, 5d
```

### Граф зависимостей
```mermaid
graph TD
    A[Проект] --> B[Frontend]
    A --> C[Backend]

    B --> D[React]
    B --> E[CSS]

    C --> F[Node.js]
    C --> G[PostgreSQL]

    F --> H[API]
    G --> H
```
### Диаграмма состояний

```mermaid
stateDiagram-v2
    [*] --> Новый

    Новый --> Обработка: начать
    Обработка --> Успешно: завершить
    Обработка --> Ошибка: ошибка

    Ошибка --> Обработка: повторить
    Успешно --> [*]
```
### Юзер-джайрни

```mermaid
journey
    title Путь пользователя при покупке товара

    section Поиск
      Открывает сайт: 5: Пользователь
      Ищет товар: 4: Пользователь
      Просматривает каталог: 4: Пользователь

    section Покупка
      Открывает товар: 5: Пользователь
      Добавляет в корзину: 5: Пользователь
      Оформляет заказ: 4: Пользователь

    section Оплата
      Вводит данные карты: 3: Пользователь
      Оплачивает заказ: 5: Пользователь
      Получает подтверждение: 5: Пользователь
```
### Кастомизация стилей

```mermaid
flowchart TD
    A[Начало] --> B[Процесс]
    B --> C{Условие}
    C -->|Да| D[Успех]
    C -->|Нет| E[Ошибка]

    classDef start fill:#d4edda,stroke:#28a745,stroke-width:2px
    classDef process fill:#d1ecf1,stroke:#17a2b8,stroke-width:2px
    classDef decision fill:#fff3cd,stroke:#ffc107,stroke-width:2px
    classDef success fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545

    class A start
    class B process
    class C decision
    class D success
    class E error
```
#### Классы CSS

```mermaid
flowchart LR
    A[Frontend] --> B[Backend]
    B --> C[Database]

    classDef frontend fill:#e3f2fd,stroke:#1565c0,stroke-width:2px
    classDef backend fill:#f3e5f5,stroke:#6a1b9a,stroke-width:2px
    classDef database fill:#e8f5e9,stroke:#2e7d32,stroke-width:2px

    class A frontend
    class B backend
    class C database
```
#### Интерактивность

```mermaid
flowchart TD
    A[Главная] --> B[Документация]
    B --> C[GitHub]

    click A "https://example.com"
    click B "https://example.com/docs"
    click C "https://github.com"
```

### Круговая диграмма
Круговая диограмма
```mermaid
pie
    title ОС на десктопе
    "Windows" : 70
    "MacOS"   : 20
    "Linux"   : 7
    "Other"   : 3
```