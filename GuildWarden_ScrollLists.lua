function libGuildWarden.TabClicked(self)
	local tabIndex = self:GetID();
	CloseGuildMenus();
	PanelTemplates_SetTab(self:GetParent(), tabIndex);
	if (tabIndex == libGuildWarden.TabsLeading + 1) then
		ButtonFrameTemplate_HideButtonBar(GuildFrame);
		GuildFrame_ShowPanel("frmGuildWardenMain");
		GuildFrameInset:SetPoint("TOPLEFT", 4, -65);
		GuildFrameInset:SetPoint("BOTTOMRIGHT", -7, 44);
		frmGuildWardenMain:SetPoint("TOPLEFT", 4, -65);
		frmGuildWardenMain:SetPoint("BOTTOMRIGHT", -7, 44);
		GuildFrameBottomInset:Hide();
		GuildXPFrame:Hide();
		GuildFactionFrame:Hide();
		--GuildAddMemberButton:Hide();
		--GuildControlButton:Hide();
		--GuildViewLogButton:Hide();
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
	if (tabIndex == libGuildWarden.TabsLeading + 2) then
		ButtonFrameTemplate_HideButtonBar(GuildFrame);
		GuildFrame_ShowPanel("frmGuildWardenLeft");
		GuildFrameInset:SetPoint("TOPLEFT", 7, -85);
		GuildFrameInset:SetPoint("BOTTOMRIGHT", -7, 24);
		frmGuildWardenLeft:SetPoint("TOPLEFT", 7, -85);
		frmGuildWardenLeft:SetPoint("BOTTOMRIGHT", -7, 24);
		GuildFrameBottomInset:Hide();
		GuildXPFrame:Hide();
		GuildFactionFrame:Hide();
		--GuildAddMemberButton:Hide();
		--GuildControlButton:Hide();
		--GuildViewLogButton:Hide();
		GuildFrameMembersCountLabel:Hide();
		GuildFrameMembersCount:Hide();
		if (libGuildWarden.Loaded >= 1) then
			libGuildWarden.SetLeftView();			
		end
		
		--frmGuildWardenMain:Show();
		--frmGuildWardenMainLabel:Show();

	end
	
	if (tabIndex == libGuildWarden.TabsLeading + 3) then
		ButtonFrameTemplate_HideButtonBar(GuildFrame);
		GuildFrame_ShowPanel("frmGuildWardenJoined");
		GuildFrameInset:SetPoint("TOPLEFT", 7, -85);
		GuildFrameInset:SetPoint("BOTTOMRIGHT", -7, 24);
		frmGuildWardenJoined:SetPoint("TOPLEFT", 7, -85);
		frmGuildWardenJoined:SetPoint("BOTTOMRIGHT", -7, 24);
		GuildFrameBottomInset:Hide();
		GuildXPFrame:Hide();
		GuildFactionFrame:Hide();
		--GuildAddMemberButton:Hide();
		--GuildControlButton:Hide();
		--GuildViewLogButton:Hide();
		GuildFrameMembersCountLabel:Hide();
		GuildFrameMembersCount:Hide();
		if (libGuildWarden.Loaded >= 1) then
			libGuildWarden.SetJoinedView();			
		end
		
		--frmGuildWardenMain:Show();
		--frmGuildWardenMainLabel:Show();


	end	
	
	if (tabIndex == libGuildWarden.TabsLeading + 4) then
		ButtonFrameTemplate_HideButtonBar(GuildFrame);
		GuildFrame_ShowPanel("frmGuildWardenBanned");
		GuildFrameInset:SetPoint("TOPLEFT", 7, -85);
		GuildFrameInset:SetPoint("BOTTOMRIGHT", -7, 24);
		frmGuildWardenBanned:SetPoint("TOPLEFT", 7, -85);
		frmGuildWardenBanned:SetPoint("BOTTOMRIGHT", -7, 24);
		GuildFrameBottomInset:Hide();
		GuildXPFrame:Hide();
		GuildFactionFrame:Hide();
		--GuildAddMemberButton:Hide();
		--GuildControlButton:Hide();
		--GuildViewLogButton:Hide();
		GuildFrameMembersCountLabel:Hide();
		GuildFrameMembersCount:Hide();
		if (libGuildWarden.Loaded >= 1) then
			libGuildWarden.SetBannedView();			
		end
		
		--frmGuildWardenMain:Show();
		--frmGuildWardenMainLabel:Show();

	end	
		
    frmGuildWardenAlts:Hide();
    frmGuildWardenInfo:Hide();
end
function libGuildWarden.ShortByDate(List, a, b)
	if (not a) then	
	 return;
	end
	if (not b) then	
	 return;
	end	
	local Whichway =libGuildWarden.TempListMain[List].dir;
		if (Whichway == "+") then						
			if ((a.DBY == b.DBY) and (a.DBM == b.DBM) and (a.DBD == b.DBD) and (a.TBH == b.TBH) and (a.TBM == b.TBM))then
				return a["Name"] < b["Name"];		
			end
			
			if (a.DBY ~= b.DBY) then
				return a.DBY < b.DBY;
			else
				if (a.DBM ~= b.DBM) then
					return a.DBM < b.DBM;
				else										
					if (a.DBD ~= b.DBD) then
						return a.DBD < b.DBD;
					else
						if (a.TBH ~= b.TBH) then
							return a.TBH < b.TBH;
						else
							if (a.TBM ~= b.TBM) then
								return a.TBM < b.TBM;
							else										
								return a.TBS < b.TBS;
							end									
						end											
						
					end	
				end									
			end	
		end
		if (Whichway == "-") then
			if ((a.DBY == b.DBY) and (a.DBM == b.DBM) and (a.DBD == b.DBD) and (a.TBH == b.TBH) and (a.TBM == b.TBM))then
				return a["Name"] > b["Name"];		
			end		
			if (a.DBY ~= b.DBY) then
				return a.DBY > b.DBY;
			else
				if (a.DBM ~= b.DBM) then
					return a.DBM > b.DBM;
				else										
					if (a.DBD ~= b.DBD) then
						return a.DBD > b.DBD;
					else
						if (a.TBH ~= b.TBH) then
							return a.TBH > b.TBH;
						else
							if (a.TBM ~= b.TBM) then
								return a.TBM > b.TBM;
							else										
								return a.TBS > b.TBS;
							end									
						end											
						
					end	
				end									
			end		
		end

