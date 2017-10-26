local me
--[[local]] KANGZ = CreateFrame("FRAME", "KANGZ");
KANGZ:RegisterEvent("PARTY_MEMBERS_CHANGED")
KANGZ:RegisterEvent("VARIABLES_LOADED")
KANGZ:RegisterEvent("CHAT_MSG_GUILD")
KANGZ:RegisterEvent("CHAT_MSG_WHISPER")
KANGZ:RegisterEvent("CHAT_MSG_OFFICER")

local printColors =
{
	DARK	= "|cff6D3200",
	LIGHT	= "|cff92592C",
}
--FONT_COLOR_CODE_CLOSE	= "|r",
local printStrings =
{
	TITLE							= string.format("%s[KANGZ] %sUsage: /KANGZ, /kangz", printColors["DARK"], printColors["LIGHT"]),
	
	GUILD_AD_AUTO					= string.format("%s/kangz ad [on | off] %s- turn on/off automatic advertising of your DM Tribute ID in guild chat.", printColors["DARK"], printColors["LIGHT"]),
	GUILD_INV_AUTO					= string.format("%s/kangz inv guild [on | off] %s- turn on/off automatic invites if a trigger appears in guild chat.", printColors["DARK"], printColors["LIGHT"]),
	WHISPER_INV_AUTO				= string.format("%s/kangz inv whisper [on | off] %s- turn on/off automatic invites if a trigger appears in a whisper.", printColors["DARK"], printColors["LIGHT"]),
	GUILD_AD_AUTO_CURRENT			= string.format("%sCurrent auto-advertise setting: %s%s", printColors["LIGHT"], printColors["DARK"], "%s"),
	GUILD_INV_AUTO_CURRENT			= string.format("%sCurrent guild auto-invite setting: %s%s", printColors["LIGHT"], printColors["DARK"], "%s"),
	WHISPER_INV_AUTO_CURRENT		= string.format("%sCurrent whisper auto-invite setting: %s%s", printColors["LIGHT"], printColors["DARK"], "%s"),
	GUILD_AD_TIMER					= string.format("%s/kangz ad <minutes> %s- set the default timer for advertising in guild chat.", printColors["DARK"], printColors["LIGHT"]),
	ID_TIMER						= string.format("%s/kangz ID <minutes> %s- set the timer for Mizzle the Crafty despawn.", printColors["DARK"], printColors["LIGHT"]),
	START							= string.format("%s/kangz start <minutes> %s- start KANGZ. Duration optional, default is ID timer setting.", printColors["DARK"], printColors["LIGHT"]),
	STOP							= string.format("%s/kangz stop %s- stop KANGZ.", printColors["DARK"], printColors["LIGHT"]),
	GUILD_AD_TIMER_CURRENT			= string.format("%sCurrent guild ad timer setting: %s%s min(s)", printColors["LIGHT"], printColors["DARK"], "%s"),
	ID_TIMER_CURRENT				= string.format("%sCurrent Mizzle timer setting: %s%s min(s)", printColors["LIGHT"], printColors["DARK"], "%s"),
	EXPIRED							= string.format("%s[KANGZ] %sDM Tribute expired due to Mizzle the Crafty despawn.", printColors["DARK"], printColors["LIGHT"]),
	TRIGGER							= string.format("%s/kangz trigger [add | remove] <word> %s- add or remove an auto-invite trigger word.", printColors["DARK"], printColors["LIGHT"]),
	TRIGGER_LIST					= string.format("%s/kangz trigger list %s- list current trigger words.", printColors["DARK"], printColors["LIGHT"]),
	
	REPLY_TIMER						= string.format("%s/kangz reply cd <minutes> %s- Set the (per-player) cooldown for replying to whispers with hints while KANGZ is running.", printColors["DARK"], printColors["LIGHT"]),
	REPLY_TIMER_CURRENT				= string.format("%sCurrent reply cooldown setting: %s%s min(s)", printColors["LIGHT"], printColors["DARK"], "%s"),
	
	INVITE_TIMER					= string.format("%s/kangz inv cd <minutes> %s- Set the (per-player) cooldown for automatic invites.", printColors["DARK"], printColors["LIGHT"]),
	INVITE_TIMER_CURRENT			= string.format("%sCurrent invite cooldown setting: %s%s min(s)", printColors["LIGHT"], printColors["DARK"], "%s"),
	
	ID_TIMER_SET					= string.format("%s[KANGZ] Setting Mizzle the Crafty despawn timer to: %s%s min(s)", printColors["LIGHT"], printColors["DARK"], "%s"),
	INV_COOLDOWN_SET				= string.format("%s[KANGZ] Setting (per-player) invite cooldown to: %s%s min(s)", printColors["LIGHT"], printColors["DARK"], "%s"),
	WHISPER_COOLDOWN_SET			= string.format("%s[KANGZ] Setting (per-player) whisper reply cooldown to: %s%s min(s)", printColors["LIGHT"], printColors["DARK"], "%s"),
	START_SET						= string.format("%s[KANGZ] Starting KANGZ for: %s%s min(s)", printColors["LIGHT"], printColors["DARK"], "%s"),
	STOP_SET						= string.format("%s[KANGZ] Stopping KANGZ.", printColors["LIGHT"], printColors["DARK"], "%s"),
	WHISPER_AUTO_INV_SET			= string.format("%s[KANGZ] Setting whisper auto-invites to: %s%s", printColors["LIGHT"], printColors["DARK"], "%s"),
	GUILD_AUTO_INV_SET				= string.format("%s[KANGZ] Setting guild chat auto-invites to: %s%s", printColors["LIGHT"], printColors["DARK"], "%s"),
	AD_TIMER_SET					= string.format("%s[KANGZ] Setting timer between guild chat ads to: %s%s min(s)", printColors["LIGHT"], printColors["DARK"], "%s"),
	AD_AUTO_SET						= string.format("%s[KANGZ] Setting guild ads to: %s%s", printColors["LIGHT"], printColors["DARK"], "%s"),
	
	
	
	TRIGGER_ADD_SET					= string.format("%s[KANGZ] %sAdded trigger word: %s%s", printColors["DARK"], printColors["LIGHT"], printColors["DARK"], "%s"),
	TRIGGER_REMOVE_SET				= string.format("%s[KANGZ] %sRemoved trigger word: %s%s", printColors["DARK"], printColors["LIGHT"], printColors["DARK"], "%s"),
	TRIGGER_LIST_SET				= string.format("%s[KANGZ] %sCurrent triggers:", printColors["DARK"], printColors["LIGHT"]),
	ERROR_NO_TRIGGER				= string.format("%s[KANGZ] Error: could not find trigger: %s%s", printColors["LIGHT"], printColors["DARK"], "%s"),
	
	START_ERROR_NO_LEAD				= string.format("%s[KANGZ] Error: you are not the party leader! Aborting.", printColors["LIGHT"]),
	
	START_ERROR_ALREADY_RUNNING		= string.format("%s[KANGZ] Error: KANGZ is already running!", printColors["LIGHT"]),
	STOP_ERROR_NOT_RUNNING			= string.format("%s[KANGZ] Error: KANGZ was not running.", printColors["LIGHT"]),
	ERROR_INVALID_TIMER				= string.format("%s[KANGZ] Error: invalid timer.", printColors["LIGHT"]),
	ERROR_INVALID_ARGUMENT			= string.format("%s[KANGZ] Error: invalid argument.", printColors["LIGHT"]),
	ERROR_AD_TIMER_SHORT			= string.format("%s[KANGZ] Error: timer too short. Please set the timer higher than 1 min.", printColors["LIGHT"]),
	PREFIX_COLOR					= string.format("%s[KANGZ] %s", printColors["DARK"], printColors["LIGHT"]),
	
	GUILD_AD						= "[KANGZ] DM Tribute has been cleared. Whisper me for an invite.",
	GUILD_AD_END					= "[KANGZ] DM Tribute no longer available.",
	WHISPER_REPLY_HELP				= "[KANGZ] If you want DM Tribute buffs, please whisper me one of these words:",
	PREFIX							= "[KANGZ] ",
	
	
}

