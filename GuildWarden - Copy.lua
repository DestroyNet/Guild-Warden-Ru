
libGuildWarden = {};
libGuildWarden.Loaded = -2;
libGuildWarden.TempListMain = {};
libGuildWarden.SelectedName = nil;

StaticPopupDialogs["GuildWarden_AddAlt"] = {
	text = "Enter alts char. name to add it to curent char.",
		button1 = "Add",
	button2 = "Cancel",
	OnAccept = function(self)
		local altsname = self.editBox:GetText();
		local Mainsname = libGuildWarden.SelectedName;
		local tmpinfo = libGuildWarden.GetPlayerInfo(Mainsname);

		if (tmpinfo.ID and tmpinfo.ID ~= "??") then
			libGuildWarden.SetPlayerInfo(altsname, "TMPID", tmpinfo.ID);
		else
			if (tmpinfo.TMPID and tmpinfo.TMPID ~= "??") then
				libGuildWarden.SetPlayerInfo(altsname, "TMPID", tmpinfo.TMPID);
			else
				local x = math.random(10000);
				local NewID = libGuildWarden.Realm .. Mainsname .. x;
				libGuildWarden.SetPlayerInfo(Mainsname, "TMPID", NewID);
				libGuildWarden.SetPlayerInfo(altsname, "TMPID", NewID);
				libGuildWarden.SendText("New ID made for " .. Mainsname .. ". ID: " .. NewID);
			end
		end

		libGuildWarden.SelectedName = Mainsname;
		libGuildWarden.SortAltsList();
		GuildAlts_Update();
	end,

	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	hasEditBox = 1,
}

StaticPopupDialogs["GuildWarden_AddBanned"] = {
	text = "Enter reason to ban this char(s).",
		button1 = "Ban!",
	button2 = "Cancel",
	OnAccept = function(self)
		local reason = self.editBox:GetText();
		local Mainsname = libGuildWarden.SelectedName;
		libGuildWarden.BanPlayer(Mainsname, reason);
	end,

	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	hasEditBox = 1,
}

function libGuildWarden.BanPlayer(Name, Reason)
	local tmpinfo = libGuildWarden.GetPlayerInfo(Name);
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	local LeftList = libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName];
	local Added = false;

	for key, value in pairs(libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm]) do
		if (tmpinfo.ID and tmpinfo.ID ~= "??") then
			Added = true;
			if (value.ID == tmpinfo.ID or value.TMPID == tmpinfo.ID) then
				if (not libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][key]) then
					libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][key] = {};
				end

				if (not libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][key].Datebanned) then
					libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][key].BannedBy = UnitName("player");
					libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][key].BannedReason = Reason;
					local SplitA = {strsplit("/",date("%m/%d/%y"))};
					SplitA[2] = tonumber(SplitA[2]) - 1;
					SplitA = SplitA[1] .. "/" .. SplitA[2] .. "/" ..SplitA[3];
					libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][key].Datebanned = SplitA;
			 		libGuildWarden.SendText(key .. " has been banned");
			 	end
			end
		end

		if (tmpinfo.TMPID and tmpinfo.TMPID ~= "??") then
			Added = true;
			if (value.ID == tmpinfo.TMPID or value.TMPID == tmpinfo.TMPID) then
				if (not libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][key]) then
					libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][key] = {};
				end

				if (not libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][key].Datebanned) then
					libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][key].BannedBy = UnitName("player");
					libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][key].BannedReason = Reason;
					local SplitA = {strsplit("/",date("%m/%d/%y"))};
					SplitA[2] = tonumber(SplitA[2]) - 1;
					SplitA = SplitA[1] .. "/" .. SplitA[2] .. "/" ..SplitA[3];
					libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][key].Datebanned = SplitA;
			 		libGuildWarden.SendText(key .. " has been banned");
			 	end
			end
		end
	end

	if (Added == false) then
		local x = math.random(10000);
		local NewID = libGuildWarden.Realm .. Name .. x;
		libGuildWarden.SetPlayerInfo(Name, "TMPID", NewID);
		libGuildWarden.SendText("New ID made for " .. Name .. ". ID: " .. NewID);
		if (not libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][Name]) then
			libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][Name]= {};
		end

		if (not libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][Name].Datebanned) then
			libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][Name].BannedBy = UnitName("player");
			libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][Name].BannedReason = Reason;

			local SplitA = {strsplit("/",date("%m/%d/%y"))};
			SplitA[2] = tonumber(SplitA[2]) - 1;
			SplitA = SplitA[1] .. "/" .. SplitA[2] .. "/" ..SplitA[3];			

			libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][Name].Datebanned = SplitA;
			libGuildWarden.SendText(Name .. " has been banned");
		end
	end
end

function libGuildWarden.RemoveBanPlayer(Name)
	local tmpinfo = libGuildWarden.GetPlayerInfo(Name);
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	local LeftList = libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName];
	local Added = false;
	for key, value in pairs(libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm]) do
		if (tmpinfo.ID and tmpinfo.ID ~= "??") then
			Added = true;
			if (value.ID == tmpinfo.ID or value.TMPID == tmpinfo.ID) then
				libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][key] = {};
					libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][key].RemovedBy = UnitName("player");
					libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][key].Dateremoved = date("%m/%d/%y");
			 	libGuildWarden.SendText(key .. " has been removed from banned");
			end
		end

		if (tmpinfo.TMPID and tmpinfo.TMPID ~= "??") then
			Added = true;
			if (value.ID == tmpinfo.TMPID or value.TMPID == tmpinfo.TMPID) then
				libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][key] = {};
					libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][key].RemovedBy = UnitName("player");
					libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][key].Dateremoved = date("%m/%d/%y");
				libGuildWarden.SendText(key .. " has been removed from banned");
			end
		end
	end

	if (Added == false) then
		local x = math.random(10000);
		local NewID = libGuildWarden.Realm .. Name .. x;
		libGuildWarden.SetPlayerInfo(Name, "TMPID", NewID);
		libGuildWarden.SendText("New ID made for " .. Name .. ". ID: " .. NewID);
		libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][Name] = {};
		libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][Name].RemovedBy = UnitName("player");
		libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][Name].Dateremoved = date("%m/%d/%y");
		libGuildWarden.SendText(Name .. " has been removed from banned");
	end
end

function libGuildWarden.SendText(Text)
	local red = 0;
	local green = 1;
	local blue = 0;
	if (Text == nil) then
		return;
	end

	local colorNew = libGuildWarden.RGBPercToHex(red, green, blue);
	local OutText = "|cFF" .. colorNew .. "Guild Warden: " .. Text .. "|r";
	ChatFrame1:AddMessage(OutText);
end

function libGuildWarden.RGBPercToHex(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r*255, g*255, b*255)
end

function GuildWarden_Load(self)
	libGuildWarden.Version = GetAddOnMetadata("Guild Warden", "Version")
	SlashCmdList["GuildWarden"] = GuildWarden_List_cmd;
	SLASH_GuildWarden1 = "/guildwarden";
	SLASH_GuildWarden2 = "/gw";
	SLASH_GuildWarden3 = "/warden";
	self:RegisterEvent("VARIABLES_LOADED");
	self:RegisterEvent("CHAT_MSG_ADDON");
end

function GuildWarden_List_cmd(msg)
	msg = strlower(msg);
	if (msg == "") then
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
	return	GuildMemberCountCLass[TypeClass].Max,	Total;
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
	GuildMemberCountCLass["LastOnline"].LessMonth =	0;
	GuildMemberCountCLass["LastOnline"].OneSixMonth = 0;
	GuildMemberCountCLass["LastOnline"].SixMonth = 0;
	GuildMemberCountCLass["LastOnline"].Week = 0;
	for index=1,GetNumGuildMembers() do
		local subname, subrank, subrankIndex, sublevel, subclass, subzone, subnote, subofficernote, subonline, substatus, subclassFileName, subachievementPoints, subachievementRank, subisMobile = GetGuildRosterInfo(index);
		local years, months, days, hours = GetGuildRosterLastOnline(index)
		GuildRoster[subname] = subname;
		if (not libGuildWardenSaveVar["Roster"][libGuildWarden.Realm][guildName][subname]) then
			libGuildWardenSaveVar["Joined"][libGuildWarden.Realm][guildName][subname] = {};
			libGuildWardenSaveVar["Joined"][libGuildWarden.Realm][guildName][subname].Datejoined = date("%m/%d/%y");
		end

		libGuildWarden.SetPlayerInfo(subname, "LVL", sublevel);
		libGuildWarden.SetPlayerInfo(subname, "Class", subclass);
		libGuildWarden.SetPlayerInfo(subname, "RankIndex", subrankIndex);
		libGuildWarden.SetPlayerInfo(subname, "Guild", guildName);
		if (not libGuildWardenSaveVar["Joined"][libGuildWarden.Realm][guildName][subname].Datejoined) then
			libGuildWardenSaveVar["Joined"][libGuildWarden.Realm][guildName][subname].Datejoined = "00/00/00";
		end

		if (libGuildWardenSaveVar["Joined"][libGuildWarden.Realm][guildName][subname].Datejoined == date("%m/%d/%y")) then
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
			libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName][value].Dateleft = date("%m/%d/%y");
		end
	end

	for key, value in pairs(libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName]) do
		local tmpinfo = libGuildWarden.GetPlayerInfo(key);
		if (not libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName][key].Dateleft) then
			libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName][key].Dateleft = "00/00/00";
		end

		if (libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName][key].Dateleft == date("%m/%d/%y")) then
			Left = Left + 1;
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

function libGuildWarden.SetLeftView()
	local GUILD_LEFT_COLUMN_DATA = {};
	local stringsInfo = { };
	local stringOffset = 0;
	local haveIcon, haveBar;

	GUILD_LEFT_COLUMN_DATA[1] = { width = 32, text = "LVL", stringJustify="CENTER", type = "LVL"};
	GUILD_LEFT_COLUMN_DATA[2] = { width = 32, text = "Cls", hasIcon = true, type = "Class" };
	GUILD_LEFT_COLUMN_DATA[3] = { width = 81, text = "Name", stringJustify="LEFT", type = "Name" };
	GUILD_LEFT_COLUMN_DATA[4] = { width = 144, text = "Date Left", stringJustify="LEFT", type = "Dateleft" };
	libGuildWarden.TempListMain["Left"].sort = "Dateleft"
	libGuildWarden.TempListMain["Left"].dir = "-"
	for columnIndex = 1, 4 do
		local columnButton = _G["GuildLeftColumnButton"..columnIndex];
		local columnData = GUILD_LEFT_COLUMN_DATA[columnIndex];

		columnButton:SetText(columnData.text);
		WhoFrameColumn_SetWidth(columnButton, columnData.width);
		columnButton:Show();

		-- by default the sort type should be the same as the column type
		--[[
		if ( columnData.sortType ) then
			columnButton.sortType = columnData.sortType;
		else
			columnButton.sortType = columnType;
		end
		]]--

		columnButton.sortType = columnData.type;
		if ( columnData.hasIcon ) then
			haveIcon = true;
		else
			-- store string data for processing
			columnData["stringOffset"] = stringOffset;
			table.insert(stringsInfo, columnData);
		end

		stringOffset = stringOffset + columnData.width - 2;
		haveBar = haveBar or columnData.hasBar;
	end

	local buttons = GuildLeftContainer.buttons;
	local button, fontString;
	for buttonIndex = 1, #buttons do
		button = buttons[buttonIndex];
		for stringIndex = 1, 4 do
			fontString = button["string"..stringIndex];
			local stringData = stringsInfo[stringIndex];
			if ( stringData ) then
				-- want strings a little inside the columns, 6 pixels from the left and 8 from the right
				fontString:SetPoint("LEFT", stringData.stringOffset + 6, 0);
				fontString:SetWidth(stringData.width - 14);
				fontString:SetJustifyH(stringData.stringJustify);
				fontString:Show();
			else
				fontString:Hide();
			end
		end

		if ( haveIcon ) then
			button.icon:Show();
		else
			button.icon:Hide();
		end

		if ( haveBar ) then
			button.barLabel:Show();
			-- button.barTexture:Show(); -- shown status determined in GuildRoster_Update
		else
			button.barLabel:Hide();
			button.barTexture:Hide();
		end
		button.header:Hide();
	end
	libGuildWarden.SortLeftList();
	GuildLeft_Update();
