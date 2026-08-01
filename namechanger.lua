local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

print("✅ 통합 닉네임 변경 시스템 시작!")

-- 킬캠 닉네임 설정
local DISPLAY_NAME = "5678"  -- 디플닉
local ACCOUNT_NAME = "1234"  -- 본닉

-- 플레이어 닉네임 설정
local PLAYER_CHANGES = {}  -- {플레이어명 = {rank, displayNickname, username}}

local screenGui
local mainFrame
local isGuiVisible = false

-- UI 생성 함수
local function createGui()
    -- UI 생성
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CombinedNicknameGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    -- 메인 프레임
    mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 580)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -290)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    -- 코너 둥글게
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame

    -- 제목
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    titleLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "🎮 닉네임 변경 시스템"
    titleLabel.Parent = mainFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleLabel

    -- ===== 킬캠 섹션 =====
    local killcamSectionLabel = Instance.new("TextLabel")
    killcamSectionLabel.Name = "KillcamSection"
    killcamSectionLabel.Size = UDim2.new(1, -20, 0, 25)
    killcamSectionLabel.Position = UDim2.new(0, 10, 0, 50)
    killcamSectionLabel.BackgroundTransparency = 1
    killcamSectionLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    killcamSectionLabel.TextSize = 14
    killcamSectionLabel.Font = Enum.Font.GothamBold
    killcamSectionLabel.Text = "⚔️ 킬캠 닉네임"
    killcamSectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    killcamSectionLabel.Parent = mainFrame

    -- 디플닉 라벨
    local displayLabel = Instance.new("TextLabel")
    displayLabel.Name = "DisplayLabel"
    displayLabel.Size = UDim2.new(0, 80, 0, 30)
    displayLabel.Position = UDim2.new(0, 10, 0, 80)
    displayLabel.BackgroundTransparency = 1
    displayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    displayLabel.TextSize = 12
    displayLabel.Font = Enum.Font.Gotham
    displayLabel.Text = "디플닉:"
    displayLabel.TextXAlignment = Enum.TextXAlignment.Left
    displayLabel.Parent = mainFrame

    -- 디플닉 입력창
    local displayInput = Instance.new("TextBox")
    displayInput.Name = "DisplayInput"
    displayInput.Size = UDim2.new(0, 280, 0, 30)
    displayInput.Position = UDim2.new(0, 100, 0, 80)
    displayInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    displayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    displayInput.TextSize = 12
    displayInput.Font = Enum.Font.Gotham
    displayInput.Text = DISPLAY_NAME
    displayInput.BorderSizePixel = 0
    displayInput.Parent = mainFrame

    local displayCorner = Instance.new("UICorner")
    displayCorner.CornerRadius = UDim.new(0, 5)
    displayCorner.Parent = displayInput

    -- 본닉 라벨
    local accountLabel = Instance.new("TextLabel")
    accountLabel.Name = "AccountLabel"
    accountLabel.Size = UDim2.new(0, 80, 0, 30)
    accountLabel.Position = UDim2.new(0, 10, 0, 120)
    accountLabel.BackgroundTransparency = 1
    accountLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    accountLabel.TextSize = 12
    accountLabel.Font = Enum.Font.Gotham
    accountLabel.Text = "본닉:"
    accountLabel.TextXAlignment = Enum.TextXAlignment.Left
    accountLabel.Parent = mainFrame

    -- 본닉 입력창
    local accountInput = Instance.new("TextBox")
    accountInput.Name = "AccountInput"
    accountInput.Size = UDim2.new(0, 280, 0, 30)
    accountInput.Position = UDim2.new(0, 100, 0, 120)
    accountInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    accountInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    accountInput.TextSize = 12
    accountInput.Font = Enum.Font.Gotham
    accountInput.Text = ACCOUNT_NAME
    accountInput.BorderSizePixel = 0
    accountInput.Parent = mainFrame

    local accountCorner = Instance.new("UICorner")
    accountCorner.CornerRadius = UDim.new(0, 5)
    accountCorner.Parent = accountInput

    -- 킬캠 적용 버튼
    local killcamApplyButton = Instance.new("TextButton")
    killcamApplyButton.Name = "KillcamApplyButton"
    killcamApplyButton.Size = UDim2.new(1, -20, 0, 35)
    killcamApplyButton.Position = UDim2.new(0, 10, 0, 160)
    killcamApplyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
    killcamApplyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    killcamApplyButton.TextSize = 13
    killcamApplyButton.Font = Enum.Font.GothamBold
    killcamApplyButton.Text = "✅ 킬캠 적용"
    killcamApplyButton.BorderSizePixel = 0
    killcamApplyButton.Parent = mainFrame

    local killcamButtonCorner = Instance.new("UICorner")
    killcamButtonCorner.CornerRadius = UDim.new(0, 5)
    killcamButtonCorner.Parent = killcamApplyButton

    -- ===== 플레이어 닉네임 섹션 =====
    local playerSectionLabel = Instance.new("TextLabel")
    playerSectionLabel.Name = "PlayerSection"
    playerSectionLabel.Size = UDim2.new(1, -20, 0, 25)
    playerSectionLabel.Position = UDim2.new(0, 10, 0, 205)
    playerSectionLabel.BackgroundTransparency = 1
    playerSectionLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    playerSectionLabel.TextSize = 14
    playerSectionLabel.Font = Enum.Font.GothamBold
    playerSectionLabel.Text = "👤 플레이어 닉네임 (지속 변경)"
    playerSectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    playerSectionLabel.Parent = mainFrame

    -- 플레이어 선택
    local playerLabel = Instance.new("TextLabel")
    playerLabel.Name = "PlayerLabel"
    playerLabel.Size = UDim2.new(0, 80, 0, 30)
    playerLabel.Position = UDim2.new(0, 10, 0, 235)
    playerLabel.BackgroundTransparency = 1
    playerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    playerLabel.TextSize = 12
    playerLabel.Font = Enum.Font.Gotham
    playerLabel.Text = "플레이어:"
    playerLabel.TextXAlignment = Enum.TextXAlignment.Left
    playerLabel.Parent = mainFrame

    local playerInput = Instance.new("TextBox")
    playerInput.Name = "PlayerInput"
    playerInput.Size = UDim2.new(0, 280, 0, 30)
    playerInput.Position = UDim2.new(0, 100, 0, 235)
    playerInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    playerInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    playerInput.TextSize = 12
    playerInput.Font = Enum.Font.Gotham
    playerInput.PlaceholderText = "'me' 또는 플레이어명"
    playerInput.BorderSizePixel = 0
    playerInput.Parent = mainFrame

    local playerCorner = Instance.new("UICorner")
    playerCorner.CornerRadius = UDim.new(0, 5)
    playerCorner.Parent = playerInput

    -- 직급 입력
    local rankLabel = Instance.new("TextLabel")
    rankLabel.Name = "RankLabel"
    rankLabel.Size = UDim2.new(0, 80, 0, 30)
    rankLabel.Position = UDim2.new(0, 10, 0, 275)
    rankLabel.BackgroundTransparency = 1
    rankLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    rankLabel.TextSize = 12
    rankLabel.Font = Enum.Font.Gotham
    rankLabel.Text = "직급:"
    rankLabel.TextXAlignment = Enum.TextXAlignment.Left
    rankLabel.Parent = mainFrame

    local rankInput = Instance.new("TextBox")
    rankInput.Name = "RankInput"
    rankInput.Size = UDim2.new(0, 280, 0, 30)
    rankInput.Position = UDim2.new(0, 100, 0, 275)
    rankInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    rankInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    rankInput.TextSize = 12
    rankInput.Font = Enum.Font.Gotham
    rankInput.PlaceholderText = "예: Soldier, General"
    rankInput.BorderSizePixel = 0
    rankInput.Parent = mainFrame

    local rankCorner = Instance.new("UICorner")
    rankCorner.CornerRadius = UDim.new(0, 5)
    rankCorner.Parent = rankInput

    -- 디스플레이 닉네임 입력
    local displayNicknameLabel = Instance.new("TextLabel")
    displayNicknameLabel.Name = "DisplayNicknameLabel"
    displayNicknameLabel.Size = UDim2.new(0, 80, 0, 30)
    displayNicknameLabel.Position = UDim2.new(0, 10, 0, 315)
    displayNicknameLabel.BackgroundTransparency = 1
    displayNicknameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    displayNicknameLabel.TextSize = 12
    displayNicknameLabel.Font = Enum.Font.Gotham
    displayNicknameLabel.Text = "디스플레이:"
    displayNicknameLabel.TextXAlignment = Enum.TextXAlignment.Left
    displayNicknameLabel.Parent = mainFrame

    local displayNicknameInput = Instance.new("TextBox")
    displayNicknameInput.Name = "DisplayNicknameInput"
    displayNicknameInput.Size = UDim2.new(0, 280, 0, 30)
    displayNicknameInput.Position = UDim2.new(0, 100, 0, 315)
    displayNicknameInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    displayNicknameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    displayNicknameInput.TextSize = 12
    displayNicknameInput.Font = Enum.Font.Gotham
    displayNicknameInput.PlaceholderText = "디스플레이 닉네임"
    displayNicknameInput.BorderSizePixel = 0
    displayNicknameInput.Parent = mainFrame

    local displayNicknameCorner = Instance.new("UICorner")
    displayNicknameCorner.CornerRadius = UDim.new(0, 5)
    displayNicknameCorner.Parent = displayNicknameInput

    -- 유저 네임 입력
    local usernameLabel = Instance.new("TextLabel")
    usernameLabel.Name = "UsernameLabel"
    usernameLabel.Size = UDim2.new(0, 80, 0, 30)
    usernameLabel.Position = UDim2.new(0, 10, 0, 355)
    usernameLabel.BackgroundTransparency = 1
    usernameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    usernameLabel.TextSize = 12
    usernameLabel.Font = Enum.Font.Gotham
    usernameLabel.Text = "유저명:"
    usernameLabel.TextXAlignment = Enum.TextXAlignment.Left
    usernameLabel.Parent = mainFrame

    local usernameInput = Instance.new("TextBox")
    usernameInput.Name = "UsernameInput"
    usernameInput.Size = UDim2.new(0, 280, 0, 30)
    usernameInput.Position = UDim2.new(0, 100, 0, 355)
    usernameInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    usernameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    usernameInput.TextSize = 12
    usernameInput.Font = Enum.Font.Gotham
    usernameInput.PlaceholderText = "유저 네임"
    usernameInput.BorderSizePixel = 0
    usernameInput.Parent = mainFrame

    local usernameCorner = Instance.new("UICorner")
    usernameCorner.CornerRadius = UDim.new(0, 5)
    usernameCorner.Parent = usernameInput

    -- 플레이어 변경 버튼
    local changeButton = Instance.new("TextButton")
    changeButton.Name = "ChangeButton"
    changeButton.Size = UDim2.new(1, -20, 0, 35)
    changeButton.Position = UDim2.new(0, 10, 0, 395)
    changeButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    changeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    changeButton.TextSize = 13
    changeButton.Font = Enum.Font.GothamBold
    changeButton.Text = "✅ 플레이어 변경 (지속)"
    changeButton.BorderSizePixel = 0
    changeButton.Parent = mainFrame

    local changeButtonCorner = Instance.new("UICorner")
    changeButtonCorner.CornerRadius = UDim.new(0, 5)
    changeButtonCorner.Parent = changeButton

    -- 상태 메시지
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -20, 0, 50)
    statusLabel.Position = UDim2.new(0, 10, 0, 440)
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.TextSize = 11
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Text = "✅ 준비 완료\n(우측 Shift로 토글)"
    statusLabel.TextWrapped = true
    statusLabel.Parent = mainFrame

    -- 닫기 버튼
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 16
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Text = "✕"
    closeButton.BorderSizePixel = 0
    closeButton.Parent = mainFrame

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 5)
    closeCorner.Parent = closeButton

    -- 킬캠 적용 버튼 클릭
    killcamApplyButton.MouseButton1Click:Connect(function()
        DISPLAY_NAME = displayInput.Text
        ACCOUNT_NAME = accountInput.Text
        print("✅ 킬캠 적용됨 - 디플닉:", DISPLAY_NAME, "본닉:", ACCOUNT_NAME)
        statusLabel.Text = "✅ 킬캠 설정 적용됨!\n디플닉: " .. DISPLAY_NAME .. "\n본닉: " .. ACCOUNT_NAME
    end)

    -- 플레이어 변경 버튼 클릭
    changeButton.MouseButton1Click:Connect(function()
        local playerName = playerInput.Text
        local rank = rankInput.Text
        local displayNickname = displayNicknameInput.Text
        local username = usernameInput.Text
        
        if playerName == "" then
            statusLabel.Text = "❌ 플레이어를 선택해주세요."
            return
        end
        
        if rank == "" and displayNickname == "" and username == "" then
            statusLabel.Text = "❌ 최소 하나 이상 입력해주세요."
            return
        end
        
        local targetPlayer
        
        if playerName:lower() == "me" then
            targetPlayer = player
        else
            targetPlayer = game.Players:FindFirstChild(playerName)
        end
        
        if not targetPlayer then
            statusLabel.Text = "❌ 플레이어를 찾을 수 없습니다."
            return
        end
        
        -- 저장
        PLAYER_CHANGES[targetPlayer.Name] = {rank, displayNickname, username}
        statusLabel.Text = "✅ " .. targetPlayer.Name .. " 지속 변경 시작!\n(계속 적용됩니다)"
        print("✅ 플레이어 지속 변경 추가:", targetPlayer.Name)
    end)

    -- 닫기 버튼
    closeButton.MouseButton1Click:Connect(function()
        toggleGui()
    end)

    -- 드래그 기능
    local dragging = false
    local dragStart
    local framePos

    mainFrame.InputBegan:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            framePos = mainFrame.Position
        end
    end)

    mainFrame.InputEnded:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input, gameProcessed)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = framePos + UDim2.new(0, delta.X, 0, delta.Y)
        end
    end)
