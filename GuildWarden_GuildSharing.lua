
function GuildWarden_SendTimerOnUpdate(self, elapsed)
	local Rate = 15;
	local bandwidthIn, bandwidthOut, latencyHome, latencyWorld = GetNetStats();
	if (GuildWardenSliderTH) then
		Rate = GuildWardenSliderTH:GetValue()
	end

	if (GW_ThrotalOption:GetChecked()) then
		if (latencyHome > 500 or latencyWorld > 500) then
			if (Rate > 7) then
				Rate = 7;
			end
		end

		if (latencyHome > 1000 or latencyWorld > 1000) then
			if (Rate > 1) then
				Rate = 1;
			end
		end
	end

	if (GuildWardenStatusUpdate2) then
		local Pre = (Rate/15) * 100;
		Pre = strsub(tostring(Pre), 1, 3);
		GuildWardenStatusUpdate2.value:SetText(Pre .. "%");
		GuildWardenStatusUpdate2:SetValue(Rate);
	end

	if (libGuildWarden.TempListMain["Sender"]) then
		local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
		local RealmName = libGuildWarden.Realm;
		if (libGuildWarden.TempListMain["Sender"].LimitGIn) then
			if (not libGuildWarden.TempListMain["Sender"].TimeGIn) then
				libGuildWarden.TempListMain["Sender"].TimeGIn = 0;
			end

			libGuildWarden.TempListMain["Sender"].TimeGIn = libGuildWarden.TempListMain["Sender"].TimeGIn + elapsed;
			local DiviLimt = libGuildWarden.TempListMain["Sender"].LimitGIn;
			if (libGuildWarden.TempListMain["Sender"].LimitGIn > libGuildWarden.GlobalReceivingRate) then
				libGuildWarden.TempListMain["Sender"].LimitGIn = libGuildWarden.GlobalReceivingRate;
			end

			if (libGuildWarden.TempListMain["Sender"].TimeGIn > 1) then
				if (GuildWardenStatusBarGlobalIn) then
					local Pre = (libGuildWarden.TempListMain["Sender"].LimitGIn/libGuildWarden.GlobalReceivingRate) * 100;
					GuildWardenStatusBarGlobalIn.sendto:SetText(DiviLimt .. " pre sec")
					Pre = strsub(tostring(Pre), 1, 3);
					GuildWardenStatusBarGlobalIn:SetStatusBarColor(0, 0.65, 0)
					if (libGuildWarden.TempListMain["Sender"].LimitGIn > libGuildWarden.GlobalReceivingRate*0.45) then
						GuildWardenStatusBarGlobalIn:SetStatusBarColor(0.7, 0.65, 0)
					end

					if (libGuildWarden.TempListMain["Sender"].LimitGIn > libGuildWarden.GlobalReceivingRate*0.75) then
						GuildWardenStatusBarGlobalIn:SetStatusBarColor(0.7, 0, 0)
					end
					GuildWardenStatusBarGlobalIn.value:SetText(Pre .. "%");
					GuildWardenStatusBarGlobalIn:SetValue(libGuildWarden.TempListMain["Sender"].LimitGIn);
				end
				libGuildWarden.TempListMain["Sender"].LimitGIn = 0;
				libGuildWarden.TempListMain["Sender"].TimeGIn = 0;
			end
		end

		if (libGuildWarden.TempListMain["Sender"].LimitJFL) then
			if (not libGuildWarden.TempListMain["Sender"].TimeJFL) then
				libGuildWarden.TempListMain["Sender"].TimeJFL = 0;
			end

			libGuildWarden.TempListMain["Sender"].TimeJFL = libGuildWarden.TempListMain["Sender"].TimeJFL + elapsed;
			local DiviLimt = libGuildWarden.TempListMain["Sender"].LimitJFL;
			if (libGuildWarden.TempListMain["Sender"].LimitJFL > libGuildWarden.GlobalSendingRate) then
				libGuildWarden.TempListMain["Sender"].LimitJFL = libGuildWarden.GlobalSendingRate;
			end

			if (libGuildWarden.TempListMain["Sender"].TimeJFL > 1) then
				if (GuildWardenStatusBarGlobal) then
					local Pre = (libGuildWarden.TempListMain["Sender"].LimitJFL/libGuildWarden.GlobalSendingRate) * 100;
					GuildWardenStatusBarGlobal.sendto:SetText(DiviLimt .. " pre sec")
					Pre = strsub(tostring(Pre), 1, 3);
					GuildWardenStatusBarGlobal:SetStatusBarColor(0, 0.65, 0)
					if (libGuildWarden.TempListMain["Sender"].LimitJFL > libGuildWarden.GlobalSendingRate*0.45) then
						GuildWardenStatusBarGlobal:SetStatusBarColor(0.7, 0.65, 0)
					end

					if (libGuildWarden.TempListMain["Sender"].LimitJFL > libGuildWarden.GlobalSendingRate*0.75) then
						GuildWardenStatusBarGlobal:SetStatusBarColor(0.7, 0, 0)
					end
					GuildWardenStatusBarGlobal.value:SetText(Pre .. "%");
					GuildWardenStatusBarGlobal:SetValue(libGuildWarden.TempListMain["Sender"].LimitJFL);
				end
				libGuildWarden.TempListMain["Sender"].LimitJFL = 0;
				libGuildWarden.TempListMain["Sender"].TimeJFL = 0;
			end
		end

		if (libGuildWarden.TempListMain["Sender"].Send == true) then
			local What = "None";
			if (libGuildWarden.TempListMain["Sender"].ListID == 1) then
				What = "Realm List";
			end

			if (libGuildWarden.TempListMain["Sender"].ListID == 2) then
				What = "Left List";
			end

			if (libGuildWarden.TempListMain["Sender"].ListID == 3) then
				What = "Joined List";
			end

			if (libGuildWarden.TempListMain["Sender"].ListID == 4) then
				What = "Banned List";
			end

			if (libGuildWarden.TempListMain["Sender"].ListID == 5) then
				What = "Note List";
			end

			local Max = 0;
			local CountList = libGuildWarden.TempListMain["Sender"]["CountList"];
			if (CountList) then
				Max = #CountList;
			end

			if (GuildWardenStatusBarSending) then
				GuildWardenStatusBarSending:SetMinMaxValues(0, Max);
			end

			if (libGuildWarden.TempListMain["Sender"].Count < Max) then
				libGuildWarden.TempListMain["Sender"].Time = libGuildWarden.TempListMain["Sender"].Time + elapsed;
				if (libGuildWarden.TempListMain["Sender"].Time > 1) then
					libGuildWarden.TempListMain["Sender"].Time = 0;
					libGuildWarden.TempListMain["Sender"].Limit = 0;
				end

				if (libGuildWarden.TempListMain["Sender"].Limit < Rate) then
					libGuildWarden.TempListMain["Sender"].Count = libGuildWarden.TempListMain["Sender"].Count + 1;
					if (GuildWardenStatusBarSending) then
						local Pre = (libGuildWarden.TempListMain["Sender"].Count/Max) * 100;
						Pre = strsub(tostring(Pre), 1, 3);
						GuildWardenStatusBarSending.value:SetText(Pre .. "%");
						GuildWardenStatusBarSending:SetValue(libGuildWarden.TempListMain["Sender"].Count);
						local SendingText = libGuildWarden.TempListMain["Sender"].GoingTo .."/" .. What;
						if (libGuildWarden.LastHelpNeed) then
							if (libGuildWarden.LastHelpNeed[libGuildWarden.TempListMain["Sender"].ListID]) then
								if (libGuildWarden.LastHelpNeed[libGuildWarden.TempListMain["Sender"].ListID].target == libGuildWarden.TempListMain["Sender"].GoingTo) then
									SendingText = SendingText .. " (" .. libGuildWarden.LastHelpNeed[libGuildWarden.TempListMain["Sender"].ListID].Count .. ")";
								end
							end
						end
						GuildWardenStatusBarSending.sendto:SetText(SendingText);
	 				end

					--libGuildWarden.TempListMain["Sender"].Limit = libGuildWarden.TempListMain["Sender"].Limit + 1;
					local tmpinfo = CountList[libGuildWarden.TempListMain["Sender"].Count];
					local DataToSend = libGuildWarden.TempListMain["Sender"].ListID .. "," .. libGuildWarden.TempListMain["Sender"].Count .. "," .. Max .. ",";

					for key, value in pairs(tmpinfo) do
						DataToSend = DataToSend .. key .. ":" .. value .. ",";
					end

					if (not libGuildWarden.IsPlayerOnline(libGuildWarden.TempListMain["Sender"].GoingTo)) then
						libGuildWarden.CloseSend();
						return;
					end

					if (strlen(DataToSend) < 250) then
						libGuildWarden.SendAddonMessage( "GW-List", DataToSend, "WHISPER", libGuildWarden.TempListMain["Sender"].GoingTo);
					else
						libGuildWarden.SendText("Skip: " .. tmpinfo.Name .. ". Text To Long", true);
					end
				end
			end

			if (libGuildWarden.TempListMain["Sender"].Count == Max) then
				libGuildWarden.CloseSend();
			end
		end

		if (libGuildWarden.TempListMain["Sender"].SentPing == true) then
			if (not libGuildWarden.TempListMain["Sender"].Time2) then
				libGuildWarden.TempListMain["Sender"].Time2 = 0;
			end

			if (GuildWardenStatusBarPing) then
				local Pre = (libGuildWarden.TempListMain["Sender"].Time2/30) * 100;
				Pre = strsub(tostring(Pre), 1, 3);
				GuildWardenStatusBarPing:SetMinMaxValues(0, 30);
				GuildWardenStatusBarPing.value:SetText(Pre .. "%");
				GuildWardenStatusBarPing:SetValue(libGuildWarden.TempListMain["Sender"].Time2);
				GuildWardenStatusBarPing.sendto:SetText("Ожидание...");
	 		end

			libGuildWarden.TempListMain["Sender"].Time2 = libGuildWarden.TempListMain["Sender"].Time2 + elapsed;
			if (libGuildWarden.TempListMain["Sender"].Time2 > 30) then
					libGuildWarden.SetPingToFalse();
			end
		end

		if (libGuildWarden.TempListMain["Sender"].INeed) then
			for index=1, 5 do
				if (libGuildWarden.TempListMain["Sender"]["INeed" .. index]) then
					if (not libGuildWarden.TempListMain["Sender"]["INeed" .. index].Timer) then
						libGuildWarden.TempListMain["Sender"]["INeed" .. index].Timer = 0;
					end

					libGuildWarden.TempListMain["Sender"]["INeed" .. index].Timer = libGuildWarden.TempListMain["Sender"]["INeed" .. index].Timer + elapsed;
					if (not libGuildWarden.IsPlayerOnline(libGuildWarden.TempListMain["Sender"]["INeed" .. index].Name) or libGuildWarden.TempListMain["Sender"]["INeed" .. index].Timer > 5) then
 						local BarSettings = _G["GuildWardenStatusBarReceiving" .. index];
 						libGuildWarden.TempListMain["Sender"].INeed	= nil;
						if (BarSettings) then
							BarSettings:SetMinMaxValues(0, 100);
							BarSettings:SetValue(0);
							BarSettings.value:SetText("0%");
							BarSettings.sendto:SetText("Free to Receive...");
	 					end

						libGuildWarden.TempListMain["Sender"]["INeed" .. index] = nil;
						libGuildWarden.ClearCantSink(index);
						libGuildWarden.SetPingToFalse();
					end
				end
			end
		end

		if (not libGuildWarden.TempListMain["Sender"].AutoTimer) then
			libGuildWarden.TempListMain["Sender"].AutoTimer = 900 - 30;
		end

		libGuildWarden.TempListMain["Sender"].AutoTimer = libGuildWarden.TempListMain["Sender"].AutoTimer + elapsed;
		if (GuildWardenStatusUpdate1) then
			local Pre = (libGuildWarden.TempListMain["Sender"].AutoTimer/900) * 100;
			Pre = strsub(tostring(Pre), 1, 3);
			local tmpTime = libGuildWarden.TempListMain["Sender"].AutoTimer / 60;
			tmpTime = (15 - tmpTime);
			tmpTime = strsub(tostring(tmpTime), 1, 4);
			GuildWardenStatusUpdate1.value:SetText(Pre .. "% " .. tmpTime .. " Mins");
			GuildWardenStatusUpdate1:SetValue(libGuildWarden.TempListMain["Sender"].AutoTimer);
		end

		if (libGuildWarden.TempListMain["Sender"].AutoTimer > 900) then
			libGuildWarden.TempListMain["Sender"].AutoTimer = 0;
			libGuildWarden.TempListMain["WardenUsers"] = {};
			libGuildWarden.SendMyPing();
		end
	end
