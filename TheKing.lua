--// Serviços
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local placeId = game.PlaceId
local jobId = game.JobId
local visited = {}
local maxPlayers = 4

--// Sistema de Key
local keyGui = Instance.new("ScreenGui", game.CoreGui)
keyGui.Name = "TheKingKeySystem"
keyGui.ResetOnSpawn = false

local frame = Instance.new("Frame", keyGui)
frame.Size = UDim2.new(0, 320, 0, 180)
frame.Position = UDim2.new(0.5, -160, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🔑 The King Scripts - Key System"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local input = Instance.new("TextBox", frame)
input.Size = UDim2.new(1, -20, 0, 35)
input.Position = UDim2.new(0, 10, 0, 55)
input.PlaceholderText = "Enter Key Here"
input.Text = ""
input.TextColor3 = Color3.new(1, 1, 1)
input.Font = Enum.Font.Gotham
input.TextSize = 14
input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, -20, 0, 30)
status.Position = UDim2.new(0, 10, 0, 95)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(255, 255, 255)
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.Text = "Status: Aguardando"

local getKeyBtn = Instance.new("TextButton", frame)
getKeyBtn.Size = UDim2.new(0.5, -15, 0, 30)
getKeyBtn.Position = UDim2.new(0, 10, 1, -40)
getKeyBtn.Text = "📎 Get Key"
getKeyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
getKeyBtn.TextColor3 = Color3.new(1, 1, 1)
getKeyBtn.Font = Enum.Font.GothamBold
getKeyBtn.TextSize = 14

local checkBtn = Instance.new("TextButton", frame)
checkBtn.Size = UDim2.new(0.5, -15, 0, 30)
checkBtn.Position = UDim2.new(0.5, 5, 1, -40)
checkBtn.Text = "✅ Check Key"
checkBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
checkBtn.TextColor3 = Color3.new(1, 1, 1)
checkBtn.Font = Enum.Font.GothamBold
checkBtn.TextSize = 14

getKeyBtn.MouseButton1Click:Connect(function()
	setclipboard("https://discord.gg/46k2QFKYhg")
	status.Text = "Key copiada para sua área de transferência"
end)

checkBtn.MouseButton1Click:Connect(function()
	if input.Text == "TheBestHack" then
		status.Text = "✅ Key correta. Carregando The King Scripts..."
		wait(1.5)
		keyGui:Destroy()
		loadHopInterface()
	else
		status.Text = "❌ Key inválida. Pegue a key no botão 'Get Key'"
	end
end)

--// Função que ativa o GUI principal
function loadHopInterface()
	local hopping = false

	local gui = Instance.new("ScreenGui", game.CoreGui)
	gui.Name = "TheKingScripts"
	gui.ResetOnSpawn = false

	local frame = Instance.new("Frame", gui)
	frame.Size = UDim2.new(0, 320, 0, 180)
	frame.Position = UDim2.new(0, 20, 0, 100)
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.BorderSizePixel = 0
	frame.Active = true
	frame.Draggable = true

	local background = Instance.new("ImageLabel", frame)
	background.Size = UDim2.new(1, 0, 1, 0)
	background.Image = "rbxassetid://13760250605"
	background.BackgroundTransparency = 0.7
	background.ZIndex = 0
	background.ScaleType = Enum.ScaleType.Crop

	local status = Instance.new("TextLabel", frame)
	status.Size = UDim2.new(1, -20, 0, 40)
	status.Position = UDim2.new(0, 10, 0, 10)
	status.BackgroundTransparency = 1
	status.TextColor3 = Color3.fromRGB(255, 255, 255)
	status.Font = Enum.Font.GothamBold
	status.TextSize = 18
	status.Text = "Status: Pronto para teleportar"
	status.ZIndex = 1

	local btnMinMax = Instance.new("TextButton", gui)
	btnMinMax.Size = UDim2.new(0, 100, 0, 30)
	btnMinMax.Position = UDim2.new(0, 20, 0, 280)
	btnMinMax.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btnMinMax.TextColor3 = Color3.fromRGB(255, 255, 255)
	btnMinMax.Font = Enum.Font.GothamBold
	btnMinMax.TextSize = 14
	btnMinMax.Text = "Minimizar"
	btnMinMax.ZIndex = 2

	local btnInstantTP = Instance.new("TextButton", frame)
	btnInstantTP.Size = UDim2.new(0, 150, 0, 40)
	btnInstantTP.Position = UDim2.new(0.5, -75, 1, -85)
	btnInstantTP.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
	btnInstantTP.TextColor3 = Color3.fromRGB(255, 255, 255)
	btnInstantTP.Font = Enum.Font.GothamBold
	btnInstantTP.TextSize = 18
	btnInstantTP.Text = "Iniciar Instant TP"
	btnInstantTP.ZIndex = 1

	local minimized = false

	local function atualizarBotaoMinMax()
		if minimized then
			btnMinMax.Text = "Maximizar"
			btnMinMax.Position = UDim2.new(0, 20, 0, 100)
			frame.Visible = false
			btnInstantTP.Visible = false
		else
			btnMinMax.Text = "Minimizar"
			btnMinMax.Position = UDim2.new(0, 20, 0, 280)
			btnInstantTP.Visible = true
			frame.Visible = true
		end
	end

	btnMinMax.MouseButton1Click:Connect(function()
		minimized = not minimized
		atualizarBotaoMinMax()
	end)

	atualizarBotaoMinMax()

	local cores = {
		Color3.fromRGB(0, 0, 0),
		Color3.fromRGB(255, 255, 0),
		Color3.fromRGB(128, 0, 128),
		Color3.fromRGB(255, 105, 180),
		Color3.fromRGB(0, 0, 255),
	}

	coroutine.wrap(function()
		local i = 1
		while true do
			frame.BackgroundColor3 = cores[i]
			i = i + 1
			if i > #cores then i = 1 end
			wait(5)
		end
	end)()

	local function buscarServidor()
		local cursor = ""
		while hopping do
			status.Text = "Status: Aguarde pacientemente..."
			local success, data = pcall(function()
				local url = string.format("https://games.roblox.com/v1/games/%s/servers/Public?limit=100&sortOrder=Asc&cursor=%s", placeId, cursor)
				return HttpService:JSONDecode(game:HttpGet(url))
			end)

			if success and data and data.data then
				local encontrou = false
				for _, server in pairs(data.data) do
					if server.playing <= maxPlayers and not table.find(visited, server.id) and server.id ~= jobId then
						table.insert(visited, server.id)
						status.Text = "Status: Teleportando ("..server.playing.." players)..."
						local ok, err = pcall(function()
							TeleportService:TeleportToPlaceInstance(placeId, server.id, LocalPlayer)
						end)
						if not ok then
							status.Text = "Erro ao teleportar! Tentando novamente..."
						end
						wait(5)
						encontrou = true
						break
					end
				end
				if not encontrou then
					status.Text = "Status: Nenhum servidor válido, tentando novamente..."
				end
				cursor = data.nextPageCursor or ""
				wait(5)
			else
				status.Text = "Status: Aguarde pacientemente..."
				wait(4)
			end
		end
	end

	btnInstantTP.MouseButton1Click:Connect(function()
		if not hopping then
			hopping = true
			status.Text = "Status: Iniciando Instant TP..."
			task.spawn(buscarServidor)
		end
	end)
end
