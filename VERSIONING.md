# Руководство по версионированию AriseMobileSdk v2

## Создание новой версии

### 1. Обновите версию в Xcode проекте
Обновите `CFBundleShortVersionString` в `src/AriseMobileSdk/AriseMobileSdk-Info.plist`

### 2. Соберите новый XCFramework
```bash
cd ../../libs
./build_framework.sh
```

### 3. Скопируйте бинарники в пакет
```bash
cd ../Distribution/AriseMobileSdk-v2
cp -R ../../libs/AriseMobileSdk.xcframework libs/
```

### 4. Создайте Git тег
```bash
# Patch версия (2.0.0 -> 2.0.1)
git tag v2.0.1
git push origin v2.0.1

# Minor версия (2.0.1 -> 2.1.0)
git tag v2.1.0
git push origin v2.1.0

# Major версия (2.x.x -> 3.0.0)
git tag v3.0.0
git push origin v3.0.0
```

### 5. Создайте Release в GitHub (опционально)
1. Перейдите в GitHub репозиторий
2. Releases → Draft a new release
3. Выберите созданный тег
4. Заполните описание изменений
5. Опубликуйте release

## Семантическое версионирование

Формат: `MAJOR.MINOR.PATCH` (например, 2.0.1)

- **MAJOR** (2.0.0): Несовместимые изменения API
- **MINOR** (2.1.0): Новая функциональность, обратно совместимая
- **PATCH** (2.0.1): Исправления ошибок, обратно совместимые

## Использование версий в SPM

### Последняя версия из диапазона
```swift
.package(url: "https://github.com/your-org/arise-merchant-app.git", from: "2.0.0")
```

### Конкретная версия
```swift
.package(url: "https://github.com/your-org/arise-merchant-app.git", exact: "2.0.1")
```

### Диапазон версий
```swift
.package(url: "https://github.com/your-org/arise-merchant-app.git", "2.0.0"..<"3.0.0")
```

### Конкретный тег
```swift
.package(url: "https://github.com/your-org/arise-merchant-app.git", .upToNextMinor(from: "2.0.0"))
```

## Проверка версий

Проверить доступные теги:
```bash
git tag -l "v2.*"
```

Просмотреть информацию о теге:
```bash
git show v2.0.0
```










