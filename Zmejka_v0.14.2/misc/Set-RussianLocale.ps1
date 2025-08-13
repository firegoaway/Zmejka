#Requires -RunAsAdministrator
# ---------------------------------------------------------------
#  Установка русской локали с подтверждением от пользователя
# ---------------------------------------------------------------

Write-Host "🔍 Проверка наличия русского языкового пакета (ru-RU)..." -ForegroundColor Cyan

$languagePackPath = "HKLM:\SYSTEM\CurrentControlSet\Control\MUI\UILanguages"

# Проверяем подразделы (subkeys), например: ru-RU, en-US
try {
    $subKeys = Get-ChildItem -Path $languagePackPath -ErrorAction Stop
    $langTags = $subKeys.PSChildName

    if ($langTags -contains "ru-RU") {
        Write-Host "✅ Русский (ru-RU) найден в установленных языках." -ForegroundColor Green
    } else {
        Write-Host "❌ Русский (ru-RU) НЕ найден в установленных языках." -ForegroundColor Red
        Write-Host "👉 Установите языковой пакет:" -ForegroundColor Yellow
        Write-Host "   Параметры → Язык → Добавить язык → Русский" -ForegroundColor Yellow
        Write-Host "   Или выполните в командной строке (от администратора):" -ForegroundColor Yellow
        Write-Host "   DISM /Online /Add-Capability /CapabilityName:Language.Basic~~~ru-RU~~~0.0.1.0" -ForegroundColor Gray
        Write-Host ""
        pause
        exit 1
    }
}
catch {
    Write-Host "⚠️ Ошибка доступа к реестру: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "   Убедитесь, что запустили PowerShell от имени администратора." -ForegroundColor Red
    pause
    exit 1
}

# Проверка, поддерживается ли ru-RU как локаль
try {
    $culture = [System.Globalization.CultureInfo]::GetCultures("AllCultures") | Where-Object { $_.Name -eq "ru-RU" }
    if ($culture) {
        Write-Host "✅ Локаль ru-RU доступна в системе." -ForegroundColor Green
    } else {
        Write-Host "❌ Локаль ru-RU не найдена в системе." -ForegroundColor Red
        Write-Host "   Возможно, языковой пакет установлен не полностью." -ForegroundColor Red
        pause
        exit 1
    }
}
catch {
    Write-Host "⚠️ Ошибка при проверке локали: $($_.Exception.Message)" -ForegroundColor Red
}

# 🔐 Подтверждение от пользователя
Write-Host ""
Write-Host "⚠️ ВНИМАНИЕ:" -ForegroundColor Yellow
Write-Host "  Будут изменены системные параметры локали:" -ForegroundColor Yellow
Write-Host "  • Системная локаль (влияет на старые программы и кодировку ANSI)" -ForegroundColor Yellow
Write-Host "  • Языки пользователя" -ForegroundColor Yellow
Write-Host "  • Региональные параметры (даты, числа)" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Потребуется перезагрузка компьютера." -ForegroundColor Yellow
Write-Host ""
Write-Host "  Внимание! Изменение глобального системого языка поможет решить проблему с неправильным чтением кириллических путей." -ForegroundColor Gray
Write-Host "  FDS заработает, однако это может повлиять на другие программы, работа которых зависит от глобальной системной языковой структуры." -ForegroundColor Gray
Write-Host ""

$answer = Read-Host "  Выполнить изменения? [Y/N] (по умолчанию N)"

if ($answer -notmatch "^[Yy]([Ee][Ss])?$") {
    Write-Host ""
    Write-Host "🛑 Операция отменена пользователем." -ForegroundColor Yellow
    Write-Host "   Никакие изменения не были внесены." -ForegroundColor Gray
    exit 0
}

Write-Host ""
Write-Host "✅ Подтверждено. Продолжаем..." -ForegroundColor Green

# Установка системной локали
try {
    $cmd = Get-Command Set-WinSystemLocale -ErrorAction SilentlyContinue
    if ($cmd) {
        Write-Host "`n🔧 Устанавливаем системную локаль: ru-RU..." -ForegroundColor Cyan
        Set-WinSystemLocale -SystemLocale ru-RU
        Write-Host "✅ Системная локаль установлена." -ForegroundColor Green
    } else {
        Write-Host "`n🟡 Командлет Set-WinSystemLocale недоступен (возможно, Windows Home)." -ForegroundColor Yellow
        Write-Host "   Настройте вручную: Панель управления → Язык → Административные → Изменить системную локаль" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "❌ Ошибка при установке системной локали: $($_.Exception.Message)" -ForegroundColor Red
}

# Установка языков пользователя
try {
    $list = New-WinUserLanguageList -LanguageList ru-RU, en-US
    Set-WinUserLanguageList -LanguageList $list -Force
    Write-Host "✅ Языки пользователя обновлены: ru-RU, en-US" -ForegroundColor Green
}
catch {
    Write-Host "⚠️ Не удалось обновить языки пользователя: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Установка региональных параметров
try {
    Set-Culture ru-RU
    Write-Host "✅ Региональные параметры установлены: ru-RU" -ForegroundColor Green
}
catch {
    Write-Host "⚠️ Set-Culture недоступен. Настройте вручную." -ForegroundColor Yellow
}

# Финал
Write-Host "`n🔄 Не забудьте перезагрузить компьютер, чтобы изменения вступили в силу." -ForegroundColor Green
Write-Host "📌 Рекомендация: для FDS используйте пути без кириллицы (например: C:\fds\input.fds)" -ForegroundColor Red
Write-Host ""
pause