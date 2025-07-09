local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

_G.HeadSize = 15
_G.Disabled = false
_G.SelectedColor = BrickColor.new("Lime green")

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "Расширитель Хитбокса by Luminaprojects"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 220)
frame.Position = UDim2.new(0.5, -150, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local minimizeBtn = Instance.new("TextButton", frame)
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -35, 0, 5)
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -40, 0, 30)
title.Text = "Расширитель Хитбокса by Luminaprojects"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Position = UDim2.new(0, 0, 0, 0)

local sizeLabel = Instance.new("TextLabel", frame)
sizeLabel.Position = UDim2.new(0, 10, 0, 40)
sizeLabel.Size = UDim2.new(0, 120, 0, 25)
sizeLabel.Text = "Размер хитбокса:"
sizeLabel.TextColor3 = Color3.new(1, 1, 1)
sizeLabel.BackgroundTransparency = 1
sizeLabel.Font = Enum.Font.Gotham
sizeLabel.TextSize = 14

local sizeBox = Instance.new("TextBox", frame)
sizeBox.Position = UDim2.new(0, 140, 0, 40)
sizeBox.Size = UDim2.new(0, 140, 0, 25)
sizeBox.Text = tostring(_G.HeadSize)
sizeBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
sizeBox.TextColor3 = Color3.new(1, 1, 1)
sizeBox.Font = Enum.Font.Gotham
sizeBox.TextSize = 14
sizeBox.FocusLost:Connect(function()
	local num = tonumber(sizeBox.Text)
	if num then
		_G.HeadSize = num
	end
end)

local colorLabel = Instance.new("TextLabel", frame)
colorLabel.Position = UDim2.new(0, 10, 0, 75)
colorLabel.Size = UDim2.new(0, 120, 0, 25)
colorLabel.Text = "Цвет:"
colorLabel.TextColor3 = Color3.new(1, 1, 1)
colorLabel.BackgroundTransparency = 1
colorLabel.Font = Enum.Font.Gotham
colorLabel.TextSize = 14

local colorDropdown = Instance.new("TextButton", frame)
colorDropdown.Position = UDim2.new(0, 140, 0, 75)
colorDropdown.Size = UDim2.new(0, 140, 0, 25)
colorDropdown.Text = "Салатовый"
colorDropdown.BackgroundColor3 = BrickColor.new("Lime green").Color
colorDropdown.TextColor3 = Color3.new(1, 1, 1)
colorDropdown.Font = Enum.Font.Gotham
colorDropdown.TextSize = 14

-- ✅ Tambahan warna di sini
local colorOptions = {
	["Салатовый"] = BrickColor.new("Lime green"),
	["Синий"] = BrickColor.new("Really blue"),
	["Чёрный"] = BrickColor.new("Black"),
	["Жёлтый"] = BrickColor.new("New Yeller"),
	["Белый"] = BrickColor.new("White"),
	["Фиолетовый"] = BrickColor.new("Bright violet"),
	["Розовый"] = BrickColor.new("Hot pink"),
	["Оранжевый"] = BrickColor.new("Bright orange"),
}

local dropdownOpen = false
colorDropdown.MouseButton1Click:Connect(function()
	if dropdownOpen then return end
	dropdownOpen = true
	local y = 105
	for name, brick in pairs(colorOptions) do
		local opt = Instance.new("TextButton", frame)
		opt.Size = UDim2.new(0, 140, 0, 20)
		opt.Position = UDim2.new(0, 140, 0, y)
		opt.Text = name
		opt.BackgroundColor3 = brick.Color
		opt.TextColor3 = Color3.new(1, 1, 1)
		opt.Font = Enum.Font.Gotham
		opt.TextSize = 13
		opt.ZIndex = 2
		opt.Name = "DropdownOption"
		opt.MouseButton1Click:Connect(function()
			colorDropdown.Text = name
			colorDropdown.BackgroundColor3 = brick.Color
			_G.SelectedColor = brick
			for _, child in pairs(frame:GetChildren()) do
				if child.Name == "DropdownOption" then
					child:Destroy()
				end
			end
			dropdownOpen = false
		end)
		y += 22
	end
end)

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Position = UDim2.new(0, 10, 0, 170)
toggleBtn.Size = UDim2.new(0, 280, 0, 30)
toggleBtn.Text = "Включить хитбоксы"
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 16

toggleBtn.MouseButton1Click:Connect(function()
	_G.Disabled = not _G.Disabled
	toggleBtn.Text = _G.Disabled and "Отключить хитбоксы" or "Включить хитбоксы"
	toggleBtn.BackgroundColor3 = _G.Disabled and Color3.fromRGB(170, 0, 0) or Color3.fromRGB(0, 170, 0)
end)

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	local goalSize = minimized and UDim2.new(0, 300, 0, 40) or UDim2.new(0, 300, 0, 220)
	TweenService:Create(frame, TweenInfo.new(0.25), {Size = goalSize}):Play()

	for _, v in pairs(frame:GetChildren()) do
		if v ~= title and v ~= minimizeBtn then
			v.Visible = not minimized
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if _G.Disabled then
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				local part = plr.Character.HumanoidRootPart
				pcall(function()
					part.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
					part.Transparency = 0.7
					part.BrickColor = _G.SelectedColor
					part.Material = Enum.Material.Neon
					part.CanCollide = false
				end)
			end
		end
	end
end)
