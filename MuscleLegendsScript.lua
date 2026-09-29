--[[
    ================================================================================
    FOUF32 BUILD 0.21 — MUSCLE LEGENDS MASTER HUB
    ================================================================================
    Название клиента: Fouf32 build 0.21
    Открытие / Скрытие меню: Right Shift (r.shift) или кнопка FOUF32 на экране
    
    Особенности v0.21:
      - Стартовое приветственное окно: "Привет! Какой язык ты предпочитаешь?"
      - Двуязычный интерфейс (Русский / English) с модальным переключением
      - 10 Удобных разделов с индикаторами состояния [ВКЛ / ВЫКЛ]
      - Онлайн-авторизация (GitHub Whitelist integration)
      - Исправлен фарм камней (поворот лицом + CFrame.lookAt)
      - Исправлен вылуп яиц/кристаллов (авто-телепорт вплотную + мульти-Remote)
    ================================================================================
--]]

print("==================================================")
print("[FOUF32 BUILD 0.21]: SCRIPT EXECUTION STARTED!")
print("==================================================")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ============================================================
-- СИСТЕМА АВТОРИЗАЦИИ / WHITELIST (GITHUB AUTH)
-- ============================================================
local WHITELIST_URL = "https://raw.githubusercontent.com/ugvejkun-cloud/Folf32/main/whitelist.json"
local ENABLE_WHITELIST = true

local function checkPlayerWhitelist()
    if not ENABLE_WHITELIST then return true end

    local playerName = string.lower(LocalPlayer.Name)
    print("[Fouf32 STAGE A]: авторизация игрока '" .. LocalPlayer.Name .. "'")

    -- До 3 попыток: raw.githubusercontent иногда отдает 429/таймаут
    for attempt = 1, 3 do
        local success, response = pcall(function()
            return game:HttpGet(WHITELIST_URL, true)
        end)
        if success and response and #response > 0 then
            local ok, data = pcall(function() return HttpService:JSONDecode(response) end)
            if ok and type(data) == "table" then
                for _, name in ipairs(data) do
                    local n = string.lower(tostring(name))
                    if n == playerName or n == "all" then
                        print("[Fouf32 STAGE B]: whitelist OK (попытка " .. attempt .. ")")
                        return true
                    end
                end
                print("[Fouf32 STAGE B]: ник '" .. LocalPlayer.Name .. "' НЕ найден в whitelist.json")
                return false -- список загружен, игрока в нем нет
            end
            warn("[Fouf32 Auth]: JSON некорректен (попытка " .. attempt .. ")")
        else
            warn("[Fouf32 Auth]: HttpGet whitelist не удался (попытка " .. attempt .. "): " .. tostring(response))
        end
        task.wait(0.5)
    end

    -- Резерв для владельца, если GitHub совсем недоступен
    if LocalPlayer.Name == "Tvinkilp" or LocalPlayer.Name == "User" then
        print("[Fouf32 STAGE B]: резервный доступ владельца")
        return true
    end
    warn("[Fouf32 Auth]: не удалось загрузить whitelist.json (попыток: 3)")
    return false
end

if not checkPlayerWhitelist() then
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Fouf32 Auth Error",
            Text = "У вас нет доступа к скрипту Fouf32 build 0.21! Ник: " .. LocalPlayer.Name,
            Duration = 10
        })
    end)
    warn("[Fouf32 Auth]: Доступ запрещен для игрока " .. LocalPlayer.Name)
    return
end

print("[Fouf32 STAGE C]: whitelist пройден, создаю интерфейс...")

-- Защита от повторного запуска Fouf32
local FRAMEWORK_NAME = "Fouf32_MuscleLegends_Master"
pcall(function()
    if typeof(gethui) == "function" and gethui():FindFirstChild(FRAMEWORK_NAME) then
        gethui()[FRAMEWORK_NAME]:Destroy()
    end
end)
pcall(function()
    if CoreGui:FindFirstChild(FRAMEWORK_NAME) then
        CoreGui[FRAMEWORK_NAME]:Destroy()
    end
end)
pcall(function()
    if LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild(FRAMEWORK_NAME) then
        LocalPlayer.PlayerGui[FRAMEWORK_NAME]:Destroy()
    end
end)

-- Хранилище подключений для полной выгрузки (Unload)
local ScriptConnections = {}
-- Forward-декларация: определяется позже в секции ESP, но нужна в completeScriptUnload
local clearESP

-- ============================================================
-- ГЛОБАЛЬНЫЙ КОНФИГ FOUF32 BUILD 0.21
-- ============================================================
local Config = {
    -- Язык по умолчанию
    Language          = "RU", -- "RU" или "EN"

    -- Glass UI Настройки
    Glow              = true,
    BgOpacity         = 25,
    GlassIntensity    = 75,
    EnableTooltips    = true,

    -- Тренировки
    AutoOpFarm        = false,
    AutoDumbbell      = false,
    AutoPushups       = false,
    AutoSitups        = false,
    AutoWeight        = false,
    AutoPunch         = false,
    AutoMultiTool     = false,
    WalkWhileTraining = false,
    FastRepMultiplier = 5,
    UltraFastRep      = false,
    TrainDelay        = 0,

    -- Тренажеры игры (Machine Farm)
    AutoBenchPress       = false,
    AutoSquat            = false,
    AutoTreadmillMachine = false,
    AutoPullups          = false,
    AutoBoulder          = false,
    AutoRockMachine      = false,

    -- Камни и Тренажеры
    AutoRock          = false,
    SelectedRockTier  = "Any",
    RockOffset        = 3,
    AutoTreadmill     = false,

    -- Бой & Kill Aura
    KillAura          = false,
    KillAuraMode      = "Bring To Me", -- "Bring To Me", "Magnet TP to Target", "Orbit Target"
    KillAuraRange     = 45,
    KillAuraDelay     = 0.03,
    PunchMultiplier   = 2,
    AutoKillBoss      = false,
    BossHitMultiplier = 5,
    AutoKillServer    = false,
    AutoBrawl         = false,
    SelectedTargetPlayer = nil,
    TargetLoopKill    = false,

    -- Защита
    AntiHit           = false,
    AntiRagdoll       = false,
    AntiKnockback     = false,
    AutoSafeTPLowHP   = false,
    AntiAFK           = true,

    -- Фарминг & Автоматизация
    AutoRebirth       = false,
    StayAfterRebirth  = true,   -- после ребирта возвращаться на исходную точку (не спавн)
    AutoChest         = false,
    AutoCrystal       = false,
    SelectedCrystal   = "Blue Crystal",
    HatchCount        = 50,     -- сколько яиц открывать за один Mass Hatch (1..500)
    HatchDelay        = 0.12,   -- задержка между открытиями яиц (сек)
    HatchPower        = false,  -- флаг живости массового вылупления (гасится при Unload)
    AutoCollectOrbs   = false,

    -- Тема окна (сначала — сплошной чёрный)
    ThemeIndex        = 1,

    -- Питомцы
    AutoEvolvePets    = false,
    AutoEquipBest     = false,

    -- Полет & Движение
    FlyEnabled        = false,
    FlySpeed          = 80,
    SpeedHack         = false,
    SpeedValue        = 65,
    JumpPowerHack     = false,
    JumpPowerValue    = 100,
    InfJump           = false,
    Noclip            = false,
    Bhop              = false,
    GravityValue      = 196.2,

    -- Визуал & Спектейт
    PlayerESP         = false,
    FullBright        = false,
    ShowOnScreenHUD   = true,
    CustomFOV         = 70,
    SpectateTarget    = false,

    -- Размер Персонажа
    PlayerScale       = 1,
    
    -- Точки сохранения
    SavedWaypoint     = nil
}

-- Вспомогательная функция локализации (Локализация текста RU / EN)
local function t(ruText, enText)
    if Config.Language == "EN" then
        return enText or ruText
    end
    return ruText
end

-- ============================================================
-- ЖИВАЯ ЛОКАЛИЗАЦИЯ UI: словарь RU -> EN + ре-применение
-- ============================================================
local LangDict = {
    ["Переключает язык интерфейса между Русским и English"] = "Switches the interface language between Russian and English",
    ["Красный цвет интерфейса"] = "Interface red color",
    ["Зеленый цвет интерфейса"] = "Interface green color",
    ["Синий цвет интерфейса"] = "Interface blue color",
    ["Пульсирующая неоновая рамка меню"] = "Pulsing neon menu frame",
    ["Интенсивность размытия стекла"] = "Glass blur intensity",
    ["Отображение описания функций внизу экрана"] = "Show feature descriptions at the bottom of the screen",
    ["Удаляет текстуры карты для увеличения FPS"] = "Removes map textures to boost FPS",
    ["Полная выгрузка скрипта Fouf32 build 0.21 и очистка памяти"] = "Fully unload Fouf32 build 0.21 and free memory",
    ["Делает персонажа незаметным мини-карликом"] = "Makes your character a tiny unnoticed dwarf",
    ["Стандартный человеческий размер"] = "Standard human size",
    ["Большой накачанный персонаж"] = "Big muscular character",
    ["Огромный титан на всю карту"] = "Huge titan across the whole map",
    ["Колоссальный гигант"] = "Colossal giant",
    ["Точная настройка масштаба персонажа (1x - 30x)"] = "Fine-tune character scale (1x - 30x)",
    ["Auto OP (Универсальный сумасшедший кликер)"] = "Auto OP (Universal Crazy Clicker)",
    ["Сели за ЛЮБОЙ тренажер или взяли ЛЮБОЙ снаряд — мгновенно качает на предельной турбо-скорости!"] = "Sit on ANY machine or grab ANY equipment — instantly trains at max turbo speed!",
    ["Авто-фарм Силы через Гантели"] = "Auto farm Strength with Dumbbells",
    ["Авто-фарм Силы через Отжимания"] = "Auto farm Strength with Pushups",
    ["Авто-фарм Силы через Пресс"] = "Auto farm Strength with Situps",
    ["Авто-фарм Силы через Штангу"] = "Auto farm Strength with Barbell",
    ["Авто-удары по груше/воздуху для прокачки"] = "Auto punches on the bag/air for training",
    ["Автоматически чередует все снаряды для максимальной прокачки"] = "Automatically cycles all equipment for maximum training",
    ["Walk While Training (Ходить во время упражнения)"] = "Walk While Training (Move During Exercise)",
    ["Позволяет свободно ходить со штангой, гантелями или во время выполнения упражнений!"] = "Allows you to walk freely with a barbell, dumbbells or during exercises!",
    ["GYM MACHINES AUTO-FARM (БЛИЖАЙШИЙ ТРЕНАЖЕР)"] = "GYM MACHINES AUTO-FARM (NEAREST MACHINE)",
    ["Auto Bench Press (Жим лежа)"] = "Auto Bench Press",
    ["Садится на ближайший жим лежа 1 раз и качает грудь!"] = "Sits on the nearest bench press once and trains chest!",
    ["Auto Squat Rack (Приседания)"] = "Auto Squat Rack (Squats)",
    ["Садится на ближайшую стойку приседаний 1 раз и качает ноги!"] = "Sits on the nearest squat rack once and trains legs!",
    ["Auto Treadmill (Беговая дорожка)"] = "Auto Treadmill (Running Track)",
    ["Встает на ближайшую беговую дорожку 1 раз и качает ловкость!"] = "Steps on the nearest treadmill once and trains agility!",
    ["Auto Pull-ups (Подтягивания)"] = "Auto Pull-ups",
    ["Встает к ближайшему турнику 1 раз и подтягивается!"] = "Moves to the nearest pull-up bar once and does pull-ups!",
    ["Auto Boulder Throw (Бросок валуна)"] = "Auto Boulder Throw",
    ["Подходит к валуну 1 раз и качает броски!"] = "Approaches the boulder once and trains throwing!",
    ["Auto Rock Farm (Камень)"] = "Auto Rock Farm (Rock)",
    ["Телепортируется к ближайшему камню 1 раз и непрерывно бьет!"] = "Teleports to the nearest rock once and hits it continuously!",
    ["Ультра-скоростной режим: мгновенный спам ивентов качания без задержки!"] = "Ultra-fast mode: instant training event spam with no delay!",
    ["Ускоритель фарма: количество отправляемых пакетов качания за один раз (до 100x)"] = "Farm booster: number of training packets sent per tick (up to 100x)",
    ["Задержка между повторами (0 = мгновенно)"] = "Delay between reps (0 = instant)",
    ["Телепортируется к камню 1 раз и непрерывно бьет!"] = "Teleports to the rock once and hits it continuously!",
    ["Телепортируется на беговую дорожку 1 раз и качает ловкость!"] = "Teleports to the treadmill once and trains agility!",
    ["SELECT ROCK TIER (ТОЧНЫЕ ТРЕБОВАНИЯ)"] = "SELECT ROCK TIER (EXACT REQUIREMENTS)",
    ["Mode 1: Bring Target To Me (Телепортировать врага к себе)"] = "Mode 1: Bring Target To Me (Teleport Enemy To You)",
    ["Притягивает/телепортирует корпус врага прямо перед вашими кулаками и бьет!"] = "Pulls/teleports the enemy body right in front of your fists and hits!",
    ["Mode 2: Magnet TP To Target (Телепортироваться к врагу)"] = "Mode 2: Magnet TP To Target (Teleport To Enemy)",
    ["Мгновенно телепортирует вас за спину / в лицо врагу и наносит удары"] = "Instantly teleports you behind/in front of the enemy and strikes",
    ["Mode 3: Orbit Target (Орбита вокруг цели)"] = "Mode 3: Orbit Target (Circle Around Target)",
    ["Вращается по кругу вокруг цели и наносит серии ударов"] = "Orbits around the target and lands hit combos",
    ["Активирует Kill Aura: бьет, телепортирует врагов прямо к вам или телепортируется к ним!"] = "Activates Kill Aura: hits, teleports enemies to you or you to them!",
    ["Радиус в студах для обнаружения и телепортации врагов"] = "Radius in studs for detecting and teleporting enemies",
    ["Задержка ударов в миллисекундах"] = "Strike delay in milliseconds",
    ["Количество отправляемых пакетов ударов за итерацию"] = "Number of hit packets sent per iteration",
    ["Выбирает ближайшего к вам игрока в качестве цели"] = "Selects the nearest player to you as a target",
    ["Притягивает выбранного игрока прямо к вашим кулакам"] = "Pulls the selected player right to your fists",
    ["Непрерывно бьет и телепортирует выбранного игрока"] = "Continuously hits and teleports the selected player",
    ["Зацикленный авто-телепорт по всем игрокам сервера и их уничтожение"] = "Looped auto-teleport across all server players and their elimination",
    ["Авто-вход на Brawl турниры сервера и немедленная победа"] = "Auto-joins server Brawl tournaments and wins instantly",
    ["Авто-фарм Босса: позиция у босса + без урона по вам + быстрая атака!"] = "Auto boss farm: positioned at the boss + no damage to you + fast attacks!",
    ["Количество ударов по боссу за один цикл"] = "Number of hits on the boss per cycle",
    ["Отключает коллизии урона персонажа (защита от чужих ударов)"] = "Disables damage collisions for your character (protection from enemy hits)",
    ["Автоматически телепортирует в небесную зону безопасности при падении HP ниже 25%"] = "Automatically teleports to the sky safe zone when HP drops below 25%",
    ["Запрет падений и станов"] = "Prevents ragdoll and stuns",
    ["Отключает отбрасывание при ударах"] = "Disables knockback from hits",
    ["Спавнит небесную платформу и телепортирует вас туда"] = "Spawns a sky platform and teleports you there",
    ["Сохраняет вашу текущую позицию в память"] = "Saves your current position to memory",
    ["Телепортирует на ранее сохраненную точку"] = "Teleports to the previously saved point",
    ["Телепортирует к игроку с максимальной силой на сервере"] = "Teleports to the strongest player on the server",
    ["Auto Rebirth (Бесконечный авто-ребирт)"] = "Auto Rebirth (Infinite Auto-Rebirth)",
    ["Автоматически выполняет перерождение сразу при достижении нужного количества силы"] = "Automatically rebirths as soon as the required strength is reached",
    ["Manual Rebirth (Переродиться прямо сейчас)"] = "Manual Rebirth (Rebirth Right Now)",
    ["Принудительно запрашивает перерождение на сервере через все каналы"] = "Forcefully requests a rebirth on the server via all channels",
    ["Авто-телепорт по всем сундукам карты и их сбор"] = "Auto-teleports to all map chests and collects them",
    ["Автоматически притягивает/собирает сферы со всей карты"] = "Automatically attracts/collects orbs from across the map",
    ["Авто-открытие кристалла с питомцами (авто-телепорт вплотную)"] = "Auto-opens pet crystals (auto-teleport up close)",
    ["Автоматически объединяет одинаковых питомцев для эволюции"] = "Automatically merges identical pets for evolution",
    ["Автоматически надевает лучших питомцев в инвентаре"] = "Automatically equips the best pets in your inventory",
    ["Режим свободного полета Fouf32"] = "Fouf32 free flight mode",
    ["Скорость полета в воздухе"] = "Flight speed in the air",
    ["Изменение скорости ходьбы"] = "Change walk speed",
    ["Значение скорости ходьбы"] = "Walk speed value",
    ["Изменение высоты прыжка"] = "Change jump height",
    ["Сила высоты прыжка"] = "Jump power value",
    ["Настройка гравитации игрового мира"] = "Game world gravity setting",
    ["Проход сквозь стены и объекты"] = "Walk through walls and objects",
    ["Бесконечные прыжки в воздухе"] = "Infinite jumps in the air",
    ["Авто-прыжок при касании земли"] = "Auto-jump when touching the ground",
    ["Режим наблюдения от первого/третьего лица за выбранной целью"] = "First/third person spectate mode for the selected target",
    ["Показывает имена и дистанцию до игроков"] = "Shows names and distance to players",
    ["Убирает тени на карте и включает день"] = "Removes map shadows and sets daytime",
    ["Угол обзора камеры"] = "Camera field of view",
    ["Перезайти на этот же сервер"] = "Rejoin this same server",
    ["Подключиться к случайному серверу"] = "Connect to a random server",
    ["Копирует ID текущего сервера в буфер обмена"] = "Copies the current server ID to clipboard",
    ["Switch Theme (Сменить Тему)"] = "Switch Theme",
    ["Stay In Place After Rebirth (Не телепортовать на спавн)"] = "Stay In Place After Rebirth",
    ["Сохраняет вашу позицию до перерождения и возвращает вас обратно после него"] = "Saves your position before rebirth and returns you there after it",
    ["MASS EGG HATCHER (ДО 500 ЗА РАЗ)"] = "MASS EGG HATCHER (UP TO 500 AT ONCE)",
    ["Eggs Per Batch (1-500)"] = "Eggs Per Batch (1-500)",
    ["Сколько яиц открывать за один Mass Hatch (максимум 500)"] = "How many eggs to open per Mass Hatch (max 500)",
    ["Авто-открытие выбранного кристалла пока включено (остановка при отказе сервера)"] = "Auto-opens the selected crystal while enabled (stops on server denial)",
    ["MASS HATCH (открыть выбранное количество)"] = "MASS HATCH (open selected amount)",
    ["Быстро открывает до 500 яиц подряд с проверкой мест в инвентаре и валюты"] = "Quickly opens up to 500 eggs in a row, checking inventory slots and currency",
    ["Hatch x10"] = "Hatch x10",
    ["Быстро открывает 10 яиц подряд"] = "Quickly opens 10 eggs in a row",
    ["Hatch x1"] = "Hatch x1",
    ["Открывает одно яйцо"] = "Opens one egg",
    ["Stop Mass Hatch"] = "Stop Mass Hatch",
    ["Останавливает идущее массовое вылупление"] = "Stops the running mass hatch",
    ["CRYSTAL SELECTOR (ВЫБОР ЯЙЦА)"] = "CRYSTAL SELECTOR",
    ["Встает на ближайшую беговую дорожку и качает ловкость!"] = "Steps onto the nearest treadmill and trains agility!",
    ["Активирует Kill Aura: бьет, телепортирует врагов прямо к вам или телепортируется к ним!"] = "Enables Kill Aura: hits enemies, dashes to them or pulls them into your fists!",
}

