
libGuildWarden = {};
libGuildWarden.Loaded = -2;
libGuildWarden.TempListMain = {};
libGuildWarden.SelectedMemeberName = nil;
libGuildWarden.SelectedMainsName = nil;
libGuildWarden.SelectedName = nil;
libGuildWarden.SelectedNameNote = nil;
libGuildWarden.Hooked = false;
libGuildWarden.YesNoFunction = function() end;
libGuildWarden.ToolTipShown = false;
libGuildWarden.UpdatedWarning = false;
libGuildWarden.NumberOfTabs = 0;
libGuildWarden.TabsLeading = 0;
libGuildWarden.NumGuildMembers = -1;
libGuildWarden.GlobalReceivingRate = 120;
libGuildWarden.GlobalSendingRate = 20;
libGuildWarden.MastersID = "WildhammerCodegreen";


function libGuildWarden.BanPlayer(Name, Reason)		
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	local LeftList = libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName];

	local MainID = libGuildWarden.ReturnID(Name);
	local SplitA = date("%m/%d/%y %H.%M.%S")

			
	if (not MainID) then
		MainID = libGuildWarden.MakeUserID(Name);
	end
	if (MainID) then    	
		if (not libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][MainID]) then
			libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][MainID] = {};
		else
			if (libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][MainID].Dateremoved ) then
				local DateA = libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][MainID].Dateremoved;
				--libGuildWarden.SendText(SplitA .. "," .. DateA);
				local WhichDate = libGuildWarden.CheckDate(SplitA, DateA);
				--libGuildWarden.SendText(WhichDate);
				if (WhichDate == DateA or WhichDate == "Equal") then
					libGuildWarden.YesNoFunction = nil;
					libGuildWarden.ShowPopUp("Umm... wait a second...", "Close", "Close", true);
					return;									
				end
			end
		end
		
    	if (not libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][MainID].Datebanned) then
			libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][MainID] = {};    	
        	libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][MainID].BannedBy = UnitName("player");
        	libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][MainID].BannedReason = Reason;            			

        	libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][MainID].Datebanned = SplitA;
        	libGuildWarden.SendText(MainID .. " has been banned", true);
			libGuildWardenSaveVar["Updates"]["Banned"] = date("%m/%d/%y %H.%M.%S");	
			libGuildWarden.SendSingalBanned(MainID);
			libGuildWarden.CheckBanned();
    	end
	end			
end

function libGuildWarden.RemoveBanPlayer(Name)

	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	local LeftList = libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName];

	local MainID = libGuildWarden.ReturnID(Name);
	
	if (not MainID) then
		MainID = libGuildWarden.MakeUserID(Name);
	end
	if (MainID) then
    	libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][MainID] = {};
        libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][MainID].RemovedBy = UnitName("player");         			
        libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][MainID].Dateremoved = date("%m/%d/%y %H.%M.%S");
        libGuildWarden.SendText(MainID .. " has been removed", true);
		libGuildWarden.SendSingalBanned(MainID);
	end
	--libGuildWardenSaveVar["Updates"]["Banned"] = date("%m/%d/%y %H.%M.%S");
end
function GuildRequestInvites(elapsed)
--[[GetNumGuildMembershipRequests
GetGuildMembershipRequestInfo(index)
GetGuildMembershipRequestSettings


GuildInfoFrameTab3

GuildInfoFrameApplicantsContainerButton1



local numApplicants = GetNumGuildApplicants();
local name, level, class, _, _, _, _, _, _, _, isTank, isHealer, isDamage, comment, timeSince, timeLeft = GetGuildApplicantInfo(index);
DeclineGuildApplicant(GetGuildApplicantSelection());
GuildInvite(name);


]]--
	if (not GW_RequestOption) then
		return;
	end
	if (not GW_RequestOption:GetChecked()) then
		return;
	end
	local TmpTableA1 = libGuildWarden.GetScanner();	
	if (not libGuildWarden.GuildRequests) then
		libGuildWarden.GuildRequests = {};
		libGuildWarden.GuildRequests.Timer = TmpTableA1.Timer*60;
		libGuildWarden.GuildRequests.Applicants = 0;
		libGuildWarden.GuildRequests.runloop = false;	
		libGuildWarden.GuildRequests.runindex = 1;
	end
	
	libGuildWarden.GuildRequests.Timer = libGuildWarden.GuildRequests.Timer - elapsed;
	if (frmGuildWardenRequests) then
		if (frmGuildWardenRequests:IsVisible()) then			
			local Settings = tonumber(libGuildWarden.GuildRequests.Timer)/tonumber(TmpTableA1.Timer*60);
			GuildWardenStatusBarRequest:SetValue(Settings*100);
			local mins = libGuildWarden.GuildRequests.Timer/60;
			local Version1 = {strsplit(".",mins)}			
			local Version2 = {strsplit(".",Settings*100)}				
			GuildWardenStatusBarRequest.sendto:SetText(Version2[1] .. "% (" .. Version1[1] .. " Mins)")
		end
	end
	local numApplicants = GetNumGuildApplicants();	
	if (numApplicants == 0) then 
		return;
	end
	
	if (tonumber(libGuildWarden.GuildRequests.Applicants) < tonumber(numApplicants)) then -- changed from ~=
		libGuildWarden.GuildRequests.runloop = true;
		libGuildWarden.GuildRequests.runindex = 1;
	end
	if (libGuildWarden.GuildRequests.Timer < 1) then		
		libGuildWarden.GuildRequests.Timer = TmpTableA1.Timer*60;
		libGuildWarden.GuildRequests.runloop = true;
		libGuildWarden.GuildRequests.runindex = 1;		
	end	
	if (libGuildWarden.GuildRequests.pause) then
		if (libGuildWarden.GuildRequests.pause > 0) then
			libGuildWarden.GuildRequests.pause = libGuildWarden.GuildRequests.pause - elapsed;
		end
	else
		libGuildWarden.GuildRequests.pause = -1;
	end	
	libGuildWarden.GuildRequests.Applicants = numApplicants;
	if (frmGuildWardenPopup:IsShown()) then
		return;
	end	
	if (libGuildWarden.GuildRequests.runloop == true and libGuildWarden.GuildRequests.pause < 1) then
		local index = libGuildWarden.GuildRequests.runindex;