end

function libGuildWarden.SetRealmView()
	local GUILD_Realm_COLUMN_DATA = {};
	local stringsInfo = { };
	local stringOffset = 0;
	local haveIcon, haveBar;

	GUILD_Realm_COLUMN_DATA[1] = { width = 32, text = "LVL", stringJustify="CENTER", type = "LVL"};
	GUILD_Realm_COLUMN_DATA[2] = { width = 32, text = "Cls", hasIcon = true, type = "Class" };
	GUILD_Realm_COLUMN_DATA[3] = { width = 81, text = "Name", stringJustify="LEFT", type = "Name" };
	GUILD_Realm_COLUMN_DATA[4] = { width = 144, text = "Guild", stringJustify="LEFT", type = "Guild" };
	libGuildWarden.TempListMain["Realm"].sort = "Guild"
	libGuildWarden.TempListMain["Realm"].dir = "-"
	for columnIndex = 1, 4 do
		local columnButton = _G["GuildRealmColumnButton"..columnIndex];
		local columnData = GUILD_Realm_COLUMN_DATA[columnIndex];
		columnButton:SetText(columnData.text);
		WhoFrameColumn_SetWidth(columnButton, columnData.width);
		columnButton:Show();
		columnButton.sortType = columnData.type;
		if ( columnData.hasIcon ) then
			haveIcon = true;
		else
			-- store string data for processing
			columnData["stringOffset"] = stringOffset;
			table.insert(stringsInfo, columnData);
		end
		stringOffset = stringOffset + columnData.width - 2;
		haveBar = haveBar or columnData.hasBar;
	end

	local buttons = GuildRealmContainer.buttons;
	local button, fontString;
	for buttonIndex = 1, #buttons do
		button = buttons[buttonIndex];
		for stringIndex = 1, 4 do
			fontString = button["string"..stringIndex];
			local stringData = stringsInfo[stringIndex];
			if ( stringData ) then
				-- want strings a little inside the columns, 6 pixels from the left and 8 from the right
				fontString:SetPoint("LEFT", stringData.stringOffset + 6, 0);
				fontString:SetWidth(stringData.width - 14);
				fontString:SetJustifyH(stringData.stringJustify);
				fontString:Show();
			else
				fontString:Hide();
			end
		end

		if ( haveIcon ) then
			button.icon:Show();
		else
			button.icon:Hide();
		end

		if ( haveBar ) then
			button.barLabel:Show();
			-- button.barTexture:Show(); -- shown status determined in GuildRoster_Update
		else
			button.barLabel:Hide();
			button.barTexture:Hide();
		end
		button.header:Hide();
	end
	libGuildWarden.SortRealmList();
	GuildRealm_Update();
end

function libGuildWarden.SortRealmList()
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	local LeftList = libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm];
	local CountList= {};
	local Counter = 0;
	local TextSearch = "";
	if (TextBoxGWRealm1) then
		TextSearch = strlower(TextBoxGWRealm1:GetText());
	end

	--libGuildWarden.SendText(GetFixedLink());
	for key, value in pairs(LeftList) do
		if (not GuildRealmShowGuiliesButton:GetChecked() or libGuildWardenSaveVar["Roster"][libGuildWarden.Realm][guildName][key]) then
			if ((string.find(strlower(key), TextSearch)) or (TextSearch == "")) then
				Counter = Counter	+ 1;
				CountList[Counter] = {};
				CountList[Counter] = libGuildWarden.CloneSimpleTable(libGuildWarden.GetPlayerInfo(key));
				CountList[Counter].LVL = tonumber(CountList[Counter].LVL);
				if (not CountList[Counter].LVL) then
					CountList[Counter].LVL = 0;
				end

				if (not CountList[Counter].Guild) then
					CountList[Counter].Guild = "No Guild";
				end
			end
		end
	end

	-- "LVL"
	--"Cls"
	--"Name"
	--"Dateleft";
	--libGuildWardenSaveVar["Left"].dir
	--libGuildWardenSaveVar["Left"].sort
	libGuildWarden.TempListMain["Realm"]["CountList"] = CountList;
	libGuildWarden.TempListMain["Realm"].Max = Counter;
end

function GuildRealm_Update()
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	local scrollFrame = GuildRealmContainer;
	local offset = HybridScrollFrame_GetOffset(scrollFrame);
	local index;
	local classFileName;
	local buttons = scrollFrame.buttons;
	local numButtons = #buttons;
	local CountList = libGuildWarden.TempListMain["Realm"]["CountList"];
	local Counter = libGuildWarden.TempListMain["Realm"].Max;
	if (libGuildWarden.TempListMain["Realm"].dir == "+") then
		sort(CountList, function(a,b) return a[libGuildWarden.TempListMain["Realm"].sort] < b[libGuildWarden.TempListMain["Realm"].sort] end)
	end

	if (libGuildWarden.TempListMain["Realm"].dir == "-") then
		sort(CountList, function(a,b) return a[libGuildWarden.TempListMain["Realm"].sort] > b[libGuildWarden.TempListMain["Realm"].sort] end)
	end

 	for i = 1, numButtons do
		button = buttons[i];
		index = offset + i
		if (CountList[tonumber(index)]) then
			local Playerinfo = CountList[tonumber(index)];
			if (Playerinfo) then
				classFileName = libGuildWarden.GetClassFileName(Playerinfo.Class);
				if (classFileName) then
					if (classFileName == "РЫЦАРЬ") then
						classFileName = "РЫЦАРЬСМЕРТИ";
						Playerinfo.Class = "Рыцарь смерти";
					end

					if (CLASS_ICON_TCOORDS[classFileName]) then
						button.icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classFileName]))
						button.icon:Show();
					else
						button.icon:Hide();
					end
				else
					button.icon:Hide();
				end

				if (libGuildWardenSaveVar["Roster"][libGuildWarden.Realm][guildName][Playerinfo.Name]) then
					if (Playerinfo.DateRealm == date("%m/%d/%y")) then
						libGuildWarden.SetStringTextColor(button.string3, Playerinfo.Guild, 0, 1, 0);
						libGuildWarden.SetStringTextColor(button.string1, Playerinfo.LVL, 0, 1, 0);
					else
						libGuildWarden.SetStringText(button.string3, Playerinfo.Guild, true);
						libGuildWarden.SetStringText(button.string1, Playerinfo.LVL, true);
					end
				else
					if (libGuildWarden.GetPlayerInfo(Playerinfo.Name).Guild == guildName) then
						libGuildWarden.SetPlayerInfo(Playerinfo.Name, "Guild", "No Guild");
					end
					libGuildWarden.SetStringText(button.string3, Playerinfo.Guild);
					libGuildWarden.SetStringText(button.string1, Playerinfo.LVL);
				end

				libGuildWarden.SetStringText(button.string2, Playerinfo.Name, true, classFileName);
				button.index = index;
				button:Show();
			end
		else
			button:Hide();
		end
	end

	local totalHeight = Counter * (20 + 2);
	local displayedHeight = numButtons * (20 + 2);
	HybridScrollFrame_Update(scrollFrame, totalHeight, displayedHeight);
end

function libGuildWarden.SetJoinedView()
	local GUILD_JOINED_COLUMN_DATA = {};
	local stringsInfo = { };
	local stringOffset = 0;
	local haveIcon, haveBar;

	GUILD_JOINED_COLUMN_DATA[1] = { width = 32, text = "LVL", stringJustify="CENTER", type = "LVL"};
	GUILD_JOINED_COLUMN_DATA[2] = { width = 32, text = "Cls", hasIcon = true, type = "Class" };
	GUILD_JOINED_COLUMN_DATA[3] = { width = 81, text = "Name", stringJustify="LEFT", type = "Name" };
	GUILD_JOINED_COLUMN_DATA[4] = { width = 144, text = "Date Joined", stringJustify="LEFT", type = "Datejoined" };
	libGuildWarden.TempListMain["Joined"].sort = "Datejoined"
	libGuildWarden.TempListMain["Joined"].dir = "-"
	for columnIndex = 1, 4 do
		local columnButton = _G["GuildJoinedColumnButton"..columnIndex];
		local columnData = GUILD_JOINED_COLUMN_DATA[columnIndex];

		columnButton:SetText(columnData.text);
		WhoFrameColumn_SetWidth(columnButton, columnData.width);
		columnButton:Show();

		-- by default the sort type should be the same as the column type
		--[[
		if ( columnData.sortType ) then
			columnButton.sortType = columnData.sortType;
		else
			columnButton.sortType = columnType;
		end
		]]--

		columnButton.sortType = columnData.type;
		if ( columnData.hasIcon ) then
			haveIcon = true;
		else
			-- store string data for processing
			columnData["stringOffset"] = stringOffset;
			table.insert(stringsInfo, columnData);
		end
		stringOffset = stringOffset + columnData.width - 2;
		haveBar = haveBar or columnData.hasBar;
	end

	local buttons = GuildJoinedContainer.buttons;
	local button, fontString;
	for buttonIndex = 1, #buttons do
		button = buttons[buttonIndex];
		for stringIndex = 1, 4 do
			fontString = button["string"..stringIndex];
			local stringData = stringsInfo[stringIndex];
			if ( stringData ) then
				-- want strings a little inside the columns, 6 pixels from the left and 8 from the right
				fontString:SetPoint("LEFT", stringData.stringOffset + 6, 0);
				fontString:SetWidth(stringData.width - 14);
				fontString:SetJustifyH(stringData.stringJustify);
				fontString:Show();
			else
				fontString:Hide();
			end
		end

		if ( haveIcon ) then
			button.icon:Show();
		else
			button.icon:Hide();
		end

		if ( haveBar ) then
			button.barLabel:Show();
			-- button.barTexture:Show(); -- shown status determined in GuildRoster_Update
		else
			button.barLabel:Hide();
			button.barTexture:Hide();
		end
		button.header:Hide();
	end
	libGuildWarden.SortJoinedList();
	GuildJoined_Update();
end

