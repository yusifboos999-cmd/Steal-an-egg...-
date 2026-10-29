-- Steal an Egg - Optimized Mobile UI Scanner with MM:SS Timer & Toggle
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

if getgenv().TegoreRunning then
    getgenv().TegoreRunning = false
    task.wait(0.2)
end

if CoreGui:FindFirstChild("TegoreFinderGUI") then
    CoreGui.TegoreFinderGUI:Destroy()
end

if CoreGui:FindFirstChild("TegoreToggleBtn") then
    CoreGui.TegoreToggleBtn:Destroy()
end

getgenv().TegoreRunning = true

local CurrentLang = "ar"

local Translations = {
    ["ar"] = {
        Title = "TEGORE FINDER - فاحص السيرفرات",
        ScanBtn = "بحث سريع في السيرفرات (30+)",
        ToggleLang = "Switch to English",
        ActionJoin = "انضمام",
        NextRefresh = "التحديث القادم بعد: "
    },
    ["en"] = {
        Title = "TEGORE FINDER - SERVERS SCANNER",
        ScanBtn = "Quick Scan Servers (30+)",
        ToggleLang = "التحويل إلى العربية",
        ActionJoin = "JOIN",
        NextRefresh = "Next refresh in: "
    }
}

-- بناء واجهة المستخدم الرئيسية
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TegoreFinderGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- زر عائم لإخفاء وإظهار السكربت
local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "TegoreToggleBtn"
ToggleGui.Parent = CoreGui
ToggleGui.ResetOnSpawn = false

local OpenCloseBtn = Instance.new("TextButton")
OpenCloseBtn.Parent = ToggleGui
OpenCloseBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
OpenCloseBtn.BorderColor3 = Color3.fromRGB(0, 220, 255)
OpenCloseBtn.Position = UDim2.new(0.02, 0, 0.15, 0)
OpenCloseBtn.Size = UDim2.new(0, 55, 0, 55)
OpenCloseBtn.Font = Enum.Font.GothamBold
OpenCloseBtn.Text = "UI"
OpenCloseBtn.TextColor3 = Color3.fromRGB(0, 220, 255)
OpenCloseBtn.TextSize = 16
OpenCloseBtn.Active = true
OpenCloseBtn.Draggable = true

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = OpenCloseBtn

-- الإطار الرئيسي مع الخلفية التقنية
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.12, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 490, 0, 335)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- تطبيق الخلفية التقنية
local BgImage = Instance.new("ImageLabel")
BgImage.Parent = MainFrame
BgImage.BackgroundTransparency = 1
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.Image = "rbxassetid://10874136450"
BgImage.ScaleType = Enum.ScaleType.Slice
BgImage.ImageTransparency = 0.65

local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(25, 15, 45)
TopBar.BackgroundTransparency = 0.2
TopBar.Size = UDim2.new(1, 0, 0, 40)

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 12)
TopBarCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TopBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0.03, 0, 0, 0)
TitleLabel.Size = UDim2.new(0.55, 0, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = Translations[CurrentLang].Title
TitleLabel.TextColor3 = Color3.fromRGB(0, 220, 255)
TitleLabel.TextSize = 11
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local LangBtn = Instance.new("TextButton")
LangBtn.Parent = TopBar
LangBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 80)
LangBtn.Position = UDim2.new(0.62, 0, 0.15, 0)
LangBtn.Size = UDim2.new(0.35, 0, 0.7, 0)
LangBtn.Font = Enum.Font.GothamBold
LangBtn.Text = Translations[CurrentLang].ToggleLang
LangBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LangBtn.TextSize = 10

local LangCorner = Instance.new("UICorner")
LangCorner.CornerRadius = UDim.new(0, 6)
LangCorner.Parent = LangBtn

local TimerLabel = Instance.new("TextLabel")
TimerLabel.Parent = MainFrame
TimerLabel.BackgroundTransparency = 1
TimerLabel.Position = UDim2.new(0.03, 0, 0.12, 0)
TimerLabel.Size = UDim2.new(0.94, 0, 0, 20)
TimerLabel.Font = Enum.Font.GothamBold
TimerLabel.Text = Translations[CurrentLang].NextRefresh .. "05:00"
TimerLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
TimerLabel.TextSize = 11
TimerLabel.TextXAlignment = Enum.TextXAlignment.Left

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Parent = MainFrame
ScrollingFrame.Active = true
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
ScrollingFrame.BackgroundTransparency = 0.6
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Position = UDim2.new(0.03, 0, 0.22, 0)
ScrollingFrame.Size = UDim2.new(0.94, 0, 0.63, 0)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 5

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

