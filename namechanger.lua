local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

print("✅ [최종 완벽 통합 버전] UI & 환생수 동시 작동 시작!")

-- 킬캠 닉네임 설정
local DISPLAY_NAME = "5678"  -- 디플닉
local ACCOUNT_NAME = "1234"  -- 본닉
local REBIRTH_COUNT = "10"   -- 환생수
local REBIRTH_10_BADGE = "rbxassetid://73940890241936"  -- 10환생 계급장
local PROFILE_IMAGE = "rbxthumb://type=AvatarHeadShot&id=11187718885&w=420&h=420" -- 프로필 사진

-- 계급장 좌표 조절 기본값
local RECT_SIZE_X = 100
local RECT_SIZE_Y = 100
local RECT_OFFSET_X = 400
local RECT_OFFSET_Y = 100

-- 플레이어 닉네임 설정
local PLAYER_CHANGES = {}  -- {플레이어명 = {rank, displayNickname, username}}

local screenGui
local mainFrame
local isGuiVisible = false

-- UI 입력 필드 참조 (전역)
local displayInput
local accountInput
local rebirthInput
local sizeXInput
local sizeYInput
local offsetXInput
local offsetYInput
local playerInput
local rankInput
local displayNicknameInput
local usernameInput
local profileImageInput
local statusLabel