end

-- UI 토글 함수
function toggleGui()
    if isGuiVisible then
        screenGui:Destroy()
        isGuiVisible = false
        print("❌ UI 숨김")
    else
        createGui()
        isGuiVisible = true
        print("✅ UI 표시")
    end
end

-- 우측 Shift 키 감지
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        toggleGui()
    end
end)

-- 킬캠 변경 함수
local function changeKillcamNicknames()
    local ui = playerGui:FindFirstChild("UI")
    if not ui then return end
    
    local container = ui:FindFirstChild("Container")
    if not container then return end
    
    local screen = container:FindFirstChild("Screen")
    if not screen then return end
    
    local deathScreen = screen:FindFirstChild("DeathScreen")
    if not deathScreen then return end
    
    -- 1️⃣ 디플닉 변경 (위의 빨간 텍스트) - "@본닉" 형식
    local eliminated = deathScreen:FindFirstChild("Eliminated")
    if eliminated then
        local killerLabel = eliminated:FindFirstChild("Killer")
        if killerLabel then
            killerLabel.Text = "You were eliminated by <b><font color=\"#FF3939\">" .. DISPLAY_NAME .. " @" .. ACCOUNT_NAME .. "</font></b>"
        end
    end
    
    -- 2️⃣ 본닉 변경 (왼쪽 초록색 카드)
    local killcard = deathScreen:FindFirstChild("Killcard")
    if killcard then
        local killedBy = killcard:FindFirstChild("KilledBy")
        if killedBy then
            local killerName = killedBy:FindFirstChild("KillerName")
            if killerName then
                killerName.Text = ACCOUNT_NAME
            end
        end
    end