end

function libGuildWarden.HookedSendAddonMessage(Id, Text, Type, target)
	-- If player send something from another addon count that as part of the speed limit!!!!
	if (libGuildWarden.Loaded < 1) then
		return;
	end

	if (not libGuildWarden.TempListMain["Sender"].LimitJFL) then
		libGuildWarden.TempListMain["Sender"].LimitJFL = 0;
	end

	libGuildWarden.TempListMain["Sender"].LimitJFL = libGuildWarden.TempListMain["Sender"].LimitJFL + 1;
	if (libGuildWarden.TempListMain["Sender"].Send == true) then
		libGuildWarden.TempListMain["Sender"].Limit = libGuildWarden.TempListMain["Sender"].Limit + 1;
	end
end

function libGuildWarden.SendSingalMain(MainID)
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	local CountList;
	NoteToS = "FAKE";
	if (MainID and NoteToS ~= "Main") then
	local List = libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][MainID];
		if (List) then
			CountList = {};
			CountList.Name = NoteToS;
			CountList.ID = MainID;
			CountList.Main = List.Main;
			libGuildWarden.SendGlobal(5, CountList);
		end
	end
end

function libGuildWarden.SendSingalNotes(MainID, NoteToS)
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	local CountList;
	if (MainID and NoteToS ~= "Main") then
	local List = libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][MainID];
		if (List) then
			local valuesub = List[NoteToS];
			if (valuesub) then
				CountList = {};
				CountList.Name = NoteToS;
				CountList.Removed = valuesub.Removed;
				CountList.Date = valuesub.Date;
				CountList.Text = valuesub.Text;
				CountList.By = valuesub.By;
				CountList.ID = MainID;
				CountList.Main = List.Main;
				libGuildWarden.SendGlobal(5, CountList);
			end
		end
	end