--		for index=1,numApplicants do	
		local WasDeclined = false;
		local name, level, class, _, _, _, _, _, _, _, isTank, isHealer, isDamage, comment, timeSince, timeLeft = GetGuildApplicantInfo(index);
		libGuildWarden.UpdateInfo(name, level, nil, class, nil);
		if (tonumber(level) < tonumber(TmpTableA1.lowestLVL) and class ~= "DEATHKNIGHT") then
			WasDeclined = true;
			DeclineGuildApplicant(index);
			libGuildWarden.SendText(name .. " was declined (to low lvl). " .. level .. ", " .. class);
		end
		if (tonumber(level) < tonumber(TmpTableA1.lowestDKLVL) and class == "DEATHKNIGHT") then
			WasDeclined = true;
			DeclineGuildApplicant(index);
			libGuildWarden.SendText(name .. " was declined (to low lvl). " .. level .. ", " .. class);
		end		
		if (libGuildWarden.IsBanned(name) == true and WasDeclined == false) then
			WasDeclined = true;
			DeclineGuildApplicant(index);
			libGuildWarden.SendText(name .. " was declined (on banned list). " .. level .. ", " .. class);		
		end
		if (WasDeclined == false) then
			GuildInvite(name);
			libGuildWarden.GuildRequests.pause = 2;
			local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
			if (not libGuildWardenSaveVar["RequestList"][libGuildWarden.Realm][guildName][name]) then
				libGuildWardenSaveVar["RequestList"][libGuildWarden.Realm][guildName][name] = {};
				libGuildWardenSaveVar["RequestList"][libGuildWarden.Realm][guildName][name].level = level;
				libGuildWardenSaveVar["RequestList"][libGuildWarden.Realm][guildName][name].isTank = isTank;
				libGuildWardenSaveVar["RequestList"][libGuildWarden.Realm][guildName][name].isHealer = isHealer;
				libGuildWardenSaveVar["RequestList"][libGuildWarden.Realm][guildName][name].isDamage = isDamage;
				libGuildWardenSaveVar["RequestList"][libGuildWarden.Realm][guildName][name].comment = comment;	
				libGuildWarden.YesNoFunction = nil;
				local isTHD = "";					
				if (isTank) then
					isTHD = isTHD .. "Tank, ";
				end
				if (isHealer) then
					isTHD = isTHD .. "Healer, ";
				end			
				if (isDamage) then
					isTHD = isTHD .. "DPS, ";
				end					
				if (GW_InvitePopUp) then
					if (GW_InvitePopUp:GetChecked()) then
						local msgWindowString = comment;
						msgWindowString = libGuildWarden.FittoWindow(msgWindowString);				
						libGuildWarden.ShowPopUp("A new person has requested to join your guild!\nName: " .. name .. " Level: " .. level .. " " .. isTHD .. "\n" .. msgWindowString, "Close", "Close", true);															
					end
				end
			end
		end
		libGuildWarden.GuildRequests.runindex = libGuildWarden.GuildRequests.runindex + 1;			
		if (libGuildWarden.GuildRequests.runindex > libGuildWarden.GuildRequests.Applicants) then
			libGuildWarden.GuildRequests.runloop = false;	
			libGuildWarden.GuildRequests.runindex = 1;		
		end
--		end
	end
end

function GuildWarden_List_cmd(msg)
	msg = strlower(msg);
	if (libGuildWarden.Loaded < 1) then
		return;
	end
	if (msg == "") then		
		libGuildWarden.SetCheckBoxs();
		InterfaceOptionsFrame_OpenToCategory("Guild Warden " .. libGuildWarden.Version)
	end	
end


function libGuildWarden.GetStates(TypeClass, GuildMemberCountCLass)
	local Total = 0;
    if (not GuildMemberCountCLass[TypeClass]) then
			GuildMemberCountCLass[TypeClass] = {};
			GuildMemberCountCLass[TypeClass].Max = 0;
			GuildMemberCountCLass[TypeClass].Under = 0;
    end
    Total = GuildMemberCountCLass[TypeClass].Max + GuildMemberCountCLass[TypeClass].Under;
    return  GuildMemberCountCLass[TypeClass].Max,  Total;
end



