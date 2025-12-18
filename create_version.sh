#!/bin/bash

# Скрипт для создания новой версии пакета AriseMobileSdk-v2
# Использование: ./create_version.sh 2.0.1

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}💡 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Проверка аргументов
if [ $# -eq 0 ]; then
    print_error "Не указана версия!"
    echo "Использование: $0 <version>"
    echo "Пример: $0 2.0.1"
    exit 1
fi

VERSION=$1
TAG="v${VERSION}"

# Валидация формата версии (MAJOR.MINOR.PATCH)
if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    print_error "Неверный формат версии: $VERSION"
    echo "Используйте формат: MAJOR.MINOR.PATCH (например, 2.0.1)"
    exit 1
fi

print_status "Создание версии $VERSION..."

# Определяем пути
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_ROOT="$(dirname "$SCRIPT_DIR")"
PROJECT_ROOT="$(dirname "$PACKAGE_ROOT")"
PACKAGE_DIR="$PACKAGE_ROOT/AriseMobileSdk-v2"

print_status "Package directory: $PACKAGE_DIR"

# Проверка существования тега
if git rev-parse "$TAG" >/dev/null 2>&1; then
    print_warning "Тег $TAG уже существует!"
    read -p "Продолжить? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Отменено"
        exit 1
    fi
fi

# Шаг 1: Обновление версии в Info.plist
print_status "Шаг 1: Обновление версии в AriseMobileSdk-Info.plist..."
INFO_PLIST="$PROJECT_ROOT/src/AriseMobileSdk/AriseMobileSdk-Info.plist"
if [ -f "$INFO_PLIST" ]; then
    # Обновляем CFBundleShortVersionString
    /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $VERSION" "$INFO_PLIST" 2>/dev/null || \
    /usr/libexec/PlistBuddy -c "Add :CFBundleShortVersionString string $VERSION" "$INFO_PLIST"
    print_success "Версия обновлена в Info.plist"
else
    print_warning "Info.plist не найден: $INFO_PLIST"
fi

# Шаг 2: Сборка XCFramework
print_status "Шаг 2: Сборка XCFramework..."
BUILD_SCRIPT="$PROJECT_ROOT/libs/build_framework.sh"
if [ -f "$BUILD_SCRIPT" ]; then
    cd "$PROJECT_ROOT/libs"
    bash build_framework.sh
    print_success "XCFramework собран"
else
    print_warning "Скрипт сборки не найден: $BUILD_SCRIPT"
    print_warning "Пропускаем сборку. Убедитесь, что XCFramework собран вручную."
fi

# Шаг 3: Копирование бинарников
print_status "Шаг 3: Копирование бинарников в пакет..."
FRAMEWORK_SOURCE="$PROJECT_ROOT/libs/AriseMobileSdk.xcframework"
FRAMEWORK_DEST="$PACKAGE_DIR/libs/AriseMobileSdk.xcframework"

if [ -d "$FRAMEWORK_SOURCE" ]; then
    rm -rf "$FRAMEWORK_DEST"
    cp -R "$FRAMEWORK_SOURCE" "$FRAMEWORK_DEST"
    print_success "Бинарники скопированы"
else
    print_error "XCFramework не найден: $FRAMEWORK_SOURCE"
    exit 1
fi

# Шаг 4: Проверка Package.swift
print_status "Шаг 4: Проверка Package.swift..."
if [ ! -f "$PACKAGE_DIR/Package.swift" ]; then
    print_error "Package.swift не найден!"
    exit 1
fi
print_success "Package.swift найден"

# Шаг 5: Создание Git тега (опционально)
print_status "Шаг 5: Создание Git тега..."
read -p "Создать Git тег $TAG? (Y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
    cd "$PROJECT_ROOT"
    
    # Проверка наличия изменений
    if [[ -n $(git status --porcelain) ]]; then
        print_warning "Обнаружены незакоммиченные изменения"
        read -p "Закоммитить изменения перед созданием тега? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git add -A
            git commit -m "Release version $VERSION"
        fi
    fi
    
    git tag -a "$TAG" -m "Release version $VERSION"
    print_success "Git тег $TAG создан"
    
    read -p "Отправить тег в удаленный репозиторий? (Y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        git push origin "$TAG"
        print_success "Тег отправлен в удаленный репозиторий"
    fi
else
    print_warning "Создание тега пропущено"
fi

print_success "Версия $VERSION успешно создана!"
print_status "Следующие шаги:"
echo "  1. Убедитесь, что все изменения закоммичены"
echo "  2. Создайте Release в GitHub (опционально)"
echo "  3. Пользователи смогут использовать версию через:"
echo "     .package(url: \"...\", from: \"$VERSION\")"