end

function libGuildWarden.SendSingalNotesByName(Name, NoteToS)
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	local MainID = libGuildWarden.ReturnID(Name);
	local CountList;
	if (MainID and NoteToS ~= "Main") then
		local List = libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][MainID];
		if (List) then
			local valuesub = List[NoteToS];
			if (valuesub) then
				CountList = {};
				CountList.Name = NoteToS;
				CountList.Removed = valuesub.Removed;
				CountList.Date = valuesub.Date;
				CountList.Text = valuesub.Text;
				CountList.By = valuesub.By;
				CountList.ID = MainID;
				CountList.Main = List.Main;
				libGuildWarden.SendGlobal(5, CountList);
			end
		end
	end
end

function libGuildWarden.SendSingalPlayer(Name)
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	local ItemToSend =	libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name]
	if (ItemToSend) then
		local CountList = {};
		CountList = {};
		CountList.Name = Name;
		CountList.ID = ItemToSend.ID;
		CountList.LVL = ItemToSend.LVL;
		CountList.Class = ItemToSend.Class;
		CountList.Race = ItemToSend.Race;
		CountList.TMPID = ItemToSend.TMPID;
		CountList.Faction = ItemToSend.Faction;
		libGuildWarden.SendGlobal(1, CountList);
	end