end
function libGuildWarden.SetupDate(CounterList, Date)
	if (not Date) then
		Date = "00/00/00 00.00.00"; 
	end
	local SplitA = {strsplit(" ", Date)};
	local SplitB = {strsplit("/",SplitA[1])}
	
	CounterList.MainDate = SplitA[1];	
	CounterList.MainTime = SplitA[2];	
	CounterList.Date = SplitA[1];		
	CounterList.DBY = SplitB[3]; 
	CounterList.DBD = SplitB[2]; 
	CounterList.DBM = SplitB[1];
	
	CounterList.TBH = "00"; 
	CounterList.TBM = "00"; 
	CounterList.TBS = "00";
	if (SplitA[2]) then	
		local SplitB = {strsplit(".",SplitA[2])}	
		if (table.getn(SplitB) == 3)then
			if (SplitA[1] == date("%m/%d/%y")) then
				CounterList.Date = SplitA[2];
			end			
			CounterList.TBH = SplitB[1]; 
			CounterList.TBM = SplitB[2]; 
			CounterList.TBS = SplitB[3];				
		end
	end
	
	return CounterList;		
end
function libGuildWarden.DefaultShort(TempList,a,b)
	local CountList = TempList["CountList"]; 
	if (TempList.dir == "+") then
							if (a[TempList.sort] == b[TempList.sort]) then
								return a["Name"] < b["Name"];
							else
								return a[TempList.sort] < b[TempList.sort];
							end
	end
	if (TempList.dir == "-") then
		sort(CountList, function(a,b) 
							if (a[TempList.sort] == b[TempList.sort]) then
								return a["Name"] > b["Name"];
							else
								return a[TempList.sort] > b[TempList.sort];
							end
						
						end);
	end
end
---------------------------------LEFT VIEW--------------------------------------
function GuildLeftButton_OnClick(self, button)
	local AltsName = libGuildWarden.TempListMain["Left"]["CountList"][self.index].Name;
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	
	if (AltsName) then
		if (button == "LeftButton") then
			libGuildWarden.SetAlts(AltsName);
			libGuildWarden.ShowUserBox();
			libGuildWarden.HyperlinkClicked(self, "player:" .. AltsName .. ":STOP", nil, button);
		end
		if (button == "RightButton") then			
			libGuildWarden.NameChanger = AltsName;
			libGuildWarden.YesNoFunction = function()
												local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
												local LeftList = libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName][libGuildWarden.NameChanger];
												local DateEdit = GuildWardenPopTextBox:GetText();
												if (libGuildWarden.CheckFormateDate(DateEdit)) then
													LeftList.Dateleft = DateEdit;
													LeftList.Dateremoved = nil;
													libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName][libGuildWarden.NameChanger] = LeftList; 
													libGuildWarden.SendText("Date changed.");
													libGuildWarden.SetLeftView();
												else
													libGuildWarden.SendText("Wrong Formate, Date not changed.");
												end
										   end;
			libGuildWarden.ShowPopUp("Type in date below. Formate: \n MH/DY/YR HR.MN.SC \n Example: " .. date("%m/%d/%y %H.%M.%S"), "Change Date", "Cancel", false, libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName][libGuildWarden.NameChanger].Dateleft);			
		end
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
function libGuildWarden.SortLeftList()
local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
local LeftList = libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName];
local CountList= {};         
local Counter = 0;

GuildLeftShowGuiliesButton:Hide();
for key, value in pairs(LeftList) do
    if (not GuildLeftShowGuiliesButton:GetChecked() or libGuildWardenSaveVar["Roster"][libGuildWarden.Realm][guildName][key]) then
		if (not value.Dateremoved) then
			Counter = Counter  + 1;
			CountList[Counter] = {};
			CountList[Counter] = libGuildWarden.CloneSimpleTable(libGuildWarden.GetPlayerInfo(key));
			CountList[Counter].Name = key;
			CountList[Counter].LVL = tonumber(CountList[Counter].LVL);
			if (not CountList[Counter].LVL) then
				CountList[Counter].LVL = 0;
			end	
			
			CountList[Counter] = libGuildWarden.SetupDate(CountList[Counter], value.Dateleft);
		end


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
function libGuildWarden.SetLeftView()
	local GUILD_LEFT_COLUMN_DATA = {};
	local stringsInfo = { };
	local stringOffset = 0;
	local haveIcon, haveBar;
	
	
	GUILD_LEFT_COLUMN_DATA[1] = { width = 32, text = "Ур", stringJustify="CENTER", type = "LVL"};
	GUILD_LEFT_COLUMN_DATA[2] = { width = 32, text = "Кл", hasIcon = true, type = "Class" };
	GUILD_LEFT_COLUMN_DATA[3] = { width = 81, text = "Имя", stringJustify="LEFT", type = "Name" };
	GUILD_LEFT_COLUMN_DATA[4] = { width = 144, text = "Дата ухода", stringJustify="LEFT", type = "Date" };	
    libGuildWarden.TempListMain["Left"].sort = "Date"
    libGuildWarden.TempListMain["Left"].dir = "-"
	for columnIndex = 1, 4 do
			local columnButton = _G["GuildLeftColumnButton"..columnIndex];
            local columnData = GUILD_LEFT_COLUMN_DATA[columnIndex];
            
			columnButton:SetText(columnData.text);			
			WhoFrameColumn_SetWidth(columnButton, columnData.width);
			columnButton:Show();
			
			-- by default the sort type should be the same as the column type
--[[			if ( columnData.sortType ) then
				columnButton.sortType = columnData.sortType;
			else
				columnButton.sortType = columnType;
			end ]]--
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

	if (libGuildWarden.TempListMain["Left"].sort == "Date") then
	    sort(CountList, function(a,b) return libGuildWarden.ShortByDate("Left", a,b) end);
	else
		libGuildWarden.DefaultShort(libGuildWarden.TempListMain["Left"],a,b);
	end

 	for i = 1, numButtons do
		button = buttons[i];
		index = offset + i	
	
		
		if (CountList[tonumber(index)]) then
		

		    local Playerinfo = CountList[tonumber(index)];
		    
		    if (Playerinfo) then

				classFileName = libGuildWarden.GetClassFileName(Playerinfo.Class);
				if (classFileName) then
					if (classFileName == "DEATH") then
						classFileName = "DEATHKNIGHT";
						Playerinfo.Class = "Death Knight";
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
				
								
				

				if (Playerinfo.MainDate == date("%m/%d/%y")) then
					libGuildWarden.SetStringTextColor(button.string3, Playerinfo.Date, 1,0,0);			
					libGuildWarden.SetStringTextColor(button.string1, Playerinfo.LVL, 1,0,0);
				else
					if (libGuildWardenSaveVar["Roster"][libGuildWarden.Realm][guildName][Playerinfo.Name]) then
						libGuildWarden.SetStringText(button.string3, Playerinfo.Date, true);		
						libGuildWarden.SetStringText(button.string1, Playerinfo.LVL, true);		
					else
						if (libGuildWarden.GetPlayerInfo(Playerinfo.Name)) then
					    	if (libGuildWarden.GetPlayerInfo(Playerinfo.Name).Guild == guildName) then
								libGuildWarden.SetPlayerInfo(Playerinfo.Name, "Guild", "Н/Д");	
							end					
						end
						libGuildWarden.SetStringText(button.string3, Playerinfo.Date);				
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