-- UI 생성 함수
local function createGui()
    if screenGui and screenGui.Parent then
        screenGui:Destroy()
    end

    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CombinedNicknameGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 760)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -380)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    titleLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "🎮 닉네임 & 계급장 변경 시스템"
    titleLabel.Parent = mainFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleLabel

    -- ===== 킬캠 섹션 =====
    local killcamSectionLabel = Instance.new("TextLabel")
    killcamSectionLabel.Name = "KillcamSection"
    killcamSectionLabel.Size = UDim2.new(1, -20, 0, 25)
    killcamSectionLabel.Position = UDim2.new(0, 10, 0, 45)
    killcamSectionLabel.BackgroundTransparency = 1
    killcamSectionLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    killcamSectionLabel.TextSize = 14
    killcamSectionLabel.Font = Enum.Font.GothamBold
    killcamSectionLabel.Text = "⚔️ 킬캠 닉네임 & 계급장"
    killcamSectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    killcamSectionLabel.Parent = mainFrame

    -- 입력창 생성 도우미
    local function createInputRow(labelText, defaultVal, posY)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 90, 0, 25)
        label.Position = UDim2.new(0, 10, 0, posY)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 12
        label.Font = Enum.Font.Gotham
        label.Text = labelText
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = mainFrame

        local input = Instance.new("TextBox")
        input.Size = UDim2.new(0, 270, 0, 25)
        input.Position = UDim2.new(0, 110, 0, posY)
        input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        input.TextColor3 = Color3.fromRGB(255, 255, 255)
        input.TextSize = 12
        input.Font = Enum.Font.Gotham
        input.Text = tostring(defaultVal)
        input.BorderSizePixel = 0
        input.Parent = mainFrame

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 5)
        c.Parent = input

        return input
    end

    displayInput = createInputRow("디플닉:", "", 75)
    accountInput = createInputRow("본닉:", "", 105)
    rebirthInput = createInputRow("환생수:", "", 135)
    
    sizeXInput = createInputRow("계급장 Size X:", RECT_SIZE_X, 165)
    sizeYInput = createInputRow("계급장 Size Y:", RECT_SIZE_Y, 195)
    offsetXInput = createInputRow("계급장 Offset X:", RECT_OFFSET_X, 225)
    offsetYInput = createInputRow("계급장 Offset Y:", RECT_OFFSET_Y, 255)

    profileImageInput = createInputRow("프로필 ID:", "", 285)
    profileImageInput.PlaceholderText = "플레이어 ID"

    -- 킬캠 적용 버튼
    local killcamApplyButton = Instance.new("TextButton")
    killcamApplyButton.Size = UDim2.new(1, -20, 0, 30)
    killcamApplyButton.Position = UDim2.new(0, 10, 0, 315)
    killcamApplyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
    killcamApplyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    killcamApplyButton.TextSize = 12
    killcamApplyButton.Font = Enum.Font.GothamBold
    killcamApplyButton.Text = "✅ 킬캠 설정 적용"
    killcamApplyButton.BorderSizePixel = 0
    killcamApplyButton.Parent = mainFrame

    local killcamButtonCorner = Instance.new("UICorner")
    killcamButtonCorner.CornerRadius = UDim.new(0, 5)
    killcamButtonCorner.Parent = killcamApplyButton

    -- ===== 플레이어 닉네임 섹션 =====
    local playerSectionLabel = Instance.new("TextLabel")
    playerSectionLabel.Name = "PlayerSection"
    playerSectionLabel.Size = UDim2.new(1, -20, 0, 25)
    playerSectionLabel.Position = UDim2.new(0, 10, 0, 355)
    playerSectionLabel.BackgroundTransparency = 1
    playerSectionLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    playerSectionLabel.TextSize = 14
    playerSectionLabel.Font = Enum.Font.GothamBold
    playerSectionLabel.Text = "👤 플레이어 닉네임 (지속 변경)"
    playerSectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    playerSectionLabel.Parent = mainFrame

    playerInput = createInputRow("플레이어:", "", 385)
    playerInput.PlaceholderText = "'me' 또는 플레이어명"

    rankInput = createInputRow("직급:", "", 415)
    rankInput.PlaceholderText = "예: Soldier, General"

    displayNicknameInput = createInputRow("본닉 @ 붙이기:", "", 445)
    displayNicknameInput.PlaceholderText = "본닉"

    usernameInput = createInputRow("디플닉:", "", 475)
    usernameInput.PlaceholderText = "디플닉"

    local changeButton = Instance.new("TextButton")
    changeButton.Size = UDim2.new(1, -20, 0, 30)
    changeButton.Position = UDim2.new(0, 10, 0, 510)
    changeButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    changeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    changeButton.TextSize = 12
    changeButton.Font = Enum.Font.GothamBold
    changeButton.Text = "✅ 플레이어 변경 (지속)"
    changeButton.BorderSizePixel = 0
    changeButton.Parent = mainFrame

    local changeButtonCorner = Instance.new("UICorner")
    changeButtonCorner.CornerRadius = UDim.new(0, 5)
    changeButtonCorner.Parent = changeButton

    statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -20, 0, 45)
    statusLabel.Position = UDim2.new(0, 10, 0, 550)
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.TextSize = 11
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Text = "✅ 준비 완료\n(우측 Shift로 토글)"
    statusLabel.TextWrapped = true
    statusLabel.Parent = mainFrame

    local closeButton = Instance.new("TextButton")
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

    -- 버튼 연결
    killcamApplyButton.MouseButton1Click:Connect(function()
        DISPLAY_NAME = displayInput.Text ~= "" and displayInput.Text or DISPLAY_NAME
        ACCOUNT_NAME = accountInput.Text ~= "" and accountInput.Text or ACCOUNT_NAME
        REBIRTH_COUNT = rebirthInput.Text ~= "" and rebirthInput.Text or REBIRTH_COUNT
        
        local profileId = profileImageInput.Text
        if profileId ~= "" then
            PROFILE_IMAGE = "rbxthumb://type=AvatarHeadShot&id=" .. profileId .. "&w=420&h=420"
        end
        
        statusLabel.Text = "✅ 킬캠 설정 적용됨!"
    end)

    changeButton.MouseButton1Click:Connect(function()
        local playerName = playerInput.Text
        local rank = rankInput.Text
        local displayNickname = displayNicknameInput.Text
        local username = usernameInput.Text
        
        if playerName == "" then
            statusLabel.Text = "❌ 플레이어를 선택해주세요."
            return
        end
        
        local targetPlayer = (playerName:lower() == "me") and player or game.Players:FindFirstChild(playerName)
        if not targetPlayer then
            statusLabel.Text = "❌ 플레이어를 찾을 수 없습니다."
            return
        end
        
        PLAYER_CHANGES[targetPlayer.Name] = {rank, displayNickname, username}
        statusLabel.Text = "✅ " .. targetPlayer.Name .. " 지속 변경 시작!"
    end)

    closeButton.MouseButton1Click:Connect(function()
        toggleGui()
    end)

    -- 드래그
    local dragging = false
    local dragStart
    local framePos

    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            framePos = mainFrame.Position
        end
    end)

    mainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = framePos + UDim2.new(0, delta.X, 0, delta.Y)
        end
    end)
end

