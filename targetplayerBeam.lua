local targetplayer3 = Instance.new("ScreenGui")
local TextBox = Instance.new("TextBox")
local UICorner = Instance.new("UICorner")
local uistroke = Instance.new("UIStroke")
local var = Instance.new("StringValue")

-- Properties:

targetplayer3.Name = "targetplayer :3"
targetplayer3.Parent = game.CoreGui
targetplayer3.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

TextBox.Parent = targetplayer3
TextBox.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
TextBox.BackgroundTransparency = 0.400
TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextBox.BorderSizePixel = 0
TextBox.Position = UDim2.new(0.840514004, 0, 0.922982872, 0)
TextBox.Size = UDim2.new(0, 200, 0, 50)
TextBox.Font = Enum.Font.SourceSans
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
TextBox.TextSize = 14.000

UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = TextBox

uistroke.Transparency = 0.2
uistroke.Thickness = 2
uistroke.Color = Color3.fromRGB(0, 0, 0)
uistroke.Parent = TextBox
uistroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

var.Parent = targetplayer3
var.Name = "player"

local beamPart
local predictPart
local predictPart1Sec
local redBeamUp

local function createBeam(player)
    if beamPart then
        beamPart:Destroy() -- Destroy existing beam if it exists
    end
    if predictPart then
        predictPart:Destroy() -- Destroy existing predict part if it exists
    end
    if predictPart1Sec then
        predictPart1Sec:Destroy() -- Destroy existing 1-second predict part if it exists
    end
    if redBeamUp then
        redBeamUp:Destroy() -- Destroy existing red beam if it exists
    end

    if player then
        local localplayer = game.Players.LocalPlayer
        beamPart = Instance.new("Part")
        beamPart.Size = Vector3.new(0.1, 2000, 0.1)
        beamPart.Anchored = true
        beamPart.Color = Color3.fromRGB(255, 0, 0) -- Red color
        beamPart.Material = Enum.Material.Neon
        beamPart.CanCollide = false
        beamPart.CastShadow = false

        predictPart = Instance.new("Part")
        predictPart.Anchored = true
        predictPart.Color = Color3.fromRGB(0, 0, 255) -- Blue color
        predictPart.Material = Enum.Material.Neon
        predictPart.CanCollide = false
        predictPart.CastShadow = false

        predictPart1Sec = Instance.new("Part")
        predictPart1Sec.Anchored = true
        predictPart1Sec.Color = Color3.fromRGB(0, 255, 0) -- Green color
        predictPart1Sec.Material = Enum.Material.Neon
        predictPart1Sec.CanCollide = false
        predictPart1Sec.CastShadow = false

        redBeamUp = Instance.new("Part")
        redBeamUp.Size = Vector3.new(0, 0, 0) -- Set size to 2, 5, 2
        redBeamUp.Anchored = true
        redBeamUp.Color = Color3.fromRGB(255, 0, 0) -- Red color
        redBeamUp.Material = Enum.Material.Neon
        redBeamUp.CanCollide = false
        redBeamUp.CastShadow = false

        local function updateParts()
            local playerPosition = player.Character.PrimaryPart.Position
            local playerVelocity = player.Character.PrimaryPart.AssemblyLinearVelocity
            local predictPosition = playerPosition + playerVelocity
            local predictPosition1Sec = playerPosition + playerVelocity * 0.5 -- Predict for 1 second

            local localplayerY = localplayer.Character.PrimaryPart.Position.Y
            beamPart.Position = Vector3.new(playerPosition.X, localplayerY, playerPosition.Z)
            
            -- Update current predict part
            local distance = (playerPosition - predictPosition).magnitude
            predictPart.Size = Vector3.new(0.1, 0.1, distance)
            predictPart.CFrame = CFrame.new(playerPosition, predictPosition) * CFrame.new(0, 0, -distance / 1.5)
            
            -- Update 1-second predict part
            local distance1Sec = (playerPosition - predictPosition1Sec).magnitude
            predictPart1Sec.Size = Vector3.new(0.12, 0.12, distance1Sec) -- Make it slightly bigger
            predictPart1Sec.CFrame = CFrame.new(playerPosition, predictPosition1Sec) * CFrame.new(0, 0, -distance1Sec / 1.5)
            
            -- Position the red beam halfway through the 0.5 second line
            redBeamUp.Position = playerPosition + (predictPosition1Sec - playerPosition) / 2 + Vector3.new(0, 2.5, 0)
        end

        game:GetService("RunService").RenderStepped:Connect(updateParts)
        
        -- Listen for the player leaving
        player.AncestryChanged:Connect(function()
            if not player:IsDescendantOf(game) then
                if beamPart then beamPart:Destroy() end
                if predictPart then predictPart:Destroy() end
                if predictPart1Sec then predictPart1Sec:Destroy() end
                if redBeamUp then redBeamUp:Destroy() end
                print(player.Name .. " left the game, parts destroyed.")
            end
        end)
        
        beamPart.Parent = workspace
        predictPart.Parent = workspace
        predictPart1Sec.Parent = workspace
        redBeamUp.Parent = workspace
        print("Beam, predict parts, and red beam created for " .. player.Name)
    else
        if beamPart then
            beamPart:Destroy() end
        if predictPart then
            predictPart:Destroy() end
        if predictPart1Sec then
            predictPart1Sec:Destroy() end
        if redBeamUp then
            redBeamUp:Destroy() end
        print("Player not found.")
    end
end

local function findPlayerByName(name)
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Name:lower() == name:lower() then
            return player
        end
    end
    return nil
end

local function AOJHCRD_fake_script() -- TextBox.LocalScript
    local script = Instance.new('LocalScript', TextBox)
    local userInputService = game:GetService("UserInputService")

    local function onSubmit(textBox)
        script.Parent.Parent.player.Value = textBox.Text
        local playerToLocate = findPlayerByName(textBox.Text) -- Find new player by name
        createBeam(playerToLocate) -- Create or update the beam
        script.Parent:Destroy()
    end

    local function onTextBoxFocusLost(textBox)
        textBox.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                onSubmit(textBox)
            end
        end)
    end

    local textBox = script.Parent
    if textBox then 
        onTextBoxFocusLost(textBox) 
    else 
        print("TextBox not found") 
    end 
end 
coroutine.wrap(AOJHCRD_fake_script)()