function libGuildWarden.SetBannedView()
	local GUILD_Banned_COLUMN_DATA = {};
	local stringsInfo = { };
	local stringOffset = 0;
	local haveIcon, haveBar;

	GUILD_Banned_COLUMN_DATA[1] = { width = 32, text = "LVL", stringJustify="CENTER", type = "LVL"};
	GUILD_Banned_COLUMN_DATA[2] = { width = 32, text = "Cls", hasIcon = true, type = "Class" };
	GUILD_Banned_COLUMN_DATA[3] = { width = 81, text = "Name", stringJustify="LEFT", type = "Name" };
	GUILD_Banned_COLUMN_DATA[4] = { width = 144, text = "Date Banned", stringJustify="LEFT", type = "Datebanned" };
	libGuildWarden.TempListMain["Banned"].sort = "Datebanned"
	libGuildWarden.TempListMain["Banned"].dir = "-"
	for columnIndex = 1, 4 do
		local columnButton = _G["GuildBannedColumnButton"..columnIndex];
		local columnData = GUILD_Banned_COLUMN_DATA[columnIndex];

		columnButton:SetText(columnData.text);
		WhoFrameColumn_SetWidth(columnButton, columnData.width);
		columnButton:Show();

		-- by default the sort type should be the same as the column type
		--[[
		if ( columnData.sortType ) then
			columnButton.sortType = columnData.sortType;
		else
			columnButton.sortType = columnType;
		end
		]]--

		columnButton.sortType = columnData.type;
		if ( columnData.hasIcon ) then
			haveIcon = true;
		else
			-- store string data for processing
			columnData["stringOffset"] = stringOffset;
			table.insert(stringsInfo, columnData);
		end
		stringOffset = stringOffset + columnData.width - 2;
		haveBar = haveBar or columnData.hasBar;
	end

	local buttons = GuildBannedContainer.buttons;
	local button, fontString;
	for buttonIndex = 1, #buttons do
		button = buttons[buttonIndex];
		for stringIndex = 1, 4 do
			fontString = button["string"..stringIndex];
			local stringData = stringsInfo[stringIndex];
			if ( stringData ) then
				-- want strings a little inside the columns, 6 pixels from the left and 8 from the right
				fontString:SetPoint("LEFT", stringData.stringOffset + 6, 0);
				fontString:SetWidth(stringData.width - 14);
				fontString:SetJustifyH(stringData.stringJustify);
				fontString:Show();
			else
				fontString:Hide();
			end
		end

		if ( haveIcon ) then
			button.icon:Show();
		else
			button.icon:Hide();
		end

		if ( haveBar ) then
			button.barLabel:Show();
			-- button.barTexture:Show(); -- shown status determined in GuildRoster_Update
		else
			button.barLabel:Hide();
			button.barTexture:Hide();
		end
		button.header:Hide();
	end
	libGuildWarden.SortBannedList();
	GuildBanned_Update();
end

function libGuildWarden.SetAltsView()
	local GUILD_Alts_COLUMN_DATA = {};
	local stringsInfo = { };
	local stringOffset = 0;
	local haveIcon, haveBar;

	GUILD_Alts_COLUMN_DATA[1] = { width = 32, text = "LVL", stringJustify="CENTER", type = "LVL"};
	GUILD_Alts_COLUMN_DATA[2] = { width = 32, text = "Cls", hasIcon = true, type = "Class" };
	GUILD_Alts_COLUMN_DATA[3] = { width = 81, text = "Name", stringJustify="LEFT", type = "Name" };
	GUILD_Alts_COLUMN_DATA[4] = { width = 144, text = "Guild", stringJustify="LEFT", type = "Guild" };
	libGuildWarden.TempListMain["Alts"].sort = "Guild"
	libGuildWarden.TempListMain["Alts"].dir = "-"
	for columnIndex = 1, 4 do
		local columnButton = _G["GuildAltsColumnButton"..columnIndex];
		local columnData = GUILD_Alts_COLUMN_DATA[columnIndex];

		columnButton:SetText(columnData.text);
		WhoFrameColumn_SetWidth(columnButton, columnData.width);
		columnButton:Show();

		-- by default the sort type should be the same as the column type
		--[[
		if ( columnData.sortType ) then
			columnButton.sortType = columnData.sortType;
		else
			columnButton.sortType = columnType;
		end
		]]--

		columnButton.sortType = columnData.type;
		if ( columnData.hasIcon ) then
			haveIcon = true;
		else
			-- store string data for processing
			columnData["stringOffset"] = stringOffset;
			table.insert(stringsInfo, columnData);
		end
		stringOffset = stringOffset + columnData.width - 2;
		haveBar = haveBar or columnData.hasBar;
	end

	local buttons = GuildAltsContainer.buttons;
	local button, fontString;
	for buttonIndex = 1, #buttons do
		button = buttons[buttonIndex];
		for stringIndex = 1, 4 do
			fontString = button["string"..stringIndex];
			local stringData = stringsInfo[stringIndex];
			if ( stringData ) then
				-- want strings a little inside the columns, 6 pixels from the left and 8 from the right
				fontString:SetPoint("LEFT", stringData.stringOffset + 6, 0);
				fontString:SetWidth(stringData.width - 14);
				fontString:SetJustifyH(stringData.stringJustify);
				fontString:Show();
			else
				fontString:Hide();
			end
		end

		if ( haveIcon ) then
			button.icon:Show();
		else
			button.icon:Hide();
		end

		if ( haveBar ) then
			button.barLabel:Show();
			-- button.barTexture:Show(); -- shown status determined in GuildRoster_Update
		else
			button.barLabel:Hide();
			button.barTexture:Hide();
		end
		button.header:Hide();
	end
	libGuildWarden.SortAltsList();
	GuildAlts_Update();
end

function libGuildWarden.SetStringTextColor(buttonString, text, R, G, B)
	buttonString:SetText(text);
	buttonString:SetTextColor(R, G, B);
end

function libGuildWarden.SetStringText(buttonString, text, isOnline, class)
	buttonString:SetText(text);
	if ( isOnline ) then
		if ( class ) then
			local classColor = RAID_CLASS_COLORS[class];
			if (classColor) then
				buttonString:SetTextColor(classColor.r, classColor.g, classColor.b);
			else
				buttonString:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
			end
		else
			buttonString:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
		end
	else
		buttonString:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
end

function libGuildWarden.LoadAllTaps()
	libGuildWarden.GetStatus();
	libGuildWarden.SetLeftView();
	libGuildWarden.SetJoinedView();
	libGuildWarden.SetJoinedView();
	libGuildWarden.SetBannedView();
	libGuildWarden.SetRealmView();
	libGuildWarden.SetAltsView();
end

function libGuildWarden.TabClicked(self)
	local tabIndex = self:GetID();
	CloseGuildMenus();
	PanelTemplates_SetTab(self:GetParent(), tabIndex);
	if (tabIndex == 6) then
		ButtonFrameTemplate_HideButtonBar(GuildFrame);
		GuildFrame_ShowPanel("frmGuildWardenMain");
		GuildFrameInset:SetPoint("TOPLEFT", 4, -65);
		GuildFrameInset:SetPoint("BOTTOMRIGHT", -7, 44);
		frmGuildWardenMain:SetPoint("TOPLEFT", 4, -65);
		frmGuildWardenMain:SetPoint("BOTTOMRIGHT", -7, 44);
		GuildFrameBottomInset:Hide();
		GuildXPFrame:Hide();
		GuildFactionFrame:Hide();
		GuildAddMemberButton:Hide();
		GuildControlButton:Hide();
		GuildViewLogButton:Hide();
		GuildFrameMembersCountLabel:Hide();
		GuildFrameMembersCount:Hide();
		if (libGuildWarden.Loaded >= 1) then
			libGuildWarden.GetStatus();
			--frmGuildWardenRealm:Show();
			libGuildWarden.SetRealmView();
		end
		--frmGuildWardenMain:Show();
		--frmGuildWardenMainLabel:Show();
	end

	if (tabIndex == 7) then
		ButtonFrameTemplate_HideButtonBar(GuildFrame);
		GuildFrame_ShowPanel("frmGuildWardenLeft");
		GuildFrameInset:SetPoint("TOPLEFT", 7, -85);
		GuildFrameInset:SetPoint("BOTTOMRIGHT", -7, 24);
		frmGuildWardenLeft:SetPoint("TOPLEFT", 7, -85);
		frmGuildWardenLeft:SetPoint("BOTTOMRIGHT", -7, 24);
		GuildFrameBottomInset:Hide();
		GuildXPFrame:Hide();
		GuildFactionFrame:Hide();
		GuildAddMemberButton:Hide();
		GuildControlButton:Hide();
		GuildViewLogButton:Hide();
		GuildFrameMembersCountLabel:Hide();
		GuildFrameMembersCount:Hide();
		if (libGuildWarden.Loaded >= 1) then
			libGuildWarden.SetLeftView();
		end
		--frmGuildWardenMain:Show();
		--frmGuildWardenMainLabel:Show();
	end

	if (tabIndex == 8) then
		ButtonFrameTemplate_HideButtonBar(GuildFrame);
		GuildFrame_ShowPanel("frmGuildWardenJoined");
		GuildFrameInset:SetPoint("TOPLEFT", 7, -85);
		GuildFrameInset:SetPoint("BOTTOMRIGHT", -7, 24);
		frmGuildWardenJoined:SetPoint("TOPLEFT", 7, -85);
		frmGuildWardenJoined:SetPoint("BOTTOMRIGHT", -7, 24);
		GuildFrameBottomInset:Hide();
		GuildXPFrame:Hide();
		GuildFactionFrame:Hide();
		GuildAddMemberButton:Hide();
		GuildControlButton:Hide();
		GuildViewLogButton:Hide();
		GuildFrameMembersCountLabel:Hide();
		GuildFrameMembersCount:Hide();
		if (libGuildWarden.Loaded >= 1) then
			libGuildWarden.SetJoinedView();
		end
		--frmGuildWardenMain:Show();
		--frmGuildWardenMainLabel:Show();
	end

	if (tabIndex == 9) then
		ButtonFrameTemplate_HideButtonBar(GuildFrame);
		GuildFrame_ShowPanel("frmGuildWardenBanned");
		GuildFrameInset:SetPoint("TOPLEFT", 7, -85);
		GuildFrameInset:SetPoint("BOTTOMRIGHT", -7, 24);
		frmGuildWardenBanned:SetPoint("TOPLEFT", 7, -85);
		frmGuildWardenBanned:SetPoint("BOTTOMRIGHT", -7, 24);
		GuildFrameBottomInset:Hide();
		GuildXPFrame:Hide();
		GuildFactionFrame:Hide();
		GuildAddMemberButton:Hide();
		GuildControlButton:Hide();
		GuildViewLogButton:Hide();
		GuildFrameMembersCountLabel:Hide();
		GuildFrameMembersCount:Hide();
		if (libGuildWarden.Loaded >= 1) then
			libGuildWarden.SetBannedView();
		end
		--frmGuildWardenMain:Show();
		--frmGuildWardenMainLabel:Show();
	end
	frmGuildWardenAlts:Hide();
end

function libGuildWarden.GetGuildInfo()
	 if (IsInGuild() ~= nil) then
		local guildName, guildRankName, guildRankIndex =	GetGuildInfo("player");
		if (guildName ~= nil) then
			return	GetGuildInfo("player");
		else
			return "No Guild", "None", 0;
		end
	 else
		return "No Guild", "None", 0;
	 end
end

function libGuildWarden.GetNumGuildMembers()
	 if (IsInGuild() ~= nil) then
		if (GetNumGuildMembers(true) ~= 0) then
			return	GetNumGuildMembers(true);
		else
			return -1;
		end
	 else
		return 0;
	 end
end

function libGuildWarden.GetClassFileName(Class)
	if (Class) then
		Class = strupper(Class);
		Class = strreplace(Class, " ", "");
 	end
	return Class;
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

function libGuildWarden.UpperFirstChar(SringtoUp)
	subString = strsub(SringtoUp, 1, 1);
	NsubString = strsub(SringtoUp, 2, strlen(SringtoUp));
	if (subString == strlower(subString)) then
		return strupper(subString) .. strlower(NsubString);
	end
	return SringtoUp;
end

function libGuildWarden.MakePlayerInfo(Name)
	if (Name) then
		Name = libGuildWarden.UpperFirstChar(Name);
		if (not libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name]) then
			libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name] = {};
			libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name].Name = Name;
			libGuildWarden.SendText("Player created: " .. Name);
		end
	end