local TextBindings = {}

-- value: строка ИЛИ функция, возвращающая строку (для динамических надписей)
local function resolveText(value)
    if type(value) == "function" then
        local ok, res = pcall(value)
        value = (ok and res) or ""
    end
    if Config.Language == "EN" and type(value) == "string" then
        local en = LangDict[value]
        if en then return en end
    end
    return value
end

-- Регистрирует TextLabel/TextButton для живого обновления при смене языка
local function bindText(inst, getter)
    table.insert(TextBindings, {inst = inst, get = getter})
    pcall(function() inst.Text = getter() end)
end

local function applyLanguage()
    for _, binding in ipairs(TextBindings) do
        local inst = binding.inst
        if inst and inst.Parent then
            local ok, txt = pcall(binding.get)
            if ok then inst.Text = txt end
        end
    end
end

local AccentColor = Color3.fromRGB(236, 236, 240) -- по умолчанию — серебро на чёрном

local AccentPresets = {
    {name = "Silver",  color = Color3.fromRGB(236, 236, 240)},
    {name = "Teal",    color = Color3.fromRGB(45, 212, 191)},
    {name = "Purple",  color = Color3.fromRGB(168, 85, 247)},
    {name = "Red",     color = Color3.fromRGB(248, 113, 113)},
    {name = "Blue",    color = Color3.fromRGB(96, 165, 250)},
    {name = "Green",   color = Color3.fromRGB(74, 222, 128)},
    {name = "Pink",    color = Color3.fromRGB(244, 114, 182)},
    {name = "Amber",   color = Color3.fromRGB(251, 191, 36)},
    {name = "Slate",   color = Color3.fromRGB(148, 163, 184)},
}

-- Темы окна: сплошные (непрозрачные) фоны. Первая тема — "Black" по умолчанию.
local UIThemes = {
    {name = "Black",     window = Color3.fromRGB(12, 12, 14),    panel = Color3.fromRGB(22, 22, 25),    bar = Color3.fromRGB(16, 16, 18),    side = Color3.fromRGB(14, 14, 16),    accent = Color3.fromRGB(236, 236, 240)},
    {name = "Slate",     window = Color3.fromRGB(17, 20, 24),    panel = Color3.fromRGB(26, 30, 36),    bar = Color3.fromRGB(20, 24, 28),    side = Color3.fromRGB(18, 21, 26),    accent = Color3.fromRGB(148, 163, 184)},
    {name = "Midnight",  window = Color3.fromRGB(10, 13, 22),    panel = Color3.fromRGB(18, 23, 38),    bar = Color3.fromRGB(13, 17, 28),    side = Color3.fromRGB(11, 14, 24),    accent = Color3.fromRGB(96, 165, 250)},
    {name = "Crimson",   window = Color3.fromRGB(18, 11, 12),    panel = Color3.fromRGB(30, 19, 20),    bar = Color3.fromRGB(22, 14, 15),    side = Color3.fromRGB(16, 10, 11),    accent = Color3.fromRGB(248, 113, 113)},
    {name = "Cyberpunk", window = Color3.fromRGB(8, 12, 16),     panel = Color3.fromRGB(20, 26, 30),    bar = Color3.fromRGB(10, 15, 18),    side = Color3.fromRGB(10, 15, 18),    accent = Color3.fromRGB(45, 212, 191)},
}

local function currentTheme()
    return UIThemes[Config.ThemeIndex] or UIThemes[1]
end

local rockTiers = {
    {"Tiny Rock", "0 Rebirths / 0 Str", "tiny"},
    {"Punching Rock", "0 Rebirths / 100 Str", "punching"},
    {"Large Rock", "0 Rebirths / 5K Str", "large"},
    {"Frost Rock", "5 Rebirths / 150K Str", "frost"},
    {"Mythic Rock", "15 Rebirths / 400K Str", "mythic"},
    {"Jungle Rock", "60 Rebirths / 750K Str", "jungle"},
    {"Industrial Rock", "150 Rebirths / 1M Str", "industrial"},
    {"Eternal Rock", "300 Rebirths / 5M Str", "eternal"},
    {"Legend Rock", "3,000 Rebirths / 10M Str", "legend"},
    {"Muscle King Rock", "30,000 Rebirths / 50M Str", "king"},
}

local crystalsList = {
    "Blue Crystal", "Green Crystal", "Frost Crystal", "Mythic Crystal", "Infernal Crystal", "Galaxy Crystal"
}

-- ============================================================
-- УТИЛИТЫ И ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ FOUF32
-- ============================================================
local function round(n) return math.floor(n + 0.5) end

local function applyCorner(inst, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = inst
    return c
end

local function applyStroke(inst, color, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(255,255,255)
    s.Transparency = transparency or 0.9
    s.Thickness = thickness or 1
    s.Parent = inst
    return s
end

local function tw(inst, props, dur, style)
    return TweenService:Create(inst, TweenInfo.new(dur or 0.2, style or Enum.EasingStyle.Quad), props)
end

local function notify(title, message, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "Fouf32 build 0.21",
            Text = message or "",
            Duration = duration or 4
        })
    end)
end

-- Игровая модель и ивенты Muscle Legends
local function getMuscleEvent()
    return LocalPlayer:FindFirstChild("muscleEvent") or ReplicatedStorage:FindFirstChild("muscleEvent")
end

-- Ленивый доступ к ремоутам папки ReplicatedStorage.rEvents
local function getREvent(name)
    local rEvents = ReplicatedStorage:FindFirstChild("rEvents")
    if not rEvents then return nil end
    local r = rEvents:FindFirstChild(name)
    if r then return r end
    r = rEvents:WaitForChild(name, 5)
    return r
end

-- Модуль GlobalFunctions игры (проверка требований тренажёров и т.п.)
local _globalFunctions = nil
local function getGlobalFunctions()
    if _globalFunctions ~= nil then return _globalFunctions or nil end
    local ok, mod = pcall(function()
        local shared = ReplicatedStorage:WaitForChild("shared", 5)
        local modules = shared and shared:WaitForChild("modules", 5)
        return require(modules.GlobalFunctions)
    end)
    _globalFunctions = ok and mod or false
    return _globalFunctions or nil
end

-- Текущий занятый тренажёр (значение Value у LocalPlayer.machineInUse)
local function getMachineInUse()
    local v = LocalPlayer:FindFirstChild("machineInUse")
    if v then return v.Value end
    return nil
end

local function leaveMachine()
    pcall(function()
        local remote = getREvent("machineInteractRemote")
        if remote and remote:IsA("RemoteFunction") then
            remote:InvokeServer("leaveMachine")
        end
    end)
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.Sit = false end
    end)
end

-- ============================================================
-- ИНВЕНТАРЬ ПИТОМЦЕВ: количество, вместимость, свободные места
-- ============================================================
local CAPACITY_SEARCH_NAMES = {
    "ItemCapacity", "itemCapacity", "Capacity", "capacity",
    "MaxItems", "maxItems", "PetCapacity", "petCapacity",
    "MaxPets", "maxPets", "StorageSize", "storageSize",
}

local function countOwnedPets()
    local n = 0
    local pf = LocalPlayer:FindFirstChild("petsFolder")
    if pf then
        for _, rarityFolder in pairs(pf:GetChildren()) do
            n = n + #rarityFolder:GetChildren()
        end
    end
    return n
end

local function detectItemCapacity()
    local ls = LocalPlayer:FindFirstChild("leaderstats")
    for _, name in ipairs(CAPACITY_SEARCH_NAMES) do
        local child = LocalPlayer:FindFirstChild(name)
        if child and child:IsA("ValueBase") then
            local v = tonumber(child.Value)
            if v and v > 0 then return v end
        end
        local leaderChild = ls and ls:FindFirstChild(name)
        if leaderChild and leaderChild:IsA("ValueBase") then
            local v = tonumber(leaderChild.Value)
            if v and v > 0 then return v end
        end
        local attr = LocalPlayer:GetAttribute(name)
        if attr ~= nil then
            local v = tonumber(attr)
            if v and v > 0 then return v end
        end
    end
    return nil
end

-- free, owned, capacity (capacity/free = nil, если вместимость найти не удалось)
local function freePetSlots()
    local owned = countOwnedPets()
    local cap = detectItemCapacity()
    if cap then
        return math.max(0, cap - owned), owned, cap
    end
    return nil, owned, nil
end

-- Баланс валюты: "Gems" (по умолчанию) или "Tokens"
local function getCurrency(kind)
    local name = (kind == "Tokens") and "Tokens" or "Gems"
    local v = LocalPlayer:FindFirstChild(name)
    if v and v:IsA("ValueBase") then return tonumber(v.Value) or 0 end
    local ls = LocalPlayer:FindFirstChild("leaderstats")
    v = ls and ls:FindFirstChild(name)
    if v and v:IsA("ValueBase") then return tonumber(v.Value) or 0 end
    return nil
end