---------------------------------LEFT VIEW--------------------------------------
-------------------------------JOINED VIEW--------------------------------------
function GuildJoinedButton_OnClick(self, button)
	local AltsName = libGuildWarden.TempListMain["Joined"]["CountList"][self.index].Name;
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	if (AltsName) then	
		if (button == "LeftButton") then	
			libGuildWarden.SetAlts(AltsName);  
			libGuildWarden.HyperlinkClicked(self, "player:" .. AltsName .. ":STOP", nil, button);		
		end		
		
		if (button == "RightButton") then			
			libGuildWarden.NameChanger = AltsName;
			libGuildWarden.YesNoFunction = function()
												local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
												local JoinedList = libGuildWardenSaveVar["Joined"][libGuildWarden.Realm][guildName][libGuildWarden.NameChanger];
												local DateEdit = GuildWardenPopTextBox:GetText();
												if (libGuildWarden.CheckFormateDate(DateEdit)) then
													JoinedList.Datejoined = DateEdit;
													libGuildWardenSaveVar["Joined"][libGuildWarden.Realm][guildName][libGuildWarden.NameChanger] = JoinedList; 
													libGuildWarden.SendText("Date changed.");
													libGuildWarden.SetJoinedView();
												else
													libGuildWarden.SendText("Wrong Formate, Date not changed.");
												end
										   end;
			libGuildWarden.ShowPopUp("Type in date below. Formate: \n MH/DY/YR HR.MN.SC \n Example: " .. date("%m/%d/%y %H.%M.%S"), "Change Date", "Cancel", false, libGuildWardenSaveVar["Joined"][libGuildWarden.Realm][guildName][libGuildWarden.NameChanger].Datejoined);			
		end	
				
	end	
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
function libGuildWarden.SortJoinedList()
local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
local LeftList = libGuildWardenSaveVar["Joined"][libGuildWarden.Realm][guildName];
local CountList= {};         
local Counter = 0;

for key, value in pairs(LeftList) do
    if (not GuildJoinedShowGuiliesButton:GetChecked() or libGuildWardenSaveVar["Roster"][libGuildWarden.Realm][guildName][key]) then
		Counter = Counter  + 1;
		CountList[Counter] = {};
		CountList[Counter] = libGuildWarden.CloneSimpleTable(libGuildWarden.GetPlayerInfo(key));
		CountList[Counter].Name = key;
		CountList[Counter].LVL = tonumber(CountList[Counter].LVL);
		if (not CountList[Counter].LVL) then
			CountList[Counter].LVL = 0;
		end	
		CountList[Counter] = libGuildWarden.SetupDate(CountList[Counter], value.Datejoined);

		
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

	if (libGuildWarden.TempListMain["Joined"].sort == "Date") then
		sort(CountList, function(a,b) return libGuildWarden.ShortByDate("Joined", a,b) end);
	else
		libGuildWarden.DefaultShort(libGuildWarden.TempListMain["Joined"]);
	end

 	for i = 1, numButtons do
		button = buttons[i];
		index = offset + i	
	
		
		if (CountList[tonumber(index)]) then
		    local Playerinfo = CountList[tonumber(index)];
		    
		    if (Playerinfo) then
				classFileName = libGuildWarden.GetClassFileName(Playerinfo.Class);
				if (classFileName) then
					if (classFileName == "DEATH") then
						classFileName = "DEATHKNIGHT";
						Playerinfo.Class = "Death Knight";
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
					if (Playerinfo.MainDate == date("%m/%d/%y")) then
						libGuildWarden.SetStringTextColor(button.string3, Playerinfo.Date, 0, 1, 0);
						libGuildWarden.SetStringTextColor(button.string1, Playerinfo.LVL, 0, 1, 0);			
					else
						libGuildWarden.SetStringText(button.string3, Playerinfo.Date, true);
						libGuildWarden.SetStringText(button.string1, Playerinfo.LVL, true);
					end			
				else	
						if (libGuildWarden.GetPlayerInfo(Playerinfo.Name)) then
					    	if (libGuildWarden.GetPlayerInfo(Playerinfo.Name).Guild == guildName) then
								libGuildWarden.SetPlayerInfo(Playerinfo.Name, "Guild", "Н/Д");	
							end					
						end										
                	libGuildWarden.SetStringText(button.string3, Playerinfo.Date);
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
	
	
	GUILD_JOINED_COLUMN_DATA[1] = { width = 32, text = "Ур", stringJustify="CENTER", type = "LVL"};
	GUILD_JOINED_COLUMN_DATA[2] = { width = 32, text = "Кл", hasIcon = true, type = "Class" };
	GUILD_JOINED_COLUMN_DATA[3] = { width = 81, text = "Имя", stringJustify="LEFT", type = "Name" };
	GUILD_JOINED_COLUMN_DATA[4] = { width = 144, text = "Дата прихода", stringJustify="LEFT", type = "Date" };	
    libGuildWarden.TempListMain["Joined"].sort = "Date"
    libGuildWarden.TempListMain["Joined"].dir = "-"
	for columnIndex = 1, 4 do
			local columnButton = _G["GuildJoinedColumnButton"..columnIndex];
            local columnData = GUILD_JOINED_COLUMN_DATA[columnIndex];
            
			columnButton:SetText(columnData.text);			
			WhoFrameColumn_SetWidth(columnButton, columnData.width);
			columnButton:Show();
			
			-- by default the sort type should be the same as the column type
--[[			if ( columnData.sortType ) then
				columnButton.sortType = columnData.sortType;
			else
				columnButton.sortType = columnType;
			end ]]--
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

