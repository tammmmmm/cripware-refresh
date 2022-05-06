local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst   = game:GetService("ReplicatedFirst")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local Lighting          = game:GetService("Lighting")
local Players           = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer.PlayerGui
local Mouse       = LocalPlayer:GetMouse()
local Camera      = workspace.CurrentCamera
RunService.RenderStepped:Connect(function()
    Camera = workspace.CurrentCamera
end)

local function Create(Object, Properties, Parent)
    local Obj = Instance.new(Object)

    for i,v in pairs (Properties) do
        Obj[i] = v
    end
    if Parent ~= nil then
        Obj.Parent = Parent
    end

    return Obj
end

local function GetCharacter()
end
local function GetHumanoid()
end
local function GetHealth()
end
local function GetBodypart()
end


local menu
do
    local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/senpaioffice132/frosty.tk/main/cw_menu.lua"))()

    menu = library.new([[soaphook <font color="rgb(78, 93, 234)">dev</font>]], "nemv2\\")
    local tabs = {
        menu.new_tab("http://www.roblox.com/asset/?id=7300477598"),
        menu.new_tab("http://www.roblox.com/asset/?id=7300535052"),
        menu.new_tab("http://www.roblox.com/asset/?id=7300480952"),
        menu.new_tab("http://www.roblox.com/asset/?id=7300486042"),
        menu.new_tab("http://www.roblox.com/asset/?id=7300489566"),
    }

    do
        local _menu = tabs[5].new_section("menu")

        local all_cfgs

        local configs = _menu.new_sector("configs")
        local text
        local list = configs.element("Scroll", "config list", {options = {"none"}}, function(State)
            text:set_value({Text = State.Scroll})
        end)
        text = configs.element("TextBox", "config name")
        configs.element("Button", "save", nil, function()
            if menu.values[5].menu.configs["config name"].Text ~= "none" then
                menu.save_cfg(menu.values[5].menu.configs["config name"].Text)
            end
        end)
        configs.element("Button", "load", nil, function()
            if menu.values[5].menu.configs["config name"].Text ~= "none" then
                menu.load_cfg(menu.values[5].menu.configs["config name"].Text)
            end
        end)

        local function update_cfgs()
            all_cfgs = listfiles("nemv2\\")
            for _,cfg in next, all_cfgs do
                all_cfgs[_] = string.gsub(string.gsub(cfg, "nemv2\\", ""), ".txt", "")
                list:add_value(all_cfgs[_])
            end
        end update_cfgs()

        task.spawn(function()
            while true do
                wait(1)
                update_cfgs()
            end
        end)

        local methods = _menu.new_sector("methods", "Right")
        methods.element("Combo", "mouse types", {options = {"target", "hit"}})
        methods.element("Dropdown", "ray method", {options = {"none", "findpartonray", "findpartonraywithignorelist", "raycast"}})
        methods.element("Slider", "minimum ray ignore", {default = {min = 0, max = 100, default = 3}})
        methods.element("Combo", "must include", {options = {"camera", "character"}, default = {Combo = {"camera", "character"}}})

        local playercheck = _menu.new_sector("player check")
        playercheck.element("Toggle", "free for all")
        playercheck.element("Toggle", "forcefield check")
    end
    do
        local aimbot = tabs[1].new_section("aimbot")

        local main = aimbot.new_sector("main")
        main.element("Toggle", "enabled"):add_keybind()
        main.element("Dropdown", "origin", {options = {"camera", "head"}})
        main.element("Dropdown", "hitbox", {options = {"head", "torso"}})
        main.element("Toggle", "automatic fire")

        local antiaim = tabs[1].new_section("antiaim")

        local direction = antiaim.new_sector("direction")
        direction.element("Toggle", "enabled"):add_keybind()
        direction.element("Dropdown", "yaw base", {options = {"camera", "random", "spin"}})
        direction.element("Slider", "yaw offset", {default = {min = -180, max = 180, default = 0}})
        direction.element("Dropdown", "yaw modifier", {options = {"none", "jitter", "offset jitter"}})
        direction.element("Slider", "modifier offset", {default = {min = -180, max = 180, default = 0}})
        direction.element("Toggle", "force angles")

        local fakelag = antiaim.new_sector("fakelag", "Right")
        fakelag.element("Toggle", "enabled"):add_keybind()
        fakelag.element("Dropdown", "method", {options = {"static", "random"}})
        fakelag.element("Slider", "limit", {default = {min = 1, max = 16, default = 6}})
        fakelag.element("Toggle", "visualize"):add_color(nil, true)
        fakelag.element("Toggle", "freeze world", nil, function(state)
            if menu.values[1].antiaim.fakelag["freeze world"].Toggle and menu.values[1].antiaim.fakelag["$freeze world"].Active then
                settings().Network.IncomingReplicationLag = 1000
            else
                settings().Network.IncomingReplicationLag = 0
            end
        end):add_keybind(nil, function(state)
            if menu.values[1].antiaim.fakelag["freeze world"].Toggle and menu.values[1].antiaim.fakelag["$freeze world"].Active then
                settings().Network.IncomingReplicationLag = 1000
            else
                settings().Network.IncomingReplicationLag = 0
            end
        end)

        local Line = Drawing.new("Line")
        Line.Visible = false
        Line.Transparency = 1
        Line.Color = Color3.new(1,1,1)
        Line.Thickness = 1
        Line.ZIndex = 1

        local EnabledPosition = Vector3.new()
        fakelag.element("Toggle", "no send", nil, function(State)
            if menu.values[1].antiaim.fakelag["no send"].Toggle and menu.values[1].antiaim.fakelag["$no send"].Active then
                local SelfCharacter = LocalPlayer.Character
                local SelfRootPart, SelfHumanoid = SelfCharacter and SelfCharacter:FindFirstChild("HumanoidRootPart"), SelfCharacter and SelfCharacter:FindFirstChildOfClass("Humanoid")
                if not SelfCharacter or not SelfRootPart or not SelfHumanoid then Line.Visible = false return end

                EnabledPosition = SelfRootPart.Position
            end
        end):add_keybind(nil, function(State)
            if menu.values[1].antiaim.fakelag["no send"].Toggle and menu.values[1].antiaim.fakelag["$no send"].Active then
                local SelfCharacter = LocalPlayer.Character
                local SelfRootPart, SelfHumanoid = SelfCharacter and SelfCharacter:FindFirstChild("HumanoidRootPart"), SelfCharacter and SelfCharacter:FindFirstChildOfClass("Humanoid")
                if not SelfCharacter or not SelfRootPart or not SelfHumanoid then Line.Visible = false return end

                EnabledPosition = SelfRootPart.Position
            end
        end)

        local WasEnabled = false
        local FakelagLoop = RunService.Heartbeat:Connect(function()
            local Enabled = menu.values[1].antiaim.fakelag["no send"].Toggle and menu.values[1].antiaim.fakelag["$no send"].Active or false

            local SelfCharacter = LocalPlayer.Character
            local SelfRootPart, SelfHumanoid = SelfCharacter and SelfCharacter:FindFirstChild("HumanoidRootPart"), SelfCharacter and SelfCharacter:FindFirstChildOfClass("Humanoid")
            if not SelfCharacter or not SelfRootPart or not SelfHumanoid then Line.Visible = false return end

            sethiddenproperty(SelfRootPart, "NetworkIsSleeping", Enabled)

            Line.Visible = Enabled
            local StartPos = Camera:WorldToViewportPoint(SelfRootPart.Position)
            Line.From = Vector2.new(StartPos.X, StartPos.Y)
            local EndPos, OnScreen = Camera:WorldToViewportPoint(EnabledPosition)
            if not OnScreen then
                Line.Visible = false
            end
            Line.To = Vector2.new(EndPos.X, EndPos.Y)
        end)

        task.spawn(function()
            local Network = game:GetService("NetworkClient")
            local LagTick = 0

            while true do
                wait(1/16)
                LagTick = math.clamp(LagTick + 1, 0, menu.values[1].antiaim.fakelag.limit.Slider)
                if menu.values[1].antiaim.fakelag.enabled.Toggle and menu.values[1].antiaim.fakelag["$enabled"].Active and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                    if LagTick == (menu.values[1].antiaim.fakelag.method.Dropdown == "static" and menu.values[1].antiaim.fakelag.limit.Slider or math.random(1, menu.values[1].antiaim.fakelag.limit.Slider)) then
                        Network:SetOutgoingKBPSLimit(9e9)
                        LagTick = 0

                        if LocalPlayer.Character:FindFirstChild("Fakelag") then
                            LocalPlayer.Character:FindFirstChild("Fakelag"):ClearAllChildren()
                        else
                            local Folder = Instance.new("Folder")
                            Folder.Name = "Fakelag"
                            Folder.Parent = LocalPlayer.Character
                        end
                        if menu.values[1].antiaim.fakelag.visualize.Toggle then
                            LocalPlayer.Character.Archivable = true
                            local Clone = LocalPlayer.Character:Clone()
                            for _,Obj in next, Clone:GetDescendants() do
                                if Obj.Name == "HumanoidRootPart" or Obj:IsA("Humanoid") or Obj:IsA("LocalScript") or Obj:IsA("Script") or Obj:IsA("Decal") then
                                    Obj:Destroy()
                                elseif Obj:IsA("BasePart") or Obj:IsA("Meshpart") or Obj:IsA("Part") then
                                    if Obj.Transparency == 1 then
                                        Obj:Destroy()
                                    else
                                        Obj.CanCollide = false
                                        Obj.Anchored = true
                                        Obj.Material = "ForceField"
                                        Obj.Color = menu.values[1].antiaim.fakelag["$visualize"].Color
                                        Obj.Transparency = menu.values[1].antiaim.fakelag["$visualize"].Transparency
                                        Obj.Size = Obj.Size + Vector3.new(0.03, 0.03, 0.03)
                                    end
                                end
                                pcall(function()
                                    Obj.CanCollide = false
                                end)
                            end
                            Clone.Parent = LocalPlayer.Character.Fakelag
                        end
                    else
                        Network:SetOutgoingKBPSLimit(1)
                    end
                else
                    if LocalPlayer.Character then
                        if LocalPlayer.Character:FindFirstChild("Fakelag") then
                            LocalPlayer.Character:FindFirstChild("Fakelag"):ClearAllChildren()
                        else
                            local Folder = Instance.new("Folder")
                            Folder.Name = "Fakelag"
                            Folder.Parent = LocalPlayer.Character
                        end
                    end
                    Network:SetOutgoingKBPSLimit(9e9)
                end
            end
        end)
    end
    do
        local Circle = Drawing.new("Circle") do
            Circle.Color = Color3.fromRGB(255, 255, 255)
            Circle.Thickness = 1
            Circle.Transparency = 1
            Circle.Radius = 100
            Circle.Visible = false

            RunService.RenderStepped:Connect(function()
                Circle.Position = UserInputService:GetMouseLocation()
                if menu.values[2].advanced["mouse offset"].enabled.Toggle then
                    Circle.Position = Circle.Position + Vector2.new(menu.values[2].advanced["mouse offset"]["x offset"].Slider, menu.values[2].advanced["mouse offset"]["y offset"].Slider)
                end
            end)
        end

        local aimbot = tabs[2].new_section("aimbot")

        local assist = aimbot.new_sector("assist")
        assist.element("Toggle", "enabled"):add_keybind()
        assist.element("Dropdown", "hitbox", {options = {"closest", "head", "torso"}})
        assist.element("Slider", "smoothing", {default = {min = 1, max = 50, default = 1}})

        local silent = aimbot.new_sector("silent aim")
        silent.element("Toggle", "enabled"):add_keybind()
        silent.element("Dropdown", "hitbox", {options = {"closest", "head", "torso"}})
        silent.element("Slider", "hitchance", {default = {min = 1, max = 100, default = 100}})

        local targeting = aimbot.new_sector("targeting", "Right")
        targeting.element("Dropdown", "prioritize", {options = {"crosshair", "distance", "lowest hp"}})
        targeting.element("Toggle", "visible check")
        targeting.element("Slider", "max distance", {default = {min = 250, max = 15000, default = 15000}})

        local fov = aimbot.new_sector("fov", "Right")
        fov.element("Slider", "fov size", {default = {min = 30, max = 600, default = 100}}, function(State) Circle.Radius = State.Slider end)
        fov.element("Toggle", "draw fov", nil, function(State) Circle.Visible = State.Toggle end):add_color({Color = Color3.fromRGB(84, 101, 255)}, nil, function(State) Circle.Color = State.Color end)
        fov.element("Slider", "sides", {default = {min = 15, max = 100, default = 100}}, function(State) Circle.NumSides = State.Slider end)
        fov.element("Slider", "thickness", {default = {min = 1, max = 4, default = 1}}, function(State) Circle.Thickness = State.Slider end)

        local triggerbot = aimbot.new_sector("triggerbot")
        triggerbot.element("Toggle", "enabled"):add_keybind()
        triggerbot.element("Slider", "reaction time (ms)", {default = {min = 0, max = 500, default = 150}})

        local advanced = tabs[2].new_section("advanced")

        local offset = advanced.new_sector("mouse offset")
        offset.element("Toggle", "enabled")
        offset.element("Slider", "x offset", {default = {min = -100, max = 100, default = 0}})
        offset.element("Slider", "y offset", {default = {min = -100, max = 100, default = 0}})
    end
    do
        local players = tabs[3].new_section("players")

        local esp = players.new_sector("esp")
        esp.element("Toggle", "enabled"):add_keybind()
        esp.element("Slider", "max distance", {default = {min = 250, max = 15000, default = 15000}})

        local enemies = players.new_sector("enemies")
        enemies.element("Toggle", "box"):add_color({Color = Color3.fromRGB(255, 255, 255)})
        enemies.element("Toggle", "name"):add_color({Color = Color3.fromRGB(255, 255, 255)})
        enemies.element("Toggle", "health"):add_color({Color = Color3.fromRGB(0, 255, 0)})
        enemies.element("Toggle", "indicators"):add_color({Color = Color3.fromRGB(255, 255, 255)})
        enemies.element("Combo", "types", {options = {"tool", "distance"}})

        local friendlies = players.new_sector("friendlies")
        friendlies.element("Toggle", "box"):add_color({Color = Color3.fromRGB(255, 255, 255)})
        friendlies.element("Toggle", "name"):add_color({Color = Color3.fromRGB(255, 255, 255)})
        friendlies.element("Toggle", "health"):add_color({Color = Color3.fromRGB(0, 255, 0)})
        friendlies.element("Toggle", "indicators"):add_color({Color = Color3.fromRGB(255, 255, 255)})
        friendlies.element("Combo", "types", {options = {"tool", "distance"}})

        local oof = players.new_sector("out of fov", "Right")
        oof.element("Toggle", "enemies"):add_color({Color = Color3.fromRGB(84, 101, 255)})
        oof.element("Toggle", "teammates"):add_color({Color = Color3.fromRGB(84, 101, 255)})
        oof.element("Slider", "size", {default = {min = 10, max = 15, default = 15}})
        oof.element("Slider", "offset", {default = {min = 100, max = 700, default = 400}})
        oof.element("Combo", "settings", {options = {"outline", "blinking"}})

        local function UpdateChams()
            for _,Player in next, Players:GetPlayers() do
                if Player ~= LocalPlayer then
                    ApplyChams(Player)
                end
            end
        end

        local chams = players.new_sector("chams", "Right")
        chams.element("Toggle", "enemies", nil, UpdateChams):add_color({Color = Color3.fromRGB(141, 115, 245)}, false, UpdateChams)
        chams.element("Toggle", "friendlies", nil, UpdateChams):add_color({Color = Color3.fromRGB(102, 255, 102)}, false, UpdateChams)
        chams.element("Toggle", "through walls", nil, UpdateChams):add_color({Color = Color3.fromRGB(170, 170, 170)}, false, UpdateChams)

        local drawings = players.new_sector("drawings", "Right")
        drawings.element("Dropdown", "font", {options = {"Plex", "Monospace", "System", "UI"}})
        drawings.element("Dropdown", "surround", {options = {"none", "[]", "--", "<>"}})

        local world = tabs[3].new_section("world")

        local self = world.new_sector("self")
        self.element("Toggle", "third person"):add_keybind()
        self.element("Slider", "distance", {default = {min = 8, max = 20, default = 15}})
        self.element("Toggle", "fov changer"):add_keybind()
        self.element("Slider", "field of view", {default = {min = 30, max = 120, default = 80}})
    end
    do
        local misc = tabs[4].new_section("misc")

        local character = misc.new_sector("character")
        character.element("Toggle", "walkspeed"):add_keybind()
        character.element("Slider", "speed", {default = {min = 20, max = 200, default = 50}})
        character.element("Toggle", "jumppower"):add_keybind()
        character.element("Slider", "power", {default = {min = 50, max = 200, default = 50}})
        character.element("Slider", "height", {default = {min = 7, max = 50, default = 15}})
        character.element("Toggle", "noclip"):add_keybind()

        local NoclipLoop = RunService.Stepped:Connect(function()
            if not LocalPlayer.Character then return end
            if not menu.values[4].misc.character.noclip.Toggle and not menu.values[4].misc.character["$noclip"].Toggle then return end

            for _,part in pairs (LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide == true then
                    part.CanCollide = false
                end
            end
        end)
    end
end

function ApplyChams(Player)
    if Player.Character == nil then return end

    local BodyParts =
    {
    "Torso", "UpperTorso", "LowerTorso",
    "Left Arm", "LeftUpperArm","LeftLowerArm", "LeftHand",
    "Right Arm", "RightUpperArm", "RightLowerArm", "RightHand",
    "Left Leg", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
    "Right Leg", "RightUpperLeg", "RightLowerLeg", "RightFoot"
    }

    local Enabled, Color
    if Player.Team ~= LocalPlayer.Team then
        Enabled = menu.values[3].players.chams["enemies"].Toggle
        Color = menu.values[3].players.chams["$enemies"].Color
    else
        Enabled = menu.values[3].players.chams["friendlies"].Toggle
        Color = menu.values[3].players.chams["$friendlies"].Color
    end
    local Enabled2, Color2 = menu.values[3].players.chams["through walls"].Toggle, menu.values[3].players.chams["$through walls"].Color

    local function ApplyHandle(Part, Handle)
        local Inline, __Outline = Part:FindFirstChild("Inline"), Part:FindFirstChild("_Outline")
        if not Inline then
            Inline = Create(Handle, {
                Name = "Inline",
                Color3 = Color2,
                Transparency = 0.75,
                ZIndex = 2,
                AlwaysOnTop = true,
                AdornCullingMode = "Never",
                Visible = Enabled and Enabled2 or false,
                Adornee = Part,
            })
            if Handle == "BoxHandleAdornment" then
                Inline.Size = Part.Size + Vector3.new(0.05, 0.05, 0.05)
            else
                Inline.Radius = Part.Size.X / 2 + 0.15
                Inline.Height = Part.Size.Y + 0.3
                Inline.CFrame = CFrame.new(Vector3.new(), Vector3.new(0,1,0))
            end
        end
        if not _Outline then
            _Outline = Create(Handle, {
                Name = "_Outline",
                Color3 = Color,
                Transparency = 0.55,
                Transparency = 0.55,
                ZIndex = 2,
                AlwaysOnTop = false,
                AdornCullingMode = "Never",
                Visible = Enabled,
                Adornee = Part,
            })
            if Handle == "BoxHandleAdornment" then
                _Outline.Size = Part.Size + Vector3.new(0.1, 0.1, 0.1)
            else
                _Outline.Radius = Part.Size.X / 2 + 0.2
                _Outline.Height = Part.Size.Y + 0.35
                _Outline.CFrame = CFrame.new(Vector3.new(), Vector3.new(0,1,0))
            end
        end
        Inline.Color3 = Color2
        Inline.Visible = Enabled and Enabled2 or false
        _Outline.Color3 = Color
        _Outline.Visible = Enabled

        Inline.Parent = Part
        _Outline.Parent = Part

        return Inline, _Outline
    end

    for _,Part in next, Player.Character:GetChildren() do
        if Part.Name == "Head" and not Part:IsA("LocalScript") and not Part:IsA("Accessory") then
            ApplyHandle(Part, "CylinderHandleAdornment")
        elseif table.find(BodyParts, Part.Name) and not Part:IsA("LocalScript") and not Part:IsA("Accessory") then
            ApplyHandle(Part, "BoxHandleAdornment")
        end
    end

    Player.Character.ChildAdded:Connect(function(Child)
        if Child.Name == "Head" and not Child:IsA("LocalScript") and not Child:IsA("Accessory") then
            ApplyHandle(Child, "CylinderHandleAdornment")
        elseif table.find(BodyParts, Child.Name) and not Child:IsA("LocalScript") and not Child:IsA("Accessory") then
            ApplyHandle(Child, "BoxHandleAdornment")
        end
    end)
end

Players.PlayerAdded:Connect(function(Player)
    Player.CharacterAdded:Connect(function()
        RunService.RenderStepped:Wait()
        ApplyChams(Player)
    end)

    Player:GetPropertyChangedSignal("Team"):Connect(function()
        ApplyChams(Player)
    end)
end)
for _,Player in next, Players:GetPlayers() do
    if Player ~= LocalPlayer then
        ApplyChams(Player)

        Player.CharacterAdded:Connect(function()
            RunService.RenderStepped:Wait()
            ApplyChams(Player)
        end)

        Player:GetPropertyChangedSignal("Team"):Connect(function()
            ApplyChams(Player)
        end)
    end
end
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function()
    for _,Player in next, Players:GetPlayers() do
        ApplyChams(Player)
    end
end)

