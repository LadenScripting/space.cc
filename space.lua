
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")  -- Add UserInputService
local LocalPlayer = Players.LocalPlayer
local Mouse = game.Players.LocalPlayer:GetMouse()
local CamlockState = false
local Prediction = 0.1153725
local HorizontalPrediction = 0.111076110
local VerticalPrediction = 0.11034856
local XPrediction = 20
local YPrediction = 20

function FindNearestEnemy()
    local ClosestDistance, ClosestPlayer = math.huge, nil
    local CenterPosition = Vector2.new(game:GetService("GuiService"):GetScreenResolution().X / 2, game:GetService("GuiService"):GetScreenResolution().Y / 2)

    for _, Player in ipairs(game:GetService("Players"):GetPlayers()) do
        if Player ~= LocalPlayer then
            local Character = Player.Character
            if Character and Character:FindFirstChild("HumanoidRootPart") and Character.Humanoid.Health > 0 then
                local Position, IsVisibleOnViewport = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(Character.HumanoidRootPart.Position)
                if IsVisibleOnViewport then
                    local Distance = (CenterPosition - Vector2.new(Position.X, Position.Y)).Magnitude
                    if Distance < ClosestDistance then
                        ClosestPlayer = Character.HumanoidRootPart
                        ClosestDistance = Distance
                    end
                end
            end
        end
    end

    return ClosestPlayer
end

local enemy = nil
local glowingPart = nil

-- Function to aim the camera at the nearest enemy's HumanoidRootPart
RunService.Heartbeat:Connect(function()
    if CamlockState == true then
        if enemy then
            local camera = workspace.CurrentCamera
            camera.CFrame = CFrame.new(camera.CFrame.p, enemy.Position + enemy.Velocity * Prediction)
            
            if glowingPart then
                glowingPart.Enabled = true
                glowingPart.Parent = enemy
                glowingPart.Face = Enum.NormalId.Front
            end
        end
    else
        if glowingPart then
            glowingPart:Destroy() -- Remove glowing effect by destroying the part
        end
    end
end)

local SpaceLua = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TextButton = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")

-- Properties:
SpaceLua.Name = "SpaceLua"
SpaceLua.Parent = game.CoreGui
SpaceLua.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = SpaceLua
Frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Fully red color
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.133798108, 0, 0.20107238, 0)
Frame.Size = UDim2.new(0, 202, 0, 70)
Frame.Active = true
Frame.Draggable = true

local function TopContainer()
    Frame.Position = UDim2.new(0.5, -Frame.AbsoluteSize.X / 2, 0, -Frame.AbsoluteSize.Y / 2)
end

TopContainer()
Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(TopContainer)

UICorner.Parent = Frame

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BackgroundTransparency = 5.000
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.0792079195, 0, 0.18571429, 0)
TextButton.Size = UDim2.new(0, 170, 0, 44)
TextButton.Font = Enum.Font.SourceSansSemibold
TextButton.Text = "space.lua OFF" -- Initial text
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextScaled = true
TextButton.TextSize = 11.000
TextButton.TextWrapped = true

-- Function to send notifications
local function Noti(a, b)
    local CoreGui = game:GetService("StarterGui")
    CoreGui:SetCore("SendNotification", {
        Title = a;
        Text = b;
        Duration = 5;
    })
end

TextButton.MouseButton1Click:Connect(function()
    CamlockState = not CamlockState
    TextButton.Text = CamlockState and "space.lua ON" or "space.lua OFF"
    enemy = CamlockState and FindNearestEnemy() or nil
    
    if CamlockState then
        Frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Change to green
        glowingPart = Instance.new("SurfaceLight")
        glowingPart.Color = Color3.fromRGB(255, 0, 0) -- Red glow color
        glowingPart.Brightness = 10 -- Brighter glow
        Noti("Space.lua", "space.lua has been turned ON.") -- Send notification
    else
        Frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Change back to red
        if glowingPart then
            glowingPart:Destroy() -- Remove glowing effect by destroying the part
        end
        Noti("Space.lua", "space.lua has been turned OFF.") -- Send notification
    end
end)

-- Keybind functionality
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    -- Check if the Q key is pressed and the game is not processing another input
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Q and not gameProcessedEvent then
        CamlockState = not CamlockState
        TextButton.Text = CamlockState and "space.lua ON" or "space.lua OFF"
        enemy = CamlockState and FindNearestEnemy() or nil
        
        if CamlockState then
            Frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Change to green
            glowingPart = Instance.new("SurfaceLight")
            glowingPart.Color = Color3.fromRGB(255, 0, 0) -- Red glow color
            glowingPart.Brightness = 10 -- Brighter glow
            Noti("Space.lua", "space.lua has been turned ON.") -- Send notification
        else
            Frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Change back to red
            if glowingPart then
                glowingPart:Destroy() -- Remove glowing effect by destroying the part
            end
            Noti("Space.lua", "space.lua has been turned OFF.") -- Send notification
        end
    end
end)

UICorner_2.Parent = TextButton