-------------------------------JOINED VIEW--------------------------------------
-------------------------------BANNED VIEW--------------------------------------
function GuildBannedButton_OnClick(self, button)
	local AltsName = libGuildWarden.TempListMain["Banned"]["CountList"][self.index].Name;
	if (AltsName) then
		libGuildWarden.SetAlts(AltsName);
		libGuildWarden.HyperlinkClicked(self, "player:" .. AltsName .. ":STOP", nil, button);
	end
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
function libGuildWarden.SortBannedList()
local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
local LeftList = libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName];
local CountList= {};         
local Counter = 0;

	for key, value in pairs(LeftList) do
		for keysub, valuesub in pairs(libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm]) do
			local PIID = libGuildWarden.ReturnID(keysub);
  			if (PIID == key) then    	
    			if (not GuildBannedShowGuiliesButton:GetChecked() or libGuildWardenSaveVar["Roster"][libGuildWarden.Realm][guildName][keysub]) then
    				if (value.Datebanned == "00/00/00") then
    					value.Datebanned = nil;
    				end
    				if (value.Datebanned) then 
						Counter = Counter  + 1;
						CountList[Counter] = {};
						CountList[Counter] = libGuildWarden.CloneSimpleTable(libGuildWarden.GetPlayerInfo(keysub));											
						CountList[Counter].LVL = tonumber(CountList[Counter].LVL);
						
						CountList[Counter] = libGuildWarden.SetupDate(CountList[Counter], value.Datebanned);
			
						libGuildWarden.BanPlayer(CountList[Counter].Name, CountList[Counter].BannedReason);
					end
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

	libGuildWarden.TempListMain["Banned"]["CountList"] = CountList;    
	libGuildWarden.TempListMain["Banned"].Max = Counter;
		
end 
function libGuildWarden.SetBannedView()
	local GUILD_Banned_COLUMN_DATA = {};
	local stringsInfo = { };
	local stringOffset = 0;
	local haveIcon, haveBar;
	
	
	GUILD_Banned_COLUMN_DATA[1] = { width = 32, text = "Ур", stringJustify="CENTER", type = "LVL"};
	GUILD_Banned_COLUMN_DATA[2] = { width = 32, text = "Кл", hasIcon = true, type = "Class" };
	GUILD_Banned_COLUMN_DATA[3] = { width = 81, text = "Имя", stringJustify="LEFT", type = "Name" };
	GUILD_Banned_COLUMN_DATA[4] = { width = 144, text = "Дата бана", stringJustify="LEFT", type = "Date" };	
    libGuildWarden.TempListMain["Banned"].sort = "Date"
    libGuildWarden.TempListMain["Banned"].dir = "-"
	for columnIndex = 1, 4 do
			local columnButton = _G["GuildBannedColumnButton"..columnIndex];
            local columnData = GUILD_Banned_COLUMN_DATA[columnIndex];
            
			columnButton:SetText(columnData.text);			
			WhoFrameColumn_SetWidth(columnButton, columnData.width);
			columnButton:Show();
			
			-- by default the sort type should be the same as the column type