KANGZ_BUTTON_TOOLTIP	= "KANGZ"
KANGZ_BUTTON_TOOLTIP2a	= "Left-click to start KANGZ for the default duration."
KANGZ_BUTTON_TOOLTIP2b	= "Left-click to stop KANGZ."
KANGZ_BUTTON_TOOLTIP3	= "Right-click and drag to move this button."
KANGZ_BUTTON_TOOLTIP4	= "For a full list of commands, type /KANGZ"

local function print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg)
end

function KANGZ:MinToSec(mins)
	local secs = mins and (mins * 60) or nil
	return secs
end

function KANGZ:FormatTime(seconds)
	local hours = 0
	local minutes = 0
	while seconds >= 3600 do
		hours = hours + 1
		seconds = seconds - 3600
	end
	while seconds >= 60 do
		minutes = minutes + 1
		seconds = seconds - 60
	end
	if hours <= 9 then
		hours = "0"..hours
	end
	if minutes <= 9 then
		minutes = "0"..minutes
	end
	if seconds <= 9 then
		seconds = "0"..seconds
	end
	return string.format("Time left: %s:%s.%s", hours, minutes, seconds)
end

function KANGZ:SecToMin(secs)
	-- local mins = secs and (secs / 60) or nil
	-- return mins
	local mins = 0
	while secs >= 60 do
		mins = mins + 1
		secs = secs - 60
	end
	return mins, secs