end

function libGuildWarden.SetPlayerInfo(Name, What, Toset)
	if (Toset and Toset ~= "??" and Toset ~= "???"and Toset ~= "????") then
		if (not libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name]) then
			libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name] = {};
			libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name].Name = Name;
		end
		libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name][What] = Toset;
	end
end

function libGuildWarden.SortByColumn(column)
	if (libGuildWarden.TempListMain["Left"].sort == column.sortType) then
		if (libGuildWarden.TempListMain["Left"].dir == "+") then
			libGuildWarden.TempListMain["Left"].dir = "-";
		else
			libGuildWarden.TempListMain["Left"].dir = "+";
		end
	else
		libGuildWarden.TempListMain["Left"].sort = column.sortType;
	end
	PlaySound("igMainMenuOptionCheckBoxOn");
	GuildLeft_Update();
end

function libGuildWarden.SortJoinedByColumn(column)
	if (libGuildWarden.TempListMain["Joined"].sort == column.sortType) then
		if (libGuildWarden.TempListMain["Joined"].dir == "+") then
			libGuildWarden.TempListMain["Joined"].dir = "-";
		else
			libGuildWarden.TempListMain["Joined"].dir = "+";
		end
	else
		libGuildWarden.TempListMain["Joined"].sort = column.sortType;
	end
	PlaySound("igMainMenuOptionCheckBoxOn");
	GuildJoined_Update();
end

function libGuildWarden.SortRealmByColumn(column)
	if (libGuildWarden.TempListMain["Realm"].sort == column.sortType) then
		if (libGuildWarden.TempListMain["Realm"].dir == "+") then
			libGuildWarden.TempListMain["Realm"].dir = "-";
		else
			libGuildWarden.TempListMain["Realm"].dir = "+";
		end
	else
		libGuildWarden.TempListMain["Realm"].sort = column.sortType;
	end
	PlaySound("igMainMenuOptionCheckBoxOn");
	GuildRealm_Update();
end

function libGuildWarden.SortBannedByColumn(column)
	if (libGuildWarden.TempListMain["Banned"].sort == column.sortType) then
		if (libGuildWarden.TempListMain["Banned"].dir == "+") then
			libGuildWarden.TempListMain["Banned"].dir = "-";
		else
			libGuildWarden.TempListMain["Banned"].dir = "+";
		end
	else
		libGuildWarden.TempListMain["Banned"].sort = column.sortType;
	end
	PlaySound("igMainMenuOptionCheckBoxOn");
	GuildBanned_Update();
end

function libGuildWarden.SortAltsByColumn(column)
	if (libGuildWarden.TempListMain["Alts"].sort == column.sortType) then
		if (libGuildWarden.TempListMain["Alts"].dir == "+") then
			libGuildWarden.TempListMain["Alts"].dir = "-";
		else
			libGuildWarden.TempListMain["Alts"].dir = "+";
		end
	else
		libGuildWarden.TempListMain["Alts"].sort = column.sortType;
	end
	PlaySound("igMainMenuOptionCheckBoxOn");
	GuildAlts_Update();
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

function libGuildWarden.SortLeftList()
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	local LeftList = libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName];
	local CountList= {};		
	local Counter = 0;

	for key, value in pairs(LeftList) do
		if (not GuildLeftShowGuiliesButton:GetChecked() or libGuildWardenSaveVar["Roster"][libGuildWarden.Realm][guildName][key]) then
			Counter = Counter	+ 1;
			CountList[Counter] = {};
			CountList[Counter] = libGuildWarden.CloneSimpleTable(libGuildWarden.GetPlayerInfo(key));
			CountList[Counter].LVL = tonumber(CountList[Counter].LVL);
			if (not CountList[Counter].LVL) then
				CountList[Counter].LVL = 0;
			end

			if (not value.Dateleft) then
				value.Dateleft = "00/00/00";
			end

			local SplitA = {strsplit(" ",value.Dateleft)};
			local SplitB = {strsplit("/",SplitA[1])}
			CountList[Counter].Dateleft = SplitA[1];
			CountList[Counter].DLY = SplitB[3];
			CountList[Counter].DLD = SplitB[2];
			CountList[Counter].DLM = SplitB[1];
		end
	end

	-- "LVL"
	--"Cls"
	--"Name"
	--"Dateleft";
	--libGuildWardenSaveVar["Left"].dir
	--libGuildWardenSaveVar["Left"].sort
	libGuildWarden.TempListMain["Left"]["CountList"] = CountList;
	libGuildWarden.TempListMain["Left"].Max = Counter;
end

function libGuildWarden.SortJoinedList()
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	local LeftList = libGuildWardenSaveVar["Joined"][libGuildWarden.Realm][guildName];
	local CountList= {};		
	local Counter = 0;

	for key, value in pairs(LeftList) do
		if (not GuildJoinedShowGuiliesButton:GetChecked() or libGuildWardenSaveVar["Roster"][libGuildWarden.Realm][guildName][key]) then
			Counter = Counter	+ 1;
			CountList[Counter] = {};
			CountList[Counter] = libGuildWarden.CloneSimpleTable(libGuildWarden.GetPlayerInfo(key));
			CountList[Counter].LVL = tonumber(CountList[Counter].LVL);
			if (not CountList[Counter].LVL) then
				CountList[Counter].LVL = 0;
			end

			if (not value.Datejoined) then
				value.Datejoined = "00/00/00";
			end

			local SplitA = {strsplit(" ",value.Datejoined)};
			local SplitB = {strsplit("/",SplitA[1])}
			CountList[Counter].Datejoined = SplitA[1];
			CountList[Counter].DJY = SplitB[3];
			CountList[Counter].DJD = SplitB[2];
			CountList[Counter].DJM = SplitB[1];
		end
	end

	-- "LVL"
	--"Cls"
	--"Name"
	--"Dateleft";
	--libGuildWardenSaveVar["Left"].dir
	--libGuildWardenSaveVar["Left"].sort
	libGuildWarden.TempListMain["Joined"]["CountList"] = CountList;
	libGuildWarden.TempListMain["Joined"].Max = Counter;
end

function GuildJoined_Update()
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	local scrollFrame = GuildJoinedContainer;
	local offset = HybridScrollFrame_GetOffset(scrollFrame);
	local index;
	local classFileName;
	local buttons = scrollFrame.buttons;
	local numButtons = #buttons;
	local CountList = libGuildWarden.TempListMain["Joined"]["CountList"];
	local Counter = libGuildWarden.TempListMain["Joined"].Max;

	if (libGuildWarden.TempListMain["Joined"].sort == "Datejoined") then
		if (libGuildWarden.TempListMain["Joined"].dir == "+") then
			sort(CountList, function(a,b)
				if (a.DJY ~= b.DJY) then
					return a.DJY < b.DJY;
				else
					if (a.DJM ~= b.DJM) then
						return a.DJM < b.DJM;
					else
						return a.DJD < b.DJD;
					end
				end

			end)
		end

		if (libGuildWarden.TempListMain["Joined"].dir == "-") then
			sort(CountList, function(a,b)
				if (a.DJY ~= b.DJY) then
					return a.DJY > b.DJY;
				else
					if (a.DJM ~= b.DJM) then
						return a.DJM > b.DJM;
					else
						return a.DJD > b.DJD;
					end
				end
			end)
		end
	else
		if (libGuildWarden.TempListMain["Joined"].dir == "+") then
			sort(CountList, function(a,b) return a[libGuildWarden.TempListMain["Joined"].sort] < b[libGuildWarden.TempListMain["Joined"].sort] end)
		end

		if (libGuildWarden.TempListMain["Joined"].dir == "-") then
			sort(CountList, function(a,b) return a[libGuildWarden.TempListMain["Joined"].sort] > b[libGuildWarden.TempListMain["Joined"].sort] end)
		end
	end

 	for i = 1, numButtons do
		button = buttons[i];
		index = offset + i
		if (CountList[tonumber(index)]) then
			local Playerinfo = CountList[tonumber(index)];
			if (Playerinfo) then
				classFileName = libGuildWarden.GetClassFileName(Playerinfo.Class);
				if (classFileName) then
					if (classFileName == "РЫЦАРЬ") then
						classFileName = "РЫЦАРЬСМЕРТИ";
						Playerinfo.Class = "Рыцарь смерти";
					end

					if (CLASS_ICON_TCOORDS[classFileName]) then
						button.icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classFileName]))
						button.icon:Show();
					else
						button.icon:Hide();
					end
				else
					button.icon:Hide();
				end

				if (libGuildWardenSaveVar["Roster"][libGuildWarden.Realm][guildName][Playerinfo.Name]) then
					if (Playerinfo.Datejoined == date("%m/%d/%y")) then
						libGuildWarden.SetStringTextColor(button.string3, Playerinfo.Datejoined, 0, 1, 0);
						libGuildWarden.SetStringTextColor(button.string1, Playerinfo.LVL, 0, 1, 0);
					else
						libGuildWarden.SetStringText(button.string3, Playerinfo.Datejoined, true);
						libGuildWarden.SetStringText(button.string1, Playerinfo.LVL, true);
					end
				else
					if (libGuildWarden.GetPlayerInfo(Playerinfo.Name)) then
						if (libGuildWarden.GetPlayerInfo(Playerinfo.Name).Guild == guildName) then
							libGuildWarden.SetPlayerInfo(Playerinfo.Name, "Guild", "No Guild");
						end
					end
					libGuildWarden.SetStringText(button.string3, Playerinfo.Datejoined);
					libGuildWarden.SetStringText(button.string1, Playerinfo.LVL);
				end

				libGuildWarden.SetStringText(button.string2, Playerinfo.Name, true, classFileName);

				button.index = index;
				button:Show();
			end
		else
			button:Hide();
		end
	end

	local totalHeight = Counter * (20 + 2);
	local displayedHeight = numButtons * (20 + 2);
	HybridScrollFrame_Update(scrollFrame, totalHeight, displayedHeight);
end

function libGuildWarden.SortBannedList()
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	local LeftList = libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName];
	local CountList= {};		
	local Counter = 0;

	for key, value in pairs(LeftList) do
		if (not GuildBannedShowGuiliesButton:GetChecked() or libGuildWardenSaveVar["Roster"][libGuildWarden.Realm][guildName][key]) then
			if (value.Datebanned == "00/00/00") then
				value.Datebanned = nil;
			end
			if (value.Datebanned) then
				Counter = Counter	+ 1;
				CountList[Counter] = {};
				CountList[Counter] = libGuildWarden.CloneSimpleTable(libGuildWarden.GetPlayerInfo(key));
				CountList[Counter].LVL = tonumber(CountList[Counter].LVL);
				if (not CountList[Counter].LVL) then
					CountList[Counter].LVL = 0;
				end

				local SplitA = {strsplit(" ",value.Datebanned)};
				local SplitB = {strsplit("/",SplitA[1])}
				CountList[Counter].Datebanned = SplitA[1];
				CountList[Counter].DBY = SplitB[3];
				CountList[Counter].DBD = SplitB[2];
				CountList[Counter].DBM = SplitB[1];

				libGuildWarden.BanPlayer(CountList[Counter].Name, CountList[Counter].BannedReason);
			end
		end
	end

	-- "LVL"
	--"Cls"
	--"Name"
	--"Dateleft";
	--libGuildWardenSaveVar["Left"].dir
	--libGuildWardenSaveVar["Left"].sort

	libGuildWarden.TempListMain["Banned"]["CountList"] = CountList;
	libGuildWarden.TempListMain["Banned"].Max = Counter;
