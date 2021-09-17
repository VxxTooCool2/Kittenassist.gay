local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pi-314Git/Roseware-Library/main/PiModedImGuiUiLibrary.lua"))()

local Window = library:AddWindow("kittenassist.crack v2", {
    main_color = Color3.fromRGB(10, 10, 10),
    min_size = Vector2.new(450, 500),
    toggle_key = Enum.KeyCode.RightShift,
    can_resize = false,
})

local Aiming = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pi-314Git/CreditsToStefanuk12/main/ModuleF.lua"))()
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
ESP:Toggle(false)
ESP.Tracers = false
ESP.Names = false
ESP.Boxes = false
Aiming.TeamCheck(false)
Aiming.VisibleCheck = false
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

local RCTab = Window:AddTab("Rage Cheats")
local ALTab = Window:AddTab("Aimlock")
local ESPTab = Window:AddTab("Esp")

ESPTab:AddSwitch("Enable ESP", function(bool)
    ESP:Toggle(bool)
end)

ESPTab:AddSwitch("Enable Tracers", function(bool)
    ESP.Tracers = bool
end)

ESPTab:AddSwitch("Enable Names", function(bool)
    ESP.Names = bool
end)

ESPTab:AddSwitch("Enable Boxes", function(bool)
    ESP.Boxes = bool
end)

ALTab:AddSwitch("Silent Aim", function(bool)
    DaHoodSettings.SilentAim = bool
end)

ALTab:AddSwitch("Aim Lock", function(bool)
    DaHoodSettings.AimLock = bool
end)

ALTab:AddSwitch("FOV Circle", function(bool)
    Aiming.ShowFOV = bool
end)

ALTab:AddSlider("FOV Size", function(value)
    Aiming.FOV = value
end, {
    ["min"] = 0,
    ["max"] = 400,
    ["readonly"] = false,
})

ALTab:AddSlider("Prediction", function(value)
    DaHoodSettings.Prediction = tonumer("0." .. value)
end, {
    ["min"] = 0,
    ["max"] = 500,
    ["readonly"] = false,
})

ALTab:AddSwitch("Visible Check", function(bool)
    Aiming.VisibleCheck = bool
end)

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