-- ============================================================
-- ПОИСК И НАДЕЖНЫЙ ФАРМ КАМНЯ (Rock Farming Engine)
-- ============================================================
local function getTargetRockPart(tierKeyword)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = char.HumanoidRootPart.Position
    local bestRock, minDist = nil, math.huge

    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") or v:IsA("BasePart") then
            local nameLower = string.lower(v.Name)
            if string.find(nameLower, "rock") then
                local part = v:IsA("BasePart") and v or (v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart"))
                if part then
                    local isMatch = false
                    if tierKeyword == "Any" then
                        isMatch = true
                    elseif string.find(nameLower, string.lower(tierKeyword)) then
                        isMatch = true
                    end

                    if isMatch then
                        local dist = (part.Position - myPos).Magnitude
                        if dist < minDist then
                            minDist = dist
                            bestRock = part
                        end
                    end
                end
            end
        end
    end
    return bestRock
end

-- ============================================================
-- НАДЕЖНОЕ ОТКРЫТИЕ КРИСТАЛЛОВ / ЯИЦ
-- ============================================================
local function teleportToCrystal(crystalName)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local myHrp = char.HumanoidRootPart

    local crystalObj = nil
    for _, v in pairs(Workspace:GetDescendants()) do
        if (v:IsA("Model") or v:IsA("BasePart")) and (string.find(string.lower(v.Name), string.lower(crystalName)) or v.Name == crystalName) then
            crystalObj = v:IsA("BasePart") and v or (v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart"))
            if crystalObj then break end
        end
    end

    if crystalObj then
        pcall(function()
            myHrp.CFrame = crystalObj.CFrame * CFrame.new(0, 2, 3)
        end)
    end
end

-- Одно открытие кристалла. Возвращает:
--   true,  petName, rarity  — выпал питомец
--   false, "denied"         — сервер отказал (инвентарь полон / не хватает валюты)
--   false, "noremote"       — ремоут openCrystalRemote не найден
local function openCrystalOnce(crystalName)
    local remote = nil
    pcall(function()
        remote = getREvent("openCrystalRemote")
    end)
    if remote and remote:IsA("RemoteFunction") then
        local ok, pet, rarity = pcall(function()
            return remote:InvokeServer("openCrystal", crystalName)
        end)
        if ok then
            if type(pet) == "string" then return true, pet, rarity end
            return false, "denied"
        end
        return false, "invokefail"
    end

    -- Фолбэк: muscleEvent (старая схема, только если ремоута нет вовсе)
    local ev = getMuscleEvent()
    if ev then
        pcall(function() ev:FireServer("openCrystal", crystalName) end)
        pcall(function() ev:FireServer("crys", crystalName) end)
        pcall(function() ev:FireServer("openEgg", crystalName) end)
        return true, nil, nil
    end
    return false, "noremote"
end

local function hatchCrystal(crystalName)
    teleportToCrystal(crystalName)
    return openCrystalOnce(crystalName)
end

-- ============================================================
-- УМНЫЙ ТЕЛЕПОРТ FOUF32 (Smart Teleport Engine)
-- ============================================================
local islandDatabase = {
    ["Spawn Beach"]             = {pos = Vector3.new(0, 10, 0),       keywords = {"spawn", "beach"}},
    ["Tiny Island"]              = {pos = Vector3.new(-39, 10, 1860),  keywords = {"tiny"}},
    ["Legend Beach"]            = {pos = Vector3.new(0, 10, -4000),   keywords = {"legend beach"}},
    ["Frost Gym (5 Rebirths)"]  = {pos = Vector3.new(-2569, 12, -474), keywords = {"frost", "frozen"}},
    ["Mythic Gym (15 Reb)"]     = {pos = Vector3.new(2250, 12, 1070),  keywords = {"mythic"}},
    ["Jungle Gym (60 Reb)"]     = {pos = Vector3.new(-2500, 15, 2350), keywords = {"jungle"}},
    ["Industrial Gym (150 Reb)"]= {pos = Vector3.new(-4560, 995, -3000),keywords = {"industrial"}},
    ["Eternal Gym (300 Reb)"]   = {pos = Vector3.new(-6730, 12, -1280),keywords = {"eternal"}},
    ["Legend Gym (3K Reb)"]     = {pos = Vector3.new(4400, 995, -4000),keywords = {"legend gym"}},
    ["Muscle King Gym (30K)"]   = {pos = Vector3.new(-8550, 20, -5700),keywords = {"muscle king"}},
    ["Overcharged Gym (100K)"]  = {pos = Vector3.new(-7050, 20, -1350),keywords = {"overcharged"}}
}

local function safeTeleport(targetCFrame)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hum and hrp then
        if hum.Sit then
            hum.Sit = false
            task.wait(0.1)
        end

        local platform = Instance.new("Part")
        platform.Size = Vector3.new(12, 1, 12)
        platform.Position = targetCFrame.Position - Vector3.new(0, 3.5, 0)
        platform.Anchored = true
        platform.Transparency = 1
        platform.CanCollide = true
        platform.Parent = Workspace

        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        hrp.CFrame = targetCFrame + Vector3.new(0, 3, 0)

        task.wait(0.05)
        hrp.CFrame = targetCFrame + Vector3.new(0, 3, 0)
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

        task.delay(3, function()
            pcall(function() platform:Destroy() end)
        end)
    end
end

local function smartTeleportToIsland(islandName)
    local data = islandDatabase[islandName]
    local targetPos = data and data.pos or Vector3.new(0, 0, 0)

    local foundPart = nil
    if data and data.keywords then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Model") then
                local objName = string.lower(obj.Name)
                for _, kw in ipairs(data.keywords) do
                    if string.find(objName, kw) then
                        foundPart = obj:IsA("BasePart") and obj or (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart"))
                        if foundPart then break end
                    end
                end
            end
            if foundPart then break end
        end
    end

    if foundPart then
        safeTeleport(foundPart.CFrame * CFrame.new(0, 5, 0))
    elseif data then
        safeTeleport(CFrame.new(targetPos))
    end
    notify("Fouf32 Teleport", "Teleported to " .. islandName, 2)
end

-- Поиск ближайшего тренажера по ключевым словам
-- Сначала смотрим в игровые папки (machinesFolder / Treadmills),
-- затем — общий обход Workspace. blacklist: модель -> время блокировки.
local function findNearestMachine(machineKeywords, blacklist)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil, nil end
    local myPos = char.HumanoidRootPart.Position
    local bestPart, bestModel, minDist = nil, nil, math.huge

    local wantTread = false
    for _, kw in ipairs(machineKeywords) do
        if string.find(string.lower(kw), "tread") then wantTread = true end
    end

    local function tryObject(obj)
        if blacklist and blacklist[obj] and blacklist[obj] > tick() then return end
        local objName = string.lower(obj.Name)
        local matched = false
        for _, kw in ipairs(machineKeywords) do
            if string.find(objName, string.lower(kw)) then matched = true break end
        end
        if matched then
            local part = nil
            if wantTread and obj:IsA("Model") then
                part = obj:FindFirstChild("treadmillPart")
            end
            part = part or (obj:IsA("BasePart") and obj or (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
            if part then
                local dist = (part.Position - myPos).Magnitude
                if dist < minDist then
                    minDist = dist
                    bestPart = part
                    if obj:IsA("Model") then
                        bestModel = obj
                    elseif obj.Parent and obj.Parent ~= Workspace and obj.Parent:IsA("Model") then
                        bestModel = obj.Parent
                    else
                        bestModel = nil
                    end
                end
            end
        end
    end

    -- 1) Игровые папки с тренажёрами
    local folderNames = {"machinesFolder", "Machines", "Treadmills"}
    local foundInFolders = false
    for _, fName in ipairs(folderNames) do
        local folder = Workspace:FindFirstChild(fName)
        if folder then
            for _, m in pairs(folder:GetChildren()) do
                if m:IsA("Model") or m:IsA("BasePart") then
                    foundInFolders = true
                    tryObject(m)
                end
            end
        end
    end

    -- 2) Если в папках ничего не нашли — общий обход
    if not foundInFolders or not bestPart then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") or obj:IsA("BasePart") then
                tryObject(obj)
            end
        end
    end
    return bestPart, bestModel
end

-- Сиденье тренажёра (для машин из machinesFolder PrimaryPart и есть Seat)
local function getMachineSeat(model)
    if not model then return nil end
    if model:IsA("Seat") then return model end
    local pp = model.PrimaryPart
    if pp and pp:IsA("Seat") then return pp end
    local s = model:FindFirstChildWhichIsA("Seat", true)
    return s
end

-- Серверное подключение к тренажёру: machineInteractRemote:InvokeServer("useMachine", seat)
local function engageMachine(machineModel, seat)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp or not seat then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")

    -- если уже сидим на другом тренажёре — сначала встаём
    local inUse = getMachineInUse()
    if inUse and inUse ~= seat then
        leaveMachine()
        task.wait(0.15)
    end

    -- телепорт строго над сиденьем (несколько попыток, как требует сервер)
    for _ = 1, 3 do
        pcall(function()
            hrp.CFrame = seat.CFrame * CFrame.new(0, 5, 0)
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end)
        task.wait(0.05)
    end

    local remote = getREvent("machineInteractRemote")
    if remote and remote:IsA("RemoteFunction") then
        local ok, res = pcall(function() return remote:InvokeServer("useMachine", seat) end)
        if ok and res == true then
            local t0 = tick()
            while getMachineInUse() ~= seat and tick() - t0 < 0.8 do
                task.wait(0.03)
            end
            if getMachineInUse() == seat then return true end
        end
        if ok and res == false then
            -- сервер отказал (требования не выполнены / занято)
            return false
        end
    end

    -- Фолбэк без ремоута: обычная посадка
    if seat:IsA("Seat") and hum then
        pcall(function() hum.Sit = true end)
        task.wait(0.15)
        if hum.Sit or hum.SeatPart then return true end
        if firetouchinterest then
            pcall(function()
                firetouchinterest(hrp, seat, 0)
                task.wait(0.05)
                firetouchinterest(hrp, seat, 1)
            end)
            task.wait(0.15)
            if hum.Sit or hum.SeatPart then return true end
        end
    end
    return machineModel ~= nil
end

-- Экуип и тренировки
local function trainTool(toolSearchName)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    -- Если включен режим ходьбы со штангой / гантелями — запрещаем принудительную анимацию сидения
    if Config.WalkWhileTraining then
        if hum.Sit then hum.Sit = false end
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.Anchored then
                part.Anchored = false
            end
        end
    end

    local tool = nil
    for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
        if item:IsA("Tool") then
            if toolSearchName == "Dumbbell" and (string.find(string.lower(item.Name), "dumbbell") or string.find(string.lower(item.Name), "weight")) then
                tool = item
                break
            elseif string.find(string.lower(item.Name), string.lower(toolSearchName)) then
                tool = item
                break
            end
        end
    end
    if not tool then
        for _, item in pairs(char:GetChildren()) do
            if item:IsA("Tool") then
                if toolSearchName == "Dumbbell" and (string.find(string.lower(item.Name), "dumbbell") or string.find(string.lower(item.Name), "weight")) then
                    tool = item
                    break
                elseif string.find(string.lower(item.Name), string.lower(toolSearchName)) then
                    tool = item
                    break
                end
            end
        end
    end

    if tool then
        if tool.Parent ~= char then
            hum:EquipTool(tool)
        end
        pcall(function() tool:Activate() end)
    end

    local ev = getMuscleEvent()
    if ev then
        local repCount = Config.UltraFastRep and (Config.FastRepMultiplier * 5) or Config.FastRepMultiplier
        for i = 1, repCount do
            ev:FireServer("rep")
        end
    end
end

-- Anti-AFK
pcall(function()
    for _, conn in pairs(getconnections(LocalPlayer.Idled)) do conn:Disable() end
end)
local afkConn = LocalPlayer.Idled:Connect(function()
    if Config.AntiAFK then
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end
end)
table.insert(ScriptConnections, afkConn)

-- Auto Low HP Teleport Safety
local lowHpConn = RunService.Heartbeat:Connect(function()
    if Config.AutoSafeTPLowHP and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 and (hum.Health / hum.MaxHealth) < 0.25 then
            safeTeleport(CFrame.new(0, 5005, 0))
            notify("Fouf32 Safety", "Low HP! Emergency teleport to sky safe zone!", 3)
            task.wait(5)
        end
    end
end)
table.insert(ScriptConnections, lowHpConn)

-- ============================================================
-- СИСТЕМА ПОЛЕТА (FLY ENGINE)
-- ============================================================
local flying = false
local flyBv, flyBg
local flyKeys = {W = false, A = false, S = false, D = false, Space = false, Shift = false}

local function startFlight()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    flyBv = Instance.new("BodyVelocity")
    flyBv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBv.Velocity = Vector3.new(0, 0, 0)
    flyBv.Parent = hrp

    flyBg = Instance.new("BodyGyro")
    flyBg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyBg.CFrame = hrp.CFrame
    flyBg.Parent = hrp

    flying = true

    local conn = RunService.RenderStepped:Connect(function()
        if not flying or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if flyBv then flyBv:Destroy() end
            if flyBg then flyBg:Destroy() end
            return
        end

        local cam = Workspace.CurrentCamera
        local moveDir = Vector3.new(0, 0, 0)

        if flyKeys.W then moveDir = moveDir + cam.CFrame.LookVector end
        if flyKeys.S then moveDir = moveDir - cam.CFrame.LookVector end
        if flyKeys.A then moveDir = moveDir - cam.CFrame.RightVector end
        if flyKeys.D then moveDir = moveDir + cam.CFrame.RightVector end
        if flyKeys.Space then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if flyKeys.Shift then moveDir = moveDir - Vector3.new(0, 1, 0) end

        flyBg.CFrame = cam.CFrame
        flyBv.Velocity = moveDir * Config.FlySpeed
    end)
    table.insert(ScriptConnections, conn)
end

local function stopFlight()
    flying = false
    if flyBv then flyBv:Destroy() end
    if flyBg then flyBg:Destroy() end
end

local flyDownConn = UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.W then flyKeys.W = true
    elseif input.KeyCode == Enum.KeyCode.S then flyKeys.S = true
    elseif input.KeyCode == Enum.KeyCode.A then flyKeys.A = true
    elseif input.KeyCode == Enum.KeyCode.D then flyKeys.D = true
    elseif input.KeyCode == Enum.KeyCode.Space then flyKeys.Space = true
    elseif input.KeyCode == Enum.KeyCode.LeftShift then flyKeys.Shift = true
    end
end)
table.insert(ScriptConnections, flyDownConn)

local flyUpConn = UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then flyKeys.W = false
    elseif input.KeyCode == Enum.KeyCode.S then flyKeys.S = false
    elseif input.KeyCode == Enum.KeyCode.A then flyKeys.A = false
    elseif input.KeyCode == Enum.KeyCode.D then flyKeys.D = false
    elseif input.KeyCode == Enum.KeyCode.Space then flyKeys.Space = false
    elseif input.KeyCode == Enum.KeyCode.LeftShift then flyKeys.Shift = false
    end
end)
table.insert(ScriptConnections, flyUpConn)

-- Noclip & Physics Loop
local noclipConn = RunService.Stepped:Connect(function()
    if Config.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    if Config.AntiKnockback and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity.Y, 0)
    end
end)
table.insert(ScriptConnections, noclipConn)

-- Inf Jump Input
local infJumpConn = UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Space and Config.InfJump then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)
table.insert(ScriptConnections, infJumpConn)

-- ============================================================
-- БАЗА ГУИ (FOUF32 GLASS UI FRAMEWORK)
-- ============================================================
local targetParent = nil
if typeof(gethui) == "function" then
    pcall(function() targetParent = gethui() end)
end
if not targetParent then
    pcall(function()
        if syn and syn.protect_gui then
            targetParent = CoreGui
        end
    end)
end
if not targetParent then
    pcall(function() targetParent = LocalPlayer:WaitForChild("PlayerGui") end)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = FRAMEWORK_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
print("[Fouf32 STAGE D]: ScreenGui создан")

pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    end
end)
if not ScreenGui.Parent then
    pcall(function() ScreenGui.Parent = targetParent end)
end
if not ScreenGui.Parent then
    pcall(function() ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end)
end

pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "FOUF32 BUILD 0.21",
        Text = "Скрипт успешно запущен! Нажмите Right Shift или кнопку на экране.",
        Duration = 5
    })
end)

-- ============================================================
-- ПРИВЕТСТВЕННОЕ ОКНО ВЫБОРА ЯЗЫКА (WELCOME LANGUAGE MODAL)
-- ============================================================
local LangModal = Instance.new("Frame", ScreenGui)
LangModal.Name = "LangModal"
LangModal.Size = UDim2.new(0, 480, 0, 260)
LangModal.Position = UDim2.new(0.5, -240, 0.5, -130)
LangModal.BackgroundColor3 = currentTheme().window
LangModal.BackgroundTransparency = 0
LangModal.ZIndex = 20
CollectionService:AddTag(LangModal, "ThemeWindow")
applyCorner(LangModal, 16)
local langStroke = applyStroke(LangModal, AccentColor, 0.2, 2)
CollectionService:AddTag(langStroke, "AccentStroke")

local LangTitle = Instance.new("TextLabel", LangModal)
LangTitle.BackgroundTransparency = 1
LangTitle.Position = UDim2.new(0, 20, 0, 18)
LangTitle.Size = UDim2.new(1, -40, 0, 28)
LangTitle.Font = Enum.Font.GothamBold
LangTitle.Text = "FOUF32 BUILD 0.21"
LangTitle.TextColor3 = AccentColor
LangTitle.TextSize = 16
LangTitle.TextXAlignment = Enum.TextXAlignment.Center
CollectionService:AddTag(LangTitle, "AccentText")

local LangSubTitle = Instance.new("TextLabel", LangModal)
LangSubTitle.BackgroundTransparency = 1
LangSubTitle.Position = UDim2.new(0, 20, 0, 52)
LangSubTitle.Size = UDim2.new(1, -40, 0, 40)
LangSubTitle.Font = Enum.Font.GothamMedium
LangSubTitle.Text = "Привет! Какой язык ты предпочитаешь?\nHello! Which language do you prefer?"
LangSubTitle.TextColor3 = Color3.fromRGB(240, 250, 248)
LangSubTitle.TextSize = 13
LangSubTitle.TextXAlignment = Enum.TextXAlignment.Center
LangSubTitle.TextWrapped = true

local RuBtn = Instance.new("TextButton", LangModal)
RuBtn.Name = "RuBtn"
RuBtn.Size = UDim2.new(0, 190, 0, 48)
RuBtn.Position = UDim2.new(0, 35, 0, 160)
RuBtn.BackgroundColor3 = AccentColor
RuBtn.BackgroundTransparency = 0
RuBtn.Text = "🇷🇺 Русский Язык"
RuBtn.TextColor3 = Color3.fromRGB(10, 15, 15)
RuBtn.Font = Enum.Font.GothamBold
RuBtn.TextSize = 13
applyCorner(RuBtn, 10)

local EnBtn = Instance.new("TextButton", LangModal)
EnBtn.Name = "EnBtn"
EnBtn.Size = UDim2.new(0, 190, 0, 48)
EnBtn.Position = UDim2.new(1, -225, 0, 160)
EnBtn.BackgroundColor3 = currentTheme().panel
EnBtn.BackgroundTransparency = 0
EnBtn.Text = "🇬🇧 English"
EnBtn.TextColor3 = Color3.fromRGB(240, 250, 248)
EnBtn.Font = Enum.Font.GothamBold
EnBtn.TextSize = 13
applyCorner(EnBtn, 10)

-- Обработчики кнопок языка подключены ниже (selectLanguage) — см. конец секции UI

-- ============================================================
-- КНОПКА ОТКРЫТИЯ НА ЭКРАНЕ FOUF32
-- ============================================================
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Name = "Fouf32_OpenBtn"
OpenBtn.Size = UDim2.new(0, 160, 0, 40)
OpenBtn.Position = UDim2.new(0, 15, 0.35, 0)
OpenBtn.BackgroundColor3 = currentTheme().window
OpenBtn.BackgroundTransparency = 0
OpenBtn.Text = "FOUF32 BUILD 0.21"
OpenBtn.TextColor3 = Color3.fromRGB(240, 250, 248)
OpenBtn.TextSize = 11
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Active = true
OpenBtn.Draggable = true
CollectionService:AddTag(OpenBtn, "ThemeWindow")
applyCorner(OpenBtn, 10)
local openBtnStroke = applyStroke(OpenBtn, AccentColor, 0.4, 1.5)
CollectionService:AddTag(openBtnStroke, "AccentStroke")

-- ============================================================
-- ON-SCREEN HUD
-- ============================================================
local OnScreenHUD = Instance.new("Frame", ScreenGui)
OnScreenHUD.Name = "OnScreenHUD"
OnScreenHUD.BackgroundTransparency = 1
OnScreenHUD.Position = UDim2.new(1, -240, 0, 20)
OnScreenHUD.Size = UDim2.new(0, 220, 0, 120)
OnScreenHUD.Visible = Config.ShowOnScreenHUD

local HUDPanel = Instance.new("Frame", OnScreenHUD)
HUDPanel.BackgroundColor3 = currentTheme().window
HUDPanel.BackgroundTransparency = 0
HUDPanel.Size = UDim2.new(1, 0, 1, 0)
CollectionService:AddTag(HUDPanel, "ThemeWindow")
applyCorner(HUDPanel, 12)
local HUDStroke = applyStroke(HUDPanel, AccentColor, 0.4, 1.5)
CollectionService:AddTag(HUDStroke, "AccentStroke")

local HUDContentLabel = Instance.new("TextLabel", HUDPanel)
HUDContentLabel.BackgroundTransparency = 1
HUDContentLabel.Position = UDim2.new(0, 12, 0, 10)
HUDContentLabel.Size = UDim2.new(1, -24, 1, -20)
HUDContentLabel.Font = Enum.Font.GothamBold
HUDContentLabel.TextColor3 = Color3.fromRGB(240, 250, 248)
HUDContentLabel.TextSize = 11
HUDContentLabel.TextXAlignment = Enum.TextXAlignment.Left
HUDContentLabel.TextYAlignment = Enum.TextYAlignment.Top
HUDContentLabel.TextWrapped = true

local hudConn = RunService.RenderStepped:Connect(function(dt)
    if Config.ShowOnScreenHUD then
        local fps = math.floor(1 / dt)
        local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
        local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
        local str = leaderstats and leaderstats:FindFirstChild("Strength") and leaderstats.Strength.Value or 0
        local reb = leaderstats and leaderstats:FindFirstChild("Rebirths") and leaderstats.Rebirths.Value or 0
        
        HUDContentLabel.Text = string.format("FOUF32 BUILD 0.21 HUD:\n  • FPS: %d | Ping: %d ms\n  • Player: %s\n  • Strength: %s\n  • Rebirths: %s", fps, ping, LocalPlayer.Name, tostring(str), tostring(reb))
    end
end)
table.insert(ScriptConnections, hudConn)

-- ============================================================
-- ГЛАВНОЕ ОКНО FOUF32 BUILD 0.21 (690x520)
-- ============================================================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = currentTheme().window
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -345, 0.5, -260)
MainFrame.Size = UDim2.new(0, 690, 0, 520)
MainFrame.Active = true
MainFrame.Visible = false -- стартовое окно языка поверх меню
LangModal.Visible = true
print("[Fouf32 STAGE E]: главное окно построено, показано окно языка")
MainFrame.ClipsDescendants = true
CollectionService:AddTag(MainFrame, "ThemeWindow")
applyCorner(MainFrame, 18)
local MainStroke = applyStroke(MainFrame, AccentColor, 0.3, 1.5)
CollectionService:AddTag(MainStroke, "AccentStroke")

local GlassLayer1 = Instance.new("Frame", MainFrame)
GlassLayer1.Size = UDim2.new(1,0,1,0); GlassLayer1.BackgroundColor3 = Color3.fromRGB(255,255,255); GlassLayer1.BackgroundTransparency = 1; GlassLayer1.BorderSizePixel = 0; GlassLayer1.ZIndex = 0; applyCorner(GlassLayer1, 18)

local GlassLayer2 = Instance.new("Frame", MainFrame)
GlassLayer2.Size = UDim2.new(1,0,1,0); GlassLayer2.BackgroundColor3 = Color3.fromRGB(14,14,16); GlassLayer2.BackgroundTransparency = 0.4; GlassLayer2.BorderSizePixel = 0; GlassLayer2.ZIndex = 0; applyCorner(GlassLayer2, 18)

local BgOverlay = Instance.new("Frame", MainFrame)
BgOverlay.Size = UDim2.new(1,0,1,0); BgOverlay.BackgroundColor3 = Color3.fromRGB(5,8,10); BgOverlay.BackgroundTransparency = 1; BgOverlay.BorderSizePixel = 0; BgOverlay.ZIndex = 2; applyCorner(BgOverlay, 18)

-- Шапка
local TopBar = Instance.new("Frame", MainFrame)
TopBar.BackgroundColor3 = currentTheme().bar; TopBar.BackgroundTransparency = 0; TopBar.Size = UDim2.new(1,0,0,50); TopBar.BorderSizePixel = 0; TopBar.Active = true; TopBar.ZIndex = 6
CollectionService:AddTag(TopBar, "ThemeBar")
applyCorner(TopBar, 18)

local TopCover = Instance.new("Frame", TopBar)
TopCover.BackgroundColor3 = currentTheme().bar; TopCover.BackgroundTransparency = 0; TopCover.BorderSizePixel = 0; TopCover.Position = UDim2.new(0,0,1,-12); TopCover.Size = UDim2.new(1,0,0,12); TopCover.ZIndex = 6
CollectionService:AddTag(TopCover, "ThemeBar")

