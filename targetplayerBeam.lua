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

local function createBeam(player)
	if beamPart then
		beamPart:Destroy() -- Destroy existing beam if it exists
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

		local function updateBeamPosition()
			local playerPosition = player.Character.PrimaryPart.Position
			local localplayerY = localplayer.Character.PrimaryPart.Position.Y
			beamPart.Position = Vector3.new(playerPosition.X, localplayerY, playerPosition.Z)
		end

		game:GetService("RunService").RenderStepped:Connect(updateBeamPosition)
		beamPart.Parent = workspace
		print("Beam created for " .. player.Name)
	else
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
