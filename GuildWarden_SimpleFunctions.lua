function libGuildWarden.SendText(Text, SystemMsg)
	if (not GW_GlobalTalkOption:GetChecked()) then
		return;
	end
	if (not GW_SystemTalkOption:GetChecked() and  SystemMsg) then
		return;
	end	
	local red = 0;
	local green = 1;
	local blue = 0;
	if (libGuildWarden.Loaded > 0) then
		if (GuildWardenColorPicker) then
			red, green, blue = GuildWardenColorPicker:GetColorRGB();
		end
	end
	if (Text == nil) then
		return;
	end
	Text = tostring(Text);
	local colorNew = libGuildWarden.RGBPercToHex(red, green, blue);
	local OutText = "|cFF" .. colorNew .. "Guild Warden: " .. Text .. "|r";

	ChatFrame1:AddMessage(OutText);

end
function libGuildWarden.IsGuildLeader() 
	--[[if (libGuildWarden.MastersID) then
		if (libGuildWardenSaveVar["MainMyID"] == libGuildWarden.MastersID) then
			if ( not libGuildWarden.MasterOption) then
				libGuildWarden.MasterOption = true;
				libGuildWarden.SendText("Master!!! All Option are yours!!!");
			end
			return true;
		end
	end
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	if (IsGuildLeader()) then
		if (not libGuildWardenSaveVar["GuildLeader"]) then
			libGuildWardenSaveVar["GuildLeader"] = {};
		end
		if (libGuildWardenSaveVar["GuildLeader"] == true) then
			libGuildWardenSaveVar["GuildLeader"] = {};
		end
		libGuildWardenSaveVar["GuildLeader"][guildName] = true;
		return true;
	else
		if (not libGuildWardenSaveVar["GuildLeader"]) then
			return false;
		end
		if (libGuildWardenSaveVar["GuildLeader"] == true) then
			libGuildWardenSaveVar["GuildLeader"] = {};
			libGuildWardenSaveVar["GuildLeader"][guildName] = true;
			return true;
		end	
		if (libGuildWardenSaveVar["GuildLeader"][guildName] == true) then
			return true;
		end		
	end	
	return false;]]--
	if CanEditOfficerNote()
	then return true;
	else return false;
	end
end
function libGuildWarden.UpdateInfo(Name, Level, Race, Class, Guild)
	local thmpThisPlayer = {};

	if (Guild == nil) then
		Guild = "Н/Д";                       
	end
	if (libGuildWarden.ClassFix(Class)) then
		Class = libGuildWarden.ClassFix(Class);
	end
			
	if (libGuildWarden.ReturnID(Name)) then
		libGuildWarden.SetPlayerInfo(Name, "LVL", Level);					
		libGuildWarden.SetPlayerInfo(Name, "Race", Race);
		libGuildWarden.SetPlayerInfo(Name, "Class", Class);
		libGuildWarden.SetPlayerInfo(Name, "Guild", Guild);
		libGuildWarden.SetPlayerInfo(Name, "Date", date("%m/%d/%y %H.%M.%S"));
		libGuildWarden.SetPlayerInfo(Name, "Faction", UnitFactionGroup("player"));
		libGuildWarden.SetPlayerInfo(Name, "Updated", date("%m/%d/%y %H.%M.%S"));
	end
end

function libGuildWarden.ClassFix(Class) 
	if (not Class) then
		return nil;
	end
	Class = strlower(Class);
	if (Class == strlower("Рыцарь смерти") or Class == strlower("Рыцарьсмерти")) then
		return "Рыцарь смерти";
	end	
	if (Class == strlower("Друид")) then
		return "Друид";
	end
	if (Class == strlower("Жрец") or Class == strlower("Жрица")) then
		return "Жрец";
	end
	if (Class == strlower("Паладин")) then
		return "Паладин";
	end
	if (Class == strlower("Шаман") or Class == strlower("Шаманка")) then
		return "Шаман";
	end
	if (Class == strlower("Маг")) then
		return "Маг";
	end
	if (Class == strlower("Разбойник") or Class == strlower("Разбойница")) then
		return "Разбойник";
	end
	if (Class == strlower("Воин")) then
		return "Воин";
	end	
	if (Class == strlower("Чернокнижник") or Class == strlower("Чернокнижница")) then
		return "Чернокнижник";
	end	
	if (Class == strlower("Охотник") or Class == strlower("Охотница")) then
		return "Охотник";
	end		
	return nil;