--[[			if ( columnData.sortType ) then
				columnButton.sortType = columnData.sortType;
			else
				columnButton.sortType = columnType;
			end ]]--
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

	if (libGuildWarden.TempListMain["Banned"].sort == "Date") then
		sort(CountList, function(a,b) return libGuildWarden.ShortByDate("Banned", a,b) end);
	else
		libGuildWarden.DefaultShort(libGuildWarden.TempListMain["Banned"]);
	end

 	for i = 1, numButtons do
		button = buttons[i];
		index = offset + i	
	
		
		if (CountList[tonumber(index)]) then
		    local Playerinfo = CountList[tonumber(index)];
		    
		    if (Playerinfo) then
				classFileName = libGuildWarden.GetClassFileName(Playerinfo.Class);
				if (classFileName) then
					if (classFileName == "DEATH") then
						classFileName = "DEATHKNIGHT";
						Playerinfo.Class = "Death Knight";
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
					if (Playerinfo.MainDate == date("%m/%d/%y")) then
						libGuildWarden.SetStringTextColor(button.string3, Playerinfo.Date, 0, 1, 0);
						libGuildWarden.SetStringTextColor(button.string1, Playerinfo.LVL, 0, 1, 0);			
					else
						libGuildWarden.SetStringText(button.string3, Playerinfo.Date, true);
						libGuildWarden.SetStringText(button.string1, Playerinfo.LVL, true);
					end			
				else
						if (libGuildWarden.GetPlayerInfo(Playerinfo.Name)) then
					    	if (libGuildWarden.GetPlayerInfo(Playerinfo.Name).Guild == guildName) then
								libGuildWarden.SetPlayerInfo(Playerinfo.Name, "Guild", "Н/Д");	
							end					
						end				
                	libGuildWarden.SetStringText(button.string3, Playerinfo.Date);
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
-------------------------------BANNED VIEW--------------------------------------
---------------------------------ALTS VIEW--------------------------------------
function libGuildWarden.ShowUserBox(InfoName)
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	if (InfoName) then
		local AllAbout = libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][InfoName];
		if (AllAbout) then
			local PlayersIndex = libGuildWarden.GetPlayersGuildIndex(InfoName);
			
			local subname, subrank, subrankIndex, sublevel, subclass, subzone, subnote, subofficernote, subonline, substatus, subclassFileName, subachievementPoints, subachievementRank, subisMobile;
			if (PlayersIndex) then
				subname, subrank, subrankIndex, sublevel, subclass, subzone, subnote, subofficernote, subonline, substatus, subclassFileName, subachievementPoints, subachievementRank, subisMobile = GetGuildRosterInfo(PlayersIndex);							
			end
			if (not subrank) then
				subrank = "Н/Д";
			end

			local LVL = AllAbout.LVL;
		 	if (not LVL) then
		 		LVL = 0;
		 	end
			local Guild = AllAbout.Guild;
		 	if (not Guild) then
		 		Guild = "Н/Д";
		 	end	
			local Class = AllAbout.Class;
		 	if (not Class) then
		 		Class = "Н/Д";
		 	end				 
			local Faction = AllAbout.Faction;
		 	if (not Faction) then
		 		Faction = "Н/Д";
		 	end	
			local Race = AllAbout.Race;
		 	if (not Race) then
		 		Race = "Н/Д";
		 	end	
		 	local thisID = "---";
		 	thisID = libGuildWarden.ReturnID(InfoName);
			if (not thisID) then
				thisID = "---";
			end
		
			local Main = "No ID";
			if (thisID ~= "---") then
				if (not libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][thisID]) then
					libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][thisID] = {};
				end		 	
		 		Main = libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][thisID].Main;		 	
		 		if (not Main) then
		 			Main = "Не указан";
		 		end			 		
			end	 
			local Joined = "Н/Д";
			if (libGuildWardenSaveVar["Joined"][libGuildWarden.Realm][guildName][InfoName]) then
				if (libGuildWardenSaveVar["Joined"][libGuildWarden.Realm][guildName][InfoName].Datejoined) then
					Joined = libGuildWardenSaveVar["Joined"][libGuildWarden.Realm][guildName][InfoName].Datejoined;
				end
			end
			local Left = "Н/Д";
			if (libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName][InfoName]) then
				if (libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName][InfoName].Dateleft) then
					Left = libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName][InfoName].Dateleft;
				end
				if (libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName][InfoName].Dateleft == "00/00/00 00.00.00") then
					Left = "Н/Д";
				end
				if (libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName][InfoName].Dateleft == "00/00/00") then
					Left = "Н/Д";
				end				
			end	
			
			local Banned = "Н/Д";
			local BannedBy = "Н/Д";
			local BannedReason = "Н/Д";
			if (thisID ~= "---") then
				if (libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][thisID]) then
					if (libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][thisID].Datebanned) then
						Banned = libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][thisID].Datebanned;
						BannedBy = libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][thisID].BannedBy;
						BannedReason = libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][thisID].BannedReason;
						if (not BannedReason) then
							BannedReason = "??";
						end
					end
					if (libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][thisID].Dateremoved) then
						Banned = libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][thisID].Dateremoved;
						BannedBy = libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][thisID].RemovedBy;
						BannedReason = "---";
					end				
				end						
			end
			
						 			 	 	
			frmGuildWardenInfo.CharName:SetText("Имя: " .. InfoName)
			
			
			frmGuildWardenInfo.CharLVL:SetText("Уровень: " .. LVL) 		
			
			frmGuildWardenInfo.CharGuild:SetText("<" .. Guild .. ">") 	
			
			frmGuildWardenInfo.CharClass:SetText("Класс: ".. Class) 		 
			
			frmGuildWardenInfo.CharFaction:SetText("Фракция: ".. Faction) 
			
			frmGuildWardenInfo.CharRace:SetText("Раса: ".. Race) 
			
			frmGuildWardenInfo.CharMain:SetText("[".. Main .. "]") 
			
			frmGuildWardenInfo.CharJoined:SetText("Дата прихода: ".. Joined)
			
			frmGuildWardenInfo.CharLeft:SetText("Дата ухода: ".. Left)
			
			frmGuildWardenInfo.CharRank:SetText("Звание: ".. subrank)
			
			if (Banned == "Н/Д") then
				frmGuildWardenInfo.CharBanned:Hide();
				frmGuildWardenInfo.CharBannedBy:Hide();
				frmGuildWardenInfo.CharBannedR:Hide();
			else
				if (BannedReason ~= "---") then
					frmGuildWardenInfo.CharBanned:Show();
					frmGuildWardenInfo.CharBannedBy:Show();
					frmGuildWardenInfo.CharBannedR:Show();	
								
					frmGuildWardenInfo.CharBanned:SetText("Забанен: " .. Banned);
					frmGuildWardenInfo.CharBannedBy:SetText("Кем: ".. BannedBy);
					frmGuildWardenInfo.CharBannedR:SetText("Причина: " .. BannedReason);
				else
					frmGuildWardenInfo.CharBanned:Show();
					frmGuildWardenInfo.CharBannedBy:Show();
					frmGuildWardenInfo.CharBannedR:Hide();	
								
					frmGuildWardenInfo.CharBanned:SetText("Разбанен: " .. Banned);
					frmGuildWardenInfo.CharBannedBy:SetText("Кем: ".. BannedBy);
					--frmGuildWardenInfo.CharBannedR::SetText("Reason: " .. BannedReason)				
				end
			end
			GuildWardenDeleteChar:SetText("Удалить");	
			GuildWardenDeleteChar:Enable(); 	
			local NumberAlts = libGuildWarden.GetAlts(InfoName);
			local Count = 0;
			for key, value in pairs(NumberAlts) do
				Count = Count + 1;
			end														
			if (Count < 2) then	
				GuildWardenDeleteChar:Disable();			
			end		
			if (not AllAbout.ID or AllAbout.ID == "??") then
				if (not LVL or tostring(LVL) == "??" or tostring(LVL) == "0" or tostring(LVL) == "-1") then
					if (not libGuildWarden.GetPlayersGuildIndex((InfoName))) then	
						GuildWardenDeleteChar:Enable(); 							
					end
				end
			else
				if (libGuildWarden.IsGuildLeader() and not libGuildWarden.GetPlayersGuildIndex(InfoName)) then		
						GuildWardenDeleteChar:Enable(); 				
				else	
					GuildWardenDeleteChar:Disable();
				end
			end

									
			
					--CharJoined
					--CharLeft
		 
		end
	end 
	libGuildWarden.SortNotesList();	
	GuildNotes_Update();
		
	frmGuildWardenInfo:Show();                            

end
function GuildAlButton_OnClick(self, button)	
	local InfoName = libGuildWarden.TempListMain["Alts"]["CountList"][self.index].Name;
	libGuildWarden.ShowUserBox(InfoName);
	libGuildWarden.HyperlinkClicked(self, "player:" .. InfoName .. ":STOP", nil, button);
end

function libGuildWarden.SetAlts(Name)
	libGuildWarden.SelectedName = Name;
	libGuildWarden.SelectedNameNote = Name;
	libGuildWarden.SortAltsList();
	GuildAlts_Update();
	frmGuildWardenAlts:Show();
	libGuildWarden.ShowUserBox(Name);
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

function libGuildWarden.SortAltsList()
local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
local LeftList = libGuildWarden.GetAlts(libGuildWarden.SelectedName);
local CountList= {};         
local Counter = 0;

		GuildWardenBannedBtn1:SetText("Забанить всех");

        local SelectID = libGuildWarden.ReturnID(libGuildWarden.SelectedName);
		if (libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][SelectID]) then
			if (libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][SelectID].Datebanned) then
				GuildWardenBannedBtn1:SetText("Разбанить");
			end
		end

for key, value in pairs(LeftList) do
    if (not GuildAltsShowGuiliesButton:GetChecked() or libGuildWardenSaveVar["Roster"][libGuildWarden.Realm][guildName][key]) then
		Counter = Counter  + 1;
		CountList[Counter] = {};
		CountList[Counter] = libGuildWarden.CloneSimpleTable(libGuildWarden.GetPlayerInfo(key));
		CountList[Counter].LVL = tonumber(CountList[Counter].LVL);
		if (not CountList[Counter].LVL) then
			CountList[Counter].LVL = 0;
		end 
		if (not CountList[Counter].Guild) then
			CountList[Counter].Guild = "Н/Д";
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