local TriggerbotDebounce = false
local TriggerbotLoop = RunService.RenderStepped:Connect(function()
    if not menu.values[2].aimbot.triggerbot.enabled.Toggle or not menu.values[2].aimbot.triggerbot["$enabled"].Active then return end
    if menu.open then return end
    if TriggerbotDebounce then return end

    local SelfCharacter = LocalPlayer.Character
    local SelfRootPart, SelfHumanoid = SelfCharacter and SelfCharacter:FindFirstChild("HumanoidRootPart"), SelfCharacter and SelfCharacter:FindFirstChildOfClass("Humanoid")
    if not SelfCharacter or not SelfRootPart or not SelfHumanoid then return end

    local Target = Mouse.Target
    local Player
    if Target and Target.Parent and Players:GetPlayerFromCharacter(Target.Parent) then
        Player = Players:GetPlayerFromCharacter(Target.Parent)
    end
    if not Target or not Player then return end
    if Player == LocalPlayer then return end

    local Character = Player.Character
    local RootPart, Humanoid = Character and Character:FindFirstChild("HumanoidRootPart"), Character and Character:FindFirstChildOfClass("Humanoid")
    if not Character or not RootPart or not Humanoid then return end
    if not Character:FindFirstChild("Head") then return end
    if menu.values[5].menu["player check"]["forcefield check"].Toggle and Character:FindFirstChildOfClass("ForceField") then return end
    if not menu.values[5].menu["player check"]["free for all"].Toggle and Player.Team == LocalPlayer.Team then return end
    TriggerbotDebounce = true
    task.spawn(function()
        if menu.values[2].aimbot.triggerbot["reaction time (ms)"].Slider/1000 > 1/60 then
            wait(menu.values[2].aimbot.triggerbot["reaction time (ms)"].Slider/1000)
        end
        mouse1press()
        repeat
            RunService.RenderStepped:Wait()
        until not Mouse.Target or not Mouse.Target.Parent or Players:GetPlayerFromCharacter(Mouse.Target.Parent) ~= Player or Players:GetPlayerFromCharacter(Mouse.Target.Parent) == LocalPlayer
        mouse1release()
        TriggerbotDebounce = false
    end)
end)