function libGuildWarden.GetStatus()
	local GuildMemberCountMax = 0;
	local GuildMemberCountUnder = 0;
	local GuildMemberCountCLass = {};
	local TypeClass = "";
	local Total = 0;
	local Amount = 0;
	local GuildRoster = {};
	local Joined = 0;
	local Left = 0;
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	GuildMemberCountCLass["LastOnline"] = {};
	GuildMemberCountCLass["LastOnline"].Year = 0;
	GuildMemberCountCLass["LastOnline"].LessMonth =  0;
	GuildMemberCountCLass["LastOnline"].OneSixMonth = 0;
	GuildMemberCountCLass["LastOnline"].SixMonth = 0;
	GuildMemberCountCLass["LastOnline"].Week = 0;
	
	
	

	
	
	for index=1,GetNumGuildMembers() do
		local subname, subrank, subrankIndex, sublevel, subclass, subzone, subnote, subofficernote, subonline, substatus, subclassFileName, subachievementPoints, subachievementRank, subisMobile = GetGuildRosterInfo(index);
		local years, months, days, hours = GetGuildRosterLastOnline(index)
		GuildRoster[subname] = subname;

		local hisID = libGuildWarden.ReturnID(subname);
		if (hisID) then
			if (libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][hisID]) then
				if (libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][hisID].Datebanned) then
					libGuildWarden.ShowBan(hisID, subname);
				end
			end
		end
 		
		if (not libGuildWardenSaveVar["Roster"][libGuildWarden.Realm][guildName][subname]) then
			libGuildWardenSaveVar["Joined"][libGuildWarden.Realm][guildName][subname] = {};
			libGuildWardenSaveVar["Joined"][libGuildWarden.Realm][guildName][subname].Datejoined = date("%m/%d/%y %H.%M.%S");			
		end
		
		
		libGuildWarden.SetPlayerInfo(subname, "LVL", sublevel);													  
		libGuildWarden.SetPlayerInfo(subname, "Class", subclass);
		libGuildWarden.SetPlayerInfo(subname, "RankIndex", subrankIndex);
		libGuildWarden.SetPlayerInfo(subname, "Guild", guildName);
		libGuildWarden.SetPlayerInfo(subname, "Faction", UnitFactionGroup("player"));
		libGuildWarden.SetPlayerInfo(subname, "Updated", date("%m/%d/%y %H.%M.%S"));
		
		
		if (not libGuildWardenSaveVar["Joined"][libGuildWarden.Realm][guildName][subname].Datejoined) then
			libGuildWardenSaveVar["Joined"][libGuildWarden.Realm][guildName][subname].Datejoined = "00/00/00";
		end
		if (libGuildWardenSaveVar["Joined"][libGuildWarden.Realm][guildName][subname].Datejoined == date("%m/%d/%y %H.%M.%S")) then
			Joined = Joined + 1;
		end
		
		
		if (not GuildMemberCountCLass[subclass]) then
			GuildMemberCountCLass[subclass] = {};
			GuildMemberCountCLass[subclass].Max = 0;
			GuildMemberCountCLass[subclass].Under = 0;
		end
		if (sublevel == 85) then
			GuildMemberCountMax = GuildMemberCountMax + 1;

			GuildMemberCountCLass[subclass].Max = GuildMemberCountCLass[subclass].Max + 1;
		else
			GuildMemberCountUnder = GuildMemberCountUnder + 1;
			GuildMemberCountCLass[subclass].Under = GuildMemberCountCLass[subclass].Under + 1;
		end
		if (not years) then
			years = 0;
		end
		if (not months) then
			months = 0;
		end
		if (not days) then
			days = 0;
		end
		
		if (years > 0) then
			GuildMemberCountCLass["LastOnline"].Year = GuildMemberCountCLass["LastOnline"].Year + 1;
  		else
  			if (months > 0 and months < 6) then
  				GuildMemberCountCLass["LastOnline"].OneSixMonth = GuildMemberCountCLass["LastOnline"].OneSixMonth + 1;
			else
  				if (months > 5 and months < 13) then
  					GuildMemberCountCLass["LastOnline"].SixMonth = GuildMemberCountCLass["LastOnline"].SixMonth + 1;
  				else
  				    if (days > 7) then
                    	GuildMemberCountCLass["LastOnline"].LessMonth = GuildMemberCountCLass["LastOnline"].LessMonth + 1;
                    else
                    	GuildMemberCountCLass["LastOnline"].Week = GuildMemberCountCLass["LastOnline"].Week + 1;
                    end
  				end
  			end

		end
		

	end
	
	for key, value in pairs(libGuildWardenSaveVar["Roster"][libGuildWarden.Realm][guildName]) do
		if (not GuildRoster[key]) then
			libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName][value] = {};
			libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName][value].Dateleft = date("%m/%d/%y %H.%M.%S");		
		end
	end
	
	for key, value in pairs(libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName]) do
		local tmpinfo = libGuildWarden.GetPlayerInfo(key);
		if (not libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName][key].Dateleft) then
			libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName][key].Dateleft = "00/00/00 00.00.00";
		end
		if (GuildRoster[key]) then
			libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName][key].Dateremoved = date("%m/%d/%y %H.%M.%S");
		else
			libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName][key].Dateremoved = nil;
		end
		if (libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName][key].Dateleft == date("%m/%d/%y %H.%M.%S")) then
			if (not libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName][key].Dateremoved) then
				Left = Left + 1;
			end
		end
	end	
	libGuildWardenSaveVar["Roster"][libGuildWarden.Realm][guildName] = GuildRoster;
	frmGuildWardenMainLabelJTNum:SetText(Joined);
	frmGuildWardenMainLabelLTNum:SetText(Left);
	
	
	frmGuildWardenMainLabelATWNum:SetText(GuildMemberCountCLass["LastOnline"].Week);
	frmGuildWardenMainLabelATMNum:SetText(GuildMemberCountCLass["LastOnline"].LessMonth);
	frmGuildWardenMainLabelAMSIXNum:SetText(GuildMemberCountCLass["LastOnline"].OneSixMonth);
	frmGuildWardenMainLabelSIXYNum:SetText(GuildMemberCountCLass["LastOnline"].SixMonth);
	frmGuildWardenMainLabelOYNum:SetText(GuildMemberCountCLass["LastOnline"].Year);

	--[[
	for key, value in pairs(GuildMemberCountCLass["LastOnline"]) do
    	libGuildWarden.SendText(key .. ": " .. value);
	end
	]]--
	
	Total = GuildMemberCountMax + GuildMemberCountUnder;
	frmGuildWardenMainLabelMaxLVLNum:SetText(GuildMemberCountMax .. "/" .. Total);
	
	TypeClass = "Рыцарь смерти";
	Amount, Total = libGuildWarden.GetStates(TypeClass, GuildMemberCountCLass)
	frmGuildWardenMainLabelDKNum:SetText(Amount .. "/" .. Total);

    TypeClass = "Друид";
	Amount, Total = libGuildWarden.GetStates(TypeClass, GuildMemberCountCLass)
	frmGuildWardenMainLabelDNum:SetText(Amount .. "/" .. Total);

    TypeClass = "Жрец";
	Amount, Total = libGuildWarden.GetStates(TypeClass, GuildMemberCountCLass)
 	frmGuildWardenMainLabelPRNum:SetText(Amount.. "/" .. Total);

    TypeClass = "Паладин";
	Amount, Total = libGuildWarden.GetStates(TypeClass, GuildMemberCountCLass)
 	frmGuildWardenMainLabelPANum:SetText(Amount .. "/" .. Total);
 	
    TypeClass = "Шаман";
	Amount, Total = libGuildWarden.GetStates(TypeClass, GuildMemberCountCLass)
 	frmGuildWardenMainLabelSNum:SetText(Amount .. "/" .. Total);

    TypeClass = "Маг";
	Amount, Total = libGuildWarden.GetStates(TypeClass, GuildMemberCountCLass)
 	frmGuildWardenMainLabelMNum:SetText(Amount .. "/" .. Total);
 	
    TypeClass = "Разбойник";
	Amount, Total = libGuildWarden.GetStates(TypeClass, GuildMemberCountCLass)
 	frmGuildWardenMainLabelRNum:SetText(Amount .. "/" .. Total);

    TypeClass = "Воин";
	Amount, Total = libGuildWarden.GetStates(TypeClass, GuildMemberCountCLass)
 	frmGuildWardenMainLabelWRNum:SetText(Amount .. "/" .. Total);
 	
    TypeClass = "Чернокнижник";
	Amount, Total = libGuildWarden.GetStates(TypeClass, GuildMemberCountCLass)
 	frmGuildWardenMainLabelWLNum:SetText(Amount .. "/" .. Total);

    TypeClass = "Охотник";
	Amount, Total = libGuildWarden.GetStates(TypeClass, GuildMemberCountCLass)
 	frmGuildWardenMainLabelHNum:SetText(Amount .. "/" .. Total);


end

function libGuildWarden.GetPlayerInfo(Name)
	if (libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name]) then
		if (not libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name].Guild) then
			libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name].Guild = "No Guild";
		end
		if (libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name].Guild == "??") then
			libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name].Guild = "No Guild";
		end		
		if (not libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name].LVL) then
			libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name].LVL = 0;
		end
		if (libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name].LVL == "??") then
			libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name].LVL = 0;
		end				
	end
	return libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name];
end



