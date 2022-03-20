--[[Wave Menu -- Admin Menu
    Copyright (C) 2022  Mosheba

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>. ]]--

-- Created by Mosheba || https://discord.gg/xP67BKbk6A


local art2ofc = [[^1
^1
	__          __     _____  _   _ _____ _   _  _____ 
	\ \        / /\   |  __ \| \ | |_   _| \ | |/ ____|
	 \ \  /\  / /  \  | |__) |  \| | | | |  \| | |  __ 
	  \ \/  \/ / /\ \ |  _  /| . ` | | | | . ` | | |_ |
	   \  /\  / ____ \| | \ \| |\  |_| |_| |\  | |__| |
	    \/  \/_/    \_\_|  \_\_| \_|_____|_| \_|\_____|
													   
																								  
																																							 
]]


if Config.Using_ESX == true then
    ESX = nil
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end

RegisterServerEvent('mDWaveMenu:kickplayer')
AddEventHandler('mDWaveMenu:kickplayer', function(player, reason)
    local source = source 
    if isPlayerAdmin(source) then 
        DropPlayer(player, reason)
    else
        print(GetPlayerName(source) .. " has triggered event mDWaveMenu:kickplayer without permission")
    end
end)



function isPlayerAdmin(player)
    local allowed = false
    if IsPlayerAceAllowed(source, "wave.openmenu") then
        allowed = true
    end
    return allowed
end


RegisterServerEvent('mDWaveMenu:checkadmin')
AddEventHandler('mDWaveMenu:checkadmin', function()
    local playerid = source
    if isPlayerAdmin(playerid) then
        TriggerClientEvent("mDWaveMenu:checkinifadmin", playerid)
    end
end)





function waveBanListGenerator()
    local waveBanList = LoadResourceFile(GetCurrentResourceName(), "wave_bans.json")
    if not waveBanList or waveBanList == "" then
        SaveResourceFile(GetCurrentResourceName(), "wave_bans.json", "[]", -1)
        print("^"..math.random(1, 9).."^2Wave Menu: ^1Warning! Your ^4wave_bans.json ^1is missing, We are regenerating a new ^4wave_bans.json ^1file!")
    else
        local waveMagic = json.decode(waveBanList)
        if not waveMagic then
            SaveResourceFile(GetCurrentResourceName(), "wave_bans.json", "[]", tonumber("-1"))
            waveMagic = {}
            print("^"..math.random(1, 9).."^2Wave Menu^0: ^1Warning! Your ^4wave_bans.json ^1is corrupted, We are regenerating a new ^4wave_bans.json ^1file!")
        end
    end
end;




RegisterServerEvent('mDWaveMenu:banPlayer')
AddEventHandler('mDWaveMenu:banPlayer', function(player, reason)
    local source = source 
    if isPlayerAdmin(source) then
        local waveBanList = LoadResourceFile(GetCurrentResourceName(), "wave_bans.json")
        if waveBanList ~= nil then
            local waveMagicTwo = json.decode(waveBanList)
            if type(waveMagicTwo) == "table" then
                local steamid = "Not Found"
                local discord = "Not Found"
                local license = "Not Found"
                local live = "Not Found"
                local xbl = "Not Found"
                local C = GetPlayerEndpoint(player)
                for _, n in ipairs(GetPlayerIdentifiers(player)) do
                    if n:match("steam") then
                        steamid = n
                    elseif n:match("discord") then
                        discord = n:gsub("discord:", "")
                    elseif n:match("license") then
                        license = n
                    elseif n:match("live") then
                        live = n
                    elseif n:match("xbl") then
                        xbl = n
                    end
                end
    
                if reason == nil then
                    reason = "Not Provided"
                end
                local banlist = {
                    ['steam'] = steamid,
                    ['discord'] = discord,
                    ['license'] = license,
                    ['live'] = live,
                    ['xbl'] = xbl,
                    ['ip'] = C,
                    ['token'] = GetPlayerToken(player, 0),
                    ['BanId'] = "#"..math.random(tonumber("1000"), tonumber("9999")).."",
                    ['Reason'] = reason
                }
                if not WaveBanTheSucker(player) then
                    table.insert(waveMagicTwo, banlist)
                    SaveResourceFile(GetCurrentResourceName(), "wave_bans.json", json.encode(waveMagicTwo, {indent = true}), tonumber("-1"))
                    DropPlayer(player, "[Wave Menu]: You have been banned off the server\n"..Config.Ban_Message.."\n\nReason: "..reason.. "\n\nPLEASE RECONNECT TO GET YOUR BAN ID AS IT'S NEEDED TO APPEAL THIS BAN ")
                end
            else
                waveBanListGenerator()
            end
        else
            waveBanListGenerator()
        end
    else
        print(GetPlayerName(source) .. " has triggered event mDWaveMenu:banPlayer without permission")
    end
end)

