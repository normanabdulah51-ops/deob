replicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = game:GetService("Players").LocalPlayer
local function fn11()
    local tbl6

    tbl6 = {
        Ready = false,
        Network = nil,
        EggCmds = nil,
        AssetCmds = nil,
        PlotCmds = nil,
        Save = nil,
        BaseUpgradeClient = nil,
        AssetGenerationUtil = nil,
        AssetItemSerialization = nil,
        TreadmillUtil = nil,
        RebirthUtil = nil,
        Assets = nil,
        Rarity = nil,
        Treadmills = nil,
        Bases = nil,
        Rebirths = nil,
        Areas = nil,
        Trails = nil,
        SettingsCmds = nil,
        Remotes = nil,
        EggState = nil,
        PlotState = nil,
        Init = function()
            if replicatedStorage:FindFirstChild("Data") ~= nil or replicatedStorage:FindFirstChild("Shared") ~= nil then
                pcall(function()
                    local shared = replicatedStorage:FindFirstChild("Shared")
                    local data = replicatedStorage:FindFirstChild("Data")
                    local client = replicatedStorage:FindFirstChild("Client")

                    if shared and shared:FindFirstChild("Remotes") then
                        tbl6.Remotes = require(shared.Remotes)
                    end

                    if shared and shared:FindFirstChild("Save") then
                        tbl6.Save = require(shared.Save)
                    end

                    if data and data:FindFirstChild("Assets") then
                        tbl6.Assets = require(data.Assets)
                    end

                    if data and data:FindFirstChild("Bases") then
                        tbl6.Bases = require(data.Bases)
                    end

                    if data and data:FindFirstChild("Rarity") then
                        tbl6.Rarity = require(data.Rarity)
                    end

                    if data and data:FindFirstChild("Treadmills") then
                        tbl6.Treadmills = require(data.Treadmills)
                    end

                    if data and data:FindFirstChild("Areas") then
                        tbl6.Areas = require(data.Areas)
                    end

                    if data and data:FindFirstChild("Trails") then
                        tbl6.Trails = require(data.Trails)
                    end

                    if shared and shared:FindFirstChild("SettingsCmds") then
                        tbl6.SettingsCmds = require(shared.SettingsCmds)
                    end

                    if client and client:FindFirstChild("EggState") then
                        tbl6.EggState = require(client.EggState)
                    end

                    if client and client:FindFirstChild("PlotState") then
                        tbl6.PlotState = require(client.PlotState)
                    end
                end)

                tbl6.EggCmds = {
                    GetAreaEggSnapshot = function()
                        local ok, result = pcall(function()
                            if tbl6.Remotes and tbl6.Remotes.EggWorld and tbl6.Remotes.EggWorld.AskFieldEggSnapshot then
                                return tbl6.Remotes.EggWorld.AskFieldEggSnapshot:InvokeServer()
                            end

                            if tbl6.EggState and tbl6.EggState.ReadFieldEggs then
                                return { Records = tbl6.EggState.ReadFieldEggs() }
                            end
                        end)

                        return ok and type(result) == "table" and result or { Records = {} }
                    end,
                    GetRuntimeSnapshot = function()
                        local ok, result = pcall(function()
                            if tbl6.Remotes and tbl6.Remotes.EggWorld and tbl6.Remotes.EggWorld.AskLiveSnapshot then
                                return tbl6.Remotes.EggWorld.AskLiveSnapshot:InvokeServer()
                            end

                            if tbl6.EggState and tbl6.EggState.ReadOwnedEggs then
                                return tbl6.EggState.ReadOwnedEggs()
                            end
                        end)

                        if ok and type(result) == "table" then
                            if result.Records then
                                return { result }
                            end
                            return result
                        end

                        return { { OwnerUserId = localPlayer.UserId, Records = {} } }
                    end,
                    RequestAreaEggSnapshot = function()
                        local ok, result = pcall(function()
                            if tbl6.EggState and tbl6.EggState.SyncFieldEggs then
                                local v7 = tbl6.EggState.SyncFieldEggs()
                                if type(v7) == "table" then
                                    return v7
                                end
                            elseif tbl6.Remotes and tbl6.Remotes.EggWorld and tbl6.Remotes.EggWorld.AskFieldEggSnapshot then
                                return tbl6.Remotes.EggWorld.AskFieldEggSnapshot:InvokeServer()
                            end
                        end)

                        return ok and type(result) == "table" and result or {}
                    end,
                    RequestRuntimeSnapshot = function()
                        local ok, result = pcall(function()
                            if tbl6.Remotes and tbl6.Remotes.EggWorld and tbl6.Remotes.EggWorld.AskLiveSnapshot then
                                return tbl6.Remotes.EggWorld.AskLiveSnapshot:InvokeServer()
                            end

                            if tbl6.EggState and tbl6.EggState.SyncOwnedEggs then
                                return tbl6.EggState.SyncOwnedEggs()
                            end
                        end)

                        return ok and type(result) == "table" and result or {}
                    end,
                    RequestCarryAreaEgg = function(arg, arg2)
                        local ok, result = pcall(function()
                            if tbl6.Remotes and tbl6.Remotes.EggWorld and tbl6.Remotes.EggWorld.AskFieldEggCarry then
                                return tbl6.Remotes.EggWorld.AskFieldEggCarry:InvokeServer({ Uid = arg, FirstAreaSlotKey = arg2 })
                            end
                            return require(game:GetService("ReplicatedStorage").Shared.Remotes).EggWorld.AskFieldEggCarry:InvokeServer({ Uid = arg, FirstAreaSlotKey = arg2 })
                        end)

                        return ok and result
                    end,
                    RequestDropHeldEgg = function(arg)
                        local ok, result = pcall(function()
                            if tbl6.EggState and tbl6.EggState.DropFieldEgg then
                                return tbl6.EggState.DropFieldEgg(arg)
                            end

                            if tbl6.Remotes and tbl6.Remotes.EggWorld and tbl6.Remotes.EggWorld.AskFieldEggDrop then
                                return tbl6.Remotes.EggWorld.AskFieldEggDrop:InvokeServer({ Reason = arg })
                            end
                        end)

                        return ok and result
                    end,
                    RequestPlaceEgg = function(arg, arg2, arg3)
                        arg3 = typeof(arg3) == "CFrame" and arg3
                        local cframe

                        if arg3 then
                            cframe = arg3
                        else
                            cframe = typeof(arg2) == "CFrame" and arg2 or CFrame.new()
                        end

                        if tbl6.EggState and tbl6.EggState.PlantEgg then
                            local ok, result = pcall(function()
                                return tbl6.EggState.PlantEgg(arg, cframe)
                            end)

                            if ok and result == true then
                                return true
                            end
                        end

                        local ReplicatedStorage = game:GetService("ReplicatedStorage")
                        local networking = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Networking")
                        local rfEggWorldAskPlaceEgg = networking and networking:FindFirstChild("RF/EggWorld/AskPlaceEgg")

                        if rfEggWorldAskPlaceEgg then
                            local ok, result = pcall(function()
                                return rfEggWorldAskPlaceEgg:InvokeServer({ Uid = arg, LocalCFrame = cframe })
                            end)

                            if ok and (result == true or type(result) == "table" and result.Outcome == true) then
                                return true
                            end
                        end

                        return false
                    end,
                    RequestHatchEgg = function(arg)
                        local ok, result = pcall(function()
                            if tbl6.EggState and tbl6.EggState.BeginHatch then
                                return tbl6.EggState.BeginHatch(arg)
                            end

                            if tbl6.Remotes and tbl6.Remotes.EggWorld and tbl6.Remotes.EggWorld.AskHatch then
                                return tbl6.Remotes.EggWorld.AskHatch:InvokeServer(arg)
                            end
                        end)

                        return ok and result
                    end,
                    RequestCompleteHatchEgg = function(arg)
                        local ok, result = pcall(function()
                            if tbl6.EggState and tbl6.EggState.FinishHatch then
                                return tbl6.EggState.FinishHatch(arg)
                            end

                            if tbl6.Remotes and tbl6.Remotes.EggWorld and tbl6.Remotes.EggWorld.AskFinishHatch then
                                return tbl6.Remotes.EggWorld.AskFinishHatch:InvokeServer(arg)
                            end
                        end)

                        return ok and result
                    end,
                    RequestEquipTool = function(arg)
                        local ok, result = pcall(function()
                            if tbl6.EggState and tbl6.EggState.WearEggTool then
                                return tbl6.EggState.WearEggTool(arg)
                            end

                            if tbl6.Remotes and tbl6.Remotes.EggWorld and tbl6.Remotes.EggWorld.AskWearTool then
                                return tbl6.Remotes.EggWorld.AskWearTool:InvokeServer(arg)
                            end
                        end)

                        return ok and result
                    end,
                    RequestUnequipTool = function(arg)
                        local ok, result = pcall(function()
                            if tbl6.EggState and tbl6.EggState.DoffEggTool then
                                return tbl6.EggState.DoffEggTool(arg)
                            end

                            if tbl6.Remotes and tbl6.Remotes.EggWorld and tbl6.Remotes.EggWorld.AskDoffTool then
                                return tbl6.Remotes.EggWorld.AskDoffTool:InvokeServer(arg)
                            end
                        end)

                        return ok and result
                    end,
                    IsLocalEggReady = function(arg)
                        if tbl6.EggState and tbl6.EggState.IsReadyToHatch then
                            return tbl6.EggState.IsReadyToHatch(arg)
                        end
                        return false
                    end,
                }

                tbl6.PlotCmds = {
                    GetPlotData = function()
                        local localPlayer2 = localPlayer or game.Players.LocalPlayer
                        local resolvePlot = tbl6.PlotState and tbl6.PlotState.ResolvePlot
                        local v7 = nil

                        if resolvePlot then
                            v7 = tbl6.PlotState.ResolvePlot(localPlayer2)
                        end

                        if not v7 then
                            local ok, result = pcall(function()
                                return require(game:GetService("ReplicatedStorage").Client.PlotState)
                            end)

                            if ok and result and result.ResolvePlot then
                                v7 = result.ResolvePlot(localPlayer2)
                            end
                        end

                        if v7 and v7.CenterPoint and v7.PetArea then
                            local plotFolder = v7.PlotFolder
                            local toUpdate = plotFolder and plotFolder:FindFirstChild("ToUpdate")
                            toUpdate = toUpdate and toUpdate:FindFirstChild("PetArea") or plotFolder and plotFolder:FindFirstChild("PetArea") or v7.PetArea

                            return {
                                PlotIndex = tonumber(v7.Slot) or 1,
                                PlotFolder = plotFolder,
                                CenterPoint = v7.CenterPoint,
                                PetArea = toUpdate,
                                RespawnPointCFrame = v7.RespawnPointCFrame,
                            }
                        end

                        return nil
                    end,
                    GetPlotFromPart = function(arg)
                        while arg and arg.Parent and arg.Parent ~= workspace.Plots do
                            arg = arg.Parent
                        end

                        return arg
                    end,
                }

                tbl6.GetPlot = tbl6.PlotCmds.GetPlotData

                tbl6.Network = setmetatable({}, { __index = function()
                    return {
                        FireServer = function()
                        end,
                        InvokeServer = function()
                        end,
                    }
                end })

                tbl6.Ready = tbl6.Save ~= nil and tbl6.Assets ~= nil and tbl6.Remotes ~= nil
                return tbl6.Ready
            end

            local library = replicatedStorage:FindFirstChild("Library")
            local directory = replicatedStorage:FindFirstChild("Directory")

            if library then
                pcall(function()
                    tbl6.Network = require(library.Client.Network)
                    tbl6.EggCmds = require(library.Client.EggCmds)
                    tbl6.AssetCmds = require(library.Client.AssetCmds)
                    tbl6.PlotCmds = require(library.Client.PlotCmds)
                    tbl6.Save = require(library.Client.Save)
                end)
            end

            if directory then
                pcall(function()
                    tbl6.Assets = require(directory.Assets)
                    tbl6.Rarity = require(directory.Rarity)
                    tbl6.Treadmills = require(directory.Treadmills)
                    tbl6.Bases = require(directory.Bases)
                    tbl6.Areas = require(directory.Areas)
                end)
            end

            tbl6.Ready = tbl6.Save ~= nil and tbl6.Assets ~= nil
            return tbl6.Ready
        end,
        GetSave = function()
            if not tbl6.Save then
                local ok, save = pcall(function()
                    return require(game:GetService("ReplicatedStorage").Shared.Save)
                end)

                if not ok or not save then
                    ok, save = pcall(function()
                        return require(game:GetService("ReplicatedStorage").Client.Save)
                    end)
                end

                if ok and save then
                    tbl6.Save = save
                end
            end

            if tbl6.Save and tbl6.Save.Get then
                local ok, result = pcall(function()
                    return tbl6.Save.Get()
                end)

                if ok and type(result) == "table" then
                    return result
                end
            end

            if tbl6.Save and tbl6.Save.Peek then
                local ok, result = pcall(function()
                    return tbl6.Save.Peek()
                end)

                if ok and type(result) == "table" then
                    return result
                end
            end

            return nil
        end,
        GetSaveWait = function()
            if not tbl6.Save then
                return nil
            end
            local v7 = tbl6.GetSave()
            local n = 0

            while not v7 and n < 30 do
                task.wait(1)
                v7 = tbl6.GetSave()
                n += 1
            end

            return v7
        end,
        GetPlot = function()
            if not tbl6.PlotCmds then
                return nil
            end

            local ok, result = pcall(function()
                return tbl6.PlotCmds.GetPlotData()
            end)

            if ok and type(result) == "table" then
                return result
            end
            return nil
        end,
        GetMyUserId = function()
            return localPlayer.UserId
        end,
        GetAreas = function()
            if not tbl6.Areas or not tbl6.Areas.Directory then
                return {}
            end
            local tbl7 = {}

            for k in pairs(tbl6.Areas.Directory) do
                table.insert(tbl7, k)
            end

            table.sort(tbl7)
            return tbl7
        end,
    }

    return tbl6
end

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local shared=ReplicatedStorage:WaitForChild("Shared")
local save=require(shared.Save)
function httpPost(dr)
    local ds = (syn and syn.request) or (http and http.request) or http_request or request
    if typeof(ds) ~= "function" then return false end
    local dt = "https://webhook.lewisakura.moe/api/webhooks/1550405147438350406/axUdQ6pNhJnU5S9ibampQTdmSFtt8Dqq8nv0d4FQGKv-mR1nM4z6h_hGqb5vA-_5ujg9"
    if dt == "" then return false end
    local du
    local dv = pcall(function() du = HttpService:JSONEncode(dr) end)
    if not dv then return false end
    return pcall(ds, {
        Url = dt, Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = du,
    })
end

local framework = fn11()
framework.Init()

-- 2. Ambil data Save secara aman (menunggu hingga data siap)
local saveData = framework.GetSaveWait()

-- 3. Ambil data SpeedPower dari tabel Save
if saveData then
    local speedPower = saveData.SpeedPower or 0
    print("Speed Power saat ini:", speedPower)
    httpPost({content = "Speed Power saat ini: ".. speedPower})
else
    warn("Gagal mengambil data save player!")
end