end

function GuildBanned_Update()
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	local scrollFrame = GuildBannedContainer;
	local offset = HybridScrollFrame_GetOffset(scrollFrame);
	local index;
	local classFileName;
	local buttons = scrollFrame.buttons;
	local numButtons = #buttons;
	local CountList = libGuildWarden.TempListMain["Banned"]["CountList"];
	local Counter = libGuildWarden.TempListMain["Banned"].Max;

	if (libGuildWarden.TempListMain["Banned"].sort == "Datebanned") then
		if (libGuildWarden.TempListMain["Banned"].dir == "+") then
			sort(CountList, function(a,b)
				if (a.DBY ~= b.DBY) then
					return a.DBY < b.DBY;
				else
					if (a.DBM ~= b.DBM) then
						return a.DBM < b.DBM;
					else
						return a.DBD < b.DBD;
					end
				end

			end)
		end

		if (libGuildWarden.TempListMain["Banned"].dir == "-") then
			sort(CountList, function(a,b)
				if (a.DBY ~= b.DBY) then
					return a.DBY > b.DBY;
				else
					if (a.DBM ~= b.DBM) then
						return a.DBM > b.DBM;
					else
						return a.DBD > b.DBD;
					end
				end

			end)
		end
	else
		if (libGuildWarden.TempListMain["Banned"].dir == "+") then
			sort(CountList, function(a,b) return a[libGuildWarden.TempListMain["Banned"].sort] < b[libGuildWarden.TempListMain["Banned"].sort] end)
		end

		if (libGuildWarden.TempListMain["Banned"].dir == "-") then
			sort(CountList, function(a,b) return a[libGuildWarden.TempListMain["Banned"].sort] > b[libGuildWarden.TempListMain["Banned"].sort] end)
		end
	end

 	for i = 1, numButtons do
		button = buttons[i];
		index = offset + i
		if (CountList[tonumber(index)]) then
			local Playerinfo = CountList[tonumber(index)];
			if (Playerinfo) then
				classFileName = libGuildWarden.GetClassFileName(Playerinfo.Class);
				if (classFileName) then
					if (classFileName == "РЫЦАРЬ") then
						classFileName = "РЫЦАРЬСМЕРТИ";
						Playerinfo.Class = "Рыцарь смерти";
					end

					if (CLASS_ICON_TCOORDS[classFileName]) then
						button.icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classFileName]))
						button.icon:Show();
					else
						button.icon:Hide();
					end
				else
					button.icon:Hide();
				end

				if (libGuildWardenSaveVar["Roster"][libGuildWarden.Realm][guildName][Playerinfo.Name]) then
					if (Playerinfo.Datebanned == date("%m/%d/%y")) then
						libGuildWarden.SetStringTextColor(button.string3, Playerinfo.Datebanned, 0, 1, 0);
						libGuildWarden.SetStringTextColor(button.string1, Playerinfo.LVL, 0, 1, 0);
					else
						libGuildWarden.SetStringText(button.string3, Playerinfo.Datebanned, true);
						libGuildWarden.SetStringText(button.string1, Playerinfo.LVL, true);
					end
				else
					if (libGuildWarden.GetPlayerInfo(Playerinfo.Name)) then
						if (libGuildWarden.GetPlayerInfo(Playerinfo.Name).Guild == guildName) then
							libGuildWarden.SetPlayerInfo(Playerinfo.Name, "Guild", "No Guild");
						end
					end
					libGuildWarden.SetStringText(button.string3, Playerinfo.Datebanned);
					libGuildWarden.SetStringText(button.string1, Playerinfo.LVL);
				end

				libGuildWarden.SetStringText(button.string2, Playerinfo.Name, true, classFileName);

				button.index = index;
				button:Show();
			end
		else
			button:Hide();
		end
	end
	local totalHeight = Counter * (20 + 2);
	local displayedHeight = numButtons * (20 + 2);
	HybridScrollFrame_Update(scrollFrame, totalHeight, displayedHeight);
end


function GuildLeft_Update()
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	local scrollFrame = GuildLeftContainer;
	local offset = HybridScrollFrame_GetOffset(scrollFrame);
	local index;
	local classFileName;
	local buttons = scrollFrame.buttons;
	local numButtons = #buttons;
	local CountList = libGuildWarden.TempListMain["Left"]["CountList"];
	local Counter = libGuildWarden.TempListMain["Left"].Max;

	if (libGuildWarden.TempListMain["Left"].sort == "Dateleft") then
		if (libGuildWarden.TempListMain["Left"].dir == "+") then
			sort(CountList, function(a,b)
				if (a.DLY ~= b.DLY) then
					return a.DLY < b.DLY;
				else
					if (a.DLM ~= b.DLM) then
						return a.DLM < b.DLM;
					else
						return a.DLD < b.DLD;
					end
				end

			end)
		end

		if (libGuildWarden.TempListMain["Left"].dir == "-") then
			sort(CountList, function(a,b)
				if (a.DLY ~= b.DLY) then
					return a.DLY > b.DLY;
				else
					if (a.DLM ~= b.DLM) then
						return a.DLM > b.DLM;
					else
						return a.DLD > b.DLD;
					end
				end

			end)
		end
	else
		if (libGuildWarden.TempListMain["Left"].dir == "+") then
			sort(CountList, function(a,b) return a[libGuildWarden.TempListMain["Left"].sort] < b[libGuildWarden.TempListMain["Left"].sort] end)
		end

		if (libGuildWarden.TempListMain["Left"].dir == "-") then
			sort(CountList, function(a,b) return a[libGuildWarden.TempListMain["Left"].sort] > b[libGuildWarden.TempListMain["Left"].sort] end)
		end
	end

 	for i = 1, numButtons do
		button = buttons[i];
		index = offset + i
		if (CountList[tonumber(index)]) then
			local Playerinfo = CountList[tonumber(index)];
			if (Playerinfo) then
				classFileName = libGuildWarden.GetClassFileName(Playerinfo.Class);
				if (classFileName) then
					if (classFileName == "РЫЦАРЬ") then
						classFileName = "РЫЦАРЬСМЕРТИ";
						Playerinfo.Class = "Рыцарь смерти";
					end

					if (CLASS_ICON_TCOORDS[classFileName]) then
						button.icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classFileName]))
						button.icon:Show();
					else
						button.icon:Hide();
					end
				else
					button.icon:Hide();
				end

				if (Playerinfo.Dateleft == date("%m/%d/%y")) then
					libGuildWarden.SetStringTextColor(button.string3, Playerinfo.Dateleft, 1,0,0);
					libGuildWarden.SetStringTextColor(button.string1, Playerinfo.LVL, 1,0,0);
				else
					if (libGuildWardenSaveVar["Roster"][libGuildWarden.Realm][guildName][Playerinfo.Name]) then
						libGuildWarden.SetStringText(button.string3, Playerinfo.Dateleft, true);
						libGuildWarden.SetStringText(button.string1, Playerinfo.LVL, true);
					else
						if (libGuildWarden.GetPlayerInfo(Playerinfo.Name)) then
							if (libGuildWarden.GetPlayerInfo(Playerinfo.Name).Guild == guildName) then
								libGuildWarden.SetPlayerInfo(Playerinfo.Name, "Guild", "No Guild");
							end
						end
						libGuildWarden.SetStringText(button.string3, Playerinfo.Dateleft);
						libGuildWarden.SetStringText(button.string1, Playerinfo.LVL);
					end
				end

				libGuildWarden.SetStringText(button.string2, Playerinfo.Name, true, classFileName);
				button.index = index;
				button:Show();
			end
		else
			button:Hide();
		end
	end
	local totalHeight = Counter * (20 + 2);
	local displayedHeight = numButtons * (20 + 2);
	HybridScrollFrame_Update(scrollFrame, totalHeight, displayedHeight);
end

function libGuildWarden.GetAlts(Name)
	local ThisTable = {};
	if (Name) then
		local MainID = libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name].ID;
		local MainTMPID = libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name].TMPID;
		local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
		if (MainID == "??") then
			MainID = nil;
		end

		if (MainTMPID == "??") then
			MainTMPID = nil;
		end

		ThisTable[Name] = true;
		for key, value in pairs(libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm]) do
			if (key ~= Name) then
				if (MainID) then
					if (value.ID) then
						if (MainID == value.ID) then
							ThisTable[key] = true;
						end
					end
				end

				if (MainTMPID) then
					if (value.TMPID) then
						if (MainTMPID == value.TMPID) then
							ThisTable[key] = true;
						end
					end
				end

			end
		end
	end
	return ThisTable;
end

function GuildRealmButton_OnClick(self, button)
	local AltsName = libGuildWarden.TempListMain["Realm"]["CountList"][self.index].Name;
	if (AltsName) then
		libGuildWarden.SetAlts(AltsName);
	end
end

function GuildLeftButton_OnClick(self, button)
	local AltsName = libGuildWarden.TempListMain["Left"]["CountList"][self.index].Name;
	if (AltsName) then
		libGuildWarden.SetAlts(AltsName);
	end
end

function GuildJoinedButton_OnClick(self, button)
	local AltsName = libGuildWarden.TempListMain["Joined"]["CountList"][self.index].Name;
	if (AltsName) then
		libGuildWarden.SetAlts(AltsName);
	end
end

function GuildBannedButton_OnClick(self, button)
	local AltsName = libGuildWarden.TempListMain["Banned"]["CountList"][self.index].Name;
	if (AltsName) then
		libGuildWarden.SetAlts(AltsName);
	end
end

function libGuildWarden.SetAlts(Name)
	libGuildWarden.SelectedName = Name;
	libGuildWarden.SortAltsList();
	GuildAlts_Update();
	frmGuildWardenAlts:Show();
end

function libGuildWarden.SortAltsList()
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	local LeftList = libGuildWarden.GetAlts(libGuildWarden.SelectedName);
	local CountList= {};		
	local Counter = 0;
	GuildWardenBannedBtn1:SetText("Ban All");
	if (libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][libGuildWarden.SelectedName]) then
		if (libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][libGuildWarden.SelectedName].Datebanned) then
			GuildWardenBannedBtn1:SetText("Remove Ban");
		end
	end

	for key, value in pairs(LeftList) do
		if (not GuildAltsShowGuiliesButton:GetChecked() or libGuildWardenSaveVar["Roster"][libGuildWarden.Realm][guildName][key]) then
			Counter = Counter	+ 1;
			CountList[Counter] = {};
			CountList[Counter] = libGuildWarden.CloneSimpleTable(libGuildWarden.GetPlayerInfo(key));
			CountList[Counter].LVL = tonumber(CountList[Counter].LVL);
			if (not CountList[Counter].LVL) then
				CountList[Counter].LVL = 0;
			end

			if (not CountList[Counter].Guild) then
				CountList[Counter].Guild = "No Guild";
			end
		end
	end

	-- "LVL"
	--"Cls"
	--"Name"
	--"Dateleft";
	--libGuildWardenSaveVar["Left"].dir
	--libGuildWardenSaveVar["Left"].sort

	libGuildWarden.TempListMain["Alts"]["CountList"] = CountList;
	libGuildWarden.TempListMain["Alts"].Max = Counter;
end

