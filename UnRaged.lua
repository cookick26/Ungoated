-- 로블록스 플레이어 선택 UI 티피 스크립트 (부착 방식)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 설정값
local targetPlayer = nil
local offsetDistance = 2
local isActive = false
local screenGui = nil
local statusLabel = nil

-- UI 드래그 함수
local function makeDraggable(frame, mainFrame)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    frame.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    frame.InputEnded:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input, gameProcessed)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- UI 생성
local function createUI()
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TPGui"
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 999999
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui
    
    -- 메인 프레임
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.ZIndex = 999999
    mainFrame.Parent = screenGui
    
    -- 모서리 둥글게
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- 제목 (드래그 가능)
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "UnRaged"
    titleLabel.BorderSizePixel = 0
    titleLabel.ZIndex = 1000000
    titleLabel.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleLabel
    
    -- 제목을 드래그 가능하게 설정
    makeDraggable(titleLabel, mainFrame)
    
    -- 스크롤 프레임
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ScrollFrame"
    scrollFrame.Size = UDim2.new(1, -10, 1, -100)
    scrollFrame.Position = UDim2.new(0, 5, 0, 50)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.ZIndex = 999999
    scrollFrame.Parent = mainFrame
    
    local scrollCorner = Instance.new("UICorner")
    scrollCorner.CornerRadius = UDim.new(0, 6)
    scrollCorner.Parent = scrollFrame
    
    -- 리스트 레이아웃
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = scrollFrame
    
    -- 플레이어 버튼 생성
    local function createPlayerButton(targetPlayerObj)
        local button = Instance.new("TextButton")
        button.Name = targetPlayerObj.Name
        button.Size = UDim2.new(1, -10, 0, 35)
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 14
        button.Font = Enum.Font.Gotham
        button.Text = targetPlayerObj.Name
        button.BorderSizePixel = 0
        button.ZIndex = 999998
        button.Parent = scrollFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = button
        
        button.MouseButton1Click:Connect(function()
            targetPlayer = targetPlayerObj
            statusLabel.Text = "선택됨: " .. targetPlayerObj.Name
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        end)
        
        button.MouseEnter:Connect(function()
            button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        end)
        
        button.MouseLeave:Connect(function()
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end)
    end
    
    -- 플레이어 목록 업데이트 (증분 업데이트)
    local playerButtons = {}
    local function updatePlayerList()
        local currentPlayers = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player then
                currentPlayers[p] = true
            end
        end
        
        -- 제거된 플레이어 버튼 삭제
        for p, button in pairs(playerButtons) do
            if not currentPlayers[p] then
                button:Destroy()
                playerButtons[p] = nil
            end
        end
        
        -- 새로운 플레이어 버튼 생성
        for p in pairs(currentPlayers) do
            if not playerButtons[p] then
                createPlayerButton(p)
                playerButtons[p] = scrollFrame:FindFirstChild(p.Name)
            end
        end
        
        listLayout:ApplyLayout()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    end
    
    -- 상태 표시 라벨
    statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "Status"
    statusLabel.Size = UDim2.new(1, 0, 0, 30)
    statusLabel.Position = UDim2.new(0, 0, 1, -70)
    statusLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.TextSize = 12
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Text = "플레이어를 선택하세요 | F: 시작/중지 | RShift: UI 토글"
    statusLabel.BorderSizePixel = 0
    statusLabel.ZIndex = 999999
    statusLabel.Parent = mainFrame
    
    -- 시작 버튼
    local startButton = Instance.new("TextButton")
    startButton.Name = "StartButton"
    startButton.Size = UDim2.new(0.5, -3, 0, 30)
    startButton.Position = UDim2.new(0, 5, 1, -35)
    startButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    startButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    startButton.TextSize = 14
    startButton.Font = Enum.Font.GothamBold
    startButton.Text = "시작"
    startButton.BorderSizePixel = 0
    startButton.ZIndex = 999999
    startButton.Parent = mainFrame
    
    local startCorner = Instance.new("UICorner")
    startCorner.CornerRadius = UDim.new(0, 4)
    startCorner.Parent = startButton
    
    startButton.MouseButton1Click:Connect(function()
        if targetPlayer then
            isActive = true
            statusLabel.Text = "실행 중: " .. targetPlayer.Name .. " | F: 중지"
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        end
    end)
    
    -- 중지 버튼
    local stopButton = Instance.new("TextButton")
    stopButton.Name = "StopButton"
    stopButton.Size = UDim2.new(0.5, -3, 0, 30)
    stopButton.Position = UDim2.new(0.5, 3, 1, -35)
    stopButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    stopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    stopButton.TextSize = 14
    stopButton.Font = Enum.Font.GothamBold
    stopButton.Text = "중지"
    stopButton.BorderSizePixel = 0
    stopButton.ZIndex = 999999
    stopButton.Parent = mainFrame
    
    local stopCorner = Instance.new("UICorner")
    stopCorner.CornerRadius = UDim.new(0, 4)
    stopCorner.Parent = stopButton
    
    stopButton.MouseButton1Click:Connect(function()
        isActive = false
        statusLabel.Text = "중지됨 | F: 시작/중지 | RShift: UI 토글"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end)
    
    -- 새 플레이어 입장 감지
    Players.PlayerAdded:Connect(function()
        updatePlayerList()
    end)
    
    Players.PlayerRemoving:Connect(function()
        updatePlayerList()
    end)
    
    -- 초기 플레이어 목록 로드
    updatePlayerList()
    
    return screenGui