function libGuildWarden.SetAltsView()
	local GUILD_Alts_COLUMN_DATA = {};
	local stringsInfo = { };
	local stringOffset = 0;
	local haveIcon, haveBar;
	
	
	GUILD_Alts_COLUMN_DATA[1] = { width = 32, text = "Ур", stringJustify="CENTER", type = "LVL"};
	GUILD_Alts_COLUMN_DATA[2] = { width = 32, text = "Кл", hasIcon = true, type = "Class" };
	GUILD_Alts_COLUMN_DATA[3] = { width = 81, text = "Имя", stringJustify="LEFT", type = "Name" };
	GUILD_Alts_COLUMN_DATA[4] = { width = 144, text = "Гильдия", stringJustify="LEFT", type = "Guild" };	
    libGuildWarden.TempListMain["Alts"].sort = "Guild"
    libGuildWarden.TempListMain["Alts"].dir = "-"
	for columnIndex = 1, 4 do
			local columnButton = _G["GuildAltsColumnButton"..columnIndex];
            local columnData = GUILD_Alts_COLUMN_DATA[columnIndex];
            
			columnButton:SetText(columnData.text);			
			WhoFrameColumn_SetWidth(columnButton, columnData.width);
			columnButton:Show();
			
			-- by default the sort type should be the same as the column type
--[[			if ( columnData.sortType ) then
				columnButton.sortType = columnData.sortType;
			else
				columnButton.sortType = columnType;
			end ]]--
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
	--libGuildWarden.SortAltsList();	
	--GuildAlts_Update(); 

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

		libGuildWarden.DefaultShort(libGuildWarden.TempListMain["Alts"]);

 	for i = 1, numButtons do
		button = buttons[i];
		index = offset + i	
	
		
		if (CountList[tonumber(index)]) then
		    local Playerinfo = CountList[tonumber(index)];
		    
		    if (Playerinfo) then
				classFileName = libGuildWarden.GetClassFileName(Playerinfo.Class);
				if (classFileName) then
					if (classFileName == "DEATH") then
						classFileName = "DEATHKNIGHT";
						Playerinfo.Class = "Death Knight";
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


---------------------------------ALTS VIEW--------------------------------------
--------------------------------REALM VIEW--------------------------------------
function GuildRealmButton_OnClick(self, button)
	local AltsName = libGuildWarden.TempListMain["Realm"]["CountList"][self.index].Name;
	if (AltsName) then
		libGuildWarden.SetAlts(AltsName);
		libGuildWarden.HyperlinkClicked(self, "player:" .. AltsName .. ":STOP", nil, button);
	end
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
			if (not value.Dateremoved) then
				Counter = Counter  + 1;
				CountList[Counter] = {};
				CountList[Counter] = libGuildWarden.CloneSimpleTable(libGuildWarden.GetPlayerInfo(key));
				CountList[Counter].LVL = tonumber(CountList[Counter].LVL);				
				if (not CountList[Counter].Class) then
					CountList[Counter].Class = "??";
				end				
				if (not CountList[Counter].LVL) then
					CountList[Counter].LVL = 0;
				end
				if (not CountList[Counter].Guild) then
					CountList[Counter].Guild = "Н/Д";
				end
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
function libGuildWarden.SetRealmView()
	local GUILD_Realm_COLUMN_DATA = {};
	local stringsInfo = { };
	local stringOffset = 0;
	local haveIcon, haveBar;


	GUILD_Realm_COLUMN_DATA[1] = { width = 32, text = "Ур", stringJustify="CENTER", type = "LVL"};
	GUILD_Realm_COLUMN_DATA[2] = { width = 32, text = "Кл", hasIcon = true, type = "Class" };
	GUILD_Realm_COLUMN_DATA[3] = { width = 81, text = "Имя", stringJustify="LEFT", type = "Name" };
	GUILD_Realm_COLUMN_DATA[4] = { width = 144, text = "Гильдия", stringJustify="LEFT", type = "Guild" };
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

		libGuildWarden.DefaultShort(libGuildWarden.TempListMain["Realm"]);
		

 	for i = 1, numButtons do
		button = buttons[i];
		index = offset + i


		if (CountList[tonumber(index)]) then
		    local Playerinfo = CountList[tonumber(index)];

		    if (Playerinfo) then
				classFileName = libGuildWarden.GetClassFileName(Playerinfo.Class);
				if (classFileName) then
					if (classFileName == "DEATH") then
						classFileName = "DEATHKNIGHT";
						Playerinfo.Class = "Death Knight";
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
						libGuildWarden.SetPlayerInfo(Playerinfo.Name, "Guild", "Н/Д");
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



--end

--------------------------------REALM VIEW--------------------------------------
-------------------------GuildSharing VIEW--------------------------------------
function GuildGuildSharingButton_OnClick(self, button)
	local ToShow = "";
	
	local HavesndData = false;
	ToShow = ToShow  .. libGuildWarden.TempListMain["GuildSharing"]["CountList"][self.index].Name;
	ToShow = ToShow .. "\n";
	ToShow = ToShow  .. "Left: " .. libGuildWarden.TempListMain["GuildSharing"]["CountList"][self.index].Left ..
								" Joined: " .. libGuildWarden.TempListMain["GuildSharing"]["CountList"][self.index].Joined ..
								" Banned: " .. libGuildWarden.TempListMain["GuildSharing"]["CountList"][self.index].Banned ..
								" Realm: " .. libGuildWarden.TempListMain["GuildSharing"]["CountList"][self.index].Realm ..
								" Notes: " .. libGuildWarden.TempListMain["GuildSharing"]["CountList"][self.index].Notes;	
	ToShow = ToShow .. "\n";
	
	if (libGuildWarden.TempListMain["GuildSharing"]["CountList"][self.index].RealmUpdate) then
		ToShow = ToShow .. "Realm: " .. libGuildWarden.TempListMain["GuildSharing"]["CountList"][self.index].RealmUpdate ..
									" Banned: " .. libGuildWarden.TempListMain["GuildSharing"]["CountList"][self.index].BannedUpdate ..
									"\nNotes: " .. libGuildWarden.TempListMain["GuildSharing"]["CountList"][self.index].NotesUpdate;
		ToShow = ToShow .. "\n";									
		HavesndData = true;
	end
	if (libGuildWarden.TempListMain["GuildSharing"]["CountList"][self.index].Version) then
		ToShow = ToShow .. "Version: ".. libGuildWarden.TempListMain["GuildSharing"]["CountList"][self.index].Version;
	else
		if (HavesndData) then
			ToShow = ToShow .. "Version: 3.0.3";
		else
			ToShow = ToShow .. "Version: 3.0.2 or less";
		end
	end	
	
	
	libGuildWarden.YesNoFunction = nil;
	libGuildWarden.ShowPopUp(ToShow, "Close", "Close", true);	
end

function libGuildWarden.SortGuildSharingByColumn(column)
  if (libGuildWarden.TempListMain["GuildSharing"].sort == column.sortType) then
  	if (libGuildWarden.TempListMain["GuildSharing"].dir == "+") then
  		libGuildWarden.TempListMain["GuildSharing"].dir = "-";
  	else
  		libGuildWarden.TempListMain["GuildSharing"].dir = "+";
  	end
  else
		libGuildWarden.TempListMain["GuildSharing"].sort = column.sortType;
  end
  PlaySound("igMainMenuOptionCheckBoxOn");
  GuildGuildSharing_Update();