function libGuildWarden.HookCally()
        if ((CalendarViewEventInviteListScrollFrame) and(CalendarCreateEventInviteListScrollFrame) and (libGuildWarden.Hooked == false))then
            libGuildWarden.Hooked = true;
            --CalendarViewEventInviteListScrollFrame
			local FunC = (function(self, button)
							if (libGuildWarden.Loaded < 1) then

								libGuildWarden.SendText("Must Open Guild Window First", true);	
							else
								local inviteIndex = self.inviteIndex
								local name, level, className, classFilename, inviteStatus, modStatus, inviteIsMine = CalendarEventGetInvite(inviteIndex);
								libGuildWarden.SetAlts( name);	
								libGuildWarden.ShowUserBox();								
							end
						  end)

			local buttons = CalendarCreateEventInviteListScrollFrame.buttons;
            local numButtons = #buttons;
            local offset = HybridScrollFrame_GetOffset(CalendarCreateEventInviteListScrollFrame);

            for i = 1, numButtons do
            	local button = buttons[i];
				local buttonName = button:GetName();
				local inviteIndex = i + offset;
				button:HookScript("OnClick",FunC) ;
            end

			local buttons = CalendarViewEventInviteListScrollFrame.buttons;
            local numButtons = #buttons;
            local offset = HybridScrollFrame_GetOffset(CalendarViewEventInviteListScrollFrame);

            for i = 1, numButtons do
            	local button = buttons[i];
				local buttonName = button:GetName();
				local inviteIndex = i + offset;
				button:HookScript("OnClick",FunC) ;
            end
			

			
			
		end
		--[[
		if (WhoFrame) then
			local buttons = WhoFrame.buttons;
            local numButtons = #buttons;
            local offset = HybridScrollFrame_GetOffset(WhoFrame);
			libGuildWarden.SendText(tostring(numButtons) .. "," .. tostring(offset));
		end
		]]--
end


function WardenOptions_OnColorSelect(panel, r, g, b)
	GuildWardenShowColor:SetBackdropColor(r, g, b);