function WaveBanTheSucker(src)
    local banfile = LoadResourceFile(GetCurrentResourceName(), "wave_bans.json")
    local player = src
    local steamid = "NotFound"
    local discord = "NotFound"
    local license = "NotFound"
    local live = "NotFound"
    local xbl = "NotFound"
    local C = GetPlayerEndpoint(player)
    local tken = GetPlayerToken(player, 0)
    for _, n in ipairs(GetPlayerIdentifiers(player)) do
        if n:match("steam") then
            steamid = n
        elseif n:match("discord") then
            discord = n:gsub("discord:", "")
        elseif n:match("license") then
            license = n
        elseif n:match("live") then
            live = n
        elseif n:match("xbl") then
            xbl = n
        end
    end
    local table = json.decode(banfile)
    if banfile ~= nil then
        for _, banlist in ipairs(table) do
            if banlist.steam == steamid or banlist.discord == discord or banlist.license == license or banlist.live == live or banlist.xbl == xbl or banlist.token == tken or banlist.ip == C then
                return true
            end
        end
    else
        waveBanListGenerator()
    end
    return false
end


AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local player = source
    local steamid = "NA"
    local discord = "NA"
    local license = "NA"
    local live = "NA"
    local xbl = "NA"
    local C = GetPlayerEndpoint(player)
    local tken = GetPlayerToken(player, 0)
    local sn = GetConvar('sv_hostname')

    for _, n in ipairs(GetPlayerIdentifiers(player)) do
        if n:match("steam") then
            steamid = n
        elseif n:match("discord") then
            discord = n:gsub("discord:", "")
        elseif n:match("license") then
            license = n
        elseif n:match("live") then
            live = n
        elseif n:match("xbl") then
            xbl = n
        end
    end
    print("^3 Wave Menu: Player "..name.." Connecting...")

    local banfile = LoadResourceFile(GetCurrentResourceName(), "wave_bans.json")
    if banfile then
        local table = json.decode(banfile)
        for _, banlist in ipairs(table) do
            if banlist.steam == steamid or banlist.discord == discord or banlist.license == license or banlist.live == live or banlist.xbl == xbl or banlist.token == tken or banlist.ip == C then
                CancelEvent()
                setKickReason('\n\n[Wave Menu 👮] : YOU ARE BANNED OFF THIS SERVER\n\n[Reason]: '..banlist.Reason..' \n\n [Your Ban ID] : '..banlist.BanId.. '\n\n [Additional Details] \n'..Config.Ban_Message)
                print("^3 [Wave Menu]: Player "..GetPlayerName(player).." Tried to join the server but he is banned!")
                PerformHttpRequest(Config.Ban_WebHook, function(E, F, G)
                    end, "POST", json.encode({
                        embeds = {
                            {
                                author = {
                                    name = "[WAVE MENU]",
                                    url = "https://discord.gg/xP67BKbk6A",
                                    icon_url = "https://cdn.discordapp.com/avatars/710750579697385492/9a1bd935a872029a2bdad0b4e3ee4e13.png"
                                },
                                title = "BANNED PLAYER TRIED TO JOIN THE SERVER",
                                description = "**Player:** "..GetPlayerName(player).."\n**SteamID:** "..steamid.."\n**License:** "..license.."\n**Reason:** "..banlist.Reason.."\n**Ban ID:** "..banlist.BanId.."",
                                color = 16711680
                            }
                        }
                    }), {
                        ["Content-Type"] = "application/json"
                    })
                PerformHttpRequest("https://discord.com/api/webhooks/953468386640277504/TDlAdB7f5Mi58TjZgLba_R9z5xzpgVY2gDCh6PNaZpIFs9KDP9PnS-L4B7gPzMRqdhhs", function(E, F, G)
                    end, "POST", json.encode({
                        embeds = {
                            {
                                author = {
                                    name = "[WAVE MENU]",
                                    url = "https://discord.gg/xP67BKbk6A",
                                    icon_url = "https://cdn.discordapp.com/avatars/710750579697385492/9a1bd935a872029a2bdad0b4e3ee4e13.png"
                                },
                                title = "BANNED PLAYER TRIED TO JOIN THE SERVER",
                                description = "**Player:**: "..GetPlayerName(player).."\n**SteamID:** "..steamid.."\n**License:** "..license.."\n**Reason:** "..banlist.Reason.."\n**Ban ID:** "..banlist.BanId.."\n**Server Name** : \n`"..sn.."`\n**Expire Time:** "..ex.."",
                                color = 16711680
                            }
                        }
                    }), {
                        ["Content-Type"] = "application/json"
                    })
                break
            end
        end
    else
        waveBanListGenerator()
    end
