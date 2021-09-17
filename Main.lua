-- Full Credits To UI and Silent Aim (Stefanuk12)
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()
local Aiming = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pi-314Git/CreditsToStefanuk12/main/ModuleF.lua"))()
Aiming.TeamCheck(false)
Aiming.VisibleCheck = false
local UI = library.new("Kittenassist.gay")
-- // Dependencies

-- // Services
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- // Vars
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CurrentCamera = Workspace.CurrentCamera

local themes = {
    Background = Color3.fromRGB(24, 24, 24),
    Glow = Color3.fromRGB(0, 0, 0),
    Accent = Color3.fromRGB(10, 10, 10),
    LightContrast = Color3.fromRGB(20, 20, 20),
    DarkContrast = Color3.fromRGB(14, 14, 14),  
    TextColor = Color3.fromRGB(255, 255, 255)
}

local DaHoodSettings = {
    SilentAim = false,
    AimLock = true,
    Prediction = 0.165
}

getgenv().DaHoodSettings = DaHoodSettings

UserInputService.InputBegan:Connect(function(Key, GaySkidded)
    if Key.KeyCode == SilentAimbotKey and not GaySkidded then
        DaHoodSettings.SilentAim = not DaHoodSettings.SilentAim
    end
end)

local SilentPage = UI:addPage("Silent")
local MainSection = SilentPage:addSection("Main")
local SettingSection = SilentPage:addSection("Settings")

local CreditsPage = UI:addPage("Credits")
local AmongUsSection = CreditsPage:addSection("MADE BY")

MainSection:addToggle("Enable", false, function(bool)
    Aiming.Enabled = bool
end)

SettingSection:addToggle("FOV Circle", false, function(bool)
    Aiming.ShowFOV = bool
end)

SettingSection:addToggle("Visible Check", false, function(bool)
    Aiming.VisibleCheck = bool
end)

SettingSection:addSlider("FOV Size", 0, 0, 400, function(value)
    Aiming.FOV = value
end)

SettingSection:addColorPicker("FOV Color", Color3.fromRGB(231, 84, 128), function(color)
    Aiming.FOVColour = color
end)

SettingSection:addKeybind("Toggle UI", Enum.KeyCode.RightShift, function()
    UI:toggle()
end)

AmongUsSection:addButton("Thanks to Stefanuk12 for module", function()
    
end)

AmongUsSection:addButton("Thanks to Denosaur for ui", function()
    
end)

AmongUsSection:addButton("pi#1330 ui collapse with silent aim yes", function()
    
end)

UI:SelectPage(UI.pages[1], true)

-- // Overwrite to account downed
function Aiming.Check()
    -- // Check A
    if not (Aiming.Enabled == true and Aiming.Selected ~= LocalPlayer and Aiming.SelectedPart ~= nil) then
        return false
    end

    -- // Check if downed
    local Character = Aiming.Character(Aiming.Selected)
    local KOd = Character:WaitForChild("BodyEffects")["K.O"].Value
    local Grabbed = Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil

    -- // Check B
    if (KOd or Grabbed) then
        return false
    end

    -- //
    return true
end

-- // Hook
local __index
__index = hookmetamethod(game, "__index", function(t, k)
    -- // Check if it trying to get our mouse's hit or target and see if we can use it
    if (t:IsA("Mouse") and (k == "Hit" or k == "Target") and Aiming.Check()) then
        -- // Vars
        local SelectedPart = Aiming.SelectedPart

        -- // Hit/Target
        if (DaHoodSettings.SilentAim and (k == "Hit" or k == "Target")) then
            -- // Hit to account prediction
            local Hit = SelectedPart.CFrame + (SelectedPart.Velocity * DaHoodSettings.Prediction)

            -- // Return modded val
            return (k == "Hit" and Hit or SelectedPart)
        end
    end

    -- // Return
    return __index(t, k)
end)

-- // Aimlock
RunService:BindToRenderStep("AimLock", 0, function()
    if (DaHoodSettings.AimLock and Aiming.Check() and UserInputService:IsKeyDown(Enum.KeyCode[string.upper(AimlockKey)])) then
        -- // Vars
        local SelectedPart = Aiming.SelectedPart

        -- // Hit to account prediction
        local Hit = SelectedPart.CFrame + (SelectedPart.Velocity * DaHoodSettings.Prediction)

        -- // Set the camera to face towards the Hit
        CurrentCamera.CFrame = CFrame.lookAt(CurrentCamera.CFrame.Position, Hit.Position)
    end
end)