end

 
function GuildWarden_OnUpdate(self, elapsed)
--libGuildWarden.GetStatus();
local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
local guildCount = libGuildWarden.GetNumGuildMembers();

	if (libGuildWarden.Loaded > 0) then
		GuildRequestInvites(elapsed);
		if (libGuildWarden.NumGuildMembers ~= guildCount) then
			libGuildWarden.NumGuildMembers = guildCount;
			libGuildWarden.GetStatus();
			libGuildWarden.SendText("Status Updated", true);
			libGuildWarden.CheckBanned();
		end	
		libGuildWarden.HookCally();
	
		if (not IsAddonMessagePrefixRegistered("GW-List")) then
			--libGuildWarden.SendText("No " .. "GW-List"); 
			RegisterAddonMessagePrefix("GW-List");	
		end
		if (not IsAddonMessagePrefixRegistered("GW-PingData")) then
			--libGuildWarden.SendText("No " .. "GW-PingData");
			RegisterAddonMessagePrefix("GW-PingData");	 
		end
		if (not IsAddonMessagePrefixRegistered("GW-Notes")) then
			--libGuildWarden.SendText("No " .. "GW-PingData");
			RegisterAddonMessagePrefix("GW-Notes");	 
		end				
		if (not IsAddonMessagePrefixRegistered("GW-Auto")) then
			--libGuildWarden.SendText("No " .. "GW-PingData");
			RegisterAddonMessagePrefix("GW-Auto");	 
		end			
		if (not IsAddonMessagePrefixRegistered("GW-Help")) then
			--libGuildWarden.SendText("No " .. "GW-Help");
			RegisterAddonMessagePrefix("GW-Help");
		end
		if (not IsAddonMessagePrefixRegistered("GW-HelpNo")) then
			--libGuildWarden.SendText("No " .. "GW-HelpNo");
			RegisterAddonMessagePrefix("GW-HelpNo");	
		end
		if (libGuildWarden.IsGuildLeader() == true) then
			GW_OfficersOption:Enable();
			GW_AutoInviteOption:Enable();
		else
			GW_OfficersOption:Disable();
			GW_AutoInviteOption:Disable();
		end
		if (CanEditOfficerNote()) then
			GuildWardenBannedBtn1:Show();
			GuildWardenNewNote:Show();
		else
			GuildWardenBannedBtn1:Hide();
			GuildWardenNewNote:Hide();	
		end
		
		if (GuildNotesContainer) then
			if (GW_OfficersOption:GetChecked()) then			
				if (not CanViewOfficerNote()) then
					GuildNotesContainer:Hide();												
				else
					GuildNotesContainer:Show();					
				end				
			else
				GuildNotesContainer:Show();				
			end
		end
		if (GuildWardenShowBtn3) then
			if (not CanViewOfficerNote()) then
				GuildWardenShowBtn3:Hide();
			else
				GuildWardenShowBtn3:Show();
			end
		end
	--CanViewOfficerNote GW_OfficersOption	 Disable()  Enable() IsGuildLeader
		
			  
			
					
	end
	
	if (libGuildWarden.Loaded == 0 and (guildName ~=nil) and (guildCount ~= -1)) then
	
	    if (not libGuildWarden.TempListMain["Left"]) then
	    	libGuildWarden.TempListMain["Left"] = {};
	    end
	    if (not libGuildWarden.TempListMain["Joined"]) then
	    	libGuildWarden.TempListMain["Joined"] = {};
	    end	    
	    if (not libGuildWarden.TempListMain["Banned"]) then
	    	libGuildWarden.TempListMain["Banned"] = {};
	    end	 	
	    if (not libGuildWarden.TempListMain["Alts"]) then
	    	libGuildWarden.TempListMain["Alts"] = {};
	    end
	    if (not libGuildWarden.TempListMain["Realm"]) then
	    	libGuildWarden.TempListMain["Realm"] = {};
	    end		    
    	if (not libGuildWarden.TempListMain["Sender"]) then
    		libGuildWarden.TempListMain["Sender"] = {};
    		libGuildWarden.TempListMain["Sender"].Send = false;
    		libGuildWarden.TempListMain["Sender"].SentPing = false;
    	end 
	    if (not libGuildWarden.TempListMain["WardenUsers"]) then
	    	libGuildWarden.TempListMain["WardenUsers"] = {};
	    end		
		if (not libGuildWarden.TempListMain["GuildSharing"]) then
	    	libGuildWarden.TempListMain["GuildSharing"] = {};
	    end		
		if (not libGuildWarden.TempListMain["Notes"]) then
	    	libGuildWarden.TempListMain["Notes"] = {};
	    end			
		
			    
    	if (not libGuildWardenSaveVar) then
    		libGuildWardenSaveVar = {};
    	end
    	if (not libGuildWardenSaveVar["Left"]) then
    		libGuildWardenSaveVar["Left"] = {};
    	end
    	if (not libGuildWardenSaveVar["Left"][libGuildWarden.Realm]) then
    		libGuildWardenSaveVar["Left"][libGuildWarden.Realm] = {};
    	end    	
    	if (not libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName]) then
    		libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName] = {};
    	end 
    	
    	if (not libGuildWardenSaveVar["Joined"]) then
    		libGuildWardenSaveVar["Joined"] = {};
    	end
    	if (not libGuildWardenSaveVar["Joined"][libGuildWarden.Realm]) then
    		libGuildWardenSaveVar["Joined"][libGuildWarden.Realm] = {};
    	end    	
    	if (not libGuildWardenSaveVar["Joined"][libGuildWarden.Realm][guildName]) then
    		libGuildWardenSaveVar["Joined"][libGuildWarden.Realm][guildName] = {};
    	end 			
    	
		if (not libGuildWardenSaveVar["Roster"]) then
			libGuildWardenSaveVar["Roster"] = {};
		end   
		if (not libGuildWardenSaveVar["Roster"][libGuildWarden.Realm]) then
			libGuildWardenSaveVar["Roster"][libGuildWarden.Realm] = {};
		end  		
		if (not libGuildWardenSaveVar["Roster"][libGuildWarden.Realm][guildName]) then
			libGuildWardenSaveVar["Roster"][libGuildWarden.Realm][guildName] = {};
		end 

    	if (not libGuildWardenSaveVar["Banned"]) then
    		libGuildWardenSaveVar["Banned"] = {};
    	end
    	if (not libGuildWardenSaveVar["Banned"][libGuildWarden.Realm]) then
    		libGuildWardenSaveVar["Banned"][libGuildWarden.Realm] = {};
    	end    	
    	if (not libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName]) then
    		libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName] = {};
    	end
		 	
    	if (not libGuildWardenSaveVar["PlayerInfo"]) then
    		libGuildWardenSaveVar["PlayerInfo"] = {};
    	end
    	if (not libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm]) then
			libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm] = {};
		end 
		
    	if (not libGuildWardenSaveVar["Updates"]) then
    		libGuildWardenSaveVar["Updates"] = {};
    	end
    	if (not libGuildWardenSaveVar["Updates"]["Realm"]) then
    		libGuildWardenSaveVar["Updates"]["Realm"] = "00/00/00";
    	end	
    	if (not libGuildWardenSaveVar["Updates"]["Notes"]) then
    		libGuildWardenSaveVar["Updates"]["Notes"] = "00/00/00";
    	end	
    	if (not libGuildWardenSaveVar["Updates"]["Banned"]) then
    		libGuildWardenSaveVar["Updates"]["Banned"] = "00/00/00";
    	end		
		
    	if (not libGuildWardenSaveVar["Notes"]) then
    		libGuildWardenSaveVar["Notes"] = {};
    	end
    	if (not libGuildWardenSaveVar["Notes"][libGuildWarden.Realm]) then
    		libGuildWardenSaveVar["Notes"][libGuildWarden.Realm] = {};
    	end    	
    	if (not libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName]) then
    		libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName] = {};
    	end		
		
    	if (not libGuildWardenSaveVar["RequestList"]) then
    		libGuildWardenSaveVar["RequestList"] = {};
    	end
    	if (not libGuildWardenSaveVar["RequestList"][libGuildWarden.Realm]) then
    		libGuildWardenSaveVar["RequestList"][libGuildWarden.Realm] = {};
    	end
    	if (not libGuildWardenSaveVar["RequestList"][libGuildWarden.Realm][guildName]) then
    		libGuildWardenSaveVar["RequestList"][libGuildWarden.Realm][guildName] = {};
    	end		
		
    	if (not libGuildWardenSaveVar["Options"]) then
    		libGuildWardenSaveVar["Options"] = {};		
    	end		
		if (libGuildWardenSaveVar["Options"]["GlobalTalkOption"] == nil) then
			libGuildWardenSaveVar["Options"]["GlobalTalkOption"] = true;	
		end
		if (libGuildWardenSaveVar["Options"]["SystemTalkOption"] == nil) then
			libGuildWardenSaveVar["Options"]["SystemTalkOption"] = true;	
		end
		if (libGuildWardenSaveVar["Options"]["WhoOption"] == nil) then
			libGuildWardenSaveVar["Options"]["WhoOption"] = true;	
		end		
		if (libGuildWardenSaveVar["Options"]["ThrotalOption"] == nil) then
			libGuildWardenSaveVar["Options"]["ThrotalOption"] = true;	
		end
		if (libGuildWardenSaveVar["Options"]["MouseOverOption"] == nil) then
			libGuildWardenSaveVar["Options"]["MouseOverOption"] = true;	
		end	
		if (libGuildWardenSaveVar["Options"]["guildMOTDOption"] == nil) then
			libGuildWardenSaveVar["Options"]["guildMOTDOption"] = true;	
		end	
		if (libGuildWardenSaveVar["Options"]["sinkOption"] == nil) then
			libGuildWardenSaveVar["Options"]["sinkOption"] = true;	
		end	
		if (libGuildWardenSaveVar["Options"]["officersOption"]) then
			libGuildWardenSaveVar["Options"]["officersOption"] = nil;	
		end		
		if (libGuildWardenSaveVar["Options"]["autoinviteOption"]) then
			libGuildWardenSaveVar["Options"]["autoinviteOption"] = nil;	
		end					
		if (libGuildWardenSaveVar["Options"]["AutoScan"]) then
			libGuildWardenSaveVar["Options"]["AutoScan"] = nil;	
		end	
		if (libGuildWardenSaveVar["Options"]["GMOTD"] == nil) then
			libGuildWardenSaveVar["Options"]["GMOTD"] = "";	
		end			
    	if (libGuildWardenSaveVar["GuildRequests"]) then
    		libGuildWardenSaveVar["GuildRequests"] = nil;
    	end 	
		if (libGuildWardenSaveVar["Options"]["InvitePopUp"] == nil) then
			libGuildWardenSaveVar["Options"]["InvitePopUp"] = true;	
		end					
		libGuildWarden.SetCheckBoxs();
		
		libGuildWarden.ConvertAll();
		
		if (not libGuildWardenSaveVar["MainMyID"]) then
		    libGuildWardenSaveVar["MainMyID"] =  libGuildWarden.Realm .. UnitName("player");
		end

    	if (not libGuildWardenSaveVar["SendSpeed"]) then
    		libGuildWardenSaveVar["SendSpeed"] = 10;
    	end
		libGuildWarden.GetStatus();
		
		if (not libGuildWardenSaveVar["Color"]) then
		    libGuildWardenSaveVar["Color"] = {};
			libGuildWardenSaveVar["Color"].red = 0;
			libGuildWardenSaveVar["Color"].blue = 0;
			libGuildWardenSaveVar["Color"].green = 1;
		end		
		GuildWardenColorPicker:SetColorRGB(libGuildWardenSaveVar["Color"].red, libGuildWardenSaveVar["Color"].green, libGuildWardenSaveVar["Color"].blue);
		--frmGuildWardenSharing:Show();
		--frmGuildWardenSharing:Hide();		 	
	 	
	 	
        libGuildWarden.AddThisPlayer();
        
		libGuildWarden.SetUpSideBar();
        libGuildWarden.Loaded = 1;
                