end

-- 플레이어 닉네임 지속 변경 함수
local function applyPlayerChanges()
    for playerName, changes in pairs(PLAYER_CHANGES) do
        local targetPlayer = game.Players:FindFirstChild(playerName)
        if targetPlayer and targetPlayer.Character then
            local head = targetPlayer.Character:FindFirstChild("Head")
            if head then
                local nameTag = head:FindFirstChild("NameTag")
                if nameTag then
                    local rank, displayNickname, username = changes[1], changes[2], changes[3]
                    
                    if rank ~= "" then
                        local rankObj = nameTag:FindFirstChild("Rank") or nameTag:FindFirstChild("Soldier")
                        if rankObj then
                            rankObj.Text = rank
                        end
                    end
                    
                    if displayNickname ~= "" then
                        local displayNameObj = nameTag:FindFirstChild("DisplayName")
                        if displayNameObj then
                            displayNameObj.Text = displayNickname
                        end
                    end
                    
                    if username ~= "" then
                        local usernameObj = nameTag:FindFirstChild("Username")
                        if usernameObj then
                            usernameObj.Text = username
                        end
                    end
                end
            end
        end
    end
end

-- 계속 반복해서 변경 (0.1초마다)
while true do
    task.wait(0.1)
    changeKillcamNicknames()
    applyPlayerChanges()
end