end

function libGuildWarden.SortGuildSharingList()
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	local LeftList = libGuildWarden.TempListMain["WardenUsers"];
	local CountList= {};
	local Counter = 0;

	for key, value in pairs(LeftList) do


			Counter = Counter  + 1;
			CountList[Counter] = {};
			CountList[Counter].Name = key;
			
			local SplitA = {strsplit(",",value)};
			CountList[Counter].Realm = tonumber(SplitA[1]);
			CountList[Counter].Left = tonumber(SplitA[2]);
			CountList[Counter].Joined = tonumber(SplitA[3]);
			CountList[Counter].Banned = tonumber(SplitA[4]);
			CountList[Counter].Notes = tonumber(SplitA[5]);
			CountList[Counter].RealmUpdate = SplitA[6];
			CountList[Counter].BannedUpdate = SplitA[7];
			CountList[Counter].NotesUpdate = SplitA[8];
			CountList[Counter].Version = SplitA[9];
			if (not  SplitA[9]) then
				CountList[Counter].Version = "3.0.3";
			end
			if (not SplitA[6] or not SplitA[7] or not SplitA[8]) then
				CountList[Counter].RealmUpdate = "??/??/??";
				CountList[Counter].BannedUpdate = "??/??/??";
				CountList[Counter].NotesUpdate = "??/??/??";
				CountList[Counter].Version = "3.0.2 or less";			
			end
			--CountList[Counter].Notes = tonumber(SplitA[5]);

	end
	-- "LVL"
	--"Cls"
	--"Name"
	--"Dateleft";
	--libGuildWardenSaveVar["Left"].dir
	--libGuildWardenSaveVar["Left"].sort

	libGuildWarden.TempListMain["GuildSharing"]["CountList"] = CountList;
	libGuildWarden.TempListMain["GuildSharing"].Max = Counter;
end
function libGuildWarden.SetGuildSharingView()
	local GUILD_GuildSharing_COLUMN_DATA = {};
	local stringsInfo = { };
	local stringOffset = 0;
	local haveIcon, haveBar;

	GUILD_GuildSharing_COLUMN_DATA[1] = { width = 81, text = "Name", stringJustify="LEFT", type = "Name" };
	GUILD_GuildSharing_COLUMN_DATA[2] = { width = 40, text = "Left", stringJustify="LEFT", type = "Left" };
	GUILD_GuildSharing_COLUMN_DATA[3] = { width = 40, text = "Jnd", stringJustify="LEFT", type = "Joined"};
	GUILD_GuildSharing_COLUMN_DATA[4] = { width = 40, text = "Bnd", stringJustify="LEFT", type = "Banned" };	
	GUILD_GuildSharing_COLUMN_DATA[5] = { width = 40, text = "Rlm", stringJustify="LEFT", type = "Realm" };	
	GUILD_GuildSharing_COLUMN_DATA[6] = { width = 55, text = "Version", stringJustify="LEFT", type = "Version" };	
	--288
    libGuildWarden.TempListMain["GuildSharing"].sort = "Name"
    libGuildWarden.TempListMain["GuildSharing"].dir = "-"
	for columnIndex = 1, 6 do
			local columnButton = _G["GuildGuildSharingColumnButton"..columnIndex];
            local columnData = GUILD_GuildSharing_COLUMN_DATA[columnIndex];

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

	local buttons = GuildGuildSharingContainer.buttons;
	local button, fontString;
	for buttonIndex = 1, #buttons do
		button = buttons[buttonIndex];
		for stringIndex = 1, 6 do
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
	libGuildWarden.SortGuildSharingList();
	GuildGuildSharing_Update();

end
function GuildGuildSharing_Update()
local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
local scrollFrame = GuildGuildSharingContainer;
local offset = HybridScrollFrame_GetOffset(scrollFrame);
local index;
local classFileName;
local buttons = scrollFrame.buttons;
local numButtons = #buttons;
local CountList = libGuildWarden.TempListMain["GuildSharing"]["CountList"];
local Counter = libGuildWarden.TempListMain["GuildSharing"].Max;


	libGuildWarden.DefaultShort(libGuildWarden.TempListMain["GuildSharing"]);


 	for i = 1, numButtons do
		button = buttons[i];
		index = offset + i


		if (CountList[tonumber(index)]) then
		    local Playerinfo = CountList[tonumber(index)];

		    if (Playerinfo) then
						button.icon:Hide();

                        libGuildWarden.SetStringTextColor(button.string1, Playerinfo.Name, 1, 1, 1);
                        libGuildWarden.SetStringTextColor(button.string2, Playerinfo.Left, 0.7, 0.65, 0);
                        libGuildWarden.SetStringTextColor(button.string3, Playerinfo.Joined, 0, 1, 0);
                        libGuildWarden.SetStringTextColor(button.string4, Playerinfo.Banned, 1, 0, 0);
						libGuildWarden.SetStringTextColor(button.string5, Playerinfo.Realm, 1, 1, 1);
						libGuildWarden.SetStringTextColor(button.string6, Playerinfo.Version, 0, 0, 1);

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