end

function libGuildWarden.ReturnID(Name)
	local UserInfo = libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name];
	local ITSID = nil;
	if (UserInfo) then
		if (UserInfo.TMPID) then
			if (UserInfo.TMPID ~= "??") then
				ITSID = UserInfo.TMPID;
			end
		end
		if (UserInfo.ID) then
			if (UserInfo.ID ~= "??") then
				ITSID = UserInfo.ID;
			end
		end		
	end
	
	return ITSID;
end

function libGuildWarden.RGBPercToHex(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r*255, g*255, b*255)
end
function libGuildWarden.GetPlayersGuildIndex(PlayerName)
	local subname, subrank, subrankIndex, sublevel, subclass, subzone, subnote, subofficernote, subonline, substatus, subclassFileName, subachievementPoints, subachievementRank, subisMobile;
	for index=1,GetNumGuildMembers() do
 		subname, subrank, subrankIndex, sublevel, subclass, subzone, subnote, subofficernote, subonline, substatus, subclassFileName, subachievementPoints, subachievementRank, subisMobile = GetGuildRosterInfo(index);
 		if (subname == PlayerName) then
 			return index; 
 		end
 	end
	return nil;
end
function libGuildWarden.IsPlayerOnline(PlayersName)
	local PlayersIndex = libGuildWarden.GetPlayersGuildIndex(PlayersName);
    local subname, subrank, subrankIndex, sublevel, subclass, subzone, subnote, subofficernote, subonline, substatus, subclassFileName, subachievementPoints, subachievementRank, subisMobile = GetGuildRosterInfo(PlayersIndex);
	if (not subonline) then
    	return false;                
	end
	return true;
end
function libGuildWarden.CheckVersion(VersionCurrent, VersionToCheck)

    local Version1 = {strsplit(".",VersionToCheck)}
    local Version2 = {strsplit(".",VersionCurrent)}

    if (tonumber(Version1[1]) > tonumber(Version2[1])) then
        return true;
    end
    if (tonumber(Version1[1]) < tonumber(Version2[1])) then
        return nil;
    end
    if (tonumber(Version1[2]) == tonumber(Version2[2])) then
        if (tonumber(Version1[2]) > tonumber(Version2[2])) then
            return true;
        end
        if (tonumber(Version1[2]) < tonumber(Version2[2])) then
            return  nil;
        end
        if (tonumber(Version1[2]) == tonumber(Version2[2])) then
            if (tonumber(Version1[3]) > tonumber(Version2[3])) then
                return true;
            end
            if (tonumber(Version1[3]) < tonumber(Version2[3])) then
                return  nil;
            end
            if (tonumber(Version1[3]) == tonumber(Version2[3])) then
                return  nil;
            end         
        end        
    end    
end
function libGuildWarden.CheckFormateDate(Date)
    local SplitA = {strsplit(" ",Date)};
	if (table.getn(SplitA) == 2)then
        local SplitAa = {strsplit("/",SplitA[1])};
        local SplitBa = {strsplit(".",SplitA[2])};
		if (table.getn(SplitAa) == 3)then	
				for index=1, 3 do
					if (not tonumber(SplitAa[index])) then					
						return false;
					end
					if (strlen(SplitAa[index]) < 1 or strlen(SplitAa[index]) > 2) then
						return false;
					end
				end		
			if (table.getn(SplitBa) == 3)then	
				for index=1, 3 do
					if (not tonumber(SplitBa[index])) then
						return false;
					end
					if (strlen(SplitBa[index]) < 1 or strlen(SplitBa[index]) > 2) then
						return false;
					end					
				end	
				return true;
			end		
		end
	end
	return false;   
end