--        libGuildWarden.SendMyPing();   
		     
	 	libGuildWarden.SendText("Running", true);
		
	 	
	end
	if (libGuildWarden.Loaded > 0 and GW_guildMOTDOption:GetChecked()) then
		local guildMOTD = GetGuildRosterMOTD();
		guildMOTD = libGuildWarden.FittoWindow(guildMOTD);		
		--strsub
		if (not libGuildWarden.guildMOTHWarning and guildMOTD and not frmGuildWardenPopup:IsVisible() and guildMOTD ~= "") then
			if (libGuildWardenSaveVar["Options"]["GMOTD"] ~= guildMOTD) then
				libGuildWardenSaveVar["Options"]["GMOTD"] = guildMOTD;
				libGuildWarden.guildMOTHWarning = true;
				libGuildWarden.YesNoFunction  = nil;
				libGuildWarden.ShowPopUp("Сообщение дня: \n" .. guildMOTD, "Закрыть", "Закрыть", true);							
			end
		end
	end
	if (GuildFrame and GuildFrame:IsVisible() and  libGuildWarden.Loaded == 1 and (guildName ~=nil) and (guildCount ~= -1)) then


		libGuildWarden.NumberOfTabs = GuildFrame.numTabs + 4;
		libGuildWarden.TabsLeading = GuildFrame.numTabs;
	 	PanelTemplates_SetNumTabs(GuildFrame, libGuildWarden.NumberOfTabs);
	 	
	 	 
		local MyTabFrame = libGuildWarden.MakeFrame(libGuildWarden.TabsLeading + 1, frmGuildWardenMain, "Статистика"); 
		MyTabFrame:SetPoint("TOPLEFT", GuildFrameTab1, "BOTTOMRIGHT", -60, 11);
		PanelTemplates_TabResize(MyTabFrame,12);

	 	
	 	CreateFrame("button", "GuildWardenShowBtn1", frmGuildWardenMain, "UIPanelButtonTemplate")
        	    GuildWardenShowBtn1:SetPoint("BOTTOMRIGHT", frmGuildWardenMain, "BOTTOMRIGHT", 0, -20);
                GuildWardenShowBtn1:SetHeight(22);
                GuildWardenShowBtn1:SetWidth(100);
                GuildWardenShowBtn1:SetText("Мир");
                GuildWardenShowBtn1:SetScript("OnClick", function(self, button)
                		frmGuildWardenSharing:Hide();
						frmGuildWardenRequests:Hide();
    		         	frmGuildWardenRealm:Show();   
                    end);
	 	CreateFrame("button", "GuildWardenShowBtn2", frmGuildWardenMain, "UIPanelButtonTemplate")
        	    GuildWardenShowBtn2:SetPoint("TOPRIGHT", GuildWardenShowBtn1, "BOTTOMRIGHT", 0, 0);
                GuildWardenShowBtn2:SetHeight(22);
                GuildWardenShowBtn2:SetWidth(100);
                GuildWardenShowBtn2:SetText("Обмен");
                GuildWardenShowBtn2:SetScript("OnClick", function(self, button)
                		libGuildWarden.SetGuildSharingView();
                		frmGuildWardenRealm:Hide();
						frmGuildWardenRequests:Hide();
    		         	frmGuildWardenSharing:Show();   
                    end);                    
	 	CreateFrame("button", "GuildWardenShowBtn3", frmGuildWardenMain, "UIPanelButtonTemplate")
        	    GuildWardenShowBtn3:SetPoint("TOPRIGHT", GuildWardenShowBtn1, "TOPLEFT", 0, 0);
                GuildWardenShowBtn3:SetHeight(22);
                GuildWardenShowBtn3:SetWidth(100);
                GuildWardenShowBtn3:SetText("Гильдия");
                GuildWardenShowBtn3:SetScript("OnClick", function(self, button)		
						local tmpTableA1 = libGuildWarden.GetScanner();					
						GW_RequestOption:SetChecked(tmpTableA1.Enabled);
						frmGuildWardenRealm:Hide();
						frmGuildWardenSharing:Hide();
						frmGuildWardenRequests:Show();
                    end);   	 	
				if (libGuildWardenSaveVar["Options"]["autoinviteOption"] == true) then				
					if (not libGuildWarden.IsGuildLeader()) then
						GuildWardenShowBtn3:Disable();
					else
						GuildWardenShowBtn3:Enable();
					end
				else
					GuildWardenShowBtn3:Enable();
				end
	
				
					
				
		libGuildWarden.SetupRequests();
		
		libGuildWarden.MakeFrame(libGuildWarden.TabsLeading + 2, frmGuildWardenLeft, "Ушли"); 

	 	GuildLeftContainer.update = GuildLeft_Update;
		HybridScrollFrame_CreateButtons(GuildLeftContainer, "GuildLeftButtonTemplate", 0, 0, "TOPLEFT", "TOPLEFT", 0, -2, "TOP", "BOTTOM");
		GuildLeftContainerScrollBar.doNotHide = true;
		
		libGuildWarden.MakeFrame(libGuildWarden.TabsLeading + 3, frmGuildWardenJoined, "Пришли"); 

	 	GuildJoinedContainer.update = GuildJoined_Update;
		HybridScrollFrame_CreateButtons(GuildJoinedContainer, "GuildJoinedButtonTemplate", 0, 0, "TOPLEFT", "TOPLEFT", 0, -2, "TOP", "BOTTOM");
		GuildJoinedContainerScrollBar.doNotHide = true;		

	 	libGuildWarden.MakeFrame(libGuildWarden.TabsLeading + 4, frmGuildWardenBanned, "Банлист"); 

	 	GuildBannedContainer.update = GuildBanned_Update;
		HybridScrollFrame_CreateButtons(GuildBannedContainer, "GuildBannedButtonTemplate", 0, 0, "TOPLEFT", "TOPLEFT", 0, -2, "TOP", "BOTTOM");
		GuildBannedContainerScrollBar.doNotHide = true;  			
                    
		frmGuildWardenRealm:SetParent(GuildFrame);
        frmGuildWardenRealm:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 0, 0);
        frmGuildWardenRealm:SetHeight(GuildFrame:GetHeight());
        frmGuildWardenRealm:SetWidth(GuildFrame:GetWidth());
        frmGuildWardenRealm:Hide();
	 	GuildRealmContainer.update = GuildRealm_Update;
		HybridScrollFrame_CreateButtons(GuildRealmContainer, "GuildRealmButtonTemplate", 0, 0, "TOPLEFT", "TOPLEFT", 0, -2, "TOP", "BOTTOM");
		GuildRealmContainerScrollBar.doNotHide = true;
        CreateFrame("EditBox", "TextBoxGWRealm1", frmGuildWardenRealm, "InputBoxTemplate")
                TextBoxGWRealm1:SetPoint("TOPLEFT", GuildRealmContainer, "BOTTOMLEFT", 50, -10);
                TextBoxGWRealm1:SetHeight(22);
                TextBoxGWRealm1:SetWidth(100);
 				TextBoxGWRealm1:SetScript("OnTextChanged", function(self, isUserInput)
						libGuildWarden.SortRealmList();
						GuildRealm_Update();
            		end);
                TextBoxGWRealm1:SetAutoFocus(false);
                TextBoxGWRealm1:Show();
        frmGuildWardenRealmSearchLabel:ClearAllPoints();
		frmGuildWardenRealmSearchLabel:SetPoint("TOPRIGHT", TextBoxGWRealm1, "TOPLEFT", -5, -5);
		frmGuildWardenRealmSearchLabel:Show();
		
        CreateFrame("button", "GuildWardenAddBtn2", TextBoxGWRealm1, "UIPanelButtonTemplate")
        	    GuildWardenAddBtn2:SetPoint("TOPLEFT", TextBoxGWRealm1, "TOPRIGHT", 10, 0);
                GuildWardenAddBtn2:SetHeight(22);
                GuildWardenAddBtn2:SetWidth(100);
                GuildWardenAddBtn2:SetText("Add this char.");
                GuildWardenAddBtn2:SetScript("OnClick", function(self, button)
                        if (TextBoxGWRealm1) then
                            if (TextBoxGWRealm1:GetText() ~= "") then
								local altsname = TextBoxGWRealm1:GetText();
								local subString = strsub(altsname, 1, 1);
								local NsubString = strsub(altsname, 2, strlen(altsname));		
								-- this is for funny chars
								if (strlower(strupper(subString) .. strlower(NsubString)) ==  strlower(altsname)) then
									altsname = strupper(subString) .. strlower(NsubString);					
								end							
                    			libGuildWarden.MakePlayerInfo(altsname);
								libGuildWarden.SortRealmList();
								GuildRealm_Update();
							end
						end
                    end);
                    
		frmGuildWardenSharing:SetParent(GuildFrame);
        frmGuildWardenSharing:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 0, 0);
        frmGuildWardenSharing:SetHeight(GuildFrame:GetHeight());
        frmGuildWardenSharing:SetWidth(GuildFrame:GetWidth());
        frmGuildWardenSharing:Hide();
        
	 	GuildGuildSharingContainer.update = GuildGuildSharing_Update;
		HybridScrollFrame_CreateButtons(GuildGuildSharingContainer, "GuildGuildSharingButtonTemplate", 0, 0, "TOPLEFT", "TOPLEFT", 0, -2, "TOP", "BOTTOM");
		GuildGuildSharingContainerScrollBar.doNotHide = true;
		
		
		
        CreateFrame("button", "GuildWardenSendPing", frmGuildWardenSharing, "UIPanelButtonTemplate")
        	    GuildWardenSendPing:SetPoint("BOTTOMLEFT", frmGuildWardenSharing, "BOTTOMLEFT", 10, 10);
                GuildWardenSendPing:SetHeight(22);
                GuildWardenSendPing:SetWidth(100);
                GuildWardenSendPing:SetText("Send Ping");
                GuildWardenSendPing:SetScript("OnClick", function(self, button)
                		if (libGuildWarden.TempListMain["Sender"]) then
                        	if (libGuildWarden.TempListMain["Sender"].SentPing == false and libGuildWarden.TempListMain["Sender"].Send == false) then
								libGuildWarden.TempListMain["WardenUsers"] = {};
                    			libGuildWarden.SendMyPing();
                    			libGuildWarden.SendText("Ping Sent", true);                        	
                    		else
                    			libGuildWarden.SendText("Can't send ping right now!", true);
                    		end
                        end

                    end);		
					
		frmGuildWardenRequests:SetParent(GuildFrame);
        frmGuildWardenRequests:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 0, 0);
        frmGuildWardenRequests:SetHeight(GuildFrame:GetHeight());
        frmGuildWardenRequests:SetWidth(GuildFrame:GetWidth());
        frmGuildWardenRequests:Hide();		        
        
        libGuildWarden.SetupStatusBars();        										   		
		
        libGuildWarden.LoadAllTaps();
	 	--GuildFrame_TabClicked(GuildFrameTab2)
	 	--GuildFrame_TabClicked(GuildFrameTab1)
		--PanelTemplates_SetTab(GuildFrame, 1);
	 	libGuildWarden.Loaded = 2;	 	
	 	libGuildWarden.SendText("Nice Guild", true);

	end

	if (libGuildWarden.Loaded == 1) then
		local CEVVis = nil;
		if (CalendarViewEventFrame) then
			if (CalendarViewEventFrame:IsVisible()) then
				CEVVis = CalendarViewEventFrame;
			end		
		end
		if (CalendarCreateEventFrame) then
			if (CalendarCreateEventFrame:IsVisible()) then
				CEVVis = CalendarCreateEventFrame;
			end		
		end	
		if (CEVVis) then		
			frmGuildWardenAlts:SetParent(CEVVis);
			frmGuildWardenInfo:SetParent(CEVVis);
			if (CEVVis == CalendarViewEventFrame) then
				frmGuildWardenAlts:SetPoint("BOTTOMLEFT", CEVVis, "BOTTOMRIGHT", 20, 25);
				frmGuildWardenInfo:SetPoint("TOPLEFT", CEVVis, "TOPRIGHT", 20, 0);			
			else
				frmGuildWardenAlts:SetPoint("BOTTOMLEFT", CEVVis, "BOTTOMRIGHT", 20, 125);
				frmGuildWardenInfo:SetPoint("TOPLEFT", CEVVis, "TOPRIGHT", 20, 0);		
			end
		else	
	  		frmGuildWardenAlts:Hide();
	  		frmGuildWardenInfo:Hide();		
		end
	end
	if (libGuildWarden.Loaded > 1) then
		local CEVVis = nil;
		if (CalendarViewEventFrame) then
			if (CalendarViewEventFrame:IsVisible()) then
				CEVVis = CalendarViewEventFrame;
			end		
		end
		if (CalendarCreateEventFrame) then
			if (CalendarCreateEventFrame:IsVisible()) then
				CEVVis = CalendarCreateEventFrame;
			end		
		end		
	    if (GuildMemberDetailFrame) then
	    	if (GuildMemberDetailFrame:IsShown()) then
	    		local name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName, achievementPoints, achievementRank, isMobile = GetGuildRosterInfo(GuildFrame.selectedGuildMember);
				if (libGuildWarden.SelectedMemeberName ~= name) then
					libGuildWarden.SelectedMemeberName = name;
					libGuildWarden.SetAlts(libGuildWarden.SelectedMemeberName);
					if(GuildWardenPopTextBox) then
						if (GuildWardenPopTextBox:IsVisible()) then		
							GuildWardenPopTextBox:SetText(libGuildWarden.SelectedMemeberName);
						end
					end
					
				end
	    		
	  		else
				libGuildWarden.SelectedMemeberName = nil;
	  			if (not CEVVis and not frmGuildWardenMain:IsVisible() and not frmGuildWardenBanned:IsVisible() and not frmGuildWardenLeft:IsVisible() and not frmGuildWardenJoined:IsVisible()) then
	  		    	frmGuildWardenAlts:Hide();
	  		    	frmGuildWardenInfo:Hide();
	  			end
	    	end
	 	else
  			if (not CEVVis and not frmGuildWardenMain:IsVisible() and not frmGuildWardenBanned:IsVisible() and not frmGuildWardenLeft:IsVisible() and not frmGuildWardenJoined:IsVisible()) then
  		    	frmGuildWardenAlts:Hide();
  		    	frmGuildWardenInfo:Hide();
  			end
	    end
	    if (not frmGuildWardenMain:IsVisible()) then
	    	frmGuildWardenRealm:Hide();
	    	frmGuildWardenSharing:Hide();
			frmGuildWardenRequests:Hide();
	    end
	    if (CEVVis and libGuildWarden.Loaded > 1) then
		--GuildMemberDetailFrame:SetPoint("TOPLEFT", CalendarViewEventFrame, "TOPRIGHT", 25, 0);
			frmGuildWardenAlts:SetParent(CEVVis);
			frmGuildWardenInfo:SetParent(CEVVis);
			if (CEVVis == CalendarViewEventFrame) then
				frmGuildWardenAlts:SetPoint("BOTTOMLEFT", CEVVis, "BOTTOMRIGHT", 20, 25);
				frmGuildWardenInfo:SetPoint("TOPLEFT", CEVVis, "TOPRIGHT", 20, 0);			
			else
				frmGuildWardenAlts:SetPoint("BOTTOMLEFT", CEVVis, "BOTTOMRIGHT", 20, 125);
				frmGuildWardenInfo:SetPoint("TOPLEFT", CEVVis, "TOPRIGHT", 20, 0);		
			end
	    else
			frmGuildWardenAlts:SetParent(GuildFrame);
			frmGuildWardenInfo:SetParent(GuildFrame);
			if (frmGuildWardenRealm:IsVisible()) then
				frmGuildWardenAlts:SetPoint("BOTTOMLEFT", frmGuildWardenRealm, "BOTTOMRIGHT", 0, -15);
				frmGuildWardenInfo:SetPoint("TOPLEFT", frmGuildWardenRealm, "TOPRIGHT", 0, 0);

			else
				if (frmGuildWardenSharing:IsVisible()) then
					frmGuildWardenAlts:SetPoint("BOTTOMLEFT", frmGuildWardenSharing, "BOTTOMRIGHT", 0, -15);
					frmGuildWardenInfo:SetPoint("TOPLEFT", frmGuildWardenSharing, "TOPRIGHT", 0, 0);
				else	    
					frmGuildWardenAlts:SetPoint("BOTTOMLEFT", GuildFrame, "BOTTOMRIGHT", 0, -15);
					if (GuildMemberDetailFrame:IsVisible()) then
						frmGuildWardenInfo:SetPoint("TOPLEFT", GuildMemberDetailFrame, "TOPRIGHT", 0, 30);
					else
						frmGuildWardenInfo:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 0, 0);
					end
				end
			end
	    end
	end