end

local function ParseTimer(arg)
	local timer = tonumber(arg)
	if arg and not timer then
		print(printStrings.ERROR_INVALID_TIMER)
		return nil
	end
	return timer
end

function KANGZ:SendGuildAd(available)
	local msg
	if available then
		msg = printStrings["GUILD_AD"]
	else
		msg = printStrings["GUILD_AD_END"]
	end
	SendChatMessage(msg, "GUILD")
	-- SendChatMessage(msg, "RAID")
end

local MizzleTimerTotal
local GuildAdTimer
function KANGZ:OnUpdate()
	MizzleTimerTotal = MizzleTimerTotal - arg1
	GuildAdTimer = GuildAdTimer - arg1
	this.sessionTimer = this.sessionTimer - arg1
	
	local player, cooldown
	for player, cooldown in pairs(this.Players.WhisperCooldown) do
		if cooldown then
			this.Players.WhisperCooldown[player] = this.Players.WhisperCooldown[player] - arg1
			if this.Players.WhisperCooldown[player] <= 0 then
				this.Players.WhisperCooldown[player] = nil
			end
		end
	end
	
	for player, cooldown in pairs(this.Players.InviteCooldown) do
		if cooldown then
			this.Players.InviteCooldown[player] = this.Players.InviteCooldown[player] - arg1
			if this.Players.InviteCooldown[player] <= 0 then
				this.Players.InviteCooldown[player] = nil
			end
		end
	end
	
    if MizzleTimerTotal <= 0 and this.HaveID then
		print(printStrings["EXPIRED"])
        this:LostID()
        -- MizzleTimerTotal = this.sessionTimer and this.sessionTimer or KANGZ_Options["MizzleTimer"]
        MizzleTimerTotal = KANGZ_Options["MizzleTimer"]
    end
	if this.sessionTimer <= 0 and this.Running then
		print(printStrings["SESSION_END"])
		this:Stop()
	end
	if GuildAdTimer <= 0 and this.Running then
		GuildAdTimer = KANGZ_Options["GuildAdTimer"]
		-- if IsPartyLeader() and this.HaveID then
		if IsPartyLeader() then
			if (GetNumRaidMembers() == 0) then
				ConvertToRaid()
			end
			this:SendGuildAd(true)
		end
	end
	if not this.HaveID and not this.Running then
		KANGZ:SetScript("OnUpdate", nil)
	end
end