-- UI 토글 함수 (UI가 닫힐 때 참조 변수들만 비우고 토글은 정상 작동)
function toggleGui()
    if isGuiVisible then
        if screenGui then screenGui:Destroy() end
        isGuiVisible = false
        displayInput = nil
        accountInput = nil
        rebirthInput = nil
        sizeXInput = nil
        sizeYInput = nil
        offsetXInput = nil
        offsetYInput = nil
        profileImageInput = nil
    else
        createGui()
        isGuiVisible = true
    end
end

-- 초기 실행 시 UI 띄우기
toggleGui()

-- 우측 Shift 감지
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        toggleGui()
    end
end)

-- 킬캠 변경 함수 (환생수: KillerRebirth 경로 적용 + 계급장 픽셀 조절 통합 + 프로필 사진)
local function changeKillcamNicknames()
    pcall(function()
        local ui = playerGui:FindFirstChild("UI")
        if not ui then return end
        
        local container = ui:FindFirstChild("Container")
        if not container then return end
        
        local screen = container:FindFirstChild("Screen")
        if not screen then return end
        
        local deathScreen = screen:FindFirstChild("DeathScreen")
        if not deathScreen then return end
        
        -- 값 분기 처리 (UI가 열려있을 때의 텍스트박스 값 or 닫혀있을 때의 기본 변수값)
        local curDisplay = (displayInput and displayInput.Text ~= "") and displayInput.Text or DISPLAY_NAME
        local curAccount = (accountInput and accountInput.Text ~= "") and accountInput.Text or ACCOUNT_NAME
        local curRebirth = (rebirthInput and rebirthInput.Text ~= "") and rebirthInput.Text or REBIRTH_COUNT

        -- 1️⃣ 디플닉 변경
        local eliminated = deathScreen:FindFirstChild("Eliminated")
        if eliminated then
            local killerLabel = eliminated:FindFirstChild("Killer")
            if killerLabel then
                killerLabel.Text = "You were eliminated by <b><font color=\"#FF3939\">" .. curDisplay .. " @" .. curAccount .. "</font></b>"
            end
        end
        
        -- 2️⃣ Killcard 내 본닉, 환생수(KillerRebirth), 계급장, 프로필 사진 변경
        local killcard = deathScreen:FindFirstChild("Killcard")
        if killcard then
            local killedBy = killcard:FindFirstChild("KilledBy")
            if killedBy then
                -- 본닉
                local killerName = killedBy:FindFirstChild("KillerName")
                if killerName then
                    killerName.Text = curAccount
                end
                
                -- 환생수 (올바른 경로: KilledBy -> KillerRebirth)
                local killerRebirth = killedBy:FindFirstChild("KillerRebirth")
                if killerRebirth then
                    killerRebirth.Text = "Rebirth " .. curRebirth
                end
                
                -- 계급장 아이콘 및 픽셀 크기/오프셋 조절
                local badgeIcon = killedBy:FindFirstChild("BadgeIcon")
                if badgeIcon then
                    badgeIcon.Image = REBIRTH_10_BADGE
                end

                local sX = tonumber(sizeXInput and sizeXInput.Text) or RECT_SIZE_X
                local sY = tonumber(sizeYInput and sizeYInput.Text) or RECT_SIZE_Y
                local oX = tonumber(offsetXInput and offsetXInput.Text) or RECT_OFFSET_X
                local oY = tonumber(offsetYInput and offsetYInput.Text) or RECT_OFFSET_Y

                for _, child in ipairs(killedBy:GetChildren()) do
                    if child:IsA("ImageLabel") or child:IsA("ImageButton") then
                        child.ImageRectSize = Vector2.new(sX, sY)
                        child.ImageRectOffset = Vector2.new(oX, oY)
                    end
                end
            end
        end
        
        -- 3️⃣ 프로필 사진 변경 (Killer -> KillerIcon)
        local killcard2 = deathScreen:FindFirstChild("Killcard")
        if killcard2 then
            local killedBy2 = killcard2:FindFirstChild("KilledBy")
            if killedBy2 then
                local killer = killedBy2:FindFirstChild("Killer")
                if killer then
                    local killerIcon = killer:FindFirstChild("KillerIcon")
                    if killerIcon then
                        killerIcon.Image = PROFILE_IMAGE
                    end
                end
            end
        end
    end)
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

-- 주기적 실행 (0.1초)
task.spawn(function()
    while true do
        task.wait(0.1)
        changeKillcamNicknames()
        applyPlayerChanges()
    end
end)