function GuildAlts_Update()
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	local scrollFrame = GuildAltsContainer;
	local offset = HybridScrollFrame_GetOffset(scrollFrame);
	local index;
	local classFileName;
	local buttons = scrollFrame.buttons;
	local numButtons = #buttons;
	local CountList = libGuildWarden.TempListMain["Alts"]["CountList"];
	local Counter = libGuildWarden.TempListMain["Alts"].Max;
	if (libGuildWarden.TempListMain["Alts"].dir == "+") then
		sort(CountList, function(a,b) return a[libGuildWarden.TempListMain["Alts"].sort] < b[libGuildWarden.TempListMain["Alts"].sort] end)
	end

	if (libGuildWarden.TempListMain["Alts"].dir == "-") then
		sort(CountList, function(a,b) return a[libGuildWarden.TempListMain["Alts"].sort] > b[libGuildWarden.TempListMain["Alts"].sort] end)
	end

 	for i = 1, numButtons do
		button = buttons[i];
		index = offset + i
		if (CountList[tonumber(index)]) then
			local Playerinfo = CountList[tonumber(index)];
			if (Playerinfo) then
				classFileName = libGuildWarden.GetClassFileName(Playerinfo.Class);
				if (classFileName) then
					if (classFileName == "РЫЦАРЬ") then
						classFileName = "РЫЦАРЬСМЕРТИ";
						Playerinfo.Class = "Рыцарь смерти";
					end

					if (CLASS_ICON_TCOORDS[classFileName]) then
						button.icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classFileName]))
						button.icon:Show();
					else
						button.icon:Hide();
					end
				else
					button.icon:Hide();
				end

				if (libGuildWardenSaveVar["Roster"][libGuildWarden.Realm][guildName][Playerinfo.Name]) then
					libGuildWarden.SetStringText(button.string3, Playerinfo.Guild, true);
					libGuildWarden.SetStringText(button.string1, Playerinfo.LVL, true);
				else
					libGuildWarden.SetStringText(button.string3, Playerinfo.Guild);
					libGuildWarden.SetStringText(button.string1, Playerinfo.LVL);
				end

				libGuildWarden.SetStringText(button.string2, Playerinfo.Name, true, classFileName);

				button.index = index;
				button:Show();
			end
		else
			button:Hide();
		end
	end

	local totalHeight = Counter * (20 + 2);
	local displayedHeight = numButtons * (20 + 2);
	HybridScrollFrame_Update(scrollFrame, totalHeight, displayedHeight);
end

function libGuildWarden.AddThisPlayer()
	local MyName = UnitName("player");
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();

	libGuildWarden.SetPlayerInfo(MyName, "Guild", guildName);
	libGuildWarden.SetPlayerInfo(MyName, "Race", UnitRace("player"));
	libGuildWarden.SetPlayerInfo(MyName, "LVL", UnitLevel("player"));
	libGuildWarden.SetPlayerInfo(MyName, "Class", UnitClass("player"));
	libGuildWarden.SetPlayerInfo(MyName, "ID", libGuildWardenSaveVar["MainMyID"]);
	libGuildWarden.SetPlayerInfo(MyName, "Updated", date("%m/%d/%y %H:%M:%S"));
	libGuildWarden.SetPlayerInfo(MyName, "Faction", UnitFactionGroup("player"));
end

function GuildWarden_OnUpdate(self, elapsed)
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	local guildCount = libGuildWarden.GetNumGuildMembers();
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

		libGuildWarden.ConvertAll();
		if (not libGuildWardenSaveVar["MainMyID"]) then
			libGuildWardenSaveVar["MainMyID"] =	libGuildWarden.Realm .. UnitName("player");
		end

		libGuildWarden.GetStatus();
	 	libGuildWarden.Loaded = 1;
		libGuildWarden.AddThisPlayer();
		libGuildWarden.SendMyPing();
	 	libGuildWarden.SendText("Running");
	end

	if (GuildFrame and libGuildWarden.Loaded == 1 and (guildName ~=nil) and (guildCount ~= -1)) then
	 	PanelTemplates_SetNumTabs(GuildFrame, 10);
	 	GuildFrameTab6:SetParent(GuildFrame);
	 	frmGuildWardenMain:SetParent(GuildFrame);
	 	GuildFrameTab6:SetPoint("TOPLEFT", GuildFrameTab1, "BOTTOMRIGHT", -45, 15);
	 	GuildFrameTab6:Show();
	 	GuildFrame_RegisterPanel(frmGuildWardenMain);

		CreateFrame("button", "GuildWardenShowBtn1", frmGuildWardenMain, "UIPanelButtonTemplate")
			GuildWardenShowBtn1:SetPoint("BOTTOMRIGHT", frmGuildWardenMain, "BOTTOMRIGHT", 0, -20);
			GuildWardenShowBtn1:SetHeight(22);
			GuildWardenShowBtn1:SetWidth(100);
			GuildWardenShowBtn1:SetText("Realm");
			GuildWardenShowBtn1:SetScript("OnClick", function(self, button)
				frmGuildWardenSharing:Hide();
			 	frmGuildWardenRealm:Show();
			end);

		CreateFrame("button", "GuildWardenShowBtn2", frmGuildWardenMain, "UIPanelButtonTemplate")
			GuildWardenShowBtn2:SetPoint("TOPRIGHT", GuildWardenShowBtn1, "BOTTOMRIGHT", 0, 0);
			GuildWardenShowBtn2:SetHeight(22);
			GuildWardenShowBtn2:SetWidth(100);
			GuildWardenShowBtn2:SetText("Sharing");
			GuildWardenShowBtn2:SetScript("OnClick", function(self, button)
				frmGuildWardenRealm:Hide();
			 	frmGuildWardenSharing:Show();
			end);

	 	GuildFrameTab7:SetParent(GuildFrame);
	 	frmGuildWardenLeft:SetParent(GuildFrame);
	 	GuildFrameTab7:SetPoint("LEFT", GuildFrameTab6, "RIGHT", -15, 0);
	 	GuildFrameTab7:Show();
	 	GuildFrame_RegisterPanel(frmGuildWardenLeft);
	 	GuildLeftContainer.update = GuildLeft_Update;
		HybridScrollFrame_CreateButtons(GuildLeftContainer, "GuildLeftButtonTemplate", 0, 0, "TOPLEFT", "TOPLEFT", 0, -2, "TOP", "BOTTOM");
		GuildLeftContainerScrollBar.doNotHide = true;

	 	GuildFrameTab8:SetParent(GuildFrame);
	 	frmGuildWardenJoined:SetParent(GuildFrame);
	 	GuildFrameTab8:SetPoint("LEFT", GuildFrameTab7, "RIGHT", -15, 0);
	 	GuildFrameTab8:Show();
	 	GuildFrame_RegisterPanel(frmGuildWardenJoined);
	 	GuildJoinedContainer.update = GuildJoined_Update;
		HybridScrollFrame_CreateButtons(GuildJoinedContainer, "GuildJoinedButtonTemplate", 0, 0, "TOPLEFT", "TOPLEFT", 0, -2, "TOP", "BOTTOM");
		GuildJoinedContainerScrollBar.doNotHide = true;

	 	GuildFrameTab9:SetParent(GuildFrame);
	 	frmGuildWardenBanned:SetParent(GuildFrame);
	 	GuildFrameTab9:SetPoint("LEFT", GuildFrameTab8, "RIGHT", -15, 0);
	 	GuildFrameTab9:Show();
	 	GuildFrame_RegisterPanel(frmGuildWardenBanned);
	 	GuildBannedContainer.update = GuildBanned_Update;
		HybridScrollFrame_CreateButtons(GuildBannedContainer, "GuildBannedButtonTemplate", 0, 0, "TOPLEFT", "TOPLEFT", 0, -2, "TOP", "BOTTOM");
		GuildBannedContainerScrollBar.doNotHide = true;

		frmGuildWardenAlts:SetParent(GuildFrame);
		frmGuildWardenAlts:SetPoint("BOTTOMLEFT", GuildFrame, "BOTTOMRIGHT", 0, -15);
		GuildAltsContainer.update = GuildAlts_Update;
		HybridScrollFrame_CreateButtons(GuildAltsContainer, "GuildAltsButtonTemplate", 0, 0, "TOPLEFT", "TOPLEFT", 0, -2, "TOP", "BOTTOM");
		GuildAltsContainerScrollBar.doNotHide = true;

		CreateFrame("button", "GuildWardenAddBtn1", frmGuildWardenAlts, "UIPanelButtonTemplate")
			GuildWardenAddBtn1:SetPoint("TOPLEFT", frmGuildWardenAlts, "BOTTOMLEFT", 0, 0);
			GuildWardenAddBtn1:SetHeight(22);
			GuildWardenAddBtn1:SetWidth(100);
			GuildWardenAddBtn1:SetText("Add Alt");
			GuildWardenAddBtn1:SetScript("OnClick", function(self, button)
				StaticPopup_Show ("GuildWarden_AddAlt")
			end);

		CreateFrame("button", "GuildWardenBannedBtn1", frmGuildWardenAlts, "UIPanelButtonTemplate")
			GuildWardenBannedBtn1:SetPoint("TOPLEFT", GuildWardenAddBtn1, "TOPRIGHT", 0, 0);
			GuildWardenBannedBtn1:SetHeight(22);
			GuildWardenBannedBtn1:SetWidth(100);
			GuildWardenBannedBtn1:SetText("Ban All");
			GuildWardenBannedBtn1:SetScript("OnClick", function(self, button)
				if (GuildWardenBannedBtn1:GetText() == "Ban All") then
					StaticPopup_Show ("GuildWarden_AddBanned")
				else
					libGuildWarden.RemoveBanPlayer(libGuildWarden.SelectedName);
				end
			end);

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
						libGuildWarden.MakePlayerInfo(TextBoxGWRealm1:GetText());
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


		libGuildWarden.LoadAllTaps();
	 	GuildFrame_TabClicked(GuildFrameTab2)
	 	GuildFrame_TabClicked(GuildFrameTab1)
	 	libGuildWarden.Loaded = 2;	
	 	libGuildWarden.SendText("Nice Guild");
	end

	if (libGuildWarden.Loaded == 2) then
		if (GuildMemberDetailFrame) then
			if (GuildMemberDetailFrame:IsShown()) then
				local name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName, achievementPoints, achievementRank, isMobile = GetGuildRosterInfo(GuildFrame.selectedGuildMember);
				libGuildWarden.SetAlts(name);
			else
				if (not frmGuildWardenMain:IsVisible() and not frmGuildWardenBanned:IsVisible() and not frmGuildWardenLeft:IsVisible() and not frmGuildWardenJoined:IsVisible()) then
					frmGuildWardenAlts:Hide();
				end
			end
	 	else
			if (not frmGuildWardenMain:IsVisible() and not frmGuildWardenBanned:IsVisible() and not frmGuildWardenLeft:IsVisible() and not frmGuildWardenJoined:IsVisible()) then
				frmGuildWardenAlts:Hide();
			end
		end

		if (not frmGuildWardenMain:IsVisible()) then
			frmGuildWardenRealm:Hide();
			frmGuildWardenSharing:Hide();
		end

		if (frmGuildWardenRealm:IsVisible()) then
			frmGuildWardenAlts:SetPoint("BOTTOMLEFT", frmGuildWardenRealm, "BOTTOMRIGHT", 0, -15);
		else
			if (frmGuildWardenSharing:IsVisible()) then
				frmGuildWardenAlts:SetPoint("BOTTOMLEFT", frmGuildWardenSharing, "BOTTOMRIGHT", 0, -15);
			else
				frmGuildWardenAlts:SetPoint("BOTTOMLEFT", GuildFrame, "BOTTOMRIGHT", 0, -15);
			end
		end
	end
end