local ValidTargets = {}
local AimbotLoop = RunService.RenderStepped:Connect(function()
    ValidTargets = {}

    if menu.values[2].aimbot.assist.enabled.Toggle or menu.values[2].aimbot["silent aim"].enabled.Toggle then else return end
    local SelfCharacter = LocalPlayer.Character
    local SelfRootPart, SelfHumanoid = SelfCharacter and SelfCharacter:FindFirstChild("HumanoidRootPart"), SelfCharacter and SelfCharacter:FindFirstChildOfClass("Humanoid")
    if not SelfCharacter or not SelfRootPart or not SelfHumanoid then return end
    if menu.open then return end

    local Params                      = RaycastParams.new()
    Params.FilterType                 = Enum.RaycastFilterType.Blacklist
    Params.IgnoreWater                = true
    Params.FilterDescendantsInstances = {Camera, SelfCharacter}

    local Closest      = 999999

    local CameraPosition = Camera.CFrame.Position
    local MousePosition  = Vector2.new(Mouse.X, Mouse.Y)
    if menu.values[2].advanced["mouse offset"].enabled.Toggle then
        MousePosition = MousePosition + Vector2.new(menu.values[2].advanced["mouse offset"]["x offset"].Slider, menu.values[2].advanced["mouse offset"]["y offset"].Slider)
    end
    for _,Player in pairs (Players:GetPlayers()) do
        local Character = Player.Character
        local RootPart, Humanoid = Character and Character:FindFirstChild("HumanoidRootPart"), Character and Character:FindFirstChildOfClass("Humanoid")
        if not Character or not RootPart or not Humanoid then continue end
        if not Character:FindFirstChild("Head") then continue end
        if menu.values[5].menu["player check"]["forcefield check"].Toggle and Character:FindFirstChildOfClass("ForceField") then continue end
        if not menu.values[5].menu["player check"]["free for all"].Toggle and Player.Team == LocalPlayer.Team then continue end
        if Player == LocalPlayer then continue end

        local Head
        for _,Part in next, Character:GetChildren() do
            if not Part:IsA("LocalScript") and Part.Name == "Head" then Head = Part break end
        end
        if not Head then continue end

        local DistanceFromCharacter = (Camera.CFrame.Position - RootPart.Position).Magnitude
        if menu.values[2].aimbot.targeting["max distance"].Slider < DistanceFromCharacter then continue end

        local Pos, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)
        if not OnScreen then continue end
        local Magnitude = (Vector2.new(Pos.X, Pos.Y) - MousePosition).Magnitude
        if not (Magnitude < menu.values[2].aimbot.fov["fov size"].Slider) then continue end

        local Hitbox = menu.values[2].aimbot.assist.hitbox.Dropdown == "head" and Head or RootPart
        if menu.values[2].aimbot.assist.hitbox.Dropdown == "closest" then
            local HeadPos  = Camera:WorldToViewportPoint(Head.Position)
            local TorsoPos = Camera:WorldToViewportPoint(RootPart.Position)

            local HeadDistance  = (Vector2.new(HeadPos.X, HeadPos.Y) - MousePosition).Magnitude
            local TorsoDistance = (Vector2.new(TorsoPos.X, TorsoPos.Y) - MousePosition).Magnitude

            Hitbox = HeadDistance < TorsoDistance and Head or RootPart
        end

        if menu.values[2].aimbot.targeting["visible check"].Toggle then
            local Direction = Hitbox.Position - CameraPosition
            local Result    = workspace:Raycast(CameraPosition, Direction.Unit * Direction.Magnitude, Params)

            if not Result then continue end
            local Hit, Pos  = Result.Instance, Result.Position

            if not Hit:FindFirstAncestor(Player.Name) then continue end
            table.insert(ValidTargets, {Player, Hitbox, Magnitude, DistanceFromCharacter, Humanoid.Health})
        else
            table.insert(ValidTargets, {Player, Hitbox, Magnitude, DistanceFromCharacter, Humanoid.Health})
        end
    end

    if menu.values[2].aimbot.targeting.prioritize.Dropdown == "crosshair" then
        table.sort(ValidTargets, function(a, b) return a[3] < b[3] end)
    elseif menu.values[2].aimbot.targeting.prioritize.Dropdown == "distance" then
        table.sort(ValidTargets, function(a, b) return a[4] < b[4] end)
    elseif menu.values[2].aimbot.targeting.prioritize.Dropdown == "lowest hp" then
        table.sort(ValidTargets, function(a, b) return a[5] < b[5] end)
    end

    if menu.values[2].aimbot.assist.enabled.Toggle and menu.values[2].aimbot.assist["$enabled"].Active then
        if #ValidTargets ~= 0 then
            local Target = ValidTargets[1]
            local Hitbox = Target[2]

            local Pos = Camera:WorldToScreenPoint(Hitbox.Position)
            local Magnitude = Vector2.new(Pos.X - Mouse.X, Pos.Y - Mouse.Y)
            if menu.values[2].advanced["mouse offset"].enabled.Toggle then
                Magnitude = Magnitude + Vector2.new(menu.values[2].advanced["mouse offset"]["x offset"].Slider, menu.values[2].advanced["mouse offset"]["y offset"].Slider)
            end
            mousemoverel(Magnitude.X/(menu.values[2].aimbot.assist.smoothing.Slider + 1), Magnitude.Y/(menu.values[2].aimbot.assist.smoothing.Slider + 1))
        end
    end
