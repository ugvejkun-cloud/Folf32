# Fouf32 build 0.21 — Инструкция по загрузке на GitHub и продаже

## 1. Загрузка репозитория на GitHub
1. Ваш репозиторий: `https://github.com/ugvejkun-cloud/Folf32`
2. **ВАЖНО**: Сделайте репозиторий **Public (Публичным)** в настройках GitHub (Settings -> Danger Zone -> Change visibility -> Public), иначе Roblox не сможет считывать файлы через `game:HttpGet`!

---

## 2. Ваша ссылка для покупателей (loadstring)
Запустите этот код в инжекторе Roblox:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/ugvejkun-cloud/Folf32/main/MuscleLegendsScript.lua"))()
```

---

## 3. Как добавить нового покупателя
1. Откройте файл `AddUser.bat` на компьютере.
2. Введите никнейм Roblox покупателя (например, `drybs5`).
3. Введите `Y` для отправки изменений на GitHub.
4. Готово! Покупатель сможет сразу использовать `loadstring`.