function libGuildWarden.HyperlinkClicked(self, linkData, link, button)
	local SplitA = {strsplit(":",linkData)}
	if (SplitA[1] == "player") then
		if (frmGuildWardenRealm:IsVisible()) then
			if (TextBoxGWRealm1) then
				TextBoxGWRealm1:SetText(SplitA[2]);
			end
		end

		if (StaticPopup1) then
			if (StaticPopup1:IsVisible()) then
				if (StaticPopup1EditBox) then
					if (StaticPopup1EditBox:IsVisible()) then
						StaticPopup1EditBox:SetText(SplitA[2]);
					end
				end
			end
		end
	end
end

function GuildWarden_SendTimerOnUpdate(self, elapsed)
	if (libGuildWarden.TempListMain["Sender"]) then
		local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
		local RealmName = libGuildWarden.Realm;
		if (libGuildWarden.TempListMain["Sender"].Send == true) then
			local Max = 0;
			local CountList = libGuildWarden.TempListMain["Sender"]["CountList"];
			if (CountList) then
				Max = #CountList;
			end

			if (libGuildWarden.TempListMain["Sender"].Count < Max) then
				libGuildWarden.TempListMain["Sender"].Time = libGuildWarden.TempListMain["Sender"].Time + elapsed;
				if (libGuildWarden.TempListMain["Sender"].Time > 1) then
					libGuildWarden.TempListMain["Sender"].Time = 0;
					libGuildWarden.TempListMain["Sender"].Limit = 0;
				end

				if (libGuildWarden.TempListMain["Sender"].Limit < 15) then
					libGuildWarden.TempListMain["Sender"].Count = libGuildWarden.TempListMain["Sender"].Count +1;
					--libGuildWarden.TempListMain["Sender"].Limit = libGuildWarden.TempListMain["Sender"].Limit + 1;
					local tmpinfo = CountList[libGuildWarden.TempListMain["Sender"].Count];
					local DataToSend = libGuildWarden.TempListMain["Sender"].ListID .. "," .. libGuildWarden.TempListMain["Sender"].Count .. "," .. Max .. ",";

					for key, value in pairs(tmpinfo) do
						DataToSend = DataToSend .. key .. ":" .. value .. ",";
					end

					if (strlen(DataToSend) < 250) then
						libGuildWarden.SendAddonMessage( "GW-List", DataToSend, "WHISPER", libGuildWarden.TempListMain["Sender"].GoingTo);
					else
						libGuildWarden.SendText("Skip: " .. tmpinfo.Name .. ". Banned Reason To Long");
					end
				end
			end

			if (libGuildWarden.TempListMain["Sender"].Count == Max) then
				libGuildWarden.TempListMain["Sender"].Send = false;
				libGuildWarden.TempListMain["Sender"].SentPing = false;
				libGuildWarden.SendAddonMessage("GW-HelpNo", "Done", "WHISPER", libGuildWarden.TempListMain["Sender"].GoingTo);
			end
		end

		if (libGuildWarden.TempListMain["Sender"].SentPing == true) then
			if (not libGuildWarden.TempListMain["Sender"].Time2) then
				libGuildWarden.TempListMain["Sender"].Time2 = 0;
			end

			libGuildWarden.TempListMain["Sender"].Time2 = libGuildWarden.TempListMain["Sender"].Time2 + elapsed;
			if (libGuildWarden.TempListMain["Sender"].Time2 > 30) then
				libGuildWarden.TempListMain["Sender"].SentPing = false;
				libGuildWarden.TempListMain["Sender"].Time2 = 0;
			end
		end
	end
end

--Thjis will retrun DateA, DateB, or Equal, return wich is sooner
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
	if (SplitA[1] == SplitB[1]) then
		return "Equal";
	end

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
	return "Equal";
end

function libGuildWarden.SendAddonMessage(Id, Text, Type, target)
	if (not libGuildWarden.TempListMain["Sender"].Limit) then
		libGuildWarden.TempListMain["Sender"].Limit = 0;
	end
	libGuildWarden.TempListMain["Sender"].Limit = libGuildWarden.TempListMain["Sender"].Limit + 1;
	SendAddonMessage(Id, Text, Type, target);
end

function GuildWarden_OnEvent(self, event, ...)
	local arg1, arg2,arg3, arg4 = ...;
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	if (event == "CHAT_MSG_ADDON") then
		local preFex = strsub(arg1, 1, 2);
		if (arg4 == UnitName("player") and arg1 ~= "GW-List") then
			-- If player send something from another addon count that as part of the speed limit!!!!
			if (libGuildWarden.TempListMain["Sender"].Send == true) then
				libGuildWarden.TempListMain["Sender"].Limit = libGuildWarden.TempListMain["Sender"].Limit + 1;
			end
		end

		local MyName = UnitName("player");
		if (preFex == "GW" and arg1 ~= "GW-List") then --
			libGuildWarden.SendText(arg1 .. ", " .. arg2 .. ", From: " .. arg4);
		end

		if (arg1 == "GW-Ping" and arg4 ~= MyName) then
			if (not libGuildWarden.TempListMain["WardenUsers"]) then
				libGuildWarden.TempListMain["WardenUsers"] = {};
			end

			libGuildWarden.TempListMain["WardenUsers"][arg4] = arg2;
			libGuildWarden.SendMyPing();

			local SplitGWPing = {strsplit(",",arg2)};
			local MyPingSize = libGuildWarden.GetMyPing();
			local SplitMYPing = {strsplit(",",MyPingSize)};
			for index=1, #SplitGWPing do
				if (tonumber(SplitGWPing[index]) > tonumber(SplitMYPing[index])) then
					--if (index == 4) then
						libGuildWarden.TempListMain["Sender"].INeed = arg4;
						libGuildWarden.SendAddonMessage("GW-Help", index, "WHISPER", arg4);
						break;
					--end
				end
				if (tonumber(SplitGWPing[index]) < tonumber(SplitMYPing[index])) then
					if (index == 4) then
						libGuildWarden.TempListMain["Sender"].INeed = arg4;
						libGuildWarden.SendAddonMessage("GW-Help", index, "WHISPER", arg4);
						break;
					end
				end
			end
		end

		if (arg1 == "GW-List" and arg4 ~= MyName) then
			libGuildWarden.TempListMain["Sender"].INeed = arg4
			local SplitGWList = {strsplit(",",arg2)};
			local Type = tonumber(SplitGWList[1]);
			local Count = SplitGWList[2];
			local Max = SplitGWList[3];
			local TmpListin = {};
			for index=4, #SplitGWList do
				local SplitGWItems = {strsplit(":",SplitGWList[index])};
				if (#SplitGWItems > 1) then
					if (SplitGWItems[2] ~= "" and SplitGWItems[1] ~= "") then
						TmpListin[SplitGWItems[1]] = SplitGWItems[2];
					end
				end
			end

			local TheName = TmpListin.Name;
			if (not TheName) then
				return;
			end

			if (Type == 1) then
				if (not libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName]) then
					libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName] = TmpListin;	
				else
					libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].Name = TheName;
					if (TmpListin.ID) then
						if (TmpListin.ID ~= "??") then
							libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].ID = TmpListin.ID;
						end
					end

					if (TmpListin.TMPID) then
						if (TmpListin.TMPID ~= "??") then
							libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].TMPID = TmpListin.TMPID;
						end
					end
				end
			end

			if (Type == 2) then
				TmpListin.Name = nil;
				if (not libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName][TheName]) then
					libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName][TheName] = TmpListin;
				end
			end

			if (Type == 3) then
				TmpListin.Name = nil;
				if (not libGuildWardenSaveVar["Joined"][libGuildWarden.Realm][guildName][TheName]) then
					libGuildWardenSaveVar["Joined"][libGuildWarden.Realm][guildName][TheName] = TmpListin;
				end
			end

			if (Type == 4) then
				TmpListin.Name = nil;
				if (not libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][TheName]) then
					libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][TheName] = TmpListin;
				else
					local DateA = "00/00/00";
					local DateB = "00/00/00";
					if (TmpListin.Datebanned) then
						DateA = TmpListin.Datebanned;
					end

					if (TmpListin.Dateremoved) then
						DateA = TmpListin.Dateremoved;
					end

					if (libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][TheName].Datebanned) then
						DateB = libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][TheName].Datebanned;
					end

					if (libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][TheName].Dateremoved) then
						DateB = libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][TheName].Datebanned;
					end							

					if (libGuildWarden.CheckDate(DateA, DateB) == DateA) then
						libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][TheName] = TmpListin;
					end
				end
			end
		end

		if (arg1 == "GW-HelpNo" and arg4 ~= MyName) then
			libGuildWarden.TempListMain["Sender"].INeed	= nil;
			if (arg2 == "Done") then
				libGuildWarden.TempListMain["Sender"].SentPing = false;
			end
			libGuildWarden.SendMyPing();
		end

		if (arg1 == "GW-Help" and arg4 ~= MyName) then
			if (libGuildWarden.TempListMain["Sender"].Send == true) then
				libGuildWarden.SendAddonMessage("GW-HelpNo", "Sorry", "WHISPER", arg4);
			else
				local whatheneeds = tonumber(arg2);
				local CountList = {};
				local Counter = 0;

				if (whatheneeds == 1) then
					for key, value in pairs(libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm]) do	
						local Addthis = false;
						if (value.ID) then
							if (value.ID ~= "??") then
								Addthis = true;
							end
						end

						if (value.TMPID) then
							if (value.TMPID ~= "??") then
								Addthis = true;
							end
						end

						if (not key) then
							Addthis = false;
						end

						if (key == "") then
							Addthis = false;
						end

						if (Addthis == true) then
							Counter = Counter	+ 1;
							CountList[Counter] = {};
							CountList[Counter].Name = key;
							CountList[Counter].ID = value.ID;
							CountList[Counter].TMPID = value.TMPID;
						end
					end
				end

				if (whatheneeds == 2) then
					for key, value in pairs(libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName]) do
						local Addthis = true;
						if (not key) then
							Addthis = false;
						end

						if (key == "") then
							Addthis = false;
						end

						if (Addthis == true) then
							Counter = Counter	+ 1;
							CountList[Counter] = {};
							CountList[Counter].Name = key;
							CountList[Counter].Dateleft = value.Dateleft;
						end
					end
				end

				if (whatheneeds == 3) then
					for key, value in pairs(libGuildWardenSaveVar["Joined"][libGuildWarden.Realm][guildName]) do
						local Addthis = true;
						if (not key) then
							Addthis = false;
						end

						if (key == "") then
							Addthis = false;
						end

						if (Addthis == true) then
							Counter = Counter	+ 1;
							CountList[Counter] = {};
							CountList[Counter].Name = key;
							CountList[Counter].Datejoined = value.Datejoined;
						end
					end
				end

				if (whatheneeds == 4) then
					for key, value in pairs(libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName]) do
						local Addthis = true;
						if (not key) then
							Addthis = false;
						end

						if (key == "") then
							Addthis = false;
						end

						if (Addthis == true) then
							Counter = Counter	+ 1;
							CountList[Counter] = {};
							CountList[Counter].Name = key;
							CountList[Counter].Datebanned = value.Datebanned;
							CountList[Counter].BannedReason = value.BannedReason;
							CountList[Counter].BannedBy = value.BannedBy;
							CountList[Counter].Dateremoved = value.Dateremoved;
							CountList[Counter].RemovedBy = value.RemovedBy;
						end
					end
				end
				libGuildWarden.SendData(arg4, CountList, whatheneeds)
			end
		end
		--libGuildWarden.SendAddonMessage
		--libGuildWarden.SendText(arg1 .. ", " .. arg2);
	end

	if (event == "VARIABLES_LOADED" and libGuildWarden.Loaded == -2) then
		libGuildWarden.Loaded = -1;
		libGuildWarden.Realm = GetRealmName();
		for index=1, 10 do
			local ChatFrameMe = _G["ChatFrame" .. index];
			if (ChatFrameMe) then
				ChatFrameMe:HookScript("OnHyperlinkClick", libGuildWarden.HyperlinkClicked) ;
			end
		end

		--[[
		local CountList = {};
		local Counter = 0;
		for key, value in pairs(libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm]) do	
				Counter = Counter	+ 1;
				CountList[Counter] = {};
				CountList[Counter] = libGuildWarden.CloneSimpleTable(libGuildWarden.GetPlayerInfo(key));
		end
		--libGuildWarden.SendData("Mymoney", CountList)
		]]--
		libGuildWarden.Loaded = 0;
		libGuildWarden.SendText("Hello!");
	end