end)

local RageTarget
local RageLoop = RunService.RenderStepped:Connect(function()
    RageTarget = nil

    local function GetDeg(pos1, pos2)
        local start = pos1.LookVector
        local vector = CFrame.new(pos1.Position, pos2).LookVector
        local angle = math.acos(start:Dot(vector))
        local deg = math.deg(angle)
        return deg
    end

    local SelfCharacter = LocalPlayer.Character
    local SelfRootPart, SelfHumanoid = SelfCharacter and SelfCharacter:FindFirstChild("HumanoidRootPart"), SelfCharacter and SelfCharacter:FindFirstChildOfClass("Humanoid")
    if not SelfCharacter or not SelfRootPart or not SelfHumanoid then return end
    if not menu.values[1].aimbot.main.enabled.Toggle or not menu.values[1].aimbot.main["$enabled"].Active then return end
    if menu.open then return end

    if menu.values[1].aimbot.main["automatic fire"].Toggle then
        mouse1release()
    end

    local Params                      = RaycastParams.new()
    Params.FilterType                 = Enum.RaycastFilterType.Blacklist
    Params.IgnoreWater                = true
    Params.FilterDescendantsInstances = {Camera, SelfCharacter}

    for _,Player in pairs (Players:GetPlayers()) do
        local Character = Player.Character
        local RootPart, Humanoid = Character and Character:FindFirstChild("HumanoidRootPart"), Character and Character:FindFirstChildOfClass("Humanoid")
        if not Character or not RootPart or not Humanoid then continue end
        if not Character:FindFirstChild("Head") then continue end
        if menu.values[5].menu["player check"]["forcefield check"].Toggle and Character:FindFirstChildOfClass("ForceField") then continue end
        if not menu.values[5].menu["player check"]["free for all"].Toggle and Player.Team == LocalPlayer.Team then continue end
        if Humanoid.Health == 0 then continue end
        if Player == LocalPlayer then continue end

        local Head
        for _,Part in next, Character:GetChildren() do
            if not Part:IsA("LocalScript") and Part.Name == "Head" then Head = Part break end
        end
        if not Head then continue end
        local Hitbox
        if menu.values[1].aimbot.main.hitbox.Dropdown == "head" then
            for _,Part in next, Character:GetChildren() do
                if not Part:IsA("LocalScript") and string.lower(Part.Name) == menu.values[1].aimbot.main.hitbox.Dropdown then
                    Hitbox = Part
                    break
                end
            end
        else
            Hitbox = Character:FindFirstChild("HumanoidRootPart")
        end
        if not Hitbox then continue end

        local Origin = menu.values[1].aimbot.main.origin.Dropdown == "camera" and Camera.CFrame.Position or SelfRootPart.Position + Vector3.new(0, 1.5, 0)
        local Direction = Hitbox.Position - Origin
        local Result    = workspace:Raycast(Origin, Direction.Unit * Direction.Magnitude, Params)

        if not Result then continue end
        local Hit, Pos  = Result.Instance, Result.Position

        if not Hit:FindFirstAncestor(Player.Name) then continue end
        RageTarget = {Player, Head}

        if menu.values[1].aimbot.main["automatic fire"].Toggle then
            mouse1press()
        end

        break
    end
end)