function libGuildWarden.GetGuildInfo()

     if (IsInGuild() ~= nil) then
        local guildName, guildRankName, guildRankIndex =  GetGuildInfo("player");		
        if (guildName ~= nil) then
			libGuildWarden.GuildInfoSave = {};
			libGuildWarden.GuildInfoSave.info = guildName, guildRankName, guildRankIndex;
			libGuildWarden.GuildInfoSave.count = 0;
            return  guildName, guildRankName, guildRankIndex;
        else
			-- We couldn't get the real guild name for some unkown reason
			-- So lets get the saved one and start counting
			-- If the count gets over 6 times then shut down warden
			-- or if there is no saved info
			if (libGuildWarden.GuildInfoSave) then
				libGuildWarden.GuildInfoSave.count = libGuildWarden.GuildInfoSave.count + 1;				
				if (libGuildWarden.GuildInfoSave.count < 6) then
					return libGuildWarden.GuildInfoSave.info;
				end
			end
			
			if (libGuildWarden.Loaded > 0) then
				libGuildWarden.Loaded = -7;
				libGuildWarden.YesNoFunction = nil;
				libGuildWarden.ShowPopUp("Guild Warden, Couldn't get your guild's name\n from blizzard. Guild Warden is off\n type \"/reload\" to restart Guild Warden.", "Close", "Close" ,true);			 
			end		
			return "Н/Д", "None", 0;
			
        end
     else
		if (libGuildWarden.Loaded > 0) then
			libGuildWarden.Loaded = -7;
			libGuildWarden.YesNoFunction = nil;
			libGuildWarden.ShowPopUp("\nYou are not in a guild!\n Guild Warden is off until...\n You join a guild then re-log.", "Close", "Close" ,true);			 
		end
        return "Н/Д", "None", 0;
     end

end

function libGuildWarden.GetNumGuildMembers()
     if (IsInGuild() ~= nil) then
        if (GetNumGuildMembers(true) ~= 0) then
            return  GetNumGuildMembers(true);
        else
            return -1;
        end
     else
        return 0;
     end

end

function libGuildWarden.GetClassFileName(Class)
	local classnames = {
		["Чернокнижник"] = "Warlock",
		["Воин"] = "Warrior",
		["Охотник"] = "Hunter",
		["Маг"] = "Mage",
		["Жрец"] = "Priest",
		["Друид"] = "Druid",
		["Паладин"] = "Paladin",
		["Шаман"] = "Shaman",
		["Разбойник"] = "Rogue",
		["Разбойница"] = "Rogue",
		["Шаманка"] = "Shaman",
		["Охотница"] = "Hunter",
		["Жрица"] = "Priest",
		["Чернокнижница"] = "Warlock",
		["Рыцарь смерти"] = "Death knight"
	}
	Class = classnames[Class];
	if (Class) then
		Class = strupper(Class);
		Class = string.gsub(Class, " ", "");
 	end
	return Class;	
end
function libGuildWarden.UpperFirstChar(SringtoUp)
        subString = strsub(SringtoUp, 1, 1);
        NsubString = strsub(SringtoUp, 2, strlen(SringtoUp));
        if (subString == strlower(subString)) then
            return strupper(subString) .. strlower(NsubString);
        end
        return SringtoUp;
end  

--This will retrun DateA, DateB, or Equal, return wich is sooner
function libGuildWarden.CheckDate(DateA, DateB)
    if (DateA) then
    else
        return "Equal";  
    end
    if (DateB) then
    else
        return "Equal";  
    end    
    if (DateA == DateB) then
        return "Equal";
    end
    
    local SplitA = {strsplit(" ",DateA)};
    local SplitB = {strsplit(" ",DateB)};
    local NumberA= 0;
    local NumberB = 0;
    local toSendOut = "";
    local MainCount = 0;
    if (SplitA[1] ~= SplitB[1]) then
        local SplitAa = {strsplit("/",SplitA[1])};
        local SplitBa = {strsplit("/",SplitB[1])};
        
        if (table.getn(SplitAa) < 3)then
            return "Equal";
        end
        if (table.getn(SplitBa) < 3)then
            return "Equal";
        end
    
    
--Year
        NumberA = tonumber(SplitAa[3]);
        NumberB = tonumber(SplitBa[3]);
        if ((NumberA) ~= (NumberB)) then
            if (NumberA > NumberB) then
                return DateA;
            else
                return DateB;
            end
        end
        
--Month
        NumberA = tonumber(SplitAa[1]);
        NumberB = tonumber(SplitBa[1]);
        if ((NumberA) ~= (NumberB)) then
            if (NumberA > NumberB) then
                return DateA;
            else
                return DateB;
            end 
        end