end

function libGuildWarden.SendSingalBanned(MainID)
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	local ItemToSend = libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][MainID]
	if (ItemToSend) then
		local CountList = {};
		CountList.Name = MainID;
		CountList.ID = MainID;
		CountList.Datebanned = ItemToSend.Datebanned;
		CountList.BannedReason = ItemToSend.BannedReason;
		CountList.BannedBy = ItemToSend.BannedBy;
		CountList.Dateremoved = ItemToSend.Dateremoved;
		CountList.RemovedBy = ItemToSend.RemovedBy;

		libGuildWarden.SendGlobal(4, CountList);
	end
end

function libGuildWarden.SendGlobal(WhatList, Table, prefix)
	if (not prefix) then
		prefix = "GW-List";
	end
	local DataToSend = WhatList .. "," .. 1 .. "," .. 1 .. ",";

	for key, value in pairs(Table) do
		DataToSend = DataToSend .. key .. ":" .. value .. ",";
	end

	if (strlen(DataToSend) < 250) then
		libGuildWarden.SendAddonMessage( prefix, DataToSend, "GUILD");
	else
		libGuildWarden.SendText("Skip: " .. tmpinfo.Name .. ". Text To Long", true);
	end
end

function libGuildWarden.CloseSend()
	libGuildWarden.TempListMain["Sender"].Send = false;
	libGuildWarden.SetPingToFalse();
	if (GuildWardenStatusBarSending) then
		GuildWardenStatusBarSending:SetMinMaxValues(0, 100);
		GuildWardenStatusBarSending:SetValue(0);
		GuildWardenStatusBarSending.value:SetText("0%");
		GuildWardenStatusBarSending.sendto:SetText("Готов к отправке");
	end
	libGuildWarden.SendAddonMessage("GW-HelpNo", "Done," .. libGuildWarden.TempListMain["Sender"].ListID, "WHISPER", libGuildWarden.TempListMain["Sender"].GoingTo);