local AccentDot = Instance.new("Frame", TopBar)
AccentDot.AnchorPoint = Vector2.new(0,0.5); AccentDot.Position = UDim2.new(0,22,0.5,0); AccentDot.Size = UDim2.new(0,9,0,9); AccentDot.BackgroundColor3 = AccentColor; AccentDot.ZIndex = 7
CollectionService:AddTag(AccentDot, "AccentFill"); applyCorner(AccentDot, 5)

local TitleLabel = Instance.new("TextLabel", TopBar)
TitleLabel.BackgroundTransparency = 1; TitleLabel.Position = UDim2.new(0,42,0,0); TitleLabel.Size = UDim2.new(0,420,1,0)
TitleLabel.Font = Enum.Font.GothamBold; TitleLabel.Text = "FOUF32 BUILD 0.21  •  Muscle Legends Master Hub"; TitleLabel.TextColor3 = Color3.fromRGB(240,250,248); TitleLabel.TextSize = 13; TitleLabel.TextXAlignment = Enum.TextXAlignment.Left; TitleLabel.ZIndex = 7

local CloseHeaderBtn = Instance.new("TextButton", TopBar)
CloseHeaderBtn.AnchorPoint = Vector2.new(1, 0.5); CloseHeaderBtn.Position = UDim2.new(1, -15, 0.5, 0); CloseHeaderBtn.Size = UDim2.new(0, 26, 0, 26)
CloseHeaderBtn.BackgroundColor3 = Color3.fromRGB(248, 113, 113); CloseHeaderBtn.BackgroundTransparency = 0; CloseHeaderBtn.Text = "X"; CloseHeaderBtn.TextColor3 = Color3.fromRGB(255, 255, 255); CloseHeaderBtn.Font = Enum.Font.GothamBold; CloseHeaderBtn.TextSize = 12; CloseHeaderBtn.ZIndex = 8
applyCorner(CloseHeaderBtn, 6)

-- ЕДИНАЯ ВЫГРУЗКА СКРИПТА: останавливает все while-циклы (через флаги Config),
-- отключает все соединения и уничтожает GUI
local function completeScriptUnload()
    notify("Fouf32", t("Выгрузка скрипта Fouf32 build 0.21...", "Unloading Fouf32 build 0.21..."), 2)

    local loopFlags = {
        "AutoOpFarm", "AutoDumbbell", "AutoPushups", "AutoSitups", "AutoWeight",
        "AutoPunch", "AutoMultiTool", "AutoBenchPress", "AutoSquat",
        "AutoTreadmillMachine", "AutoPullups", "AutoBoulder", "AutoRockMachine",
        "AutoRock", "AutoTreadmill", "KillAura", "TargetLoopKill", "AutoKillServer",
        "AutoBrawl", "AutoKillBoss", "AntiRagdoll", "AutoRebirth", "AutoCollectOrbs",
        "AutoCrystal", "PlayerESP", "FlyEnabled", "WalkWhileTraining", "AntiHit",
        "AutoSafeTPLowHP", "SpeedHack", "JumpPowerHack", "Noclip", "InfJump",
        "Bhop", "FullBright", "SpectateTarget", "AntiKnockback", "AntiAFK",
        "UltraFastRep", "AutoKillBoss", "HatchPower",
    }
    for _, flagName in ipairs(loopFlags) do
        Config[flagName] = false
    end

    for _, conn in ipairs(ScriptConnections) do
        pcall(function() conn:Disconnect() end)
    end
    ScriptConnections = {}

    pcall(stopFlight)
    pcall(function() clearESP() end)
    pcall(function() ScreenGui:Destroy() end)
    print("[Fouf32 Framework]: Unloaded successfully.")
end
CloseHeaderBtn.MouseButton1Click:Connect(completeScriptUnload)

-- Перетаскивание
local dragging, dragStart, startPos = false, nil, nil
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

-- Подвал с описанием (Description Footer Bar)
local DescFooterBar = Instance.new("Frame", MainFrame)
DescFooterBar.Name = "DescFooterBar"
DescFooterBar.BackgroundColor3 = currentTheme().bar
DescFooterBar.BackgroundTransparency = 0
DescFooterBar.BorderSizePixel = 0
DescFooterBar.Position = UDim2.new(0, 0, 1, -28)
DescFooterBar.Size = UDim2.new(1, 0, 0, 28)
DescFooterBar.ZIndex = 8
CollectionService:AddTag(DescFooterBar, "ThemeBar")
applyCorner(DescFooterBar, 18)

local DescTextLabel = Instance.new("TextLabel", DescFooterBar)
DescTextLabel.BackgroundTransparency = 1
DescTextLabel.Position = UDim2.new(0, 16, 0, 0)
DescTextLabel.Size = UDim2.new(1, -32, 1, 0)
DescTextLabel.Font = Enum.Font.GothamMedium
DescTextLabel.TextColor3 = Color3.fromRGB(94, 234, 212)
DescTextLabel.TextSize = 10
DescTextLabel.TextXAlignment = Enum.TextXAlignment.Left
DescTextLabel.Text = "Fouf32 build 0.21: " .. t("Наведите курсор на функцию для описания...", "Hover over feature to view description...")
CollectionService:AddTag(DescTextLabel, "AccentText")
bindText(DescTextLabel, function()
    return "Fouf32 build 0.21: " .. t("Наведите курсор на функцию для описания...", "Hover over feature to view description...")
end)

-- Сайдбар для 10 ПОНЯТНЫХ РАЗДЕЛОВ
local Sidebar = Instance.new("ScrollingFrame", MainFrame)
Sidebar.BackgroundColor3 = currentTheme().side; Sidebar.BackgroundTransparency = 0; Sidebar.BorderSizePixel = 0; Sidebar.Position = UDim2.new(0,0,0,50); Sidebar.Size = UDim2.new(0,185,1,-78); Sidebar.ZIndex = 5; Sidebar.ScrollBarThickness = 3; Sidebar.CanvasSize = UDim2.new(0,0,0, 10 * 36 + 20)
CollectionService:AddTag(Sidebar, "ThemeSide")
applyCorner(Sidebar, 18)

local SideLayout = Instance.new("UIListLayout", Sidebar)
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder; SideLayout.Padding = UDim.new(0,5)
local SidePadding = Instance.new("UIPadding", Sidebar)
SidePadding.PaddingTop = UDim.new(0,8); SidePadding.PaddingLeft = UDim.new(0,8); SidePadding.PaddingRight = UDim.new(0,8)

local pages, tabButtons = {}, {}
local PagesContainer = Instance.new("Frame", MainFrame)
PagesContainer.BackgroundTransparency = 1; PagesContainer.Position = UDim2.new(0,195,0,56); PagesContainer.Size = UDim2.new(1,-205,1,-90); PagesContainer.ZIndex = 5

local function createPage(name)
    local page = Instance.new("ScrollingFrame", PagesContainer)
    page.Name = name.."Page"; page.BackgroundTransparency = 1; page.Size = UDim2.new(1,0,1,0); page.CanvasSize = UDim2.new(0,0,0,1250); page.ScrollBarThickness = 4; page.ScrollBarImageColor3 = AccentColor; page.Visible = false; page.ZIndex = 5
    CollectionService:AddTag(page, "AccentScroll")
    local layout = Instance.new("UIListLayout", page)
    layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Padding = UDim.new(0,8)
    pages[name] = page
    return page
end

-- Создаем ровно 10 Разделов
local clickGuiPage    = createPage("ClickGUI")
local dashboardPage   = createPage("Dashboard")
local trainingPage    = createPage("Training")
local rocksPage       = createPage("Rocks")
local combatPage      = createPage("Combat")
local protectionPage  = createPage("Protection")
local teleportsPage   = createPage("Teleports")
local automationPage  = createPage("Automation")
local petsPage        = createPage("Pets")
local movementPage    = createPage("Movement")

local function switchTab(tabName)
    for name, page in pairs(pages) do page.Visible = (name == tabName) end
    local theme = currentTheme()
    for name, btn in pairs(tabButtons) do
        if name == tabName then
            tw(btn, {BackgroundColor3 = AccentColor, BackgroundTransparency = 0}, 0.2):Play()
            btn.TextColor3 = Color3.fromRGB(10,15,15)
        else
            tw(btn, {BackgroundColor3 = theme.panel, BackgroundTransparency = 0}, 0.2):Play()
            btn.TextColor3 = Color3.fromRGB(148,163,184)
        end
    end
end

local function createTabButton(displayName, internalName)
    local btn = Instance.new("TextButton", Sidebar)
    btn.BackgroundColor3 = currentTheme().panel; btn.BackgroundTransparency = 0; btn.Size = UDim2.new(1,0,0,32); btn.AutoButtonColor = false; btn.Font = Enum.Font.GothamBold; btn.Text = "   "..displayName; btn.TextColor3 = Color3.fromRGB(148,163,184); btn.TextSize = 10; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.ZIndex = 5
    applyCorner(btn, 8)
    btn.MouseButton1Click:Connect(function() switchTab(internalName) end)
    tabButtons[internalName] = btn
    return btn
end

-- 10 ПОНЯТНЫХ РАЗДЕЛОВ:
createTabButton("1. ClickGUI & Config", "ClickGUI")
createTabButton("2. Dashboard", "Dashboard")
createTabButton("3. Auto Farm", "Training")
createTabButton("4. Rocks & Gyms", "Rocks")
createTabButton("5. Combat & Killaura", "Combat")
createTabButton("6. Protection", "Protection")
createTabButton("7. Teleports & Points", "Teleports")
createTabButton("8. Automation & Eggs", "Automation")
createTabButton("9. Pets & Inventory", "Pets")
createTabButton("10. Movement & ESP", "Movement")

-- UI Компоненты с Индикатором Статуса [ВКЛ / ВЫКЛ]
local accentToggles = {}

local function bindTooltip(frame, descriptionText)
    frame.MouseEnter:Connect(function()
        if Config.EnableTooltips then
            DescTextLabel.Text = "Fouf32 build 0.21: " .. tostring(resolveText(descriptionText))
        end
    end)
    frame.MouseLeave:Connect(function()
        if Config.EnableTooltips then
            DescTextLabel.Text = "Fouf32 build 0.21: " .. t("Наведите курсор на функцию для описания...", "Hover over feature to view description...")
        end
    end)
end

local function sectionLabel(page, text)
    local lbl = Instance.new("TextLabel", page)
    lbl.BackgroundTransparency = 1; lbl.Size = UDim2.new(1,-10,0,20); lbl.Font = Enum.Font.GothamBold; lbl.Text = text; lbl.TextColor3 = Color3.fromRGB(94,234,212); lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left
    CollectionService:AddTag(lbl, "AccentText")
    bindText(lbl, function() return resolveText(text) end)
    return lbl
end

local function createGlassPanel(page, height)
    local panel = Instance.new("Frame", page)
    panel.BackgroundColor3 = currentTheme().panel; panel.BackgroundTransparency = 0; panel.Size = UDim2.new(1,-10,0,height)
    CollectionService:AddTag(panel, "ThemePanel")
    applyCorner(panel, 10); applyStroke(panel, Color3.fromRGB(255,255,255), 0.9, 1)
    return panel
end

local function createButton(page, name, desc, callback)
    local panel = createGlassPanel(page, 44)
    local btn = Instance.new("TextButton", panel)
    btn.BackgroundTransparency = 1; btn.Size = UDim2.new(1,0,1,0); btn.Text = ""; btn.ZIndex = 2

    local lbl = Instance.new("TextLabel", panel)
    lbl.BackgroundTransparency = 1; lbl.Position = UDim2.new(0,12,0,5); lbl.Size = UDim2.new(1,-24,0,16)
    lbl.Font = Enum.Font.GothamBold; lbl.Text = resolveText(name); lbl.TextColor3 = Color3.fromRGB(241,245,249); lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left
    bindText(lbl, function() return resolveText(name) end)

    local descLbl = Instance.new("TextLabel", panel)
    descLbl.BackgroundTransparency = 1; descLbl.Position = UDim2.new(0,12,0,22); descLbl.Size = UDim2.new(1,-24,0,16)
    descLbl.Font = Enum.Font.Gotham; descLbl.Text = resolveText(desc); descLbl.TextColor3 = Color3.fromRGB(148,163,184); descLbl.TextSize = 9; descLbl.TextXAlignment = Enum.TextXAlignment.Left
    bindText(descLbl, function() return resolveText(desc) end)

    bindTooltip(btn, desc)

    btn.MouseButton1Click:Connect(function()
        tw(panel, {BackgroundColor3 = AccentColor, BackgroundTransparency = 0}, 0.1):Play()
        task.delay(0.15, function() tw(panel, {BackgroundColor3 = currentTheme().panel, BackgroundTransparency = 0}, 0.15):Play() end)
        callback()
    end)
    return panel
end

local function createToggle(page, name, desc, default, callback)
    local btn = createGlassPanel(page, 48)
    local clickArea = Instance.new("TextButton", btn)
    clickArea.BackgroundTransparency = 1; clickArea.Size = UDim2.new(1,0,1,0); clickArea.Text = ""; clickArea.ZIndex = 2

    local state = default

    local statusBadge = Instance.new("TextLabel", btn)
    statusBadge.BackgroundTransparency = 1
    statusBadge.Position = UDim2.new(0, 12, 0, 5)
    statusBadge.Size = UDim2.new(0, 50, 0, 16)
    statusBadge.Font = Enum.Font.GothamBold
    statusBadge.TextSize = 10
    statusBadge.TextXAlignment = Enum.TextXAlignment.Left
    statusBadge.TextColor3 = state and Color3.fromRGB(74, 222, 128) or Color3.fromRGB(148, 163, 184)
    bindText(statusBadge, function()
        return state and t("[ВКЛ]", "[ON]") or t("[ВЫКЛ]", "[OFF]")
    end)

    local lbl = Instance.new("TextLabel", btn)
    lbl.BackgroundTransparency = 1; lbl.Position = UDim2.new(0,62,0,5); lbl.Size = UDim2.new(0,280,0,16)
    lbl.Font = Enum.Font.GothamBold; lbl.Text = resolveText(name); lbl.TextColor3 = state and Color3.fromRGB(255,255,255) or Color3.fromRGB(203,213,225); lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left
    bindText(lbl, function() return resolveText(name) end)

    local descLbl = Instance.new("TextLabel", btn)
    descLbl.BackgroundTransparency = 1; descLbl.Position = UDim2.new(0,12,0,24); descLbl.Size = UDim2.new(0,330,0,16)
    descLbl.Font = Enum.Font.Gotham; descLbl.Text = resolveText(desc); descLbl.TextColor3 = Color3.fromRGB(148,163,184); descLbl.TextSize = 9; descLbl.TextXAlignment = Enum.TextXAlignment.Left
    bindText(descLbl, function() return resolveText(desc) end)

    local indicator = Instance.new("Frame", btn)
    indicator.AnchorPoint = Vector2.new(1,0.5); indicator.Position = UDim2.new(1,-12,0.5,0); indicator.Size = UDim2.new(0,38,0,20)
    indicator.BackgroundColor3 = state and AccentColor or Color3.fromRGB(51,65,85)
    applyCorner(indicator, 10)

    local dot = Instance.new("Frame", indicator)
    dot.AnchorPoint = Vector2.new(0,0.5); dot.Position = state and UDim2.new(1,-17,0.5,0) or UDim2.new(0,3,0.5,0)
    dot.Size = UDim2.new(0,14,0,14); dot.BackgroundColor3 = Color3.fromRGB(255,255,255)
    applyCorner(dot, 7)

    bindTooltip(clickArea, desc)
    table.insert(accentToggles, {indicator = indicator, getState = function() return state end})

    clickArea.MouseButton1Click:Connect(function()
        state = not state
        statusBadge.Text = state and t("[ВКЛ]", "[ON]") or t("[ВЫКЛ]", "[OFF]")
        statusBadge.TextColor3 = state and Color3.fromRGB(74, 222, 128) or Color3.fromRGB(148, 163, 184)
        lbl.TextColor3 = state and Color3.fromRGB(255,255,255) or Color3.fromRGB(203,213,225)
        tw(indicator, {BackgroundColor3 = state and AccentColor or Color3.fromRGB(51,65,85)}, 0.15):Play()
        tw(dot, {Position = state and UDim2.new(1,-17,0.5,0) or UDim2.new(0,3,0.5,0)}, 0.15):Play()
        callback(state)
    end)
    return btn
end

local function createSlider(page, name, min, max, default, callback, colorAccent, desc)
    local sliderFrame = createGlassPanel(page, 56)
    local lbl = Instance.new("TextLabel", sliderFrame)
    lbl.BackgroundTransparency = 1; lbl.Position = UDim2.new(0,12,0,6); lbl.Size = UDim2.new(0,250,0,16)
    lbl.Font = Enum.Font.GothamBold; lbl.Text = resolveText(name); lbl.TextColor3 = Color3.fromRGB(241,245,249); lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left
    bindText(lbl, function() return resolveText(name) end)

    local valLbl = Instance.new("TextLabel", sliderFrame)
    valLbl.BackgroundTransparency = 1; valLbl.Position = UDim2.new(1,-70,0,6); valLbl.Size = UDim2.new(0,58,0,16)
    valLbl.Font = Enum.Font.GothamBold; valLbl.Text = tostring(default); valLbl.TextColor3 = colorAccent or AccentColor; valLbl.TextSize = 11; valLbl.TextXAlignment = Enum.TextXAlignment.Right
    if not colorAccent then CollectionService:AddTag(valLbl, "AccentText") end

    local BarBG = Instance.new("TextButton", sliderFrame)
    BarBG.BackgroundColor3 = Color3.fromRGB(51,65,85); BarBG.BorderSizePixel = 0; BarBG.Position = UDim2.new(0,12,0,34); BarBG.Size = UDim2.new(1,-24,0,8); BarBG.AutoButtonColor = false; BarBG.Text = ""
    applyCorner(BarBG, 4)

    local BarFill = Instance.new("Frame", BarBG)
    BarFill.BackgroundColor3 = colorAccent or AccentColor; BarFill.BorderSizePixel = 0; BarFill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    applyCorner(BarFill, 4)
    if not colorAccent then CollectionService:AddTag(BarFill, "AccentFill") end

    bindTooltip(BarBG, desc or function()
        return t("Настройка параметра ", "Adjust parameter ") .. resolveText(name)
    end)

    local sdragging = false
    BarBG.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sdragging = true end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sdragging = false end end)
    UserInputService.InputChanged:Connect(function(input)
        if sdragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mousePos = UserInputService:GetMouseLocation()
            local relX = math.clamp((mousePos.X - BarBG.AbsolutePosition.X)/BarBG.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max-min)*relX)
            BarFill.Size = UDim2.new(relX,0,1,0)
            valLbl.Text = tostring(val)
            callback(val)
        end
    end)
    return {fill = BarFill, valLbl = valLbl}