end

-- 뒷쪽 위치 계산
local function getBackPosition(targetChar)
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return nil end
    
    local direction = targetRoot.CFrame.LookVector
    local backOffset = -direction * offsetDistance
    
    return targetRoot.CFrame.Position + backOffset + Vector3.new(0, 0, 0)
end

-- 부착 방식 (한 번만 설정)
local updateConnection = nil

local function startTPAttach()
    if updateConnection then
        updateConnection:Disconnect()
    end
    
    -- 초기 위치 설정
    if targetPlayer and targetPlayer.Character then
        local backPos = getBackPosition(targetPlayer.Character)
        if backPos then
            humanoidRootPart.CFrame = CFrame.new(backPos)
        end
    end
    
    -- 매 프레임 상대 뒤를 따라가기 (부착)
    updateConnection = RunService.Heartbeat:Connect(function()
        if not isActive then return end
        
        if not character or not humanoidRootPart or not humanoidRootPart.Parent then
            character = player.Character or player.CharacterAdded:Wait()
            humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            return
        end
        
        if not targetPlayer or not targetPlayer.Character then return end
        
        local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not targetRoot then return end
        
        -- 상대 뒤에 부착 (매우 낮은 네트워크 부하)
        local direction = targetRoot.CFrame.LookVector
        local backOffset = -direction * offsetDistance
        local newPos = targetRoot.CFrame.Position + backOffset + Vector3.new(0, 0, 0)
        
        humanoidRootPart.CFrame = CFrame.new(newPos)
    end)
end

-- 키 입력 감지
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- F 키: 시작/중지 토글
    if input.KeyCode == Enum.KeyCode.F then
        if targetPlayer then
            isActive = not isActive
            if isActive then
                print("✓ 티피 시작: " .. targetPlayer.Name)
                startTPAttach()
            else
                print("✗ 티피 중지")
                if updateConnection then
                    updateConnection:Disconnect()
                    updateConnection = nil
                end
            end
        else
            print("⚠️ 플레이어를 먼저 선택해주세요")
        end
    end
    
    -- 오른쪽 Shift 키: UI 토글
    if input.KeyCode == Enum.KeyCode.RightShift then
        if screenGui then
            screenGui.Enabled = not screenGui.Enabled
            print(screenGui.Enabled and "UI 표시됨" or "UI 숨겨짐")
        end
    end