--Day
        NumberA = tonumber(SplitAa[2]);
        NumberB = tonumber(SplitBa[2]);
        if ((NumberA) ~= (NumberB)) then
            if (NumberA > NumberB) then
                return DateA;
            else
                return DateB;
            end    
        end
    end
	if (SplitA[2] and SplitB[2]) then
		if (SplitA[2] ~= SplitB[2] and SplitA[1] == SplitB[1]) then
			local SplitAa = {strsplit(".",SplitA[2])};
			local SplitBa = {strsplit(".",SplitB[2])};

			if (table.getn(SplitAa) < 3)then
				return "Equal";
			end
			if (table.getn(SplitBa) < 3)then
				return "Equal";
			end
			
	--Hour
			NumberA = tonumber(SplitAa[1]);
			NumberB = tonumber(SplitBa[1]);
			if ((NumberA) ~= (NumberB)) then
				if (NumberA > NumberB) then
					return DateA;
				else
					return DateB;
				end 
			end

	--Minute
			NumberA = tonumber(SplitAa[2]);
			NumberB = tonumber(SplitBa[2]);
			if ((NumberA) ~= (NumberB)) then
				if (NumberA > NumberB) then
					return DateA;
				else
					return DateB;
				end    
			end	
	--Secons
			NumberA = tonumber(SplitAa[3]);
			NumberB = tonumber(SplitBa[3]);
			if ((NumberA) ~= (NumberB)) then
				if (NumberA > NumberB) then
					return DateA;
				else
					return DateB;
				end
			end
		end
	end
	
	
	
    return "Equal";
end

function libGuildWarden.MakePlayerInfo(Name)
	if (Name) then
	    Name = libGuildWarden.UpperFirstChar(Name);
		if (not libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name]) then
			libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name] = {};
			libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name].Name = Name;
			libGuildWarden.SendText("Player created: " .. Name, true);
		else
			if (libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name].Dateremoved) then
				libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name] = {};
				libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name].Name = Name;
				libGuildWarden.SendText("Player created: " .. Name, true);
			end		
		end
		
	end
end

function libGuildWarden.SetPlayerInfo(Name, What, Toset)
	if (Toset and Toset ~= "??" and Toset ~= "???"and Toset ~= "????") then
		if (not libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name]) then
			libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name] = {};
			libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name].Name = Name;
		else
			if (libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name].Dateremoved) then
				libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name] = {};
				libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name].Name = Name;
			end			
		end
		libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name][What] = Toset;
	end
end

function libGuildWarden.CloneSimpleTable(TheTable)
	local NewTable = {};
	if (TheTable) then
		for key, value in pairs(TheTable) do
			NewTable[key] = value;
		end
	end
	return NewTable; 
end

function libGuildWarden.GetAlts(Name)
	local ThisTable = {};
	if (Name) then
		local MainID = libGuildWarden.ReturnID(Name);
		local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	

	
		ThisTable[Name] = true;
		for key, value in pairs(libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm]) do
			if (key ~= Name) then
			local AltsID = libGuildWarden.ReturnID(key);
				if (MainID and AltsID) then
					if (MainID == AltsID) then
						ThisTable[key] = true;
					end					
				end		
			end
		end
	end
	return ThisTable;
end
function libGuildWarden.FittoWindow(guildMOTD)
	if (strlen(guildMOTD) > 55) then
		guildMOTD = strsub(guildMOTD, 1, 55) .. "- \n-" .. strsub(guildMOTD, 56, strlen(guildMOTD));
	end
	if (strlen(guildMOTD) > 110) then
		guildMOTD = strsub(guildMOTD, 1, 110) .. "- \n-" .. strsub(guildMOTD, 111, strlen(guildMOTD));
	end	
	if (strlen(guildMOTD) > 165) then
		guildMOTD = strsub(guildMOTD, 1, 165) .. "- \n-" .. strsub(guildMOTD, 166, strlen(guildMOTD));
	end	
	return guildMOTD;
