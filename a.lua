--// HZ Hub - ChaoGigante Seguro Sem Reset
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Variáveis
local chao = nil
local crescimentoAtivo = false
local velocidade = 1
local largura = 1000
local comprimento = 1000
local alturaInicial = 5
local alturaMaxima = 500
local bv = nil -- BodyVelocity

-- Tela de carregamento
local function loadingScreen(callback)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "HZHubLoading"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1,0,1,0)
    Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    Frame.Parent = ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,0,0,50)
    Title.Position = UDim2.new(0,0,0.45,0)
    Title.Text = "HZ Hub"
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.TextScaled = true
    Title.Font = Enum.Font.FredokaOne
    Title.BackgroundTransparency = 1
    Title.Parent = Frame

    local Loading = Instance.new("TextLabel")
    Loading.Size = UDim2.new(1,0,0,30)
    Loading.Position = UDim2.new(0,0,0.55,0)
    Loading.Text = "Carregando..."
    Loading.TextColor3 = Color3.fromRGB(200,200,200)
    Loading.TextScaled = true
    Loading.Font = Enum.Font.SourceSansBold
    Loading.BackgroundTransparency = 1
    Loading.Parent = Frame

    -- Pequena animação
    task.wait(2)
    for i = 1,3 do
        Loading.Text = "Carregando" .. string.rep(".", i)
        task.wait(0.5)
    end

    -- Fechar tela
    ScreenGui:Destroy()
    if callback then callback() end
end

-- GUI principal
local function criarGUI()
    if PlayerGui:FindFirstChild("ChaoGiganteGUI") then return end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ChaoGiganteGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 220, 0, 200)
    Frame.Position = UDim2.new(0, 20, 0, 20)
    Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Frame.BorderSizePixel = 2
    Frame.Parent = ScreenGui

    -- Título HZ Hub
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "HZ Hub"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextScaled = true
    Title.Font = Enum.Font.FredokaOne
    Title.BackgroundColor3 = Color3.fromRGB(25,25,25)
    Title.Parent = Frame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.Parent = Frame

    local function criarBotao(nome)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 40)
        btn.Text = nome
        btn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextScaled = true
        btn.Parent = Frame
        return btn
    end

    local btnAtivar = criarBotao("Ativar Chão")
    local btnParar = criarBotao("Parar Crescimento")
    local btnCancelar = criarBotao("Cancelar Chão")

    btnAtivar.MouseButton1Click:Connect(criarChao)
    btnParar.MouseButton1Click:Connect(function() crescimentoAtivo = false end)
    btnCancelar.MouseButton1Click:Connect(function()
        if chao then chao:Destroy() end
        chao = nil
        crescimentoAtivo = false
        if bv then bv:Destroy() bv = nil end
    end)
end

-- Criar chão
function criarChao()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local pos = char.HumanoidRootPart.Position

    if chao then chao:Destroy() end

    chao = Instance.new("Part")
    chao.Size = Vector3.new(largura, alturaInicial, comprimento)
    chao.Position = Vector3.new(pos.X, pos.Y - alturaInicial/2, pos.Z)
    chao.Anchored = true
    chao.CanCollide = true
    chao.Transparency = 0
    chao.BrickColor = BrickColor.new("Bright yellow")
    chao.Parent = Workspace

    if bv then bv:Destroy() end
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(0, math.huge, 0)
    bv.Velocity = Vector3.new(0,0,0)
    bv.P = 10000
    bv.D = 1000
    bv.Parent = char.HumanoidRootPart

    crescimentoAtivo = true
end

-- Crescimento contínuo
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if crescimentoAtivo and chao then
        local novaAltura = math.min(chao.Size.Y + velocidade, alturaMaxima)
        local posX, posZ = chao.Position.X, chao.Position.Z
        local posY = chao.Position.Y + (novaAltura - chao.Size.Y)/2

        chao.Size = Vector3.new(largura, novaAltura, comprimento)
        chao.Position = Vector3.new(posX, posY, posZ)

        if char and char:FindFirstChild("HumanoidRootPart") and bv then
            local hrp = char.HumanoidRootPart
            local alvoY = chao.Position.Y + chao.Size.Y/2 + 3
            local diff = alvoY - hrp.Position.Y
            bv.Velocity = Vector3.new(0, math.max(diff * 2,0),0)
        end
    end
end)

-- Respawn reconectar
LocalPlayer.CharacterAdded:Connect(function()
    criarGUI()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and bv then
        bv.Parent = char.HumanoidRootPart
    end
end)

-- Primeiro exibe loading, depois abre GUI
loadingScreen(criarGUI)