end)

-- UI 생성
screenGui = createUI()

loadstring(game:HttpGet("https://raw.githubusercontent.com/cookick26/Ungoated/main/Ungoated.lua"))()

loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local playerScripts = player.PlayerScripts
local controllers = playerScripts.Controllers

local EnumLibrary = require(ReplicatedStorage.Modules:WaitForChild("EnumLibrary", 10))
if EnumLibrary then EnumLibrary:WaitForEnumBuilder() end

local CosmeticLibrary = require(ReplicatedStorage.Modules:WaitForChild("CosmeticLibrary", 10))
local ItemLibrary = require(ReplicatedStorage.Modules:WaitForChild("ItemLibrary", 10))
local DataController = require(controllers:WaitForChild("PlayerDataController", 10))

local equipped, favorites = {}, {}
local constructingWeapon, viewingProfile = nil, nil
local lastUsedWeapon = nil

local function cloneCosmetic(name, cosmeticType, options)
    local base = CosmeticLibrary.Cosmetics[name]
    if not base then return nil end
    local data = {}
    for key, value in pairs(base) do data[key] = value end
    data.Name = name
    data.Type = data.Type or cosmeticType
    data.Seed = data.Seed or math.random(1, 1000000)
    if EnumLibrary then
        local success, enumId = pcall(EnumLibrary.ToEnum, EnumLibrary, name)
        if success and enumId then data.Enum, data.ObjectID = enumId, data.ObjectID or enumId end
    end
    if options then
        if options.inverted ~= nil then data.Inverted = options.inverted end
        if options.favoritesOnly ~= nil then data.OnlyUseFavorites = options.favoritesOnly end
    end
    return data
end

local saveFile = "unlockall/config.json"
local function saveConfig()
    if not writefile then return end
    pcall(function()
        local config = {equipped = {}, favorites = favorites}
        for weapon, cosmetics in pairs(equipped) do
            config.equipped[weapon] = {}
            for cosmeticType, cosmeticData in pairs(cosmetics) do
                if cosmeticData and cosmeticData.Name then
                    config.equipped[weapon][cosmeticType] = {
                        name = cosmeticData.Name, seed = cosmeticData.Seed, inverted = cosmeticData.Inverted
                    }
                end
            end
        end
        makefolder("unlockall")
        writefile(saveFile, HttpService:JSONEncode(config))
    end)
end

local function loadConfig()
    if not readfile or not isfile or not isfile(saveFile) then return end
    pcall(function()
        local config = HttpService:JSONDecode(readfile(saveFile))
        if config.equipped then
            for weapon, cosmetics in pairs(config.equipped) do
                equipped[weapon] = {}
                for cosmeticType, cosmeticData in pairs(cosmetics) do
                    local cloned = cloneCosmetic(cosmeticData.name, cosmeticType, {inverted = cosmeticData.inverted})
                    if cloned then cloned.Seed = cosmeticData.seed equipped[weapon][cosmeticType] = cloned end
                end
            end
        end
        favorites = config.favorites or {}
    end)
end

local originalOwnsCosmetic = CosmeticLibrary.OwnsCosmetic
CosmeticLibrary.OwnsCosmetic = function(self, inventory, name, weapon)
    if name:find("MISSING_") then return originalOwnsCosmetic(self, inventory, name, weapon) end
    local cosmetic = CosmeticLibrary.Cosmetics[name]
    if cosmetic then
        local cType = cosmetic.Type
        if cType == "Skin" or cType == "Charm" or cType == "Dance" or cType == "Emote" or cType == "Wrap" or cType == "Wrapping" or name:lower():find("charm") or name:lower():find("dance") or name:lower():find("emote") or name:lower():find("wrap") then
            return true
        end
    end
    return originalOwnsCosmetic(self, inventory, name, weapon)