end

local function createColorSwatchGrid(page, presets, onPick, size)
    local Row = Instance.new("Frame", page)
    Row.BackgroundTransparency = 1; Row.Size = UDim2.new(1,0,0, math.ceil(#presets/6) * (size+6) + 6)
    local grid = Instance.new("UIGridLayout", Row)
    grid.CellSize = UDim2.new(0,size,0,size); grid.CellPadding = UDim2.new(0,6,0,6)

    local selectedStroke = nil
    for _, preset in ipairs(presets) do
        local swatch = Instance.new("TextButton", Row)
        swatch.BackgroundColor3 = preset.color; swatch.AutoButtonColor = false; swatch.Text = ""
        applyCorner(swatch, size/2)
        local sStroke = applyStroke(swatch, Color3.fromRGB(255,255,255), 0.6, 1.5)

        bindTooltip(swatch, function()
            return t("Применить цветовой пресет: ", "Apply color preset: ") .. preset.name
        end)

        swatch.MouseButton1Click:Connect(function()
            onPick(preset.color)
            if selectedStroke then tw(selectedStroke, {Transparency = 0.6, Thickness = 1.5}, 0.15):Play() end
            tw(sStroke, {Transparency = 0, Thickness = 2.5}, 0.15):Play()
            selectedStroke = sStroke
        end)
    end
    return Row
end

local function applyAccent(newColor)
    AccentColor = newColor
    for _, inst in ipairs(CollectionService:GetTagged("AccentStroke")) do tw(inst, {Color = newColor}, 0.25):Play() end
    for _, inst in ipairs(CollectionService:GetTagged("AccentFill")) do tw(inst, {BackgroundColor3 = newColor}, 0.25):Play() end
    for _, inst in ipairs(CollectionService:GetTagged("AccentText")) do tw(inst, {TextColor3 = newColor}, 0.25):Play() end
    for _, tog in ipairs(accentToggles) do if tog.getState() then tw(tog.indicator, {BackgroundColor3 = newColor}, 0.25):Play() end end
end

-- Применение темы окна (сплошные фоны, без прозрачности)
local function applyTheme(idx)
    if not UIThemes[idx] then idx = 1 end
    Config.ThemeIndex = idx
    local theme = UIThemes[idx]
    for _, inst in ipairs(CollectionService:GetTagged("ThemeWindow")) do
        tw(inst, {BackgroundColor3 = theme.window, BackgroundTransparency = 0}, 0.25):Play()
    end
    for _, inst in ipairs(CollectionService:GetTagged("ThemeBar")) do
        tw(inst, {BackgroundColor3 = theme.bar, BackgroundTransparency = 0}, 0.25):Play()
    end
    for _, inst in ipairs(CollectionService:GetTagged("ThemeSide")) do
        tw(inst, {BackgroundColor3 = theme.side, BackgroundTransparency = 0}, 0.25):Play()
    end
    for _, inst in ipairs(CollectionService:GetTagged("ThemePanel")) do
        tw(inst, {BackgroundColor3 = theme.panel, BackgroundTransparency = 0}, 0.25):Play()
    end
    applyAccent(theme.accent)
    for name, page in pairs(pages) do
        if page.Visible then switchTab(name) end
    end
end

-- ОБРАБОТЧИКИ ВЫБОРА ЯЗЫКА С ВЫХОДОМ ИЗ МОДАЛЬНОГО ОКНА
local function selectLanguage(lang)
    Config.Language = lang
    applyLanguage() -- живое обновление всех надписей UI
    tw(LangModal, {Size = UDim2.new(0, 480, 0, 0), BackgroundTransparency = 1}, 0.2):Play()
    task.delay(0.2, function()
        LangModal.Visible = false
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0,690,0,0)
        tw(MainFrame, {Size = UDim2.new(0,690,0,520)}, 0.25, Enum.EasingStyle.Quart):Play()
        notify("Fouf32 build 0.21", t("Язык успешно выбран! [Right Shift] — Меню", "Language set to English! [Right Shift] — Menu"), 4)
    end)
end

RuBtn.MouseButton1Click:Connect(function() selectLanguage("RU") end)
EnBtn.MouseButton1Click:Connect(function() selectLanguage("EN") end)

-- ============================================================
-- 1. РАЗДЕЛ: CLICKGUI & CONFIG
-- ============================================================
sectionLabel(clickGuiPage, "LANGUAGE & THEME PRESETS")
createButton(clickGuiPage, "Switch Language / Сменить Язык (RU / EN)", "Переключает язык интерфейса между Русским и English", function()
    Config.Language = (Config.Language == "RU") and "EN" or "RU"
    applyLanguage()
    notify("Fouf32 Language", t("Язык изменен на Русский", "Language changed to English"), 3)
end)

createButton(clickGuiPage, "Switch Theme (Сменить Тему)", function()
    return t("Текущая тема: ", "Current theme: ") .. UIThemes[Config.ThemeIndex].name
        .. t(" — нажмите для следующей (Black → Slate → Midnight → Crimson → Cyberpunk)", " — click for next (Black → Slate → Midnight → Crimson → Cyberpunk)")
end, function()
    local nextIdx = (Config.ThemeIndex % #UIThemes) + 1
    applyTheme(nextIdx)
    notify("Fouf32 Theme", t("Тема: ", "Theme: ") .. UIThemes[nextIdx].name, 2)
end)

local rSlider, gSlider, bSlider
createColorSwatchGrid(clickGuiPage, AccentPresets, function(color)
    applyAccent(color)
    rSlider.fill.Size = UDim2.new(color.R,0,1,0); rSlider.valLbl.Text = tostring(round(color.R*255))
    gSlider.fill.Size = UDim2.new(color.G,0,1,0); gSlider.valLbl.Text = tostring(round(color.G*255))
    bSlider.fill.Size = UDim2.new(color.B,0,1,0); bSlider.valLbl.Text = tostring(round(color.B*255))
end, 36)

sectionLabel(clickGuiPage, "CUSTOM RGB ACCENT")
local currentR, currentG, currentB = AccentColor.R*255, AccentColor.G*255, AccentColor.B*255
local function updateCustomColor()
    local newColor = Color3.fromRGB(round(currentR), round(currentG), round(currentB))
    applyAccent(newColor)
end

rSlider = createSlider(clickGuiPage, "Red Accent", 0, 255, round(currentR), function(v) currentR=v; updateCustomColor() end, Color3.fromRGB(248,113,113), "Красный цвет интерфейса")
gSlider = createSlider(clickGuiPage, "Green Accent", 0, 255, round(currentG), function(v) currentG=v; updateCustomColor() end, Color3.fromRGB(74,222,128), "Зеленый цвет интерфейса")
bSlider = createSlider(clickGuiPage, "Blue Accent", 0, 255, round(currentB), function(v) currentB=v; updateCustomColor() end, Color3.fromRGB(96,165,250), "Синий цвет интерфейса")

sectionLabel(clickGuiPage, "INTERFACE GLASS & SETTINGS")
createToggle(clickGuiPage, "Glow Outline", "Пульсирующая неоновая рамка меню", Config.Glow, function(v)
    Config.Glow = v; tw(MainStroke, {Transparency = v and 0.3 or 0.8}, 0.3):Play()
end)
createSlider(clickGuiPage, "Glass Blur Intensity", 0, 100, Config.GlassIntensity, function(v)
    Config.GlassIntensity = v
    GlassLayer2.BackgroundTransparency = 0.15 + (1 - v/100) * 0.5
end, nil, "Интенсивность размытия стекла")

createToggle(clickGuiPage, "Hover Description Bar", "Отображение описания функций внизу экрана", Config.EnableTooltips, function(v)
    Config.EnableTooltips = v
    DescFooterBar.Visible = v
end)

createButton(clickGuiPage, "Optimize FPS (Smooth Plastic)", "Удаляет текстуры карты для увеличения FPS", function()
    pcall(function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic
            elseif v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
        end
        Lighting.GlobalShadows = false
    end)
    notify("FPS Boost", "Текстуры карты оптимизированы!", 2)
end)

-- Unload кнопка использует общую completeScriptUnload (определена выше, у шапки окна)
createButton(clickGuiPage, "Unload & Terminate Fouf32", "Полная выгрузка скрипта Fouf32 build 0.21 и очистка памяти", completeScriptUnload)

-- ============================================================
-- 2. РАЗДЕЛ: DASHBOARD
-- ============================================================
sectionLabel(dashboardPage, "FOUF32 PLAYER LIVE OVERVIEW")
local StatsPanel = createGlassPanel(dashboardPage, 110)
local StatsText = Instance.new("TextLabel", StatsPanel)
StatsText.BackgroundTransparency = 1; StatsText.Position = UDim2.new(0, 12, 0, 10); StatsText.Size = UDim2.new(1, -24, 1, -20)
StatsText.Font = Enum.Font.GothamMedium; StatsText.TextColor3 = Color3.fromRGB(241,245,249); StatsText.TextSize = 11; StatsText.TextXAlignment = Enum.TextXAlignment.Left; StatsText.TextYAlignment = Enum.TextYAlignment.Top

local dashConn = RunService.RenderStepped:Connect(function()
    if dashboardPage.Visible then
        local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
        local str = leaderstats and leaderstats:FindFirstChild("Strength") and leaderstats.Strength.Value or 0
        local reb = leaderstats and leaderstats:FindFirstChild("Rebirths") and leaderstats.Rebirths.Value or 0
        local agi = leaderstats and leaderstats:FindFirstChild("Agility") and leaderstats.Agility.Value or 0
        local dur = leaderstats and leaderstats:FindFirstChild("Durability") and leaderstats.Durability.Value or 0

        StatsText.Text = string.format("ACCOUNT STATS:\n  • Name: %s (UserId: %d)\n  • Strength: %s | Rebirths: %s\n  • Agility: %s | Durability: %s", LocalPlayer.Name, LocalPlayer.UserId, tostring(str), tostring(reb), tostring(agi), tostring(dur))
    end
end)
table.insert(ScriptConnections, dashConn)

sectionLabel(dashboardPage, "QUICK CHARACTER SIZE PRESETS")
local function setCharacterScale(val)
    Config.PlayerScale = val
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        pcall(function()
            if hum:FindFirstChild("BodyWidthScale") then hum.BodyWidthScale.Value = val end
            if hum:FindFirstChild("BodyHeightScale") then hum.BodyHeightScale.Value = val end
            if hum:FindFirstChild("BodyDepthScale") then hum.BodyDepthScale.Value = val end
            if hum:FindFirstChild("HeadScale") then hum.HeadScale.Value = val end
        end)
    end
    notify("Fouf32 Size", "Масштаб установлен: " .. tostring(val) .. "x", 2)
end

createButton(dashboardPage, "Micro Size (0.1x)", "Делает персонажа незаметным мини-карликом", function() setCharacterScale(0.1) end)
createButton(dashboardPage, "Normal Size (1x)", "Стандартный человеческий размер", function() setCharacterScale(1) end)
createButton(dashboardPage, "Big Muscle (5x)", "Большой накачанный персонаж", function() setCharacterScale(5) end)
createButton(dashboardPage, "Giant Monster (15x)", "Огромный титан на всю карту", function() setCharacterScale(15) end)
createButton(dashboardPage, "Colossal God (30x)", "Колоссальный гигант", function() setCharacterScale(30) end)

createSlider(dashboardPage, "Custom Size Multiplier", 1, 30, 1, function(v) setCharacterScale(v) end, nil, "Точная настройка масштаба персонажа (1x - 30x)")

-- ============================================================
-- 3. РАЗДЕЛ: AUTO FARM / TRAINING
-- ============================================================
sectionLabel(trainingPage, "🔥 AUTO OP - UNIVERSAL TURBO FAST FARM")

createToggle(trainingPage, "Auto OP (Универсальный сумасшедший кликер)", "Сели за ЛЮБОЙ тренажер или взяли ЛЮБОЙ снаряд — мгновенно качает на предельной турбо-скорости!", Config.AutoOpFarm, function(v)
    Config.AutoOpFarm = v
    if v then
        notify("Fouf32 Auto OP", "Auto OP включен! Просто сядьте на тренажер или возьмите снаряд!", 4)
        task.spawn(function()
            while Config.AutoOpFarm do
                local char = LocalPlayer.Character
                if char and char:FindFirstChildOfClass("Humanoid") then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local ev = getMuscleEvent()

                    local isSitting = hum.Sit or (hum.SeatPart ~= nil)
                    local equippedTool = char:FindFirstChildOfClass("Tool")

                    if isSitting or equippedTool then
                        if equippedTool then
                            pcall(function() equippedTool:Activate() end)
                            if string.lower(equippedTool.Name) == "punch" and ev then
                                ev:FireServer("punch", "leftHand")
                                ev:FireServer("punch", "rightHand")
                            end
                        end

                        if isSitting and hum.SeatPart then
                            local seat = hum.SeatPart
                            local mModel = seat:FindFirstAncestorOfClass("Model")
                            if mModel and ev then
                                pcall(function() ev:FireServer("interact", mModel) end)
                            end
                        end

                        if ev then
                            local count = Config.UltraFastRep and (Config.FastRepMultiplier * 10) or (Config.FastRepMultiplier * 3)
                            for i = 1, count do
                                ev:FireServer("rep")
                            end
                        end
                    end
                end
                task.wait(Config.TrainDelay > 0 and Config.TrainDelay or 0.01)
            end
        end)
    end
end)

sectionLabel(trainingPage, "AUTOMATED EXERCISE MACHINES")
createToggle(trainingPage, "Auto Dumbbell Farm", "Авто-фарм Силы через Гантели", Config.AutoDumbbell, function(v)
    Config.AutoDumbbell = v
    if v then
        task.spawn(function()
            while Config.AutoDumbbell do
                trainTool("Dumbbell")
                task.wait(Config.TrainDelay)
            end
        end)
    end
end)

createToggle(trainingPage, "Auto Pushups Farm", "Авто-фарм Силы через Отжимания", Config.AutoPushups, function(v)
    Config.AutoPushups = v
    if v then
        task.spawn(function()
            while Config.AutoPushups do
                trainTool("Pushups")
                task.wait(Config.TrainDelay)
            end
        end)
    end
end)

createToggle(trainingPage, "Auto Situps Farm", "Авто-фарм Силы через Пресс", Config.AutoSitups, function(v)
    Config.AutoSitups = v
    if v then
        task.spawn(function()
            while Config.AutoSitups do
                trainTool("Situps")
                task.wait(Config.TrainDelay)
            end
        end)
    end
end)

createToggle(trainingPage, "Auto Weight Bar Farm", "Авто-фарм Силы через Штангу", Config.AutoWeight, function(v)
    Config.AutoWeight = v
    if v then
        task.spawn(function()
            while Config.AutoWeight do
                trainTool("Weight")
                task.wait(Config.TrainDelay)
            end
        end)
    end
end)

createToggle(trainingPage, "Auto Punching Bag Farm", "Авто-удары по груше/воздуху для прокачки", Config.AutoPunch, function(v)
    Config.AutoPunch = v
    if v then
        task.spawn(function()
            while Config.AutoPunch do
                trainTool("Punch")
                task.wait(Config.TrainDelay)
            end
        end)
    end
end)

createToggle(trainingPage, "Multi-Tool Super Farm (All-in-One)", "Автоматически чередует все снаряды для максимальной прокачки", Config.AutoMultiTool, function(v)
    Config.AutoMultiTool = v
    if v then
        task.spawn(function()
            local tools = {"Dumbbell", "Pushups", "Situps", "Weight"}
            local idx = 1
            while Config.AutoMultiTool do
                trainTool(tools[idx])
                idx = (idx % #tools) + 1
                task.wait(Config.TrainDelay)
            end
        end)
    end
end)

createToggle(trainingPage, "Walk While Training (Ходить во время упражнения)", "Позволяет свободно ходить со штангой, гантелями или во время выполнения упражнений!", Config.WalkWhileTraining, function(v)
    Config.WalkWhileTraining = v
    if v then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
        end
        notify("Fouf32 Walk", "Свободная ходьба во время качания включена!", 2)
        -- Постоянный цикл: не дает игре усадить вас, пока вы держите снаряд.
        -- Тренажеры-сиденья (жим, присед и т.д.) не затрагиваются — снаряд в руках не экипирован.
        task.spawn(function()
            while Config.WalkWhileTraining do
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Sit and char:FindFirstChildOfClass("Tool") then
                    hum.Sit = false
                end
                task.wait(0.2)
            end
        end)
    end
end)

sectionLabel(trainingPage, "GYM MACHINES AUTO-FARM (БЛИЖАЙШИЙ ТРЕНАЖЕР)")

-- Общий движок фарма на тренажере:
--  * серверное подключение: machineInteractRemote:InvokeServer("useMachine", seat)
--  * rep шлётся с аргументом-сиденьем: muscleEvent:FireServer("rep", seat)
--  * чёрный список отказавших машин (60 сек), автоматический re-engage при разрыве
--  * для беговых дорожек (isTreadmill=true): просто стоит на treadmillPart
local function startMachineFarm(configKey, keywords, isTreadmill)
    task.spawn(function()
        local mModel, mSeat, lastFind = nil, nil, 0
        local blacklist = {}
        while Config[configKey] do
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local now = tick()
                local inUse = getMachineInUse()

                local needFind = false
                if not mModel or not mModel.Parent then
                    needFind = true
                elseif (not isTreadmill) and mSeat ~= nil and inUse ~= mSeat then
                    needFind = true -- связь с тренажёром потеряна — переподключаемся
                elseif (now - lastFind) > 1.5 then
                    local okPos, mPos = pcall(function() return mModel:GetPivot().Position end)
                    if okPos and (mPos - hrp.Position).Magnitude > 40 then
                        needFind = true -- унесло дальше 40 стадов — возвращаемся
                    else
                        lastFind = now
                    end
                end

                if needFind and (now - lastFind) > 0.5 then
                    local part, model = findNearestMachine(keywords, blacklist)
                    mModel = model or part
                    mSeat = nil
                    if mModel then
                        if isTreadmill then
                            mSeat = part
                        else
                            mSeat = getMachineSeat(mModel)
                            if not mSeat and part and part:IsA("Seat") then mSeat = part end
                            if mSeat then
                                local okEngage = engageMachine(mModel, mSeat)
                                if not okEngage then
                                    blacklist[mModel] = now + 60
                                    mModel, mSeat = nil, nil
                                end
                            end
                        end
                    end
                    lastFind = now
                end

                -- Позиционирование на беговой дорожке (сервер даёт ловкость за сам факт стояния)
                if isTreadmill and mModel and mSeat and mSeat.Parent then
                    pcall(function()
                        hrp.CFrame = mSeat.CFrame * CFrame.new(0, mSeat.Size.Y / 2 + 3, 0)
                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    end)
                end

                local ev = getMuscleEvent()
                if ev and mModel and mModel.Parent then
                    local count = Config.UltraFastRep and (Config.FastRepMultiplier * 5) or Config.FastRepMultiplier
                    for _ = 1, count do
                        if (not isTreadmill) and mSeat then
                            ev:FireServer("rep", mSeat)
                        else
                            ev:FireServer("rep")
                        end
                    end
                end
            end
            task.wait(Config.TrainDelay > 0 and Config.TrainDelay or 0.05)
        end
        pcall(leaveMachine)
    end)
end

createToggle(trainingPage, "Auto Bench Press (Жим лежа)", "Садится на ближайший жим лежа 1 раз и качает грудь!", Config.AutoBenchPress, function(v)
    Config.AutoBenchPress = v
    if v then
        startMachineFarm("AutoBenchPress", {"bench", "benchpress", "bench press"})
    end
end)

createToggle(trainingPage, "Auto Squat Rack (Приседания)", "Садится на ближайшую стойку приседаний 1 раз и качает ноги!", Config.AutoSquat, function(v)
    Config.AutoSquat = v
    if v then
        startMachineFarm("AutoSquat", {"squat", "squatrack", "squat rack"})
    end
end)

createToggle(trainingPage, "Auto Treadmill (Беговая дорожка)", "Встает на ближайшую беговую дорожку и качает ловкость!", Config.AutoTreadmillMachine, function(v)
    Config.AutoTreadmillMachine = v
    if v then
        startMachineFarm("AutoTreadmillMachine", {"treadmill", "tread"}, true)
    end
end)

createToggle(trainingPage, "Auto Pull-ups (Подтягивания)", "Встает к ближайшему турнику 1 раз и подтягивается!", Config.AutoPullups, function(v)
    Config.AutoPullups = v
    if v then
        startMachineFarm("AutoPullups", {"pullup", "pull-up", "pull up", "bar"})
    end
end)

createToggle(trainingPage, "Auto Boulder Throw (Бросок валуна)", "Подходит к валуну 1 раз и качает броски!", Config.AutoBoulder, function(v)
    Config.AutoBoulder = v
    if v then
        startMachineFarm("AutoBoulder", {"boulder", "boulderthrow", "boulder throw"})
    end
end)

createToggle(trainingPage, "Auto Rock Farm (Камень)", "Телепортируется к ближайшему камню 1 раз и непрерывно бьет!", Config.AutoRockMachine, function(v)
    Config.AutoRockMachine = v
    if v then
        task.spawn(function()
            local rockPart, lastScan, lastTP = nil, 0, 0
            while Config.AutoRockMachine do
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if (tick() - lastScan) > 2 then
                        rockPart = getTargetRockPart("Any")
                        lastScan = tick()
                    end
                    if rockPart and rockPart.Parent and (tick() - lastTP) > 2
                        and (rockPart.Position - hrp.Position).Magnitude > 8 then
                        hrp.CFrame = CFrame.lookAt(rockPart.Position + Vector3.new(0, 2, 4), rockPart.Position)
                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        lastTP = tick()
                    end
                end
                trainTool("Punch")
                task.wait(Config.TrainDelay > 0 and Config.TrainDelay or 0.05)
            end
        end)
    end
end)

createToggle(trainingPage, "ULTRA FAST INSTANT REP MODE (TURBO 100X)", "Ультра-скоростной режим: мгновенный спам ивентов качания без задержки!", Config.UltraFastRep, function(v)
    Config.UltraFastRep = v
    if v then
        notify("Fouf32 Turbo Farm", "Ультра-скоростной фарм включен! (100x Rep Spam)", 3)
    end
end)

createSlider(trainingPage, "Fast Rep Multiplier (1x-100x)", 1, 100, 10, function(v)
    Config.FastRepMultiplier = v
end, nil, "Ускоритель фарма: количество отправляемых пакетов качания за один раз (до 100x)")

createSlider(trainingPage, "Train Delay Speed (sec)", 0, 0.05, Config.TrainDelay, function(v)
    Config.TrainDelay = v
end, nil, "Задержка между повторами (0 = мгновенно)")

-- ============================================================
-- 4. РАЗДЕЛ: ROCKS & GYM MACHINES (ИСПРАВЛЕН ФАРМ КАМНЕЙ)
-- ============================================================
sectionLabel(rocksPage, "AUTO ROCK FARM ENGINE (FIXED)")
local RockInfoLabel = Instance.new("TextLabel", createGlassPanel(rocksPage, 34))
RockInfoLabel.BackgroundTransparency = 1; RockInfoLabel.Position = UDim2.new(0, 12, 0, 0); RockInfoLabel.Size = UDim2.new(1, -24, 1, 0)
RockInfoLabel.Font = Enum.Font.GothamBold; RockInfoLabel.TextColor3 = Color3.fromRGB(94, 234, 212); RockInfoLabel.TextSize = 11; RockInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
RockInfoLabel.Text = "Selected Rock Tier: Any"

createToggle(rocksPage, "Auto Farm Selected Rock", "Телепортируется к камню 1 раз и непрерывно бьет!", Config.AutoRock, function(v)
    Config.AutoRock = v
    if v then
        task.spawn(function()
            local rockPart, lastScan, lastTP = nil, 0, 0
            while Config.AutoRock do
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if (tick() - lastScan) > 2 then
                        rockPart = getTargetRockPart(Config.SelectedRockTier)
                        lastScan = tick()
                    end
                    if rockPart and rockPart.Parent and (tick() - lastTP) > 2
                        and (rockPart.Position - hrp.Position).Magnitude > 8 then
                        hrp.CFrame = CFrame.lookAt(rockPart.Position + Vector3.new(0, 2, 4), rockPart.Position)
                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        lastTP = tick()
                    end
                end

                if char and char:FindFirstChildOfClass("Humanoid") then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local punch = LocalPlayer.Backpack:FindFirstChild("Punch") or char:FindFirstChild("Punch")
                    if punch and punch.Parent == LocalPlayer.Backpack then
                        hum:EquipTool(punch)
                    end
                    if punch then pcall(function() punch:Activate() end) end

                    local ev = getMuscleEvent()
                    if ev then
                        ev:FireServer("punch", "leftHand")
                        ev:FireServer("punch", "rightHand")
                        for i = 1, Config.FastRepMultiplier do
                            ev:FireServer("rep")
                        end
                    end
                end
                task.wait(Config.TrainDelay > 0 and Config.TrainDelay or 0.05)
            end
        end)
    end
end)

createToggle(rocksPage, "Auto Treadmill Farm (Agility)", "Телепортируется на беговую дорожку 1 раз и качает ловкость!", Config.AutoTreadmill, function(v)
    Config.AutoTreadmill = v
    if v then
        task.spawn(function()
            local treadPart, lastScan, lastTP = nil, 0, 0
            while Config.AutoTreadmill do
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if not treadPart or not treadPart.Parent or (tick() - lastScan) > 5 then
                        treadPart = findNearestMachine({"treadmill", "tread"})
                        lastScan = tick()
                    end
                    if treadPart and treadPart.Parent and (tick() - lastTP) > 2
                        and (treadPart.Position - hrp.Position).Magnitude > 8 then
                        safeTeleport(treadPart.CFrame * CFrame.new(0, 3, 0))
                        lastTP = tick()
                    end
                end
                local ev = getMuscleEvent()
                if ev then ev:FireServer("rep") end
                task.wait(Config.TrainDelay > 0 and Config.TrainDelay or 0.05)
            end
        end)
    end
end)

sectionLabel(rocksPage, "SELECT ROCK TIER (ТОЧНЫЕ ТРЕБОВАНИЯ)")
for _, rData in ipairs(rockTiers) do
    createButton(rocksPage, rData[1] .. " [" .. rData[2] .. "]", function()
        return t("Выбрать ", "Select ") .. rData[1] .. t(" для фарминга", " for farming")
    end, function()
        Config.SelectedRockTier = rData[3]
        RockInfoLabel.Text = "Selected Rock Tier: " .. rData[1] .. " (" .. rData[2] .. ")"
        notify("Fouf32 Rock", "Выбран камень: " .. rData[1], 2)
    end)
end

-- ============================================================
-- 5. РАЗДЕЛ: COMBAT & KILLAURA
-- ============================================================
sectionLabel(combatPage, "ADVANCED KILL AURA ENGINE (BRING & BEAT)")

local KillAuraStatusLabel = Instance.new("TextLabel", createGlassPanel(combatPage, 34))
KillAuraStatusLabel.BackgroundTransparency = 1; KillAuraStatusLabel.Position = UDim2.new(0, 12, 0, 0); KillAuraStatusLabel.Size = UDim2.new(1, -24, 1, 0)
KillAuraStatusLabel.Font = Enum.Font.GothamBold; KillAuraStatusLabel.TextColor3 = Color3.fromRGB(94, 234, 212); KillAuraStatusLabel.TextSize = 11; KillAuraStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
KillAuraStatusLabel.Text = "Kill Aura Mode: Bring To Me (Телепорт врагов к себе)"

createButton(combatPage, "Mode 1: Bring Target To Me (Телепортировать врага к себе)", "Притягивает/телепортирует корпус врага прямо перед вашими кулаками и бьет!", function()
    Config.KillAuraMode = "Bring To Me"
    KillAuraStatusLabel.Text = "Kill Aura Mode: Bring To Me (Телепорт врагов к себе)"
    notify("Fouf32 Killaura", "Режим: Притягивать врагов к себе и бить!", 2)
end)

createButton(combatPage, "Mode 2: Magnet TP To Target (Телепортироваться к врагу)", "Мгновенно телепортирует вас за спину / в лицо врагу и наносит удары", function()
    Config.KillAuraMode = "Magnet TP to Target"
    KillAuraStatusLabel.Text = "Kill Aura Mode: Magnet TP to Target (Телепорт к врагу)"
    notify("Fouf32 Killaura", "Режим: Телепортироваться к врагам и бить!", 2)
end)

createButton(combatPage, "Mode 3: Orbit Target (Орбита вокруг цели)", "Вращается по кругу вокруг цели и наносит серии ударов", function()
    Config.KillAuraMode = "Orbit Target"
    KillAuraStatusLabel.Text = "Kill Aura Mode: Orbit Target (Орбита вокруг цели)"
    notify("Fouf32 Killaura", "Режим: Орбита вокруг врагов!", 2)
end)

createToggle(combatPage, "Enable Kill Aura (Auto Hit & Teleport)", "Активирует Kill Aura: бьет, телепортирует врагов прямо к вам или телепортируется к ним!", Config.KillAura, function(v)
    Config.KillAura = v
    if v then
        task.spawn(function()
            local angle = 0
            while Config.KillAura do
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
                    local myHrp = char.HumanoidRootPart
                    local myHum = char:FindFirstChildOfClass("Humanoid")

                    if myHum.Health > 0 then
                        local punch = LocalPlayer.Backpack:FindFirstChild("Punch") or char:FindFirstChild("Punch")
                        if punch and punch.Parent == LocalPlayer.Backpack then
                            myHum:EquipTool(punch)
                        end
                        if punch then pcall(function() punch:Activate() end) end

                        local ev = getMuscleEvent()

                        for _, otherPlayer in pairs(Players:GetPlayers()) do
                            if otherPlayer ~= LocalPlayer and otherPlayer.Character then
                                local oChar = otherPlayer.Character
                                local oHrp = oChar:FindFirstChild("HumanoidRootPart")
                                local oHum = oChar:FindFirstChildOfClass("Humanoid")
                                local ff = oChar:FindFirstChildOfClass("ForceField")

                                if oHrp and oHum and oHum.Health > 0 and not ff then
                                    local dist = (oHrp.Position - myHrp.Position).Magnitude
                                    if dist <= Config.KillAuraRange then
                                        if ev then
                                            for i = 1, Config.PunchMultiplier do
                                                ev:FireServer("punch", "leftHand")
                                                ev:FireServer("punch", "rightHand")
                                            end
                                        end

                                        if Config.KillAuraMode == "Bring To Me" then
                                            -- сервер не позволяет двигать чужого игрока —
                                            -- телепортируемся сами вплотную перед целью и бьём
                                            pcall(function()
                                                myHrp.CFrame = CFrame.lookAt(
                                                    oHrp.Position - oHrp.CFrame.LookVector * 2.5 + Vector3.new(0, 1, 0),
                                                    oHrp.Position)
                                                myHrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                            end)
                                        elseif Config.KillAuraMode == "Magnet TP to Target" then
                                            safeTeleport(oHrp.CFrame * CFrame.new(0, 0, 2.5))
                                        elseif Config.KillAuraMode == "Orbit Target" then
                                            angle = angle + 0.3
                                            local offset = Vector3.new(math.sin(angle) * 4, 1, math.cos(angle) * 4)
                                            safeTeleport(CFrame.new(oHrp.Position + offset, oHrp.Position))
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait(Config.KillAuraDelay)
            end
        end)
    end
end)

createSlider(combatPage, "Kill Aura Range (Studs)", 5, 150, Config.KillAuraRange, function(v) Config.KillAuraRange = v end, nil, "Радиус в студах для обнаружения и телепортации врагов")
createSlider(combatPage, "Punch Hit Speed (ms)", 10, 100, 30, function(v) Config.KillAuraDelay = v / 1000 end, nil, "Задержка ударов в миллисекундах")
createSlider(combatPage, "Punch Event Multiplier (1x-10x)", 1, 10, 2, function(v) Config.PunchMultiplier = v end, nil, "Количество отправляемых пакетов ударов за итерацию")

sectionLabel(combatPage, "PLAYER TARGETING & SERVER DESTRUCTION")
local TargetInfoLbl = Instance.new("TextLabel", createGlassPanel(combatPage, 34))
TargetInfoLbl.BackgroundTransparency = 1; TargetInfoLbl.Position = UDim2.new(0, 12, 0, 0); TargetInfoLbl.Size = UDim2.new(1, -24, 1, 0)
TargetInfoLbl.Font = Enum.Font.GothamBold; TargetInfoLbl.TextColor3 = Color3.fromRGB(94, 234, 212); TargetInfoLbl.TextSize = 11; TargetInfoLbl.TextXAlignment = Enum.TextXAlignment.Left
TargetInfoLbl.Text = "Selected Target: None Selected"

createButton(combatPage, "Select Nearest Player as Target", "Выбирает ближайшего к вам игрока в качестве цели", function()
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    local myPos = myChar.HumanoidRootPart.Position
    local nearestP, minDist = nil, math.huge

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (p.Character.HumanoidRootPart.Position - myPos).Magnitude
            if dist < minDist then
                minDist = dist
                nearestP = p
            end
        end
    end

    if nearestP then
        Config.SelectedTargetPlayer = nearestP
        TargetInfoLbl.Text = "Selected Target: " .. nearestP.Name
        notify("Fouf32 Target", "Выбран цель: " .. nearestP.Name, 2)
    end
end)

createButton(combatPage, "Bring Selected Target to Me", "Притягивает выбранного игрока прямо к вашим кулакам", function()
    if Config.SelectedTargetPlayer and Config.SelectedTargetPlayer.Character and Config.SelectedTargetPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        pcall(function()
            Config.SelectedTargetPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
        end)
        notify("Fouf32 Target", "Игрок притянут к вам!", 2)
    end
end)

createToggle(combatPage, "Loop Kill Selected Target", "Непрерывно бьет и телепортирует выбранного игрока", Config.TargetLoopKill, function(v)
    Config.TargetLoopKill = v
    if v then
        task.spawn(function()
            while Config.TargetLoopKill do
                if Config.SelectedTargetPlayer and Config.SelectedTargetPlayer.Character and Config.SelectedTargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local tHrp = Config.SelectedTargetPlayer.Character.HumanoidRootPart
                    local tHum = Config.SelectedTargetPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if tHum and tHum.Health > 0 then
                        safeTeleport(tHrp.CFrame * CFrame.new(0, 0, 2.5))
                        local ev = getMuscleEvent()
                        if ev then
                            ev:FireServer("punch", "leftHand")
                            ev:FireServer("punch", "rightHand")
                        end
                    end
                end
                task.wait(0.05)
            end
        end)
    end
end)

createToggle(combatPage, "Auto Kill Entire Server", "Зацикленный авто-телепорт по всем игрокам сервера и их уничтожение", Config.AutoKillServer, function(v)
    Config.AutoKillServer = v
    if v then
        task.spawn(function()
            while Config.AutoKillServer do
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") then
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        local hrp = p.Character.HumanoidRootPart
                        local ff = p.Character:FindFirstChildOfClass("ForceField")

                        if hum.Health > 0 and not ff and Config.AutoKillServer then
                            safeTeleport(hrp.CFrame * CFrame.new(0, 0, 2.5))
                            local ev = getMuscleEvent()
                            if ev then
                                ev:FireServer("punch", "leftHand")
                                ev:FireServer("punch", "rightHand")
                            end
                            task.wait(0.08)
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

createToggle(combatPage, "Auto Join & Win Brawls", "Авто-вход на Brawl турниры сервера и немедленная победа", Config.AutoBrawl, function(v)
    Config.AutoBrawl = v
    if v then
        task.spawn(function()
            while Config.AutoBrawl do
                local joinEvent = ReplicatedStorage:FindFirstChild("joinBrawl") or LocalPlayer:FindFirstChild("joinBrawl")
                if joinEvent then joinEvent:FireServer() end
                task.wait(2)
            end
        end)
    end
end)

sectionLabel(combatPage, "LEGEND BOSS KILLER ENGINE (GODMODE & FAST ATTACK)")

local BOSS_TARGET_FOLDERS = {
    "bossFolder", "BossFolder", "Bosses", "Boss",
    "enemies", "Enemies", "mobs", "Mobs",
    "battleIsland", "BattleIsland", "warriors", "Warriors",
}
local BOSS_NAME_KEYWORDS = {
    "boss", "босс", "evil", "king", "warrior", "brute", "titan",
    "champion", "monster", "giant", "fighter", "bandit", "enemy",
    "warlord", "overlord", "chief", "colossus", "juggernaut", "million",
}
local BOSS_NAME_EXCLUDES = {
    "statue", "portal", "gate", "leaderboard", "display", "decor",
    "island", "beach", "gym", "ring", "quest", "trainer", "merchant",
    "vendor", "shop", "guide", "villager", "pet", "animal", "rock",
    "bench", "squat", "tread", "pull", "boulder", "dummy",
}

local function getActiveBoss()
    local char = LocalPlayer.Character
    local myPos = char and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart.Position
    local bestModel, bestHum, bestHrp, bestDist = nil, nil, nil, math.huge

    local function consider(obj)
        if not obj:IsA("Model") then return end
        if Players:GetPlayerFromCharacter(obj) then return end
        local n = string.lower(obj.Name)
        for _, ex in ipairs(BOSS_NAME_EXCLUDES) do
            if string.find(n, ex) then return end
        end
        local hum = obj:FindFirstChildOfClass("Humanoid")
        local hrp = obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart")
            or obj:FindFirstChild("Torso") or obj:FindFirstChildWhichIsA("BasePart")
        if hum and hum.Health > 0 and hrp then
            local dist = myPos and (hrp.Position - myPos).Magnitude or 0
            if dist < bestDist then
                bestModel, bestHum, bestHrp, bestDist = obj, hum, hrp, dist
            end
        end
    end

    local function nameMatches(n)
        for _, kw in ipairs(BOSS_NAME_KEYWORDS) do
            if string.find(n, kw) then return true end
        end
        return false
    end

    -- 1) Игровые папки с врагами / боссами (внутри — любые живые модели)
    for _, fName in ipairs(BOSS_TARGET_FOLDERS) do
        local folder = Workspace:FindFirstChild(fName)
        if folder then
            for _, obj in pairs(folder:GetDescendants()) do
                consider(obj)
            end
        end
    end

    -- 2) Модели с ключевыми словами в имени по всему Workspace
    if not bestModel then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and nameMatches(string.lower(obj.Name)) then
                consider(obj)
            end
        end
    end

    return bestModel, bestHum, bestHrp
end

createToggle(combatPage, "Auto Farm Boss (Godmode Safe TP & Fast Beat)", "Авто-фарм Босса: позиция у босса + без урона по вам + быстрая атака!", Config.AutoKillBoss, function(v)
    Config.AutoKillBoss = v
    if v then
        notify("Fouf32 Boss", t("Авто-фарм Босса включен! Наведение...", "Boss auto farm enabled! Targeting..."), 3)
        task.spawn(function()
            local notifiedNoBoss = false
            local lastTargetName = nil
            local cachedBoss, cachedHum, cachedHrp, lastSearch = nil, nil, nil, 0
            while Config.AutoKillBoss do
                local myChar = LocalPlayer.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") and myChar:FindFirstChildOfClass("Humanoid") then
                    local myHrp = myChar.HumanoidRootPart
                    local myHum = myChar:FindFirstChildOfClass("Humanoid")

                    for _, p in pairs(myChar:GetChildren()) do
                        if p:IsA("BasePart") then p.CanTouch = false end
                    end
                    myHum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    myHum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)

                    -- пересканировать мир не чаще раза в секунду (кэш цели)
                    if (tick() - lastSearch) > 1
                        or not cachedBoss or not cachedBoss.Parent
                        or not cachedHum or cachedHum.Health <= 0 then
                        cachedBoss, cachedHum, cachedHrp = getActiveBoss()
                        lastSearch = tick()
                    end
                    local bossModel, bossHum, bossHrp = cachedBoss, cachedHum, cachedHrp

                    if bossModel and bossModel.Parent and bossHrp and bossHum and bossHum.Health > 0 then
                        notifiedNoBoss = false
                        if lastTargetName ~= bossModel.Name then
                            lastTargetName = bossModel.Name
                            notify("Fouf32 Boss", t("Цель захвачена: ", "Target acquired: ") .. bossModel.Name, 3)
                        end

                        local punch = LocalPlayer.Backpack:FindFirstChild("Punch") or myChar:FindFirstChild("Punch")
                        if punch and punch.Parent == LocalPlayer.Backpack then
                            myHum:EquipTool(punch)
                        end
                        if punch then pcall(function() punch:Activate() end) end

                        myHrp.CFrame = CFrame.lookAt(bossHrp.Position + (bossHrp.CFrame.LookVector * -2.5) + Vector3.new(0, 1, 0), bossHrp.Position)
                        myHrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                        local ev = getMuscleEvent()
                        if ev then
                            for i = 1, Config.BossHitMultiplier do
                                ev:FireServer("punch", "leftHand")
                                ev:FireServer("punch", "rightHand")
                            end
                        end
                        pcall(function()
                            local rEvents = ReplicatedStorage:FindFirstChild("rEvents")
                            if rEvents and rEvents:FindFirstChild("punchEvent") then
                                rEvents.punchEvent:FireServer("rightHand")
                                rEvents.punchEvent:FireServer("leftHand")
                            end
                        end)
                    else
                        lastTargetName = nil
                        if not notifiedNoBoss then
                            notify("Fouf32 Boss", t("Ожидание спавна Босса на карте...", "Waiting for boss spawn..."), 3)
                            notifiedNoBoss = true
                        end
                        task.wait(1.5)
                    end
                end
                task.wait(0.04)
            end
        end)
    else
        if LocalPlayer.Character then
            for _, p in pairs(LocalPlayer.Character:GetChildren()) do
                if p:IsA("BasePart") then p.CanTouch = true end
            end
        end
    end
end)

createSlider(combatPage, "Boss Hit Multiplier (1x-20x)", 1, 20, 5, function(v)
    Config.BossHitMultiplier = v
end, nil, "Количество ударов по боссу за один цикл")

-- ============================================================
-- 6. РАЗДЕЛ: PROTECTION
-- ============================================================
sectionLabel(protectionPage, "SAFETY & DEFENSE MODS")
local antiConn
createToggle(protectionPage, "Godmode / Anti-Hit", "Отключает коллизии урона персонажа (защита от чужих ударов)", Config.AntiHit, function(v)
    Config.AntiHit = v
    if v then
        antiConn = RunService.Stepped:Connect(function()
            if Config.AntiHit and LocalPlayer.Character then
                for _, p in pairs(LocalPlayer.Character:GetChildren()) do
                    if p:IsA("BasePart") then p.CanTouch = false end
                end
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                end
            end
        end)
        table.insert(ScriptConnections, antiConn)
    else
        if antiConn then antiConn:Disconnect() end
        if LocalPlayer.Character then
            for _, p in pairs(LocalPlayer.Character:GetChildren()) do
                if p:IsA("BasePart") then p.CanTouch = true end
            end
        end
    end
end)

createToggle(protectionPage, "Auto Low HP Sky Safe TP", "Автоматически телепортирует в небесную зону безопасности при падении HP ниже 25%", Config.AutoSafeTPLowHP, function(v)
    Config.AutoSafeTPLowHP = v
end)

createToggle(protectionPage, "Anti-Ragdoll & Stun", "Запрет падений и станов", Config.AntiRagdoll, function(v)
    Config.AntiRagdoll = v
    if v then
        task.spawn(function()
            while Config.AntiRagdoll do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                end
                task.wait(0.5)
            end
        end)
    end
end)

createToggle(protectionPage, "Anti-Knockback", "Отключает отбрасывание при ударах", Config.AntiKnockback, function(v)
    Config.AntiKnockback = v
end)

createButton(protectionPage, "Teleport to Sky Safe Zone", "Спавнит небесную платформу и телепортирует вас туда", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local p = Workspace:FindFirstChild("Fouf32_SafePlatform")
        if not p then
            p = Instance.new("Part")
            p.Name = "Fouf32_SafePlatform"
            p.Size = Vector3.new(60, 2, 60)
            p.Position = Vector3.new(0, 5000, 0)
            p.Anchored = true
            p.Material = Enum.Material.SmoothPlastic
            p.Color = AccentColor
            p.Parent = Workspace
        end
        safeTeleport(CFrame.new(0, 5005, 0))
        notify("Fouf32 Safe Zone", "Успешный телепорт на небесную платформу!", 3)
    end
end)

-- ============================================================
-- 7. РАЗДЕЛ: TELEPORTS & POINTS
-- ============================================================
sectionLabel(teleportsPage, "WORLD TELEPORTS (ALL 11 ISLANDS)")

local locationDisplayList = {
    {"Spawn Beach", "0 Rebirths / Старт"},
    {"Tiny Island", "0 Rebirths / 100 Str"},
    {"Legend Beach", "0 Rebirths / 5K Str"},
    {"Frost Gym (5 Rebirths)", "5 Перерождений"},
    {"Mythic Gym (15 Reb)", "15 Перерождений"},
    {"Jungle Gym (60 Reb)", "60 Перерождений (Тренажерный зал Джунглей)"},
    {"Industrial Gym (150 Reb)", "150 Перерождений (Промышленный спортзал)"},
    {"Eternal Gym (300 Reb)", "300 Перерождений"},
    {"Legend Gym (3K Reb)", "3,000 Перерождений"},
    {"Muscle King Gym (30K)", "30,000 Перерождений"},
    {"Overcharged Gym (100K)", "100,000 Перерождений"}
}

for _, loc in ipairs(locationDisplayList) do
    createButton(teleportsPage, loc[1] .. " [" .. loc[2] .. "]", function()
        return t("Безопасный умный телепорт на ", "Safe smart teleport to ") .. loc[1]
    end, function()
        smartTeleportToIsland(loc[1])
    end)
end

sectionLabel(teleportsPage, "WAYPOINTS & PLAYER TELEPORT")
local WaypointLabel = Instance.new("TextLabel", createGlassPanel(teleportsPage, 34))
WaypointLabel.BackgroundTransparency = 1; WaypointLabel.Position = UDim2.new(0, 12, 0, 0); WaypointLabel.Size = UDim2.new(1, -24, 1, 0)
WaypointLabel.Font = Enum.Font.GothamBold; WaypointLabel.TextColor3 = Color3.fromRGB(94, 234, 212); WaypointLabel.TextSize = 11; WaypointLabel.TextXAlignment = Enum.TextXAlignment.Left
WaypointLabel.Text = "Saved Waypoint: None"

createButton(teleportsPage, "Save Current Position as Waypoint", "Сохраняет вашу текущую позицию в память", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        Config.SavedWaypoint = LocalPlayer.Character.HumanoidRootPart.CFrame
        local p = Config.SavedWaypoint.Position
        WaypointLabel.Text = string.format("Saved Waypoint: (%.0f, %.0f, %.0f)", p.X, p.Y, p.Z)
        notify("Fouf32 Waypoint", "Позиция успешно сохранена!", 2)
    end
end)

createButton(teleportsPage, "Teleport to Saved Waypoint", "Телепортирует на ранее сохраненную точку", function()
    if Config.SavedWaypoint then
        safeTeleport(Config.SavedWaypoint)
        notify("Fouf32 Waypoint", "Телепортирован на сохраненную точку!", 2)
    else
        notify("Fouf32 Waypoint", "Нет сохраненной точки!", 2)
    end
end)

createButton(teleportsPage, "Teleport to Strongest Player", "Телепортирует к игроку с максимальной силой на сервере", function()
    local topP, maxStr = nil, -1
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local ls = p:FindFirstChild("leaderstats")
            local str = ls and ls:FindFirstChild("Strength") and ls.Strength.Value or 0
            if str > maxStr then
                maxStr = str
                topP = p
            end
        end
    end
    if topP and topP.Character and topP.Character:FindFirstChild("HumanoidRootPart") then
        safeTeleport(topP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
        notify("Fouf32 TP", "Телепортирован к топ-игроку: " .. topP.Name, 2)
    end
end)

-- ============================================================
-- 8. РАЗДЕЛ: AUTOMATION & EGGS
-- ============================================================
sectionLabel(automationPage, "REBIRTH ENGINE (MUSCLE LEGENDS)")

-- Сохранение позиции перед ребиртом и возврат после телепорта на спавн
local rebirthRestoreActive = false

local function savePositionForRebirth()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    return hrp and hrp.CFrame or nil
end

local function restorePositionAfterRebirth(savedCF)
    if not Config.StayAfterRebirth or not savedCF then return end
    if rebirthRestoreActive then return end
    rebirthRestoreActive = true
    task.spawn(function()
        local t0 = tick()
        while tick() - t0 < 8 do
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local dist = (hrp.Position - savedCF.Position).Magnitude
                if dist > 15 then
                    pcall(function()
                        hrp.CFrame = savedCF
                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    end)
                    task.wait(0.4)
                else
                    rebirthRestoreActive = false
                    return
                end
            end
            task.wait(0.2)
        end
        rebirthRestoreActive = false
    end)
end

local function triggerRebirth()
    local savedCF = savePositionForRebirth()
    local done = false

    -- 1. Канонический ремоут игры: rEvents.rebirthRemote:InvokeServer("rebirthRequest")
    pcall(function()
        local rb = getREvent("rebirthRemote")
        if rb and rb:IsA("RemoteFunction") then
            local res = rb:InvokeServer("rebirthRequest")
            if res == true then done = true end
        end
    end)

    -- 2. Фолбэк: muscleEvent
    if not done then
        local ev = getMuscleEvent()
        if ev then
            pcall(function() ev:FireServer("rebirthRequest") end)
            pcall(function() ev:FireServer("rebirth") end)
            pcall(function() ev:FireServer("requestRebirth") end)
        end
    end

    -- 3. Остальные ремоуты с "rebirth" в имени (только если основной не ответил)
    if not done then
        pcall(function()
            local rEvents = ReplicatedStorage:FindFirstChild("rEvents")
            if rEvents then
                for _, child in pairs(rEvents:GetChildren()) do
                    if string.find(string.lower(child.Name), "rebirth") then
                        if child:IsA("RemoteFunction") and child.Name ~= "rebirthRemote" then
                            pcall(function() child:InvokeServer("rebirthRequest") end)
                        elseif child:IsA("RemoteEvent") then
                            pcall(function() child:FireServer("rebirthRequest") end)
                        end
                    end
                end
            end
        end)
    end

    -- Возврат на исходную точку вместо спавна
    if Config.StayAfterRebirth then
        restorePositionAfterRebirth(savedCF)
    end
    return done
end

createToggle(automationPage, "Auto Rebirth (Бесконечный авто-ребирт)", "Автоматически выполняет перерождение сразу при достижении нужного количества силы", Config.AutoRebirth, function(v)
    Config.AutoRebirth = v
    if v then
        task.spawn(function()
            while Config.AutoRebirth do
                local char = LocalPlayer.Character
                local busy = (char and char:GetAttribute("IsRebirthing") == true)
                    or (LocalPlayer:GetAttribute("LastMapCFrame") ~= nil)
                if not busy then
                    triggerRebirth()
                end
                task.wait(0.4)
            end
        end)
    end
end)

createToggle(automationPage, "Stay In Place After Rebirth (Не телепортовать на спавн)", "Сохраняет вашу позицию до перерождения и возвращает вас обратно после него", Config.StayAfterRebirth, function(v)
    Config.StayAfterRebirth = v
    notify("Fouf32 Rebirth", v
        and t("После ребирта вы останетесь на месте!", "After rebirth you will stay in place!")
        or t("После ребирта будет обычный телепорт на спавн.", "Normal spawn teleport after rebirth."), 3)
end)

createButton(automationPage, "Manual Rebirth (Переродиться прямо сейчас)", "Принудительно запрашивает перерождение на сервере через все каналы", function()
    triggerRebirth()
    notify("Fouf32 Rebirth", t("Запрос на перерождение отправлен!", "Rebirth requested!"), 2)
end)

sectionLabel(automationPage, "CHESTS & ORBS MAGNET")
createButton(automationPage, "Collect All Map Chests", "Авто-телепорт по всем сундукам карты и их сбор", function()
    local count = 0
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and string.find(string.lower(obj.Name), "chest") then
            local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if part and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                safeTeleport(part.CFrame)
                count = count + 1
                task.wait(0.3)
            end
        end
    end
    notify("Chests", "Собрано сундуков: " .. tostring(count), 3)
end)

createToggle(automationPage, "Auto Collect Map Orbs", "Автоматически притягивает/собирает сферы со всей карты", Config.AutoCollectOrbs, function(v)
    Config.AutoCollectOrbs = v
    if v then
        task.spawn(function()
            while Config.AutoCollectOrbs do
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    for _, obj in pairs(Workspace:GetChildren()) do
                        if string.find(string.lower(obj.Name), "orb") then
                            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                            if part then
                                part.CFrame = char.HumanoidRootPart.CFrame
                            end
                        end
                    end
                end
                task.wait(0.2)
            end
        end)
    end
end)

sectionLabel(automationPage, "MASS EGG HATCHER (ДО 500 ЗА РАЗ)")

-- Динамический каталог кристаллов из самой игры (обновления не ломают список)
local function getCrystalCatalog()
    local names = {}
    pcall(function()
        local shared = ReplicatedStorage:WaitForChild("shared", 5)
        local catalogs = shared and shared:WaitForChild("catalogs", 5)
        local prices = catalogs and catalogs:WaitForChild("crystalPrices", 5)
        if prices then
            for _, entry in pairs(prices:GetChildren()) do
                table.insert(names, entry.Name)
            end
        end
    end)
    table.sort(names)
    if #names == 0 then names = crystalsList end
    return names
end

local function listContains(list, value)
    for _, v in ipairs(list) do
        if v == value then return true end
    end
    return false
end

local crystalCatalog = getCrystalCatalog()
if not listContains(crystalCatalog, Config.SelectedCrystal) then
    Config.SelectedCrystal = crystalCatalog[1] or "Blue Crystal"
end

local function getCrystalPrice(name)
    local ok, price, kind = pcall(function()
        local shared = ReplicatedStorage:FindFirstChild("shared")
        local catalogs = shared and shared:FindFirstChild("catalogs")
        local prices = catalogs and catalogs:FindFirstChild("crystalPrices")
        local entry = prices and prices:FindFirstChild(name)
        if not entry then return nil, nil end
        local p = entry:FindFirstChild("price")
        local k = entry:FindFirstChild("priceType")
        return p and tonumber(p.Value) or nil, k and k.Value or "Gems"
    end)
    if ok then return price, kind end
    return nil, nil
end

-- Статус-строка: кристалл / места в инвентаре / гемы / текущее количество
local HatchStatusPanel = createGlassPanel(automationPage, 34)
local HatchStatusLabel = Instance.new("TextLabel", HatchStatusPanel)
HatchStatusLabel.BackgroundTransparency = 1
HatchStatusLabel.Position = UDim2.new(0, 12, 0, 0)
HatchStatusLabel.Size = UDim2.new(1, -24, 1, 0)
HatchStatusLabel.Font = Enum.Font.GothamBold
HatchStatusLabel.TextColor3 = Color3.fromRGB(241, 245, 249)
HatchStatusLabel.TextSize = 11
HatchStatusLabel.TextXAlignment = Enum.TextXAlignment.Left

local function refreshHatchStatus()
    local free, owned, cap = freePetSlots()
    local gems = getCurrency("Gems") or 0
    local slotText
    if free then
        slotText = t("места: ", "slots: ") .. owned .. "/" .. cap
            .. t(" (свободно ", " (free ") .. free .. ")"
    else
        slotText = t("петов: ", "pets: ") .. owned
            .. t(" (вместимость неизвестна — ограничение по отказу сервера)", " (capacity unknown — server denial will stop us)")
    end
    HatchStatusLabel.Text = t("Кристалл: ", "Crystal: ") .. Config.SelectedCrystal
        .. " | " .. slotText
        .. " | " .. t("Гемы: ", "Gems: ") .. tostring(gems)
        .. " | " .. t("Открыть: ", "Hatch: ") .. tostring(Config.HatchCount)
end

-- Проверка количества перед массовым открытием: 1..500, места в инвентаре, валюта
local function validateHatchCount(count)
    count = math.floor(tonumber(count) or 0)
    if count < 1 then
        return nil, t("Минимум — 1 яйцо!", "Minimum is 1 egg!")
    end
    if count > 500 then
        return nil, t("Максимум — 500 яиц за один раз!", "Maximum is 500 eggs at once!")
    end

    local free, owned, cap = freePetSlots()
    if free and count > free then
        return nil, string.format(
            t("Свободно только %d мест (занято %d из %d), а запрошено %d! Уменьшите количество.",
              "Only %d free slots (used %d of %d) but %d requested! Reduce the amount."),
            free, owned, cap, count)
    end

    local price, kind = getCrystalPrice(Config.SelectedCrystal)
    if price and price > 0 then
        local balance = getCurrency(kind)
        if balance then
            if balance < price then
                return nil, string.format(
                    t("Не хватает валюты: нужно %d %s, у вас %d.",
                      "Not enough currency: need %d %s, you have %d."),
                    price, kind or "Gems", balance)
            end
            local affordable = math.floor(balance / price)
            if count > affordable then
                return nil, string.format(
                    t("Хватит только на %d из %d яиц (цена %d %s, баланс %d).",
                      "Enough for only %d of %d eggs (price %d %s, balance %d)."),
                    affordable, count, price, kind or "Gems", balance)
            end
        end
    end
    return count, nil
end

-- Массовое вылупление: count яиц подряд (отмена — повторным нажатием или Stop)
local hatchState = {running = false, cancel = false}

local function hatchBatch(count)
    if hatchState.running then
        hatchState.cancel = true
        notify("Fouf32 Hatch", t("Массовое вылупление останавливается...", "Stopping mass hatch..."), 2)
        return
    end
    local n, err = validateHatchCount(count)
    if not n then
        notify("Fouf32 Hatch", err, 5)
        return
    end

    if Config.AutoCrystal then
        Config.AutoCrystal = false -- сначала гасим авто-режим, чтобы не дублировать открытия
    end
    hatchState.running = true
    hatchState.cancel = false
    Config.HatchPower = true
    task.spawn(function()
        local opened = 0
        local failReason = nil
        local lastPetText = nil
        if n >= 10 then
            pcall(teleportToCrystal, Config.SelectedCrystal)
        end
        for _ = 1, n do
            if hatchState.cancel or not Config.HatchPower then
                failReason = t("остановлено пользователем", "stopped by user")
                break
            end
            local ok, petOrReason, rarity = openCrystalOnce(Config.SelectedCrystal)
            if ok then
                opened = opened + 1
                if type(petOrReason) == "string" then
                    lastPetText = petOrReason .. (rarity and (" (" .. tostring(rarity) .. ")") or "")
                end
            else
                if petOrReason == "denied" then
                    failReason = t("сервер отказал: инвентарь полон или не хватает валюты",
                        "server denied: inventory full or not enough currency")
                elseif petOrReason == "invokefail" then
                    failReason = t("ошибка вызова openCrystalRemote",
                        "openCrystalRemote call failed")
                else
                    failReason = t("ремоут openCrystalRemote не найден",
                        "openCrystalRemote not found")
                end
                break
            end
            if opened % 25 == 0 then refreshHatchStatus() end
            task.wait(Config.HatchDelay)
        end
        hatchState.running = false
        Config.HatchPower = false
        refreshHatchStatus()
        local msg = string.format(t("Открыто яиц: %d из %d", "Eggs opened: %d of %d"), opened, n)
        if lastPetText then
            msg = msg .. " | " .. t("последний: ", "last: ") .. lastPetText
        end
        if failReason then
            msg = msg .. " — " .. failReason
        end
        notify("Fouf32 Hatch", msg, 5)
    end)
end

createSlider(automationPage, "Eggs Per Batch (1-500)", 1, 500, Config.HatchCount, function(v)
    Config.HatchCount = math.floor(v)
    refreshHatchStatus()
end, nil, "Сколько яиц открывать за один Mass Hatch (максимум 500)")

createToggle(automationPage, "Auto Hatch Selected Egg/Crystal", "Авто-открытие выбранного кристалла пока включено (остановка при отказе сервера)", Config.AutoCrystal, function(v)
    Config.AutoCrystal = v
    if v then
        if hatchState.running then
            Config.AutoCrystal = false
            notify("Fouf32 Hatch", t("Идёт массовое вылупление — сначала остановите его (Stop).",
                "Mass hatch is running — stop it first (Stop)."), 4)
            return
        end
        pcall(teleportToCrystal, Config.SelectedCrystal)
        task.spawn(function()
            while Config.AutoCrystal do
                local ok, reason = openCrystalOnce(Config.SelectedCrystal)
                if not ok then
                    Config.AutoCrystal = false
                    local msg
                    if reason == "denied" then
                        msg = t("Авто-вылупление остановлено: сервер отказал (инвентарь полон / нет валюты).",
                            "Auto hatch stopped: server denied (inventory full / no currency).")
                    elseif reason == "invokefail" then
                        msg = t("Авто-вылупление остановлено: ошибка вызова openCrystalRemote.",
                            "Auto hatch stopped: openCrystalRemote call failed.")
                    else
                        msg = t("Авто-вылупление остановлено: ремоут openCrystalRemote не найден.",
                            "Auto hatch stopped: openCrystalRemote not found.")
                    end
                    notify("Fouf32 Hatch", msg, 5)
                    break
                end
                task.wait(Config.HatchDelay)
            end
            refreshHatchStatus()
        end)
    end
end)

createButton(automationPage, "MASS HATCH (открыть выбранное количество)", "Быстро открывает до 500 яиц подряд с проверкой мест в инвентаре и валюты", function()
    hatchBatch(Config.HatchCount)
end)

createButton(automationPage, "Hatch x10", "Быстро открывает 10 яиц подряд", function()
    hatchBatch(10)
end)

createButton(automationPage, "Hatch x1", "Открывает одно яйцо", function()
    hatchBatch(1)
end)

createButton(automationPage, "Stop Mass Hatch", "Останавливает идущее массовое вылупление", function()
    if hatchState.running then
        hatchState.cancel = true
        notify("Fouf32 Hatch", t("Останавливаем массовое вылупление...", "Stopping mass hatch..."), 2)
    else
        notify("Fouf32 Hatch", t("Сейчас ничего не открывается.", "Nothing is hatching right now."), 2)
    end
end)

sectionLabel(automationPage, "CRYSTAL SELECTOR (ВЫБОР ЯЙЦА)")
for _, crystalName in ipairs(crystalCatalog) do
    createButton(automationPage, crystalName, function()
        return t("Выбрать ", "Select ") .. crystalName .. t(" для крутки", " to open")
    end, function()
        Config.SelectedCrystal = crystalName
        refreshHatchStatus()
        notify("Egg Selected", t("Активный кристалл: ", "Active crystal: ") .. crystalName, 2)
    end)
end

refreshHatchStatus()

-- ============================================================
-- 9. РАЗДЕЛ: PETS & INVENTORY
-- ============================================================
sectionLabel(petsPage, "PET MANAGEMENT ENGINE")
createButton(petsPage, "Auto Evolve All Pets", "Автоматически объединяет одинаковых питомцев для эволюции", function()
    local ev = getMuscleEvent()
    if ev then ev:FireServer("evolvePetAll") end
    notify("Fouf32 Pets", "Запрос на эволюцию отправлен!", 2)
end)

createButton(petsPage, "Equip Best Pets", "Автоматически надевает лучших питомцев в инвентаре", function()
    local ev = getMuscleEvent()
    if ev then ev:FireServer("equipBestPets") end
    notify("Fouf32 Pets", "Лучшие питомцы экипированы!", 2)
end)

-- ============================================================
-- 10. РАЗДЕЛ: MOVEMENT & ESP
-- ============================================================
sectionLabel(movementPage, "FLIGHT & SPEED ENGINE")
createToggle(movementPage, "Fly Mode (WASD + Shift/Space)", "Режим свободного полета Fouf32", Config.FlyEnabled, function(v)
    Config.FlyEnabled = v
    if v then startFlight() else stopFlight() end
end)
createSlider(movementPage, "Fly Speed", 20, 300, Config.FlySpeed, function(v) Config.FlySpeed = v end, nil, "Скорость полета в воздухе")

createToggle(movementPage, "Speed Hack", "Изменение скорости ходьбы", Config.SpeedHack, function(v)
    Config.SpeedHack = v
    if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
    end
end)
createSlider(movementPage, "WalkSpeed Value", 16, 300, Config.SpeedValue, function(v)
    Config.SpeedValue = v
    if Config.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v
    end
end, nil, "Значение скорости ходьбы")

createToggle(movementPage, "Jump Power Hack", "Изменение высоты прыжка", Config.JumpPowerHack, function(v)
    Config.JumpPowerHack = v
end)
createSlider(movementPage, "Jump Power Value", 50, 450, Config.JumpPowerValue, function(v)
    Config.JumpPowerValue = v
    if Config.JumpPowerHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = v
    end
end, nil, "Сила высоты прыжка")

createSlider(movementPage, "Custom World Gravity", 0, 196, 196, function(v)
    Config.GravityValue = v
    Workspace.Gravity = v
end, nil, "Настройка гравитации игрового мира")

createToggle(movementPage, "Noclip", "Проход сквозь стены и объекты", Config.Noclip, function(v) Config.Noclip = v end)
createToggle(movementPage, "Infinite Jump", "Бесконечные прыжки в воздухе", Config.InfJump, function(v) Config.InfJump = v end)
createToggle(movementPage, "Bunny Hop", "Авто-прыжок при касании земли", Config.Bhop, function(v) Config.Bhop = v end)

-- Movement Render Loop
local moveConn = RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if Config.Bhop and hum.FloorMaterial ~= Enum.Material.Air then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
            if Config.SpeedHack then
                hum.WalkSpeed = Config.SpeedValue
            end
            if Config.JumpPowerHack then
                hum.JumpPower = Config.JumpPowerValue
            end
        end
    end
end)
table.insert(ScriptConnections, moveConn)

sectionLabel(movementPage, "SPECTATE & VISUAL ESP")
createToggle(movementPage, "Spectate Target Player", "Режим наблюдения от первого/третьего лица за выбранной целью", Config.SpectateTarget, function(v)
    Config.SpectateTarget = v
    if v and Config.SelectedTargetPlayer and Config.SelectedTargetPlayer.Character and Config.SelectedTargetPlayer.Character:FindFirstChildOfClass("Humanoid") then
        Camera.CameraSubject = Config.SelectedTargetPlayer.Character:FindFirstChildOfClass("Humanoid")
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        end
    end
end)

local espDrawings = {} -- [Player] = Drawing.Text — создается один раз и переиспользуется

-- Определяется как присваивание: forward-декларация есть в начале скрипта
-- (нужна внутри completeScriptUnload)
clearESP = function()
    for playerKey, drawing in pairs(espDrawings) do
        if drawing then
            pcall(function() drawing.Visible = false end)
            pcall(function() drawing:Remove() end)
        end
        espDrawings[playerKey] = nil
    end
end

createToggle(movementPage, "Player NameTags ESP", "Показывает имена и дистанцию до игроков", Config.PlayerESP, function(v)
    Config.PlayerESP = v
    if v then
        if Drawing == nil or type(Drawing.new) ~= "function" then
            notify("Fouf32 ESP", "Этот инжектор не поддерживает Drawing — ESP недоступен", 4)
            Config.PlayerESP = false
            return
        end
        task.spawn(function()
            while Config.PlayerESP do
                local myChar = LocalPlayer.Character
                local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                local seen = {}

                if myHrp then
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer then
                            local c = p.Character
                            local hrp = c and c:FindFirstChild("HumanoidRootPart")
                            local hum = c and c:FindFirstChildOfClass("Humanoid")
                            if hrp and hum and hum.Health > 0 then
                                seen[p] = true
                                local d = espDrawings[p]
                                if not d then
                                    local ok, newDrawing = pcall(function()
                                        local obj = Drawing.new("Text")
                                        obj.Size = 14
                                        obj.Center = true
                                        obj.Outline = true
                                        return obj
                                    end)
                                    if ok and newDrawing then
                                        d = newDrawing
                                        espDrawings[p] = d
                                    end
                                end
                                if d then
                                    local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                                    d.Text = p.Name .. " [" .. math.floor((hrp.Position - myHrp.Position).Magnitude) .. "m]"
                                    d.Position = Vector2.new(pos.X, pos.Y - 25)
                                    d.Color = AccentColor
                                    d.Visible = onScreen
                                end
                            end
                        end
                    end
                end

                -- чистим рисунки игроков, которых больше нет на сервере / они мертвы
                for p, d in pairs(espDrawings) do
                    if not seen[p] then
                        pcall(function() d.Visible = false end)
                        pcall(function() d:Remove() end)
                        espDrawings[p] = nil
                    end
                end

                task.wait(0.1)
            end
            clearESP()
        end)
    else
        clearESP()
    end
end)

createToggle(movementPage, "Full Bright", "Убирает тени на карте и включает день", Config.FullBright, function(v)
    Config.FullBright = v
    if v then
        Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.FogEnd = 100000; Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1; Lighting.ClockTime = 12; Lighting.GlobalShadows = true
    end
end)

createSlider(movementPage, "Camera FOV", 40, 120, Config.CustomFOV, function(v)
    Config.CustomFOV = v
    Camera.FieldOfView = v
end, nil, "Угол обзора камеры")

sectionLabel(movementPage, "SERVER UTILS")
createButton(movementPage, "Rejoin Same Server", "Перезайти на этот же сервер", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

createButton(movementPage, "Server Hop (Random Server)", "Подключиться к случайному серверу", function()
    notify("Fouf32 Server", "Поиск сервера...", 2)
    pcall(function()
        local sfUrl = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local req = HttpService:JSONDecode(game:HttpGet(sfUrl))
        if req and req.data then
            for _, s in pairs(req.data) do
                if s.playing ~= s.maxPlayers and s.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                    break
                end
            end
        end
    end)
end)

createButton(movementPage, "Copy JobID to Clipboard", "Копирует ID текущего сервера в буфер обмена", function()
    pcall(function() setclipboard(tostring(game.JobId)) end)
    notify("Fouf32 Server", "JobID скопирован в буфер!", 2)
end)

-- ============================================================
-- МЕНЮ И КЛАВИША ЗАКРЫТИЯ (Right Shift)
-- ============================================================
switchTab("ClickGUI")

local guiVisible, isAnimating = true, false

local function toggleMenu()
    if isAnimating then return end
    if LangModal.Visible then return end -- стартовое окно выбора языка еще открыто
    isAnimating = true
    guiVisible = not guiVisible
    if guiVisible then
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0,690,0,0)
        local anim = tw(MainFrame, {Size = UDim2.new(0,690,0,520)}, 0.25, Enum.EasingStyle.Quart)
        anim:Play()
        task.delay(0.25, function() isAnimating = false end)
    else
        local anim = tw(MainFrame, {Size = UDim2.new(0,690,0,0)}, 0.2, Enum.EasingStyle.Quart)
        anim:Play()
        task.delay(0.2, function() MainFrame.Visible = false; isAnimating = false end)
    end
end

OpenBtn.MouseButton1Click:Connect(toggleMenu)

local mainKeyConn = UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        toggleMenu()
    end
end)
table.insert(ScriptConnections, mainKeyConn)

print("[Fouf32 STAGE Z]: ЗАГРУЗКА ЗАВЕРШЕНА — окно языка должно быть на экране (меню: RightShift)")
print("[Fouf32 Glass UI Engine v0.21]: Muscle Legends Hub loaded successfully!")