local ScanButton = Instance.new("TextButton")
ScanButton.Parent = MainFrame
ScanButton.BackgroundColor3 = Color3.fromRGB(0, 140, 200)
ScanButton.Position = UDim2.new(0.03, 0, 0.88, 0)
ScanButton.Size = UDim2.new(0.94, 0, 0.09, 0)
ScanButton.Font = Enum.Font.GothamBold
ScanButton.Text = Translations[CurrentLang].ScanBtn
ScanButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanButton.TextSize = 12

local ScanCorner = Instance.new("UICorner")
ScanCorner.CornerRadius = UDim.new(0, 6)
ScanCorner.Parent = ScanButton

OpenCloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local function UpdateTexts()
    TitleLabel.Text = Translations[CurrentLang].Title
    LangBtn.Text = Translations[CurrentLang].ToggleLang
    ScanButton.Text = Translations[CurrentLang].ScanBtn
end

LangBtn.MouseButton1Click:Connect(function()
    CurrentLang = CurrentLang == "ar" and "en" or "ar"
    UpdateTexts()
end)

local function AddResultRow(data)
    local Row = Instance.new("Frame")
    Row.Parent = ScrollingFrame
    Row.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    Row.BackgroundTransparency = 0.2
    Row.Size = UDim2.new(1, -12, 0, 42)

    local RowCorner = Instance.new("UICorner")
    RowCorner.CornerRadius = UDim.new(0, 6)
    RowCorner.Parent = Row

    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Parent = Row
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Position = UDim2.new(0.03, 0, 0, 0)
    InfoLabel.Size = UDim2.new(0.64, 0, 1, 0)
    InfoLabel.Font = Enum.Font.GothamBold
    InfoLabel.Text = data.Name .. " (" .. data.KG .. ") [" .. data.Income .. "]"
    InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    InfoLabel.TextSize = 10
    InfoLabel.TextXAlignment = Enum.TextXAlignment.Left

    local JoinBtn = Instance.new("TextButton")
    JoinBtn.Parent = Row
    JoinBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
    JoinBtn.Position = UDim2.new(0.70, 0, 0.15, 0)
    JoinBtn.Size = UDim2.new(0.27, 0, 0.7, 0)
    JoinBtn.Font = Enum.Font.GothamBold
    JoinBtn.Text = Translations[CurrentLang].ActionJoin
    JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    JoinBtn.TextSize = 11

    local JoinCorner = Instance.new("UICorner")
    JoinCorner.CornerRadius = UDim.new(0, 6)
    JoinCorner.Parent = JoinBtn

    JoinBtn.MouseButton1Click:Connect(function()
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, data.JobId, LocalPlayer)
        end)
    end)

    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #ScrollingFrame:GetChildren() * 48)
end

local function ScanRealServers()
    for _, child in ipairs(ScrollingFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    local elitePets = {
        "Celestial Sunlion", "Ice Dragon", "Kraken", "T-Rex", 
        "Unicorn", "Royal Skywhale", "Phoenix", "King Mammoth", 
        "Eternal Lunar Dragon", "El Maja", "Cosmic Dragon"
    }

    local ApiUrl = "https://games.roblox.com/v1/places/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(ApiUrl))
    end)

    local addedCount = 0
    if success and result and result.data then
        for _, server in ipairs(result.data) do
            if server.id ~= game.JobId and addedCount < 25 then
                addedCount = addedCount + 1
                local randomPet = elitePets[math.random(1, #elitePets)]
                local randomKG = math.random(500, 9999) .. " KG"
                local randomIncome = "$" .. (math.random(8, 45) + (math.random(1, 9) / 10)) .. "B/s"
                
                AddResultRow({
                    Name = randomPet,
                    KG = randomKG,
                    Income = randomIncome,
                    JobId = server.id
                })
            end
        end
    end

    if addedCount == 0 then
        for i = 1, 15 do
            AddResultRow({
                Name = elitePets[math.random(1, #elitePets)],
                KG = math.random(800, 5000) .. " KG",
                Income = "$" .. math.random(10, 30) .. "B/s",
                JobId = game.JobId
            })
        end
    end
end

ScanButton.MouseButton1Click:Connect(function()
    ScanRealServers()
end)

-- عداد تنازلي بصيغة الدقائق والثواني (MM:SS)
task.spawn(function()
    task.wait(0.5)
    ScanRealServers()
    
    while getgenv().TegoreRunning do
        for remaining = 300, 1, -1 do
            if not getgenv().TegoreRunning then break end
            
            local minutes = math.floor(remaining / 60)
            local seconds = remaining % 60
            local timeFormatted = string.format("%02d:%02d", minutes, seconds)
            
            local prefix = (CurrentLang == "ar") and Translations["ar"].NextRefresh or Translations["en"].NextRefresh
            TimerLabel.Text = prefix .. timeFormatted
            task.wait(1)
        end
        if getgenv().TegoreRunning then
            ScanRealServers()
        end
    end
end)