local OriginalWalkspeed = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed or 16
local OriginalJumpPower = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower or 50
local OriginalJumpHeight = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpHeight or 7.2
local OriginalAutoRotate = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character:FindFirstChildOfClass("Humanoid").AutoRotate or true
local AntiaimAngle = CFrame.new()
local Jitter = false
local FOV = Camera.FieldOfView
RunService.RenderStepped:Connect(function()
    local SelfCharacter = LocalPlayer.Character
    local SelfRootPart, SelfHumanoid = SelfCharacter and SelfCharacter:FindFirstChild("HumanoidRootPart"), SelfCharacter and SelfCharacter:FindFirstChildOfClass("Humanoid")
    if not SelfCharacter or not SelfRootPart or not SelfHumanoid then return end

    if menu.values[4].misc.character.walkspeed.Toggle and menu.values[4].misc.character["$walkspeed"].Active then
        SelfHumanoid.WalkSpeed = menu.values[4].misc.character.speed.Slider
    else
        SelfHumanoid.WalkSpeed = OriginalWalkspeed
    end

    if menu.values[4].misc.character.jumppower.Toggle and menu.values[4].misc.character["$jumppower"].Active then
        SelfHumanoid.JumpPower = menu.values[4].misc.character.power.Slider
        SelfHumanoid.JumpHeight = menu.values[4].misc.character.height.Slider
    else
        SelfHumanoid.JumpPower = OriginalJumpPower
        SelfHumanoid.JumpHeight = OriginalJumpHeight
    end
    if menu.values[1].antiaim.direction.enabled.Toggle and menu.values[1].antiaim.direction["$enabled"].Active then
        SelfHumanoid.AutoRotate = false

        local Angle do
            Angle = -math.atan2(Camera.CFrame.LookVector.Z, Camera.CFrame.LookVector.X) + math.rad(-90)
            if menu.values[1].antiaim.direction["yaw base"].Dropdown == "random" then
                Angle = -math.atan2(Camera.CFrame.LookVector.Z, Camera.CFrame.LookVector.X) + math.rad(math.random(0, 360))
            elseif menu.values[1].antiaim.direction["yaw base"].Dropdown == "spin" then
                Angle = -math.atan2(Camera.CFrame.LookVector.Z, Camera.CFrame.LookVector.X) + tick() * 10 % 360
            end
        end

        local Offset = math.rad(menu.values[1].antiaim.direction["yaw offset"].Slider)
        Jitter = not Jitter
        if Jitter then
            if menu.values[1].antiaim.direction["yaw modifier"].Dropdown == "jitter" then
                Offset = math.rad(menu.values[1].antiaim.direction["modifier offset"].Slider)
            elseif menu.values[1].antiaim.direction["yaw modifier"].Dropdown == "offset jitter" then
                Offset = Offset + math.rad(menu.values[1].antiaim.direction["modifier offset"].Slider)
            end
        end
        local NewAngle = CFrame.new(SelfRootPart.Position) * CFrame.Angles(0, Angle + Offset, 0)
        local function ToYRotation(_CFrame)
            local X, Y, Z = _CFrame:ToOrientation()
            return CFrame.new(_CFrame.Position) * CFrame.Angles(0, Y, 0)
        end
        if menu.values[1].antiaim.direction["yaw base"].Dropdown == "targets" then
            local Target
            local Closest = 9999
            for _,Player in next, Players:GetPlayers() do
                if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then continue end

                local Pos, OnScreen = Camera:WorldToViewportPoint(Player.Character.HumanoidRootPart.Position)
                local Magnitude = (Vector2.new(Pos.X, Pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if Closest > Magnitude then
                    Target = Player.Character.HumanoidRootPart
                    Closest = Magnitude
                end
            end
            if Target ~= nil then
                NewAngle = CFrame.new(SelfRootPart.Position, Target.Position) * CFrame.Angles(0, 0, 0)
            end
        end
        AntiaimAngle = Angle + Offset
        SelfRootPart.CFrame = ToYRotation(NewAngle)
    else
        SelfHumanoid.AutoRotate = OriginalAutoRotate
    end
    if menu.values[3].world.self["fov changer"].Toggle and menu.values[3].world.self["$fov changer"].Active then
        Camera.FieldOfView = menu.values[3].world.self["field of view"].Slider
    else
        Camera.FieldOfView = FOV
    end
end)

local OldNewIndex; OldNewIndex = hookmetamethod(game, "__newindex", function(self, key, value)
    local SelfName = tostring(self)

    if self == Camera and key == "CFrame" then
        if menu.values[3].world.self["third person"].Toggle and menu.values[3].world.self["$third person"].Active then
            value = value + Camera.CFrame.LookVector * -menu.values[3].world.self.distance.Slider
        end
    end
    if not checkcaller() then
        if key == "FieldOfView" then
            FOV = value
            if menu.values[3].world.self["fov changer"].Toggle and menu.values[3].world.self["$fov changer"].Active then
                value = menu.values[3].world.self["field of view"].Slider
            end
        end
        if key == "WalkSpeed" then
            OriginalWalkspeed = value
            if menu.values[4].misc.character.walkspeed.Toggle and menu.values[4].misc.character["$walkspeed"].Active then
                value = menu.values[4].misc.character.speed.Slider
            end
        end
        if key == "JumpPower" then
            OriginalJumpPower = value
            if menu.values[4].misc.character.jumppower.Toggle and menu.values[4].misc.character["$jumppower"].Active then
                value = menu.values[4].misc.character.power.Slider
            end
        end
        if key == "JumpHeight" then
            OriginalJumpHeight = value
            if menu.values[4].misc.character.jumppower.Toggle and menu.values[4].misc.character["$jumppower"].Active then
                value = menu.values[4].misc.character.height.Slider
            end
        end
        if key == "AutoRotate" then
            OriginalAutoRotate = value
            if menu.values[1].antiaim.direction.enabled.Toggle and menu.values[1].antiaim.direction["$enabled"].Active then
                value = false
            end
        end
        if SelfName == "HumanoidRootPart" and key == "CFrame" then
            if menu.values[1].antiaim.direction.enabled.Toggle and menu.values[1].antiaim.direction["$enabled"].Active and menu.values[1].antiaim.direction["force angles"].Toggle then
                value = CFrame.new(value.Position) * CFrame.Angles(0, AntiaimAngle, 0)
            end
        end

        return OldNewIndex(self, key, value)
    end

    return OldNewIndex(self, key, value)
end)
local _Humanoid do
    RunService.RenderStepped:Connect(function()
        _Humanoid = nil
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            _Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        end
    end)
end
local OldIndex; OldIndex = hookmetamethod(game, "__index", function(self, key)
    local SelfName = tostring(self)

    if not checkcaller() then
        if _Humanoid and self == _Humanoid then
            if key == "WalkSpeed" then
                return OriginalWalkspeed
            end
            if key == "JumpPower" then
                return OriginalJumpPower
            end
            if key == "JumpHeight" then
                return OriginalJumpHeight
            end
        end
        if key == "FieldOfView" then
            if menu.values[3].world.self["fov changer"].Toggle and menu.values[3].world.self["$fov changer"].Active then
                return menu.values[3].world.self["field of view"].Slider
            end
        end

        if self == Mouse then
            if table.find(menu.values[5].menu.methods["mouse types"].Combo, string.lower(key)) then
                local LegitTarget = ValidTargets[1] and ValidTargets[1][2]
                local RageTarget = RageTarget and RageTarget[2]
                if RageTarget then
                    if key == "Target" then
                        return RageTarget
                    elseif key == "Hit" then
                        return RageTarget.CFrame
                    end
                elseif LegitTarget then
                    if not menu.values[2].aimbot["silent aim"].enabled.Toggle or not menu.values[2].aimbot["silent aim"]["$enabled"].Active then return OldIndex(self, key) end
                    if not (math.random(1, 100) <= menu.values[2].aimbot["silent aim"]["hitchance"].Slider) then return OldIndex(self, key) end
                    if key == "Target" then
                        return LegitTarget
                    elseif key == "Hit" then
                        return LegitTarget.CFrame
                    end
                end
            end
        end
    end

    return OldIndex(self, key)
end)
local OldNamecall; OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = tostring(getnamecallmethod())

    if checkcaller() then
        return OldNamecall(self, unpack(args))
    end

    if string.lower(method) == menu.values[5].menu.methods["ray method"].Dropdown then
        local Ignore
        if method == "Raycast" then
            Ignore = args[3].FilterDescendantsInstances
        elseif method == "FindPartOnRayWithIgnoreList" then
            Ignore = args[2]
        end
        if Ignore then
            if table.find(menu.values[5].menu.methods["must include"].Combo, "camera") and not table.find(Ignore, Camera) then
                return OldNamecall(self, ...)
            end
            if table.find(menu.values[5].menu.methods["must include"].Combo, "character") and not table.find(Ignore, LocalPlayer.Character) then
                return OldNamecall(self, ...)
            end
        end

        local LegitTarget = ValidTargets[1] and ValidTargets[1][2]
        local RageTarget = RageTarget and RageTarget[2]
        if RageTarget then
            if method == "Raycast" then
                args[2] = (RageTarget.Position - args[1]).unit * 500
            elseif method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRay" then
                args[1] = Ray.new(Camera.CFrame.Position, (RageTarget.Position - Camera.CFrame.Position).unit * 500)
            end
        elseif LegitTarget then
            if not menu.values[2].aimbot["silent aim"].enabled.Toggle or not menu.values[2].aimbot["silent aim"]["$enabled"].Active then return OldNamecall(self, ...) end
            if not (math.random(1, 100) <= menu.values[2].aimbot["silent aim"]["hitchance"].Slider) then return OldNamecall(self, ...) end
            if method == "Raycast" then
                args[2] = (LegitTarget.Position - args[1]).unit * 500
            elseif method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRay" then
                args[1] = Ray.new(Camera.CFrame.Position, (LegitTarget.Position - Camera.CFrame.Position).unit * 500)
            end
        end
    end

    return OldNamecall(self, unpack(args))
end)

local PlayerDrawings = {}
local Utility        = {}

Utility.Settings = {
    Line = {
        Thickness = 1,
        Color = Color3.fromRGB(0, 255, 0)
    },
    Text = {
        Size = 13,
        Center = true,
        Outline = true,
        Font = Drawing.Fonts.Plex,
        Color = Color3.fromRGB(255, 255, 255)
    },
    Square = {
        Thickness = 1,
        Color = menu.values[3].players.enemies["$box"].Color,
        Filled = false,
    },
    Triangle = {
        Color = Color3.fromRGB(255, 255, 255),
        Filled = true,
        Visible = false,
        Thickness = 1,
    }
}
function Utility.New(Type, Outline, Name)
    local drawing = Drawing.new(Type)
    for i, v in pairs(Utility.Settings[Type]) do
        drawing[i] = v
    end
    if Outline then
        drawing.Color = Color3.new(0,0,0)
        drawing.Thickness = 3
    end
    return drawing
end
function Utility.Add(Player)
    if not PlayerDrawings[Player] then
        PlayerDrawings[Player] = {
            Offscreen = Utility.New("Triangle", nil, "Offscreen"),
            Name = Utility.New("Text", nil, "Name"),
            Tool = Utility.New("Text", nil, "Tool"),
            Distance = Utility.New("Text", nil, "Distance"),
            BoxOutline = Utility.New("Square", true, "BoxOutline"),
            Box = Utility.New("Square", nil, "Box"),
            HealthOutline = Utility.New("Line", true, "HealthOutline"),
            Health = Utility.New("Line", nil, "Health")
        }
    end
end

for _,Player in pairs(Players:GetPlayers()) do
    if Player ~= LocalPlayer then
        Utility.Add(Player)
    end
end
Players.PlayerAdded:Connect(Utility.Add)
Players.PlayerRemoving:Connect(function(Player)
    if PlayerDrawings[Player] then
        for i,v in pairs(PlayerDrawings[Player]) do
            if v then
                v:Remove()
            end
        end

        PlayerDrawings[Player] = nil
    end
end)

local ESPLoop = game:GetService("RunService").RenderStepped:Connect(function()
    for _,Player in pairs (Players:GetPlayers()) do
        local PlayerDrawing = PlayerDrawings[Player]
        if not PlayerDrawing then continue end

        for _,Drawing in pairs (PlayerDrawing) do
            Drawing.Visible = false
        end

        if not menu.values[3].players.esp.enabled.Toggle or not menu.values[3].players.esp["$enabled"].Active then continue end

        local Character = Player.Character
        local RootPart, Humanoid = Character and Character:FindFirstChild("HumanoidRootPart"), Character and Character:FindFirstChildOfClass("Humanoid")
        if not Character or not RootPart or not Humanoid then continue end

        local DistanceFromCharacter = (Camera.CFrame.Position - RootPart.Position).Magnitude
        if menu.values[3].players.esp["max distance"].Slider < DistanceFromCharacter then continue end

        local Pos, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)
        if not OnScreen then
            local VisualTable = menu.values[3].players["out of fov"]
            if Player.Team ~= LocalPlayer.Team and not VisualTable.enemies.Toggle then continue end
            if Player.Team == LocalPlayer.Team and not VisualTable.teammates.Toggle then continue end

            local RootPos = RootPart.Position
            local CameraVector = Camera.CFrame.Position
            local LookVector = Camera.CFrame.LookVector

            local Dot = LookVector:Dot(RootPart.Position - Camera.CFrame.Position)
            if Dot <= 0 then
                RootPos = (CameraVector + ((RootPos - CameraVector) - ((LookVector * Dot) * 1.01)))
            end

            local ScreenPos, OnScreen = Camera:WorldToScreenPoint(RootPos)
            if not OnScreen then
                local Drawing = PlayerDrawing.Offscreen
                local FOV     = 800 - menu.values[3].players["out of fov"].offset.Slider
                local Size    = menu.values[3].players["out of fov"].size.Slider

                local Center = (Camera.ViewportSize / 2)
                local Direction = (Vector2.new(ScreenPos.X, ScreenPos.Y) - Center).Unit
                local Radian = math.atan2(Direction.X, Direction.Y)
                local Angle = (((math.pi * 2) / FOV) * Radian)
                local ClampedPosition = (Center + (Direction * math.min(math.abs(((Center.Y - FOV) / math.sin(Angle)) * FOV), math.abs((Center.X - FOV) / (math.cos(Angle)) / 2))))
                local Point = Vector2.new(math.floor(ClampedPosition.X - (Size / 2)), math.floor((ClampedPosition.Y - (Size / 2) - 15)))

                local function Rotate(point, center, angle)
                    angle = math.rad(angle)
                    local rotatedX = math.cos(angle) * (point.X - center.X) - math.sin(angle) * (point.Y - center.Y) + center.X
                    local rotatedY = math.sin(angle) * (point.X - center.X) + math.cos(angle) * (point.Y - center.Y) + center.Y

                    return Vector2.new(math.floor(rotatedX), math.floor(rotatedY))
                end

                local Rotation = math.floor(-math.deg(Radian)) - 47
                Drawing.PointA = Rotate(Point + Vector2.new(Size, Size), Point, Rotation)
                Drawing.PointB = Rotate(Point + Vector2.new(-Size, -Size), Point, Rotation)
                Drawing.PointC = Rotate(Point + Vector2.new(-Size, Size), Point, Rotation)
                Drawing.Color = Player.Team ~= LocalPlayer.Team and VisualTable["$enemies"].Color or VisualTable["$teammates"].Color

                Drawing.Filled = not table.find(menu.values[3].players["out of fov"].settings.Combo, "outline") and true or false
                if table.find(menu.values[3].players["out of fov"].settings.Combo, "blinking") then
                    Drawing.Transparency = (math.sin(tick() * 5) + 1) / 2
                else
                    Drawing.Transparency = 1
                end

                Drawing.Visible = true
            end
        else
            local VisualTable = Player.Team ~= LocalPlayer.Team and menu.values[3].players.enemies or menu.values[3].players.friendlies

            local Size           = (Camera:WorldToViewportPoint(RootPart.Position - Vector3.new(0, 3, 0)).Y - Camera:WorldToViewportPoint(RootPart.Position + Vector3.new(0, 2.6, 0)).Y) / 2
            local BoxSize        = Vector2.new(math.floor(Size * 1.5), math.floor(Size * 1.9))
            local BoxPos         = Vector2.new(math.floor(Pos.X - Size * 1.5 / 2), math.floor(Pos.Y - Size * 1.6 / 2))

            local Name           = PlayerDrawing.Name
            local Tool           = PlayerDrawing.Tool
            local Distance       = PlayerDrawing.Distance
            local Box            = PlayerDrawing.Box
            local BoxOutline     = PlayerDrawing.BoxOutline
            local Health         = PlayerDrawing.Health
            local HealthOutline  = PlayerDrawing.HealthOutline

            if VisualTable.box.Toggle then
                Box.Size = BoxSize
                Box.Position = BoxPos
                Box.Visible = true
                Box.Color = VisualTable["$box"].Color
                BoxOutline.Size = BoxSize
                BoxOutline.Position = BoxPos
                BoxOutline.Visible = true
            end

            if VisualTable.health.Toggle then
                Health.From = Vector2.new((BoxPos.X - 5), BoxPos.Y + BoxSize.Y)
                Health.To = Vector2.new(Health.From.X, Health.From.Y - (Humanoid.Health / Humanoid.MaxHealth) * BoxSize.Y)
                Health.Color = VisualTable["$health"].Color
                Health.Visible = true

                HealthOutline.From = Vector2.new(Health.From.X, BoxPos.Y + BoxSize.Y + 1)
                HealthOutline.To = Vector2.new(Health.From.X, (Health.From.Y - 1 * BoxSize.Y) -1)
                HealthOutline.Visible = true
            end

            local function SurroundString(String, Add)
                local Left = ""
                local Right = ""

                local Remove = false
                if Add == "[]" then
                    String = string.gsub(String, "%[", "")
                    String = string.gsub(String, "%[", "")

                    Left = "["
                    Right = "]"
                elseif Add == "--" then
                    Left = "-"
                    Right = "-"
                    Remove = true
                elseif Add == "<>" then
                    Left = "<"
                    Right = ">"
                    Remove = true
                end
                if Remove then
                    String = string.gsub(String, Left, "")
                    String = string.gsub(String, Right, "")
                end

                return Left..String..Right
            end

            if VisualTable.name.Toggle then
                Name.Text = SurroundString(Player.Name, menu.values[3].players.drawings.surround.Dropdown)
                Name.Position = Vector2.new(BoxSize.X / 2 + BoxPos.X, BoxPos.Y - 16)
                Name.Color = VisualTable["$name"].Color
                Name.Font = Drawing.Fonts[menu.values[3].players.drawings.font.Dropdown]
                Name.Visible = true
            end

            if VisualTable.indicators.Toggle then
                local BottomOffset = BoxSize.Y + BoxPos.Y + 1
                if table.find(VisualTable.types.Combo, "tool") then
                    local Equipped = Player.Character:FindFirstChildOfClass("Tool") and Player.Character:FindFirstChildOfClass("Tool").Name or "None"
                    Equipped = SurroundString(Equipped, menu.values[3].players.drawings.surround.Dropdown)
                    Tool.Text = Equipped
                    Tool.Position = Vector2.new(BoxSize.X/2 + BoxPos.X, BottomOffset)
                    Tool.Color = VisualTable["$indicators"].Color
                    Tool.Font = Drawing.Fonts[menu.values[3].players.drawings.font.Dropdown]
                    Tool.Visible = true
                    BottomOffset = BottomOffset + 15
                end
                if table.find(VisualTable.types.Combo, "distance") then
                    Distance.Text = SurroundString(math.floor(DistanceFromCharacter).."m", menu.values[3].players.drawings.surround.Dropdown)
                    Distance.Position = Vector2.new(BoxSize.X/2 + BoxPos.X, BottomOffset)
                    Distance.Color = VisualTable["$indicators"].Color
                    Distance.Font = Drawing.Fonts[menu.values[3].players.drawings.font.Dropdown]
                    Distance.Visible = true

                    BottomOffset = BottomOffset + 15
                end
            end
        end
    end
end)