end
function libGuildWarden.MasterToolTip(tmpName)
		if (not GW_MouseOverOption:GetChecked()) then
			return;
		end
		local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	    local Mainis = libGuildWarden.GetMain(tmpName);
		local AltTable = libGuildWarden.GetAlts(tmpName);
		local ThisID = libGuildWarden.ReturnID(tmpName);
		local Count = 0;
		for key, value in pairs(AltTable) do
			Count = Count + 1;
		end		
		if (Mainis ~= "No ID") then
			libGuildWarden.ToolTipShown = true;
			if (not GameTooltip:IsVisible()) then
				GameTooltip:SetOwner(WorldFrame, "ANCHOR_CURSOR");    
			end
			GameTooltip:AddLine("Main: " .. HIGHLIGHT_FONT_COLOR_CODE .. Mainis .. FONT_COLOR_CODE_CLOSE);          
			GameTooltip:AddLine("Number of Char(s): " .. HIGHLIGHT_FONT_COLOR_CODE .. Count .. FONT_COLOR_CODE_CLOSE);       
			if (ThisID) then
				if (libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][ThisID]) then
					if (libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][ThisID].Datebanned) then
						GameTooltip:AddLine("WARNING! BANNED FROM GUILD");
						GameTooltip:AddLine("By: " .. HIGHLIGHT_FONT_COLOR_CODE .. libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][ThisID].BannedBy .. FONT_COLOR_CODE_CLOSE);
						GameTooltip:AddLine("When: " .. HIGHLIGHT_FONT_COLOR_CODE .. libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][ThisID].Datebanned .. FONT_COLOR_CODE_CLOSE);
						GameTooltip:AddLine("Reason: " .. HIGHLIGHT_FONT_COLOR_CODE .. libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][ThisID].BannedReason .. FONT_COLOR_CODE_CLOSE);
					end
				end
			end
						
			GameTooltip:Show();	
		end
end
function libGuildWarden.CheckLoadScanner()
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	if (not libGuildWardenSaveVar["Options"][libGuildWarden.Realm]) then
		libGuildWardenSaveVar["Options"][libGuildWarden.Realm] = {}
	end
	if (not libGuildWardenSaveVar["Options"][libGuildWarden.Realm][guildName]) then
		libGuildWardenSaveVar["Options"][libGuildWarden.Realm][guildName] = {}			
	end	
	if (libGuildWardenSaveVar["Options"][libGuildWarden.Realm][guildName]["officersOption"] == nil) then
		libGuildWardenSaveVar["Options"][libGuildWarden.Realm][guildName]["officersOption"] = "true";	
	end		
	if (libGuildWardenSaveVar["Options"][libGuildWarden.Realm][guildName]["autoinviteOption"] == nil) then
		libGuildWardenSaveVar["Options"][libGuildWarden.Realm][guildName]["autoinviteOption"] = "true";	
	end					
	if (libGuildWardenSaveVar["Options"][libGuildWarden.Realm][guildName]["AutoScan"] == nil) then
		libGuildWardenSaveVar["Options"][libGuildWarden.Realm][guildName]["AutoScan"] = "false";	
	end		
	if (libGuildWardenSaveVar["Options"][libGuildWarden.Realm][guildName]["Timer"] == nil) then
		libGuildWardenSaveVar["Options"][libGuildWarden.Realm][guildName]["Timer"] = 60;
	end 
	if (libGuildWardenSaveVar["Options"][libGuildWarden.Realm][guildName]["Level"] == nil) then
		libGuildWardenSaveVar["Options"][libGuildWarden.Realm][guildName]["Level"] = 1;
	end 	
	if (libGuildWardenSaveVar["Options"][libGuildWarden.Realm][guildName]["DKLevel"] == nil) then
		libGuildWardenSaveVar["Options"][libGuildWarden.Realm][guildName]["DKLevel"] = 55;
	end 
end
function libGuildWarden.SetScanner(tmpOptions, OptionsOnly)
	libGuildWarden.CheckLoadScanner()
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();	
	if (tmpOptions.Option) then	
		libGuildWardenSaveVar["Options"][libGuildWarden.Realm][guildName]["autoinviteOption"] = tostring(tmpOptions.Option);
	end
	if (tmpOptions.Notes) then
		libGuildWardenSaveVar["Options"][libGuildWarden.Realm][guildName]["officersOption"] = tostring(tmpOptions.Notes);
	end
	if (not OptionsOnly) then
		if (tmpOptions.Enabled) then
			libGuildWardenSaveVar["Options"][libGuildWarden.Realm][guildName]["AutoScan"] = tostring(tmpOptions.Enabled);  
		end
		if (tmpOptions.lowestLVL) then
			libGuildWardenSaveVar["Options"][libGuildWarden.Realm][guildName]["Level"] = tmpOptions.lowestLVL;   	
		end
		if (tmpOptions.lowestDKLVL) then
			libGuildWardenSaveVar["Options"][libGuildWarden.Realm][guildName]["DKLevel"] = tmpOptions.lowestDKLVL;   	
		end
		if (tmpOptions.Timer) then
			libGuildWardenSaveVar["Options"][libGuildWarden.Realm][guildName]["Timer"] = tmpOptions.Timer;	
		end
	end	