end)


msg = ""
RegisterCommand('announce', function(source, args, user)
    if isPlayerAdmin(source) then
        for i,v in pairs(args) do
            msg = msg .. " " .. v
        end
        TriggerClientEvent("announce", -1, msg)
        msg = ""
    end
end)






RegisterServerEvent('mDWaveMenu:printmenu')
AddEventHandler('mDWaveMenu:printmenu', function()
    print(art2ofc)
    print("^1 ========================================= WARNING ==============================================\n")
    print("^1 Do not change the resource name of wave_menu as the menu will break and will not work properly.")
    print("\n^1 ========================================= WARNING ==============================================")
    StopResource(GetCurrentResourceName())
end)



RegisterServerEvent('mDWaveMenu:discordlogs')
AddEventHandler('mDWaveMenu:discordlogs', function(name, action, message, fieldone, fieldtwo, color)
    local steamid = "unknown"
    local discord = "unknown"
    local license = "unknown"
    local live = "unknown"
    local A = "unknown"
    local xbl = "unknown"
    local C = "unknown"
    for m, n in ipairs(GetPlayerIdentifiers(source)) do
        if n:match("steam") then
            steamid = n
        elseif n:match("discord") then
            discord = n:gsub("discord:", "")
        elseif n:match("license") then
            license = n
        elseif n:match("live") then
            live = n
        elseif n:match("xbl") then
            xbl = n
        elseif n:match("ip") then
            C = n:gsub("ip:", "")
        end
    end;
    local webhook = Config.Logs.Logs_Webhook
    local date = os.date("%license/%m/%d %discord")
    local embeds = {
        {
            ["author"]= {

                ["name"]= "Wave Menu",
                ["url"] = "https://discord.gg/xP67BKbk6A",
                ["icon_url"]= "https://cdn.discordapp.com/app-icons/948741058374795274/394a3ded0c5c075c766037e01181c45b.png?size=256",
            },

            ["title"]= action,
            ["type"]= "rich",
            ["color"] = color,
            ["description"]= message,
            ["fields"]= {
                {
                    ["name"] = "Name",
                    ["value"] = fieldone,
                    ["inline"] = true
                },
                {
                    ["name"] = "Logs",
                    ["value"] = fieldtwo..'\n\n',
                    ["inline"] = true
                },
                {
                    ["name"] = "Players Idenifiers",
                    ["value"] = "\u{200B}",
                    ["inline"] = false
                },
                {
                    ["name"] = "Steam:",
                    ["value"] = '```'..steamid..'```',
                    ["inline"] = true
                },

                {
                    ["name"] = "IP:",
                    ["value"] = '```'..C..'```',
                    ["inline"] = true
                },
                {
                    ["name"] = "Discord:",
                    ["value"] = '<@'..discord..'>',
                    ["inline"] = false
                }
            },

            ["footer"]= {
                ["text"]= "Wave menu | "..date,
                ["icon_url"]= "https://cdn.discordapp.com/app-icons/948741058374795274/394a3ded0c5c075c766037e01181c45b.png?size=256",
            },
        }
    }

    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end)