end

function libGuildWarden.SetPingToFalse()
	libGuildWarden.TempListMain["Sender"].SentPing = false;
	libGuildWarden.TempListMain["Sender"].INeed	= nil;
	libGuildWarden.TempListMain["Sender"].Time2 = 0;
		if (GuildWardenStatusBarPing) then
			GuildWardenStatusBarPing:SetMinMaxValues(0, 100);
			GuildWardenStatusBarPing:SetValue(0);
			GuildWardenStatusBarPing.value:SetText("0%");
			GuildWardenStatusBarPing.sendto:SetText("Готов к пингу");
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

function libGuildWarden.GetUpdatedDates()
	local tmpOut = libGuildWardenSaveVar["Updates"]["Realm"] .. "," .. libGuildWardenSaveVar["Updates"]["Banned"]	.. "," ..	libGuildWardenSaveVar["Updates"]["Notes"];
	return tmpOut;
end

function libGuildWarden.SendMyPing()
	local bandwidthIn, bandwidthOut, latencyHome, latencyWorld = GetNetStats();
	if (not libGuildWarden.TempListMain["Sender"]) then
		return;
	end

	if (latencyHome > 700 or latencyWorld > 700) then
		return;
	end

 	if (libGuildWarden.TempListMain["Sender"].SentPing == false and libGuildWarden.TempListMain["Sender"].Send == false) then
		libGuildWarden.TempListMain["Sender"].SentPing = true;
		local Counter = libGuildWarden.GetLongPing();
		libGuildWarden.SendAddonMessage("GW-PingData", Counter, "GUILD");
		if (libGuildWarden.IsGuildLeader()) then
			--libGuildWarden.SendAddonMessage("GW-Notes", tostring(libGuildWardenSaveVar["Options"]["officersOption"]), "GUILD");
			--libGuildWarden.SendAddonMessage("GW-Auto", tostring(libGuildWardenSaveVar["Options"]["autoinviteOption"]), "GUILD");
			libGuildWarden.SendAutoInviteOp();
		end
	end
end