end
function libGuildWarden.GetScanner()
	libGuildWarden.CheckLoadScanner()
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	if (not libGuildWardenSaveVar["Options"][libGuildWarden.Realm]) then
		libGuildWardenSaveVar["Options"][libGuildWarden.Realm] = {}
	end
	if (not libGuildWardenSaveVar["Options"][libGuildWarden.Realm][guildName]) then
		libGuildWardenSaveVar["Options"][libGuildWarden.Realm][guildName] = {}
	end	
	local tmpOptions = {};
	tmpOptions.Option = libGuildWardenSaveVar["Options"][libGuildWarden.Realm][guildName]["autoinviteOption"];
	tmpOptions.Notes = libGuildWardenSaveVar["Options"][libGuildWarden.Realm][guildName]["officersOption"];
	tmpOptions.Enabled = libGuildWardenSaveVar["Options"][libGuildWarden.Realm][guildName]["AutoScan"];  
	tmpOptions.lowestLVL = libGuildWardenSaveVar["Options"][libGuildWarden.Realm][guildName]["Level"];   	
	tmpOptions.lowestDKLVL = libGuildWardenSaveVar["Options"][libGuildWarden.Realm][guildName]["DKLevel"];   	
	tmpOptions.Timer = libGuildWardenSaveVar["Options"][libGuildWarden.Realm][guildName]["Timer"];		
	return tmpOptions;
end

function libGuildWarden.SetCheckBoxs()
	local tmpTableA1 = libGuildWarden.GetScanner();	
	GW_GlobalTalkOption:SetChecked(libGuildWardenSaveVar["Options"]["GlobalTalkOption"]);
	GW_SystemTalkOption:SetChecked(libGuildWardenSaveVar["Options"]["SystemTalkOption"]);
	GW_WhoOption:SetChecked(libGuildWardenSaveVar["Options"]["WhoOption"]);		
	GW_ThrotalOption:SetChecked(libGuildWardenSaveVar["Options"]["ThrotalOption"]);
	GW_MouseOverOption:SetChecked(libGuildWardenSaveVar["Options"]["MouseOverOption"]);	
	GW_guildMOTDOption:SetChecked(libGuildWardenSaveVar["Options"]["guildMOTDOption"]);
	GW_SinkOption:SetChecked(libGuildWardenSaveVar["Options"]["sinkOption"]);
	GW_InvitePopUp:SetChecked(libGuildWardenSaveVar["Options"]["InvitePopUp"]);
	GW_OfficersOption:SetChecked(tmpTableA1.Notes);
	GW_AutoInviteOption:SetChecked(tmpTableA1.Option);	
	if (GuildWardenShowBtn3) then
		if (libGuildWardenSaveVar["Options"]["autoinviteOption"] == true) then				
			if (not libGuildWarden.IsGuildLeader()) then
				GuildWardenShowBtn3:Disable();
			else
				GuildWardenShowBtn3:Enable();
			end
		else
			GuildWardenShowBtn3:Enable();
		end	
	end			
	if (GW_RequestOption) then
		local tmpTableA1 = libGuildWarden.GetScanner();
		GW_RequestOption:SetChecked(tmpTableA1.Enabled);
		GuildWardenSliderRequestLevel:SetValue(tmpTableA1.lowestLVL);
		GuildWardenSliderRequestLevel.rate:SetText("Decline under level " .. tmpTableA1.lowestLVL);	     
		
		GuildWardenSliderRequestDKLevel:SetValue(tmpTableA1.lowestDKLVL);		
		GuildWardenSliderRequestDKLevel.rate:SetText("Decline DKs under level " .. tmpTableA1.lowestDKLVL);	     		
		
		GuildWardenSliderRequest:SetValue(tmpTableA1.Timer);	
		GuildWardenSliderRequest.rate:SetText("Scan every " .. tmpTableA1.Timer .. " Mins.");	
	end
	