-------------------------GuildSharing VIEW--------------------------------------
-------------------------Notes VIEW--------------------------------------
function GuildNotesButton_OnClick(self, button)
		local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
		local ThisID = libGuildWarden.ReturnID(libGuildWarden.SelectedName);
		local LeftList = libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][ThisID];
	
		local SelectedNotes = libGuildWarden.TempListMain["Notes"]["CountList"][self.index];
	if (button == "LeftButton") then
		local ToShow = ""; 
		ToShow =  ToShow  .. libGuildWarden.SelectedName;
		ToShow =  ToShow  .. "\n";
		ToShow =  ToShow  .. SelectedNotes.Name .. ": " ..  SelectedNotes.Text;
		ToShow =  ToShow  .. "\n";
		ToShow =  ToShow  .. "Автор: " .. SelectedNotes.By .. " Дата: " .. SelectedNotes.Date;
		ToShow =  ToShow  .. "\n";
		ToShow =  ToShow  .. "Нажмите правой кнопкой для редактирования";		
		
		libGuildWarden.YesNoFunction = nil;
		libGuildWarden.ShowPopUp(ToShow, "Закрыть", "Закрыть", true);			
		
		libGuildWarden.HyperlinkClicked(self, "player:" .. SelectedNotes.Name .. ":STOP", nil, button);		
	else	
		if (not CanEditOfficerNote()) then
			libGuildWarden.YesNoFunction  = nil;
			libGuildWarden.ShowPopUp("Only officers can edit notes.", "Close", "Close", true);			
			return;
		end
		libGuildWarden.TempListMain["Notes"]["Selection"] = {};
		libGuildWarden.TempListMain["Notes"]["Selection"].Name = SelectedNotes.Name;
		libGuildWarden.TempListMain["Notes"]["Selection"].Text= SelectedNotes.Text
		libGuildWarden.TempListMain["Notes"]["Selection"].ID = ThisID;
		libGuildWarden.YesNoFunction  = function()
											local altsname = GuildWardenPopTextBox:GetText();
											local SplitA = {strsplit("/",date("%m/%d/%y %H.%M.%S"))};
											SplitA[2] = tonumber(SplitA[2]) - 1;
											SplitA = SplitA[1] .. "/" .. SplitA[2] .. "/" ..SplitA[3];												
											if (altsname ~= "Main" and altsname ~= "DELETE") then
												local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
												local ThisID = libGuildWarden.TempListMain["Notes"]["Selection"].ID;
												local ThisName = libGuildWarden.TempListMain["Notes"]["Selection"].Name;
												libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][ThisID][ThisName].Text = altsname;
												libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][ThisID][ThisName].Date = date("%m/%d/%y %H.%M.%S");
												libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][ThisID][ThisName].By = UnitName("player");
												libGuildWarden.SendText("Note changed!", true);	
												libGuildWardenSaveVar["Updates"]["Notes"] = date("%m/%d/%y %H.%M.%S");						
											else
												if  (altsname == "DELETE") then
													local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
													local ThisID = libGuildWarden.TempListMain["Notes"]["Selection"].ID;
													local ThisName = libGuildWarden.TempListMain["Notes"]["Selection"].Name;				
													libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][ThisID][ThisName] = {};
													libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][ThisID][ThisName].Removed  = date("%m/%d/%y %H.%M.%S");
													libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][ThisID][ThisName].By = UnitName("player");
													libGuildWarden.SendText("Note Deleted!", true);					
												end
											end
											libGuildWarden.SendSingalNotes(ThisID,  ThisName);
											libGuildWarden.SortNotesList();
											GuildNotes_Update();					
											
										end;
		libGuildWarden.ShowPopUp("Введите текст заметки \n Введите DELETE для удаления", "Обновить", "Отмена", false, SelectedNotes.Text);								
		
		
		
		--StaticPopup_Show ("GuildWarden_ChangeNote");
	end
					
	
--self.index

end
function libGuildWarden.SortNotesByColumn(column)
  if (libGuildWarden.TempListMain["Notes"].sort == column.sortType) then
  	if (libGuildWarden.TempListMain["Notes"].dir == "+") then
  		libGuildWarden.TempListMain["Notes"].dir = "-";
  	else
  		libGuildWarden.TempListMain["Notes"].dir = "+";
  	end
  else
		libGuildWarden.TempListMain["Notes"].sort = column.sortType;
  end
  PlaySound("igMainMenuOptionCheckBoxOn");
  GuildNotes_Update();
end

function libGuildWarden.SortNotesList()
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();	
	local ThisID = libGuildWarden.ReturnID(libGuildWarden.SelectedName);
	local LeftList = libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][ThisID];
	local CountList= {};
	local Counter = 0;
	if (LeftList) then
		for key, value in pairs(LeftList) do
           	if (key ~= "Main") then
				if (not value.Removed) then
					Counter = Counter  + 1;
					CountList[Counter] = {};
					CountList[Counter].Name = key;			
					CountList[Counter].Text = value.Text;
					CountList[Counter] = libGuildWarden.SetupDate(CountList[Counter], value.Date);
	
					CountList[Counter].By = value.By;
					CountList[Counter].ID = ThisID;
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

	libGuildWarden.TempListMain["Notes"]["CountList"] = CountList;
	libGuildWarden.TempListMain["Notes"].Max = Counter;
end
function libGuildWarden.SetNotesView()
	local GUILD_Notes_COLUMN_DATA = {};
	local stringsInfo = { };
	local stringOffset = 0;
	local haveIcon, haveBar;

	GUILD_Notes_COLUMN_DATA[1] = { width = 69, text = "Название", stringJustify="LEFT", type = "Name" };
	GUILD_Notes_COLUMN_DATA[2] = { width = 81, text = "Текст", stringJustify="LEFT", type = "Text" };
	GUILD_Notes_COLUMN_DATA[3] = { width = 69, text = "Дата", stringJustify="LEFT", type = "Date"};
	GUILD_Notes_COLUMN_DATA[4] = { width = 69, text = "Автор", stringJustify="LEFT", type = "By" };	
    libGuildWarden.TempListMain["Notes"].sort = "Name"
    libGuildWarden.TempListMain["Notes"].dir = "-"
	for columnIndex = 1, 4 do
			local columnButton = _G["GuildNotesColumnButton"..columnIndex];
            local columnData = GUILD_Notes_COLUMN_DATA[columnIndex];

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

	local buttons = GuildNotesContainer.buttons;
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
	--libGuildWarden.SortNotesList();
	--GuildNotes_Update();

end
function GuildNotes_Update()
local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
local scrollFrame = GuildNotesContainer;
local offset = HybridScrollFrame_GetOffset(scrollFrame);
local index;
local classFileName;
local buttons = scrollFrame.buttons;
local numButtons = #buttons;
local CountList = libGuildWarden.TempListMain["Notes"]["CountList"];
local Counter = libGuildWarden.TempListMain["Notes"].Max;



	if (libGuildWarden.TempListMain["Notes"].sort == "Date") then
		sort(CountList, function(a,b) return libGuildWarden.ShortByDate("Notes", a,b) end);
	else
		libGuildWarden.DefaultShort(libGuildWarden.TempListMain["Notes"]);
	end


 	for i = 1, numButtons do
		button = buttons[i];
		index = offset + i


		if (CountList[tonumber(index)]) then
		    local Playerinfo = CountList[tonumber(index)];

		    if (Playerinfo) then
						button.icon:Hide();

                        libGuildWarden.SetStringTextColor(button.string1, Playerinfo.Name, 1, 0, 0);
                        libGuildWarden.SetStringTextColor(button.string2, Playerinfo.Text, 0, 1, 0);
                        libGuildWarden.SetStringTextColor(button.string3, Playerinfo.Date, 1, 1, 1);
                        libGuildWarden.SetStringTextColor(button.string4, Playerinfo.By, 1, 1, 0);

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



-------------------------Notes VIEW--------------------------------------

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
	libGuildWarden.SetGuildSharingView();
	libGuildWarden.SetNotesView();
end