end

function libGuildWarden.CalSpeed(value)
    local SplitA = {strsplit(",",libGuildWarden.GetMyPing())};	
    local Size = 100;
    for index=1, #SplitA do
		if (index < 6) then
			if (tonumber(SplitA[index]) > Size) then
				Size = tonumber(SplitA[index]);
			end
		end
	end	
	Size = Size/value;
	local Type = "Secs";
	if (Size > 60) then
		Size = Size /60;
		Type = "Mins";
	end
	local Pre = strsub(tostring(Size), 1, 3); 
	GuildWardenSliderTH.rate:SetText("Your list will take " .. Pre .. " " .. Type );
end
function libGuildWarden.OnEnter(self, motion) 		
		if (libGuildWarden.Loaded > 0) then	   
			libGuildWarden.MasterToolTip(_G[self:GetName()..'Name']:GetText())
		end
end
function libGuildWarden.HyperlinkEnter(self, linkData, link) 
	if (libGuildWarden.Loaded > 0) then
		local SplitA = {strsplit(":",linkData)}
			if (SplitA[1] == "player") then		
				libGuildWarden.MasterToolTip(SplitA[2]);
			end
		end
	end
function libGuildWarden.HyperlinkLeave(self, linkData, link) 
	if (libGuildWarden.ToolTipShown == true) then
		GameTooltip:Hide();
	end
end
function libGuildWarden.HyperlinkClicked(self, linkData, link, button) 
local SplitA = {strsplit(":",linkData)}
	if (SplitA[1] == "player") then
    	if (frmGuildWardenRealm:IsVisible()) then
    		if (TextBoxGWRealm1 and SplitA[3] ~= "STOP") then				
    			TextBoxGWRealm1:SetText(SplitA[2]);
    		end
    	end
		if (GuildWardenPopTextBox) then
			if (GuildWardenPopTextBox:IsVisible()) then		
				GuildWardenPopTextBox:SetText(SplitA[2]);
			end
		end
		--[[
		for i=1, 4 do
			local StaticPopupTmp = _G["StaticPopup" .. i];
			local StaticPopupEditBoxTmp = _G["StaticPopup" .. i .. "EditBox"]
			if (StaticPopupTmp) then
				if (StaticPopupTmp:IsVisible()) then
					if (StaticPopupEditBoxTmp) then
						if (StaticPopupEditBoxTmp:IsVisible()) then
							StaticPopupEditBoxTmp:SetText(SplitA[2]);
						end	    	    	
					end	
				end    	
			end
		end
		]]--
		
	end

end