function KANGZ:Initialize()
	me = UnitName("player")
	if not KANGZ_Options then
		KANGZ_Options = 
		{
			MizzleTimer = 3600,		-- seconds (60 mins)
			GuildAdTimer = 300,		-- seconds (5 mins)
			WhisperCooldown = 300,	-- seconds (5 mins)
			InviteCooldown = 300,	-- seconds (5 mins)
			GuildAdAuto = true,
			GuildInviteAuto = false,
			WhisperInviteAuto = true,
			KANGZButtonFrameShown = true,
			KANGZButtonPosition = 268,
			Triggers =
			{
				["inv"] 	= true,
				["invi"] 	= true,
				["invit"] 	= true,
				["invite"] 	= true,
				["+"] 		= true,
				["dm"] 		= true,
				["tribute"] = true,
				["trib"] 	= true,
				["WE"]		= true,
				["WUZ"] 	= true,
				["KANGZ"] 	= true,
				["buff"] 	= true,
				["buffs"] 	= true,
				["1"] 		= true,
			},
		}
	end
	this.Players =
	{
		WhisperCooldown = {},
		InviteCooldown = {},
	}
	this.sessionTimer = 0
	
	MizzleTimerTotal = KANGZ_Options["MizzleTimer"]
	GuildAdTimer = KANGZ_Options["GuildAdTimer"]
end

function KANGZ:ListTriggers()
	print(printStrings.TRIGGER_LIST_SET)
	
	local msg = printStrings.PREFIX_COLOR
	for trigger in pairs(KANGZ_Options.Triggers) do
		msg = msg .. trigger .. ", "
	end
	print(msg)
end

function KANGZ:AddTrigger(trigger)
	KANGZ_Options.Triggers[trigger] = true
	print(string.format(printStrings["TRIGGER_ADD_SET"], trigger))
end

function KANGZ:RemoveTrigger(trigger)
	if KANGZ_Options.Triggers[trigger] then
		KANGZ_Options.Triggers[trigger] = nil
		print(string.format(printStrings["TRIGGER_REMOVE_SET"], trigger))
	else
		print(printStrings["ERROR_NO_TRIGGER"])
	end
end

function KANGZ:Start(duration)
	if not IsPartyLeader() then
		print(printStrings["START_ERROR_NO_LEAD"])
		return
	end
	if KANGZ.Running then
		print(printStrings["START_ERROR_ALREADY_RUNNING"])
		return
	end
	
	KANGZ.Running = true
	if not duration then
		duration = KANGZ_Options["MizzleTimer"]
	end
	KANGZ.sessionTimer = duration
	
	print(string.format(printStrings.START_SET, KANGZ:SecToMin(duration)))

	if (GetNumRaidMembers() == 0) then
		ConvertToRaid()
	end
	KANGZ:SetScript("OnUpdate", KANGZ.OnUpdate)
	
	if KANGZ_Options.GuildAdAuto then
		KANGZ:SendGuildAd(true)
	end
	
	KANGZButton:SetNormalTexture("Interface\\AddOns\\KANGZ\\Images\\KANGZButton-Up")
	KANGZButton:SetPushedTexture("Interface\\AddOns\\KANGZ\\Images\\KANGZButton-Down")
end

function KANGZ:Stop()
	if KANGZ.Running then
		MizzleTimerTotal = KANGZ_Options["MizzleTimer"]
		
		KANGZ:SendGuildAd(false)
		-- KANGZ:SetScript("OnUpdate", nil)
		KANGZ.Players.WhisperCooldown = {}
		KANGZ.Players.InviteCooldown = {}
		
		KANGZ.Running = false
		
		KANGZButton:SetNormalTexture("Interface\\AddOns\\KANGZ\\Images\\KANGZButton-Up-Disabled")
		KANGZButton:SetPushedTexture("Interface\\AddOns\\KANGZ\\Images\\KANGZButton-Down-Disabled")
		
		print(string.format(printStrings.STOP_SET))
	else
		print(printStrings["STOP_ERROR_NOT_RUNNING"])
	end
end

function KANGZ:GotID()
	print("KANGZ:GotID")
	this.HaveID = true
	MizzleTimerTotal = KANGZ_Options["MizzleTimer"]
	KANGZ:SetScript("OnUpdate", KANGZ.OnUpdate)
end
function KANGZ:LostID()
	print("KANGZ:LostID")
	this.HaveID = false
	if this.Running then
		this:Stop()
	end
end

function KANGZ:CanWhisper(player)
	return not this.Players.WhisperCooldown[player]
end

function KANGZ:CanInvite(player)
	return not this.Players.InviteCooldown[player]
end