end

function libGuildWarden.GetMyPing()
	local Outtext = "";
	local Counter = 0;
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	for key, value in pairs(libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm]) do	
		local Addthis = false;
		if (value.ID) then
			if (value.ID ~= "??") then
				Addthis = true;
			end
		end

		if (value.TMPID) then
			if (value.TMPID ~= "??") then
				Addthis = true;
			end
		end

		if (not key) then
			Addthis = false;
		end

		if (key == "") then
			Addthis = false;
		end									

		if (Addthis == true) then
			Counter = Counter	+ 1;
		end
	end

	Outtext = Outtext .. Counter .. ",";
	Counter = 0;
	for key, value in pairs(libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName]) do	
		local Addthis = false;
		Addthis	= true;
		if (not key) then
			Addthis = false;
		end

		if (key == "") then
			Addthis = false;
		end

		if (Addthis == true) then
			Counter = Counter	+ 1;
		end
	end

	Outtext = Outtext .. Counter .. ",";
	Counter = 0;
	for key, value in pairs(libGuildWardenSaveVar["Joined"][libGuildWarden.Realm][guildName]) do	
		local Addthis = false;
		Addthis	= true;
		if (not key) then
			Addthis = false;
		end

		if (key == "") then
			Addthis = false;
		end

		if (Addthis == true) then
			Counter = Counter	+ 1;
		end
	end

	Outtext = Outtext .. Counter .. ",";
	Counter = 0;
	for key, value in pairs(libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName]) do	
		local Addthis = false;
		if (value.Datebanned) then
			Addthis = true;
		end

		if (not key) then
			Addthis = false;
		end

		if (key == "") then
			Addthis = false;
		end

		if (Addthis == true) then
			Counter = Counter	+ 1;
		end
	end

	Outtext = Outtext .. Counter; 		
	return Outtext;
end

function libGuildWarden.SendMyPing()
	if (not libGuildWarden.TempListMain["Sender"]) then
		return;
	end

	if (libGuildWarden.TempListMain["Sender"].SentPing == false and libGuildWarden.TempListMain["Sender"].Send == false and not libGuildWarden.TempListMain["Sender"].INeed) then
		libGuildWarden.TempListMain["Sender"].SentPing = true;
		local Counter	= libGuildWarden.GetMyPing();
		libGuildWarden.SendAddonMessage("GW-Ping", Counter, "GUILD");
	end
end

function libGuildWarden.SendData(GoingTo, NumTableToSend, listID)
	if (libGuildWarden.TempListMain["Sender"].Send == false) then
		libGuildWarden.TempListMain["Sender"]["CountList"] = NumTableToSend;
		libGuildWarden.TempListMain["Sender"].GoingTo = GoingTo;
		libGuildWarden.TempListMain["Sender"].Time = 0;
		libGuildWarden.TempListMain["Sender"].Limit = 0;
		libGuildWarden.TempListMain["Sender"].Count = 0;
		libGuildWarden.TempListMain["Sender"].ListID = listID;
		libGuildWarden.TempListMain["Sender"].Send = true;
	end
end

function libGuildWarden.ConvertAll()
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	if (MainMyID) then
		libGuildWardenSaveVar["MainMyID"] = MainMyID;
		--MainMyID = nil;
	end

	if (libWardenLeftGuildList) then
		libGuildWarden.SendText("Converting Started");
		for mainkey, mianvalue in pairs(libWardenLeftGuildList) do
			local SplitA = {strsplit("-",mainkey)}
			local RealmName = SplitA[1];
			local GuildName = SplitA[2];
		
			if (not libGuildWardenSaveVar["Left"][RealmName]) then
				libGuildWardenSaveVar["Left"][RealmName] = {};
			end

			if (not libGuildWardenSaveVar["Left"][RealmName][GuildName]) then
				libGuildWardenSaveVar["Left"][RealmName][GuildName] = {};
			end		

			for key, value in pairs(libWardenLeftGuildList[mainkey]) do
				if (not libGuildWardenSaveVar["PlayerInfo"][RealmName]) then
					libGuildWardenSaveVar["PlayerInfo"][RealmName] = {};
				end

				if (not libGuildWardenSaveVar["PlayerInfo"][RealmName][value.Name]) then
					libGuildWardenSaveVar["PlayerInfo"][RealmName][value.Name] = {};
				end

				for sub1key, sub1value in pairs(libWardenLeftGuildList[mainkey][value.Name]) do
					if (sub1key == "Date") then
						if (not libGuildWardenSaveVar["Left"][RealmName]) then
							libGuildWardenSaveVar["Left"][RealmName] = {};
						end

						if (not libGuildWardenSaveVar["Left"][RealmName][GuildName]) then
							libGuildWardenSaveVar["Left"][RealmName][GuildName] = {};
						end

						if (not libGuildWardenSaveVar["Left"][RealmName][GuildName][value.Name]) then
							libGuildWardenSaveVar["Left"][RealmName][GuildName][value.Name] = {};
						end
						libGuildWardenSaveVar["Left"][RealmName][GuildName][value.Name].Dateleft = sub1value;
					else
						if (sub1key == "Joined") then
							if (not libGuildWardenSaveVar["Joined"][RealmName]) then
								libGuildWardenSaveVar["Joined"][RealmName] = {};
							end

							if (not libGuildWardenSaveVar["Joined"][RealmName][GuildName]) then
								libGuildWardenSaveVar["Joined"][RealmName][GuildName] = {};
							end

							if (not libGuildWardenSaveVar["Joined"][RealmName][GuildName][value.Name]) then
								libGuildWardenSaveVar["Joined"][RealmName][GuildName][value.Name] = {};
							end
							libGuildWardenSaveVar["Joined"][RealmName][GuildName][value.Name].Datejoined = sub1value;
						else
							libGuildWardenSaveVar["PlayerInfo"][RealmName][value.Name][sub1key] = sub1value;
						end
					end
				end
			end
		end
		libWardenLeftGuildList = nil;
	end

	if (libWardenGuildList) then
		for mainkey, mianvalue in pairs(libWardenGuildList) do
			local SplitA = {strsplit("-",mainkey)}
			local RealmName = SplitA[1];
			local GuildName = SplitA[2];
			if (not libGuildWardenSaveVar["Roster"][RealmName]) then
				libGuildWardenSaveVar["Roster"][RealmName] = {};
			end

			if (not libGuildWardenSaveVar["Roster"][RealmName][GuildName]) then
				libGuildWardenSaveVar["Roster"][RealmName][GuildName] = {};
			end

			for key, value in pairs(libWardenGuildList[mainkey]) do
				libGuildWardenSaveVar["Roster"][RealmName][GuildName][value.Name] = value.Name;

				if (not libGuildWardenSaveVar["PlayerInfo"][RealmName]) then
					libGuildWardenSaveVar["PlayerInfo"][RealmName] = {};
				end

				if (not libGuildWardenSaveVar["PlayerInfo"][RealmName][value.Name]) then
					libGuildWardenSaveVar["PlayerInfo"][RealmName][value.Name] = {};
				end

				for sub1key, sub1value in pairs(libWardenGuildList[mainkey][value.Name]) do
					if (sub1key == "Date") then
						if (not libGuildWardenSaveVar["Left"][RealmName]) then
							libGuildWardenSaveVar["Left"][RealmName] = {};
						end

						if (not libGuildWardenSaveVar["Left"][RealmName][GuildName]) then
							libGuildWardenSaveVar["Left"][RealmName][GuildName] = {};
						end

						if (not libGuildWardenSaveVar["Left"][RealmName][GuildName][value.Name]) then
							libGuildWardenSaveVar["Left"][RealmName][GuildName][value.Name] = {};
						end
						libGuildWardenSaveVar["Left"][RealmName][GuildName][value.Name].Dateleft = sub1value;
					else
						if (sub1key == "Joined") then
							if (not libGuildWardenSaveVar["Joined"][RealmName]) then
								libGuildWardenSaveVar["Joined"][RealmName] = {};
							end

							if (not libGuildWardenSaveVar["Joined"][RealmName][GuildName]) then
								libGuildWardenSaveVar["Joined"][RealmName][GuildName] = {};
							end

							if (not libGuildWardenSaveVar["Joined"][RealmName][GuildName][value.Name]) then
								libGuildWardenSaveVar["Joined"][RealmName][GuildName][value.Name] = {};
							end
							libGuildWardenSaveVar["Joined"][RealmName][GuildName][value.Name].Datejoined = sub1value;
						else
							libGuildWardenSaveVar["PlayerInfo"][RealmName][value.Name][sub1key] = sub1value;
						end
					end
				end
			end
		end
		libWardenGuildList = nil;
	end

	--libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName]
	if (Playerslist) then
		for key, value in pairs(Playerslist) do
			if (not libGuildWardenSaveVar["PlayerInfo"][value.Server]) then
				libGuildWardenSaveVar["PlayerInfo"][value.Server] = {};
			end

			if (not libGuildWardenSaveVar["PlayerInfo"][value.Server][value.Name]) then
				libGuildWardenSaveVar["PlayerInfo"][value.Server][value.Name] = {};
			end

			for sub1key, sub1value in pairs(Playerslist[key]) do
				local SplitA = {strsplit("-",sub1key)}
				if (#SplitA > 1) then
					local GuildName = SplitA[1];
					local Tag = SplitA[2];
					if (not libGuildWardenSaveVar["Banned"][value.Server]) then
						libGuildWardenSaveVar["Banned"][value.Server] = {};
					end

					if (not libGuildWardenSaveVar["Banned"][value.Server][GuildName]) then
						libGuildWardenSaveVar["Banned"][value.Server][GuildName] = {};
					end

					if (not libGuildWardenSaveVar["Banned"][value.Server][GuildName][value.Name]) then
						libGuildWardenSaveVar["Banned"][value.Server][GuildName][value.Name] = {};
					end

					if (Tag == "BannedDate") then
						Tag = "Datebanned";
					end

					if (Tag == "RemovedDate") then
						Tag = "Dateremoved";
					end
					libGuildWardenSaveVar["Banned"][value.Server][GuildName][value.Name][Tag] = sub1value;
				else
					if (sub1key == "Date") then
						libGuildWardenSaveVar["PlayerInfo"][value.Server][value.Name]["Updated"] = sub1value;
					else
						libGuildWardenSaveVar["PlayerInfo"][value.Server][value.Name][sub1key] = sub1value;
					end
				end
			end
		end
		libGuildWarden.SendText("Converting Done");
		Playerslist = nil;
	end

	--[[
	local CountList = {};
	local Counter = 0;
	for key, value in pairs(libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName]) do
		if (value.Dateremoved) then
			Counter = Counter + 1;
			CountList[Counter] = key;
		end
	end

	for index=1, #CountList do
		libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][CountList[index] ] = nil;
	end
	 ]]--
end