end
--[[
function libGuildWarden.Convert24toAMPM(Time)
	local SplitC = {strsplit(".",Time)}
	local HR = tonumber(SplitC[1]);			
	if (HR == 0 or HR == 12) then
		local TimeOut = "12." .. SplitC[2] .. "." .. SplitC[3];
		if (HR == 0) then
			return TimeOut .. " AM";				
		else
			return TimeOut .. " PM";				
		end
	else
		if (HR > 12) then
			local Time = HR - 12;
			local TimeOut = Time .. "." .. SplitC[2] .. "." .. SplitC[3] .. " PM";
			return TimeOut;
		else
			return Time .. " AM";				
		end
	end
end ]]--
function libGuildWarden.SaveCheckBoxs()
	if (GW_GlobalTalkOption:GetChecked()) then
		libGuildWardenSaveVar["Options"]["GlobalTalkOption"] = true;
	else
		libGuildWardenSaveVar["Options"]["GlobalTalkOption"] = false;
		GW_SystemTalkOption:SetChecked(false);
		GW_WhoOption:SetChecked(false);
	end
	if (GW_SystemTalkOption:GetChecked()) then
		libGuildWardenSaveVar["Options"]["SystemTalkOption"] = true;
	else
		libGuildWardenSaveVar["Options"]["SystemTalkOption"] = false;
	end
	if (GW_WhoOption:GetChecked()) then
		libGuildWardenSaveVar["Options"]["WhoOption"] = true;
	else
		libGuildWardenSaveVar["Options"]["WhoOption"] = false;
	end	
	if (GW_ThrotalOption:GetChecked()) then
		libGuildWardenSaveVar["Options"]["ThrotalOption"] = true;
	else
		libGuildWardenSaveVar["Options"]["ThrotalOption"] = false;
	end
	if (GW_MouseOverOption:GetChecked()) then
		libGuildWardenSaveVar["Options"]["MouseOverOption"] = true;
	else
		libGuildWardenSaveVar["Options"]["MouseOverOption"] = false;
	end		
	if (GW_guildMOTDOption:GetChecked()) then
		libGuildWardenSaveVar["Options"]["guildMOTDOption"] = true;
	else
		libGuildWardenSaveVar["Options"]["guildMOTDOption"] = false;
	end			
	if (GW_SinkOption:GetChecked()) then
		libGuildWardenSaveVar["Options"]["sinkOption"] = true;
	else
		libGuildWardenSaveVar["Options"]["sinkOption"] = false;
	end			
	
	local tmpOptions = {};
	if (GW_OfficersOption:GetChecked()) then
		tmpOptions.Notes = true;
	else
		tmpOptions.Notes = false;
	end		
	if (GW_AutoInviteOption:GetChecked()) then
		tmpOptions.Option = true;
	else
		tmpOptions.Option = false;
	end			
	libGuildWarden.SetScanner(tmpOptions);
	
	if (GW_InvitePopUp:GetChecked()) then
		libGuildWardenSaveVar["Options"]["InvitePopUp"] = true;
	else
		libGuildWardenSaveVar["Options"]["InvitePopUp"] = false;
	end		
	
end
function libGuildWarden.CheckBanned()
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();

	for index=1,GetNumGuildMembers() do
		local subname, subrank, subrankIndex, sublevel, subclass, subzone, subnote, subofficernote, subonline, substatus, subclassFileName, subachievementPoints, subachievementRank, subisMobile = GetGuildRosterInfo(index);
		local hisID = libGuildWarden.ReturnID(subname);
		if (hisID) then
			if (libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][hisID]) then
				if (libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][hisID].Datebanned) then
					libGuildWarden.ShowBan(hisID, subname);
				end
			end
		end		
	end

end
function libGuildWarden.IsBanned(Name)
	if (Name) then
		local MainID = libGuildWarden.ReturnID(Name);
		local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
		if (MainID) then
			if (libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][MainID]) then
				if (libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][MainID].Datebanned) then
					--libGuildWarden.ShowBan(MainID, Name);
					return true;
				end
			end
		end			
	end
	return false;
end
function libGuildWarden.ShowPopUp(Message, YesText, NoText, HideTextBox, TextBoxMsg)
	if (not YesText) then
		YesText = "Ok";
	end
	if (not NoText) then
		NoText = "Cancel";
	end	
	if (HideTextBox) then
		GuildWardenPopTextBox:Hide();
	else
		GuildWardenPopTextBox:Show();
	end
	if (TextBoxMsg) then
		GuildWardenPopTextBox:SetText(TextBoxMsg);
	else
		GuildWardenPopTextBox:SetText("");
	end
	if (YesText == NoText) then
		GuildWardenPopClose:Show()
		GuildWardenPopClose:SetText(YesText);
		GuildWardenPopOk:Hide();
		GuildWardenPopCancel:Hide();
	else
		GuildWardenPopOk:SetText(YesText);
		GuildWardenPopCancel:SetText(NoText);
		GuildWardenPopClose:Hide()
		GuildWardenPopOk:Show();
		GuildWardenPopCancel:Show();		
	end

	frmGuildWardenPopupText:SetText(Message);
	frmGuildWardenPopup:Show();