function KANGZ:ProcessChatMessage(event, msg, author)
	msg = string.lower(msg)
	-- local canInvite = this.Running and this.HaveID and IsPartyLeader() and KANGZ_Options["GuildInviteAuto"]
	-- local canInvite = this.Running and IsPartyLeader() and KANGZ_Options["GuildInviteAuto"]
	
	-- if canInvite then
		msg = string.gsub(msg, "[^%a+%s%d]", "")	-- Filter message to only include alphanumerics and "+"
		for word in string.gfind(msg, "[^%s]+") do
			if (KANGZ_Options.Triggers[word] or KANGZ_Options.Triggers[string.upper(word)])
			and (event == "CHAT_MSG_WHISPER" or this:CanInvite(author)) then
				InviteByName(author)
				this.Players.InviteCooldown[author] = KANGZ_Options["InviteCooldown"]
				return
			end
		end
		
		if event == "CHAT_MSG_WHISPER" and this:CanWhisper(author) then
			local reply = printStrings["WHISPER_REPLY_HELP"]
			SendChatMessage(reply, "WHISPER", nil, author)
			
			reply = printStrings["PREFIX"]
			for trigger in pairs(KANGZ_Options.Triggers) do
				reply = reply .. trigger .. ", "
			end
			SendChatMessage(reply, "WHISPER", nil, author)
			
			this.Players.WhisperCooldown[author] = KANGZ_Options["WhisperCooldown"]
		elseif not this:CanWhisper(author) then
			print("[KANGZ] Debug can't whisper " .. author)
		end
	-- end
end

function KANGZ:OnEvent()
	if event == "PARTY_MEMBERS_CHANGED" then
		local grouped = max(GetNumPartyMembers(), GetNumRaidMembers()) > 0
		
		if this.HaveID and not grouped then
			this:LostID()
		end
	elseif event == "VARIABLES_LOADED" then
		this:Initialize()
	elseif ((event == "CHAT_MSG_GUILD" or event == "CHAT_MSG_OFFICER") and KANGZ_Options.GuildInviteAuto == true)
	or (event == "CHAT_MSG_WHISPER" and KANGZ_Options.WhisperInviteAuto == true) then
		if arg2 ~= me and this.Running and IsPartyLeader() then
			this:ProcessChatMessage(event, arg1, arg2)
		end
	end
end
KANGZ:SetScript("OnEvent", KANGZ.OnEvent);