end

CosmeticLibrary.OwnsCosmeticNormally = function(self, inventory, name, weapon)
    local cosmetic = CosmeticLibrary.Cosmetics[name]
    if cosmetic and cosmetic.Type == "Skin" then return true end
    return false
end

CosmeticLibrary.OwnsCosmeticUniversally = function(self, inventory, name, weapon)
    local cosmetic = CosmeticLibrary.Cosmetics[name]
    if cosmetic and cosmetic.Type == "Skin" then return true end
    return false
end

CosmeticLibrary.OwnsCosmeticForWeapon = function(self, inventory, name, weapon)
    local cosmetic = CosmeticLibrary.Cosmetics[name]
    if cosmetic and cosmetic.Type == "Skin" then return true end
    return false
end

local originalGet = DataController.Get
DataController.Get = function(self, key)
    local data = originalGet(self, key)
    if key == "CosmeticInventory" then
        local proxy = {}
        if data then for k, v in pairs(data) do 
            local cosmetic = CosmeticLibrary.Cosmetics[k]
            if cosmetic then proxy[k] = v end
        end end
        return setmetatable(proxy, {__index = function(t, k)
            local cosmetic = CosmeticLibrary.Cosmetics[k]
            if cosmetic then return true end
            return nil
        end})
    end
    if key == "FavoritedCosmetics" then
        local result = data and table.clone(data) or {}
        for weapon, favs in pairs(favorites) do
            result[weapon] = result[weapon] or {}
            for name, isFav in pairs(favs) do 
                result[weapon][name] = isFav
            end
        end
        return result
    end
    return data
end

local originalGetWeaponData = DataController.GetWeaponData
DataController.GetWeaponData = function(self, weaponName)
    local data = originalGetWeaponData(self, weaponName)
    if not data then return nil end
    local merged = {}
    for key, value in pairs(data) do merged[key] = value end
    merged.Name = weaponName
    if equipped[weaponName] then
        for cosmeticType, cosmeticData in pairs(equipped[weaponName]) do 
            merged[cosmeticType] = cosmeticData
        end
    end
    return merged
end

local FighterController
pcall(function() FighterController = require(controllers:WaitForChild("FighterController", 10)) end)