end
function libGuildWarden.ShowBan(hisID, subname)
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	PlaySound("RaidWarning");
	libGuildWarden.SendText("BANNED GUILDIE: " .. subname .. " IS IN THE GUILD!!!!!");
	libGuildWarden.SendText("BANNED By: " .. libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][hisID].BannedBy);
	libGuildWarden.SendText("BANNED Date: " .. libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][hisID].Datebanned);
	libGuildWarden.SendText(libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][hisID].BannedReason);
	libGuildWarden.YesNoFunction = nil;
	libGuildWarden.ShowPopUp("BANNED GUILDIE: " .. subname .. " IS IN THE GUILD!!!!!\n" .. "BANNED By: " .. libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][hisID].BannedBy .."\n" .. "BANNED Date: " .. libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][hisID].Datebanned .. "\n" ..	libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][hisID].BannedReason, "Close", "Close" ,true);
	
end
function libGuildWarden.MakeFrame(Index, Frame, Text) 
		CreateFrame("Button", "GuildFrameTab"  .. Index, GuildFrame, "CharacterFrameTabButtonTemplate");				
		local MyFrame = _G["GuildFrameTab" .. Index];
		local MyFramesub = _G["GuildFrameTab" .. (Index - 1)];
		MyFrame:SetFrameLevel(1);
	 	MyFrame:SetParent(GuildFrame);
		MyFrame:SetText(Text);
		MyFrame:SetScript("OnEnter", function(self)
							GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
							GameTooltip:SetText(Text, 1.0,1.0,1.0 );
						end)
		MyFrame:SetScript("OnClick", function(self)
							libGuildWarden.TabClicked(self);
							PanelTemplates_Tab_OnClick(self, GuildFrame);
							PlaySound("igCharacterInfoTab");
						end)
		MyFrame:SetScript("OnLeave", function(self) GameTooltip_Hide() end)

		
	 	Frame:SetParent(GuildFrame);	 	
		MyFrame:SetPoint("LEFT", MyFramesub, "RIGHT", -15, 0);
		MyFrame:SetID(Index);
		
	 	MyFrame:Show();		
	 	GuildFrame_RegisterPanel(Frame);
		PanelTemplates_DeselectTab(MyFrame)
		return MyFrame;
end

function libGuildWarden.GetMain(Name)
	local MainID = libGuildWarden.ReturnID(Name);
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	if (MainID) then
		if (libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][MainID]) then
			if (libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][MainID].Main) then
				return libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][MainID].Main;		
			end
		end
	else
		return "No ID";	
	end
	return "Not Set";
end
function libGuildWarden.AddThisPlayer()
	local MyName = UnitName("player");
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	
	libGuildWarden.SetPlayerInfo(MyName, "Guild", guildName);
	libGuildWarden.SetPlayerInfo(MyName, "Race", UnitRace("player"));
	libGuildWarden.SetPlayerInfo(MyName, "LVL", UnitLevel("player"));
	libGuildWarden.SetPlayerInfo(MyName, "Class", UnitClass("player"));
	libGuildWarden.SetPlayerInfo(MyName, "ID", libGuildWardenSaveVar["MainMyID"]);
	libGuildWarden.SetPlayerInfo(MyName, "Updated", date("%m/%d/%y %H.%M.%S"));
	libGuildWarden.SetPlayerInfo(MyName, "Faction", UnitFactionGroup("player"));

end

function libGuildWarden.MakeUserID(Name)
		local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
		local x = math.random(10000);
		local NewID = libGuildWarden.Realm .. Name .. x;
		libGuildWarden.SetPlayerInfo(Name, "TMPID", NewID);
		libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][NewID] = {};
		libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][NewID].Main = Name;
        libGuildWarden.SendText("New ID made for " .. Name .. ". ID: " .. NewID, true);
		libGuildWarden.SendSingalPlayer(Name);
		libGuildWarden.SendSingalMain(NewID);
        return NewID;
end