SLASH_KANGZ1 = "/KANGZ"
function SlashCmdList.KANGZ(msg)
	msg = string.lower(msg)
	if msg == "" or msg == "help" then
		local setting
		print(printStrings["TITLE"])
		
		print(printStrings["GUILD_AD_AUTO"])
		setting = KANGZ_Options["GuildAdAuto"] == true and "on" or "off"
		print(string.format(printStrings["GUILD_AD_AUTO_CURRENT"], setting))
		
		print(string.format(printStrings["GUILD_AD_TIMER"], setting))
		setting = KANGZ:SecToMin(KANGZ_Options["GuildAdTimer"])
		print(string.format(printStrings["GUILD_AD_TIMER_CURRENT"], setting))
		
		print(printStrings["GUILD_INV_AUTO"])		
		setting = KANGZ_Options["GuildInviteAuto"] == true and "on" or "off"
		print(string.format(printStrings["GUILD_INV_AUTO_CURRENT"], setting))
		
		print(printStrings["WHISPER_INV_AUTO"])
		setting = KANGZ_Options["WhisperInviteAuto"] == true and "on" or "off"
		print(string.format(printStrings["WHISPER_INV_AUTO_CURRENT"], setting))
		
		print(printStrings["INVITE_TIMER"])
		setting = KANGZ:SecToMin(KANGZ_Options["InviteCooldown"])
		print(string.format(printStrings["INVITE_TIMER_CURRENT"], setting))
		
		print(printStrings["REPLY_TIMER"])
		setting = KANGZ:SecToMin(KANGZ_Options["WhisperCooldown"])
		print(string.format(printStrings["REPLY_TIMER_CURRENT"], setting))
		
		print(string.format(printStrings["ID_TIMER"], setting))
		
		setting = KANGZ:SecToMin(KANGZ_Options["MizzleTimer"])
		print(string.format(printStrings["ID_TIMER_CURRENT"], setting))
		
		print(printStrings["TRIGGER"])
		print(printStrings["TRIGGER_LIST"])
				
		print(printStrings["START"])
		print(printStrings["STOP"])
	else
		local args = {};
		for word in string.gfind(msg, "[^%s]+") do
			table.insert(args, word);
		end
		
		if args[1] == "ad" then
			if args[2] == "on" then
				KANGZ_Options["GuildAdAuto"] = true
				print(string.format(printStrings.AD_AUTO_SET, args[2]))
			elseif args[2] == "off" then
				KANGZ_Options["GuildAdAuto"] = false
				print(string.format(printStrings.AD_AUTO_SET, args[2]))
			else 
				local timer = ParseTimer(args[2])
				if timer then
					if timer < 1 then
						print(printStrings(ERROR_AD_TIMER_SHORT))	-- spam safety
						return
					end
					timer = KANGZ:MinToSec(timer)
					KANGZ_Options["GuildAdTimer"] = timer
					print(string.format(printStrings.AD_TIMER_SET, args[2]))
					if GuildAdTimer > timer then 
						GuildAdTimer = timer
					end
				end
			end
			return
		elseif args[1] == "reply" then
			if args[2] == "cd" or args[2] == "cooldown" then
				local timer = ParseTimer(args[3])
				if timer then
					timer = KANGZ:MinToSec(timer)
					KANGZ_Options["WhisperCooldown"] = timer
					print(string.format(printStrings.WHISPER_COOLDOWN_SET, args[3]))
				end
				return
			else
				print(printStrings.ERROR_INVALID_ARGUMENT)
			end
		elseif args[1] == "inv" then
			if args[2] == "cd" or args[2] == "cooldown" then
				local timer = ParseTimer(args[3])
				if timer then
					timer = KANGZ:MinToSec(timer)
					KANGZ_Options["InviteCooldown"] = timer
					print(string.format(printStrings.INV_COOLDOWN_SET, args[3]))
				end
				return
			elseif args[2] == "guild" then
				if args[3] == "on" then
					KANGZ_Options.GuildInviteAuto = true
					print(string.format(printStrings.GUILD_AUTO_INV_SET, args[3]))
				elseif args[3] == "off" then
					KANGZ_Options.GuildInviteAuto = false
					print(string.format(printStrings.GUILD_AUTO_INV_SET, args[3]))
				else
					print(printStrings.ERROR_INVALID_ARGUMENT)
				end
			elseif args[2] == "whisper" then
				if args[3] == "on" then
					KANGZ_Options.WhisperInviteAuto = true
					print(string.format(printStrings.WHISPER_AUTO_INV_SET, args[3]))
				elseif args[3] == "off" then
					KANGZ_Options.WhisperInviteAuto = false
					print(string.format(printStrings.WHISPER_AUTO_INV_SET, args[3]))
				else
					print(printStrings.ERROR_INVALID_ARGUMENT)
				end
			else
				print(printStrings.ERROR_INVALID_ARGUMENT)
			end
			return
		elseif args[1] == "id" then
			local timer = ParseTimer(args[2])
			if timer then
				timer = KANGZ:MinToSec(timer)
				KANGZ_Options["MizzleTimer"] = timer
				print(string.format(printStrings.ID_TIMER_SET, args[2]))
				if MizzleTimerTotal > timer then
					MizzleTimerTotal = timer
				end
			end
			return
		elseif args[1] == "start" then
			if not args[2] then
				KANGZ:Start()
				return
			end
			local timer = ParseTimer(args[2])
			if timer and timer > 0 then
				timer = KANGZ:MinToSec(timer)
				KANGZ:Start(timer)
			end
			return
		elseif args[1] == "stop" then
			KANGZ:Stop()
			return
		elseif args[1] == "trigger" or args[1] == "triggers" then
			if args[2] == "add" then
				if args[3] then
					KANGZ:AddTrigger(args[3])
					return
				end
			elseif args[2] == "remove" then
				if args[3] then
					KANGZ:RemoveTrigger(args[3])
					return
				end
			elseif args[2] == "list" then
				KANGZ:ListTriggers()
				return
			end
			print(printStrings.ERROR_INVALID_ARGUMENT)
			return
		end
		print(printStrings.ERROR_INVALID_ARGUMENT)
	end
end