if hookmetamethod then
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local dataRemotes = remotes and remotes:FindFirstChild("Data")
    local equipRemote = dataRemotes and dataRemotes:FindFirstChild("EquipCosmetic")
    local favoriteRemote = dataRemotes and dataRemotes:FindFirstChild("FavoriteCosmetic")
    local replicationRemotes = remotes and remotes:FindFirstChild("Replication")
    local fighterRemotes = replicationRemotes and replicationRemotes:FindFirstChild("Fighter")
    local useItemRemote = fighterRemotes and fighterRemotes:FindFirstChild("UseItem")
    
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        if getnamecallmethod() ~= "FireServer" then return oldNamecall(self, ...) end
        local args = {...}
        
        if useItemRemote and self == useItemRemote then
            local objectID = args[1]
            if FighterController then
                pcall(function()
                    local fighter = FighterController:GetFighter(player)
                    if fighter and fighter.Items then
                        for _, item in pairs(fighter.Items) do
                            if item:Get("ObjectID") == objectID then lastUsedWeapon = item.Name break end
                        end
                    end
                end)
            end
        end
        
        if self == equipRemote then
            local weaponName, cosmeticType, cosmeticName, options = args[1], args[2], args[3], args[4] or {}
            
            if cosmeticName and cosmeticName ~= "None" and cosmeticName ~= "" then
                local inventory = originalGet(DataController, "CosmeticInventory")
                if inventory and rawget(inventory, cosmeticName) then 
                    return oldNamecall(self, ...) 
                end
            end
            
            if cosmeticType == "Dance" or cosmeticType == "Emote" or (cosmeticName and (cosmeticName:lower():find("dance") or cosmeticName:lower():find("emote"))) then
                equipped.Dances = equipped.Dances or {}
                if not cosmeticName or cosmeticName == "None" or cosmeticName == "" then
                    equipped.Dances[cosmeticType] = nil
                else
                    local cloned = cloneCosmetic(cosmeticName, cosmeticType, {inverted = options.IsInverted, favoritesOnly = options.OnlyUseFavorites})
                    if cloned then equipped.Dances[cosmeticType] = cloned end
                end
                task.defer(function()
                    pcall(function() DataController.CurrentData:Replicate("CosmeticInventory") end)
                    task.wait(0.1)
                    saveConfig()
                end)
                return
            end
            
            equipped[weaponName] = equipped[weaponName] or {}
            if not cosmeticName or cosmeticName == "None" or cosmeticName == "" then
                equipped[weaponName][cosmeticType] = nil
                if not next(equipped[weaponName]) then equipped[weaponName] = nil end
            else
                local cloned = cloneCosmetic(cosmeticName, cosmeticType, {inverted = options.IsInverted, favoritesOnly = options.OnlyUseFavorites})
                if cloned then equipped[weaponName][cosmeticType] = cloned end
            end
            
            task.defer(function()
                pcall(function() DataController.CurrentData:Replicate("WeaponInventory") end)
                task.wait(0.1)
                saveConfig()
            end)
            return
        end
        
        if self == favoriteRemote then
            local wName, cName, isFav = args[1], args[2], args[3]
            local cosmetic = CosmeticLibrary.Cosmetics[cName]
            if cosmetic then
                favorites[wName] = favorites[wName] or {}
                favorites[wName][cName] = isFav or nil
                saveConfig()
                task.spawn(function() pcall(function() DataController.CurrentData:Replicate("FavoritedCosmetics") end) end)
            end
            return
        end
        
        return oldNamecall(self, ...)
    end)
end

local ClientItem
pcall(function() ClientItem = require(player.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem) end)

if ClientItem and ClientItem._CreateViewModel then
    local originalCreateViewModel = ClientItem._CreateViewModel
    ClientItem._CreateViewModel = function(self, viewmodelRef)
        local weaponName = self.Name
        local weaponPlayer = self.ClientFighter and self.ClientFighter.Player
        constructingWeapon = (weaponPlayer == player) and weaponName or nil
        
        if weaponPlayer == player and equipped[weaponName] and viewmodelRef then
            local dataKey = self:ToEnum("Data")
            local targetTable = viewmodelRef[dataKey] or viewmodelRef.Data
            
            if targetTable then
                if equipped[weaponName].Skin then
                    targetTable[self:ToEnum("Skin") or "Skin"] = equipped[weaponName].Skin
                    targetTable[self:ToEnum("Name") or "Name"] = equipped[weaponName].Skin.Name
                end
                if equipped[weaponName].Charm then
                    targetTable[self:ToEnum("Charm") or "Charm"] = equipped[weaponName].Charm
                end
                if equipped[weaponName].Wrap then
                    targetTable[self:ToEnum("Wrap") or "Wrap"] = equipped[weaponName].Wrap
                end
            end
        end
        
        local result = originalCreateViewModel(self, viewmodelRef)
        constructingWeapon = nil
        return result
    end
end