function libGuildWarden.StringtoTable(arg2)
	local TmpListin = {};
	local SplitGWList = {strsplit(",",arg2)};
	TmpListin.Type = tonumber(SplitGWList[1]);
	TmpListin.Count = SplitGWList[2];
	TmpListin.Max = SplitGWList[3];
	for index=4, #SplitGWList do
		local SplitGWItems = {strsplit(":",SplitGWList[index])};
		if (#SplitGWItems > 1) then
			if (SplitGWItems[2] ~= "" and SplitGWItems[1] ~= "") then
				TmpListin[SplitGWItems[1]] = SplitGWItems[2];
			end
		end
	end
	return TmpListin;
end

function libGuildWarden.SendAutoInviteOp()
	local CountList = libGuildWarden.GetScanner();
	libGuildWarden.SendGlobal(0, CountList, "GW-Auto");
end

function libGuildWarden.GetLongPing()
	local Counter	= libGuildWarden.GetMyPing();
	Counter = Counter .. libGuildWarden.GetUpdatedDates();
	if (libGuildWarden.Version) then
		Counter = Counter .. "," .. libGuildWarden.Version;
	end
	return Counter;
end

function libGuildWarden.SendAddonMessage(Id, Text, Type, target)
	if (libGuildWarden.Loaded == -7) then
		return;
	end

	if (not libGuildWarden.TempListMain["Sender"].Limit) then
		libGuildWarden.TempListMain["Sender"].Limit = 0;
	end

	if (target and Type == "WHISPER") then
		if (not libGuildWarden.IsPlayerOnline(target)) then
			return;
		end
	end

	if (Id == "GW-Help") then
		if (not libGuildWarden.LastHelpNeed) then
			libGuildWarden.LastHelpNeed = {};
		end

		if (not libGuildWarden.LastHelpConfirmed) then
			libGuildWarden.LastHelpConfirmed = {};
		end

		if (not libGuildWarden.LastHelpNeed[Text]) then
			libGuildWarden.LastHelpNeed[Text] = {};
			libGuildWarden.LastHelpNeed[Text].target = target;
			libGuildWarden.LastHelpNeed[Text].Count = 0;
		end

		if (libGuildWarden.LastHelpNeed[Text].target == target) then
			if (libGuildWarden.LastHelpNeed[Text].Count > 6) then
				if (not libGuildWarden.LastHelpConfirmed[Text]) then
					libGuildWarden.LastHelpConfirmed[Text] = true;
					if (GW_SinkOption:GetChecked()) then
						libGuildWarden.YesNoFunction	= nil;
						libGuildWarden.ShowPopUp("\nCan't Sink Data From: " .. target .. "\n list: " ..Text .. "\nTries: " .. libGuildWarden.LastHelpNeed[Text].Count , "Close", "Close", true);
					end
				end
				return;
			end
		else
			libGuildWarden.LastHelpNeed[Text] = {};
			libGuildWarden.LastHelpNeed[Text].target = target;
			libGuildWarden.LastHelpNeed[Text].Count = 0;
		end
		libGuildWarden.LastHelpNeed[Text].Count = libGuildWarden.LastHelpNeed[Text].Count + 1;
	end

	--libGuildWarden.TempListMain["Sender"].Limit = libGuildWarden.TempListMain["Sender"].Limit + 1;
	SendAddonMessage(Id, Text, Type, target);	--DEBUGING IS OFF
	--libGuildWarden.SendText("Debug Mode Is ON");
end

function libGuildWarden.ClearCantSink(Which)
	if (libGuildWarden.LastHelpConfirmed and libGuildWarden.LastHelpNeed) then
		if (not libGuildWarden.LastHelpConfirmed[Which]) then
			libGuildWarden.LastHelpNeed[Which] = nil;
		end
	end
end

function libGuildWarden.GetMyPing()
	local Outtext = "";
	local Counter = 0;
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	local WhatIveCounted = {};
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

		if (strlen(key) < 3) then
			Addthis = false;
		end

		if (value.Name) then
			if (strlen(value.Name) < 3) then
				Addthis = false;
			end
		else
			Addthis = false;
		end

		if (value.Dateremoved) then
			Addthis = false;
		end

		--or string.find(value.ID, ":")	or string.find(value.TMPID, ":")
		if (value.Name) then
			if (string.find(value.Name, ":") )then
				Addthis = false;
			end
		end

		if (value.ID) then
			if (string.find(value.ID, ":") )then
				Addthis = false;
			end
		end

		if (value.TMPID) then
			if (string.find(value.TMPID, ":") )then
				Addthis = false;
			end
		end

		if (Addthis == true) then
			if (not WhatIveCounted[key] and key == value.Name) then
				WhatIveCounted[key] = true;
				Counter = Counter	+ 1;
			end
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

		if (key) then
			if (string.find(key, ":") )then
				Addthis = false;
			end
		end

		if (value.Name) then
			if (string.find(value.Name, ":") )then
				Addthis = false;
			end
		end

		if (value.ID) then
			if (string.find(value.ID, ":") )then
				Addthis = false;
			end
		end

		if (value.TMPID) then
			if (string.find(value.TMPID, ":") )then
				Addthis = false;
			end
		end

		if (value.Dateremoved) then
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

			if (key) then
				if (string.find(key, ":") )then
					Addthis = false;
				end
			end

			if (value.Name) then
				if (string.find(value.Name, ":") )then
					Addthis = false;
				end
			end

			if (value.ID) then
				if (string.find(value.ID, ":") )then
					Addthis = false;
				end
			end

			if (value.TMPID) then
				if (string.find(value.TMPID, ":") )then
					Addthis = false;
				end
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

		if (key) then
			if (string.find(key, ":") )then
				Addthis = false;
			end
		end

		if (value.Name) then
			if (string.find(value.Name, ":") )then
				Addthis = false;
			end
		end

		if (value.ID) then
			if (string.find(value.ID, ":") )then
				Addthis = false;
			end
		end

		if (value.TMPID) then
			if (string.find(value.TMPID, ":") )then
				Addthis = false;
			end
		end

		if (Addthis == true) then
			Counter = Counter	+ 1;
		end
	end

	Outtext = Outtext .. Counter .. ","; 	
	Counter = 0;

	for key, value in pairs(libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName]) do
		local Addthis = true;
		if (not key) then
			Addthis = false;
		end

		if (key == "") then
			Addthis = false;
		end

		if (Addthis == true) then
			for keysub, valuesub in pairs(value) do
				if (keysub ~= "Main") then
					if (not valuesub.Removed and valuesub.Date) then
						Counter = Counter	+ 1;
					end
				end
			end
		end
	end

	Outtext = Outtext .. Counter .. ",";
	return Outtext;
end