local viewModelModule = player.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild("ClientViewModel")
if viewModelModule then
    local ClientViewModel = require(viewModelModule)
    
    if ClientViewModel.GetCharm then
        local originalGetCharmFunc = ClientViewModel.GetCharm
        ClientViewModel.GetCharm = function(self)
            local weaponName = self.ClientItem and self.ClientItem.Name
            local weaponPlayer = self.ClientItem and self.ClientItem.ClientFighter and self.ClientItem.ClientFighter.Player
            if weaponName and weaponPlayer == player and equipped[weaponName] and equipped[weaponName].Charm then
                return equipped[weaponName].Charm
            end
            return originalGetCharmFunc(self)
        end
    end
    
    if ClientViewModel.GetWrap then
        local originalGetWrapFunc = ClientViewModel.GetWrap
        ClientViewModel.GetWrap = function(self)
            local weaponName = self.ClientItem and self.ClientItem.Name
            local weaponPlayer = self.ClientItem and self.ClientItem.ClientFighter and self.ClientItem.ClientFighter.Player
            if weaponName and weaponPlayer == player and equipped[weaponName] and equipped[weaponName].Wrap then
                return equipped[weaponName].Wrap
            end
            return originalGetWrapFunc(self)
        end
    end

    local originalNew = ClientViewModel.new
    ClientViewModel.new = function(replicatedData, clientItem)
        local weaponPlayer = clientItem.ClientFighter and clientItem.ClientFighter.Player
        local weaponName = constructingWeapon or clientItem.Name
        if weaponPlayer == player and equipped[weaponName] then
            local ReplicatedClass = require(ReplicatedStorage.Modules.ReplicatedClass)
            local dataKey = ReplicatedClass:ToEnum("Data")
            replicatedData[dataKey] = replicatedData[dataKey] or {}
            
            local cosmetics = equipped[weaponName]
            if cosmetics.Skin then replicatedData[dataKey][ReplicatedClass:ToEnum("Skin")] = cosmetics.Skin end
            if cosmetics.Charm then replicatedData[dataKey][ReplicatedClass:ToEnum("Charm")] = cosmetics.Charm end
            if cosmetics.Wrap then replicatedData[dataKey][ReplicatedClass:ToEnum("Wrap")] = cosmetics.Wrap end
        end
        
        local result = originalNew(replicatedData, clientItem)
        
        if weaponPlayer == player and equipped[weaponName] and equipped[weaponName].Wrap and result._UpdateWrap then
            result:_UpdateWrap()
            task.delay(0.1, function() if not result._destroyed then result:_UpdateWrap() end end)
        end
        return result
    end
end

ItemLibrary.GetViewModelImageFromWeaponData = function(self, weaponData, highRes)
    if not weaponData then return nil end
    local weaponName = weaponData.Name
    local shouldShowSkin = (weaponData.Skin and equipped[weaponName] and weaponData.Skin == equipped[weaponName].Skin) or (viewingProfile == player and equipped[weaponName] and equipped[weaponName].Skin)
    if shouldShowSkin and equipped[weaponName] and equipped[weaponName].Skin then
        local skinInfo = self.ViewModels[equipped[weaponName].Skin.Name]
        if skinInfo then return skinInfo[highRes and "ImageHighResolution" or "Image"] or skinInfo.Image end
    end
    return nil
end

local EmoteController
pcall(function() 
    EmoteController = require(controllers:WaitForChild("EmoteController", 10))
    if EmoteController and EmoteController.GetEmotes then
        local originalGetEmotes = EmoteController.GetEmotes
        EmoteController.GetEmotes = function(self)
            local emotes = originalGetEmotes(self)
            for name, cosmetic in pairs(CosmeticLibrary.Cosmetics) do
                if cosmetic and (cosmetic.Type == "Dance" or cosmetic.Type == "Emote" or name:lower():find("dance") or name:lower():find("emote")) then
                    if not emotes[name] then
                        emotes[name] = { Name = name, Type = cosmetic.Type, ObjectID = cosmetic.ObjectID, Enum = cosmetic.Enum }
                    end
                end
            end
            return emotes
        end
    end
end)

pcall(function()
    local ViewProfile = require(player.PlayerScripts.Modules.Pages.ViewProfile)
    if ViewProfile and ViewProfile.Fetch then
        local originalFetch = ViewProfile.Fetch
        ViewProfile.Fetch = function(self, targetPlayer)
            viewingProfile = targetPlayer
            return originalFetch(self, targetPlayer)
        end
    end
end)

loadConfig()
