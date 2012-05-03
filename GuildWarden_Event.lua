function GuildWarden_OnEvent(self, event, ...)
	local arg1, arg2,arg3, arg4 = ...;
	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	if (event == "CHAT_MSG_GUILD") then
		if (libGuildWarden.Loaded < 1) then
			return;
		end
		--arg1 = "[" .. "FART" .. "]: " .. arg1;
		--libGuildWarden.SendText(arg1);
	end

	if ((event == "UPDATE_MOUSEOVER_UNIT") and GW_MouseOverOption:GetChecked())then
		local TargetsName = nil;
		local WhatCall = nil;
		WhatCall = "mouseover";
		TargetsName = UnitName("mouseover");

		if (not TargetsName) then
			return;
		end

		if (UnitPlayerControlled("mouseover")) then
			-- Make sure we aren't adding more than 1
			for i=1,GameTooltip:NumLines() do
				local mytext = _G["GameTooltipTextLeft" .. i];
				local text = mytext:GetText();
				if (text ~= nil) then
					if (strsub(text, 1, 5) == "Main:") then
						return;
					end
				end
			end
			libGuildWarden.MasterToolTip(TargetsName);
		end
	end

	if (event == "CHAT_MSG_SYSTEM") then
		if (libGuildWarden.Loaded < 1) then
			return;
		end

		local tmpName = strsub(arg1, strlen(arg1) - 22, strlen(arg1));
		if (tmpName == " is already in a guild.") then
			local tmpName = strsub(arg1, 1, strlen(arg1) - 22); 
			local numApplicants = GetNumGuildApplicants();
			for index=1,numApplicants do
				local WasDeclined = false;
				local name, level, class, _, _, _, _, _, _, _, isTank, isHealer, isDamage, comment, timeSince, timeLeft = GetGuildApplicantInfo(index);
				libGuildWarden.UpdateInfo(name, level, nil, class, nil);
				if (name == tmpName) then
					DeclineGuildApplicant(index);
					libGuildWarden.SendText(name .. " was declined (in a guild). " .. level .. ", " .. class);
				end
			end
		end

		local tmpName = {strsplit("]", arg1)};
		if (tmpName[2] ~= nil) then
			local tmpName2 = {strsplit("[", tmpName[1])};
			if (tmpName2[2] ~= nil) then
				local TargetsName = tmpName2[2];
				if (TargetsName) then
					local ThisID = libGuildWarden.ReturnID(TargetsName);
					if (ThisID and GW_WhoOption:GetChecked()) then
						local AltTable = libGuildWarden.GetAlts(TargetsName);
						local Count = 0;
						for key, value in pairs(AltTable) do
							Count = Count + 1;
						end

						if (libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][ThisID]) then
							if (libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][ThisID].Main) then
								libGuildWarden.SendText(libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][ThisID].Main);
								libGuildWarden.SendText("Number of Char(s): " .. Count);
							else
								libGuildWarden.SendText("Main Not Set");
								libGuildWarden.SendText("Number of Char(s): " .. Count);
							end
						else
							libGuildWarden.SendText("Main Not Set");
							libGuildWarden.SendText("Number of Char(s): " .. Count);
						end

						if (libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][ThisID]) then
							if (libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][ThisID].Datebanned) then
								libGuildWarden.SendText("WARNING! BANNED FROM GUILD");
								libGuildWarden.SendText("By: " .. libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][ThisID].BannedBy);
								libGuildWarden.SendText("When: " .. libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][ThisID].Datebanned);
								libGuildWarden.SendText("Reason: " .. libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][ThisID].BannedReason);
							end
						end
					end
					local tmpUpdater = {strsplit(" ", arg1)};
					local thmpThisPlayer = {};

					if (tmpUpdater[2] == "Level") then
						local tmpgetGuild1 = {strsplit(">", arg1)};
						local tmpgetGuild2 = {strsplit("<", tmpgetGuild1[1])};
						local tmpgetGuild = tmpgetGuild2[2];
						if (tmpgetGuild == nil) then
							tmpgetGuild = "н/д";
						end

						if ((tmpUpdater[5] == "Elf")) then
								thmpThisPlayer["LVL"] = tmpUpdater[3];
								thmpThisPlayer["Race"] = tmpUpdater[4] .. " " .. tmpUpdater[5];
								thmpThisPlayer["Class"] =tmpUpdater[6];
								thmpThisPlayer["Guild"] = tmpgetGuild;
								thmpThisPlayer["Date"] = date("%m/%d/%y %H.%M.%S");
						else
							if ((tmpUpdater[6] == "Knight")) then
								thmpThisPlayer["LVL"] = tmpUpdater[3];
								thmpThisPlayer["Race"] = tmpUpdater[4];
								thmpThisPlayer["Class"] = tmpUpdater[5] .. " " .. tmpUpdater[6];
								thmpThisPlayer["Guild"] = tmpgetGuild;
								thmpThisPlayer["Date"] = date("%m/%d/%y %H.%M.%S");
							else
								thmpThisPlayer["LVL"] = tmpUpdater[3];
								thmpThisPlayer["Race"] = tmpUpdater[4];
								thmpThisPlayer["Class"] = tmpUpdater[5];
								thmpThisPlayer["Guild"] = tmpgetGuild;
								thmpThisPlayer["Date"] = date("%m/%d/%y %H.%M.%S");
							end
						end
						libGuildWarden.UpdateInfo(TargetsName, thmpThisPlayer.LVL, thmpThisPlayer.Race, thmpThisPlayer.Class, thmpThisPlayer.Guild);
					end
				end
			end
		end

		local tmpName = {strsplit(" ", arg1)}; 
		if (tmpName[2] == "declines") then
			local numApplicants = GetNumGuildApplicants();
			if (numApplicants ~= 0) then
				for index=1,numApplicants do
					local name, level, class, _, _, _, _, _, _, _, isTank, isHealer, isDamage, comment, timeSince, timeLeft = GetGuildApplicantInfo(index);
					if (name == tmpName[1]) then
						DeclineGuildApplicant(index);
						if (libGuildWarden.GuildRequests.runloop == true) then
							-- because the loop is one less
							libGuildWarden.GuildRequests.runindex = libGuildWarden.GuildRequests.runindex - 1;
						end
						libGuildWarden.SendText(name .. " was declined (He declined the invite!). " .. level .. ", " .. class);
					end
				end
				--libGuildWarden.SendText(tmpName[1] .. "WHAT!!!");
			end
		end
	end

	if (event == "CHAT_MSG_ADDON") then
		if (libGuildWarden.Loaded < 1) then
			return;
		end

		local preFex = strsub(arg1, 1, 2);
		--[[
		local tmpmessage = tmpName['Name'] .. "^" .. tmpName['Guild'] .. "^" .. tmpName['Server'] .. "^" .. tmpName['Race'] .. "^" ..
						tmpName['Faction'].. "^" .. tmpName['LVL'] .. "^" .. tmpName['Class'] .. "^" .. tmpName['ID'] .. "^" ..
						tmpName['Date'];
		if (tmpName['TMPID'] ~=  nil) then
			tmpmessage = tmpmessage  .. "^" .. tmpName['TMPID'];
		end
		libWarden.SendShare("Warden-Player", tmpmessage);
		]]--

		if (not libGuildWarden.TempListMain["Sender"].LimitGIn) then
			libGuildWarden.TempListMain["Sender"].LimitGIn = 0;
		end

		libGuildWarden.TempListMain["Sender"].LimitGIn = libGuildWarden.TempListMain["Sender"].LimitGIn + 1;
		if (arg4 ~= UnitName("player") and arg1 == "Warden-Player") then
			--libGuildWarden.SendText("OLD DATA: " .. arg1 .. ", " .. arg2 .. ", From: " .. arg4);
			local SplitGWList = {strsplit("^",arg2)};
			if (#SplitGWList > 8) then
				if (not libGuildWardenSaveVar["PlayerInfo"][SplitGWList[3]]) then
					libGuildWardenSaveVar["PlayerInfo"][SplitGWList[3]] = {};
				end

				if (libGuildWardenSaveVar["PlayerInfo"][SplitGWList[3]][SplitGWList[1]]) then
					local DateA = "00/00/00";
					local DateB = "00/00/00";
					if (SplitGWList[9]) then
						DateA = SplitGWList[9];
					end

					if (libGuildWardenSaveVar["PlayerInfo"][SplitGWList[3]][SplitGWList[1]].Updated) then
						DateB = libGuildWardenSaveVar["PlayerInfo"][SplitGWList[3]][SplitGWList[1]].Updated;
					end
					if (libGuildWarden.CheckDate(DateA, DateB) == DateA) then
						--libGuildWarden.SendText("Old Overide " .. SplitGWList[1]);
						local TMPOLDate = {};
						TMPOLDate.Name = SplitGWList[1];
						TMPOLDate.Guild = SplitGWList[2];
						TMPOLDate.Server = SplitGWList[3];
						TMPOLDate.Race = SplitGWList[4];
						TMPOLDate.Faction = SplitGWList[5];
						TMPOLDate.LVL = SplitGWList[6];
						TMPOLDate.Class = SplitGWList[7];
						TMPOLDate.ID = SplitGWList[8];
						TMPOLDate.Updated = SplitGWList[9];
						if (SplitGWList[10]) then
							TMPOLDate.TMPID = SplitGWList[10];
						end
						libGuildWardenSaveVar["PlayerInfo"][SplitGWList[3]][SplitGWList[1]] = TMPOLDate;
					end
				else
					--libGuildWarden.SendText("New Overide " .. SplitGWList[1]);
					local TMPOLDate = {};
					TMPOLDate.Name = SplitGWList[1];
					TMPOLDate.Guild = SplitGWList[2];
					TMPOLDate.Server = SplitGWList[3];
					TMPOLDate.Race = SplitGWList[4];
					TMPOLDate.Faction = SplitGWList[5];
					TMPOLDate.LVL = SplitGWList[6];
					TMPOLDate.Class = SplitGWList[7];
					TMPOLDate.ID = SplitGWList[8];
					TMPOLDate.Updated = SplitGWList[9];
					if (SplitGWList[10]) then
						TMPOLDate.TMPID = SplitGWList[10];
					end
					libGuildWardenSaveVar["PlayerInfo"][SplitGWList[3]][SplitGWList[1]] = TMPOLDate;
				end
			end
			--libGuildWarden.SetPlayerInfo
			--libGuildWarden.ReturnID
		end

		if (arg4 == UnitName("player") and arg1 ~= "GW-List") then
			-- If player send something from another addon count that as part of the speed limit!!!!
			--[[
			if (libGuildWarden.TempListMain["Sender"].Send == true) then
				libGuildWarden.TempListMain["Sender"].Limit = libGuildWarden.TempListMain["Sender"].Limit + 1;
			end
			]]--
		end


		local MyName = UnitName("player");	
		if (preFex == "GW" and arg1 ~= "GW-List") then --
			--libGuildWarden.SendText(arg1 .. ", " .. arg2 .. ", From: " .. arg4);
		end  

		if (arg1 == "GW-PingData" or arg1 == "GW-Ping") then
			if (not libGuildWarden.TempListMain["WardenUsers"]) then
				libGuildWarden.TempListMain["WardenUsers"] = {};
			end

			libGuildWarden.TempListMain["WardenUsers"][arg4] = arg2;
			if (libGuildWarden.Loaded > 1) then
				if (frmGuildWardenSharing) then
					libGuildWarden.SortGuildSharingList();
					GuildGuildSharing_Update();
				end
			end  
			  
			libGuildWarden.SendMyPing();
			local SplitGWPing = {strsplit(",",arg2)};
			local MyPingSize = libGuildWarden.GetMyPing();
			local Counter  = libGuildWarden.GetLongPing();
			local SplitMYPing = {strsplit(",",Counter)};
			local SmallAmount = #SplitMYPing;
			if (#SplitGWPing < SmallAmount) then
				SmallAmount = #SplitGWPing;
			end

			--libGuildWarden.SendText(arg4 .. "," .. SmallAmount);
			for index=1, SmallAmount do
				if (SplitGWPing[index] and SplitMYPing[index]) then
					if (index < 6) then
						if (tonumber(SplitGWPing[index]) > tonumber(SplitMYPing[index])) then
							--if (index == 4) then
								if (not libGuildWarden.TempListMain["Sender"]["INeed" .. index]) then
									libGuildWarden.TempListMain["Sender"].INeed = true;
									libGuildWarden.TempListMain["Sender"]["INeed" .. index] = {};
									libGuildWarden.TempListMain["Sender"]["INeed" .. index].Name = arg4;
									libGuildWarden.SendAddonMessage("GW-Help", index, "WHISPER", arg4);	
									break;
								end
							--end
						end

						if (tonumber(SplitGWPing[index]) < tonumber(SplitMYPing[index])) then
							if (index == 1 or index == 2  or index == 4 or index == 5) then
								if (not libGuildWarden.TempListMain["Sender"]["INeed" .. index]) then
									libGuildWarden.TempListMain["Sender"].INeed = true;
									libGuildWarden.TempListMain["Sender"]["INeed" .. index] = {};
									libGuildWarden.TempListMain["Sender"]["INeed" .. index].Name = arg4;
									libGuildWarden.SendAddonMessage("GW-Help", index, "WHISPER", arg4);
									break;
								end
							end
						end
					else
						if (index > 8) then
							--libGuildWarden.SendText(arg4);
							if (index == 9 and libGuildWarden.UpdatedWarning == false) then
								if (libGuildWarden.CheckVersion(SplitMYPing[index], SplitGWPing[index])) then
									libGuildWarden.YesNoFunction  = nil;
									libGuildWarden.ShowPopUp("\nIt's very important to keep Guild Warden \nup-to date! You have version (" .. SplitMYPing[index] .. ")\nNew version out " .. SplitGWPing[index] .. ". From: " .. arg4, "Close", "Close", true);

									--libGuildWarden.SendText("(" .. SplitMYPing[index] .. ") New version out " .. SplitGWPing[index] .. ". From: " .. arg4);
									libGuildWarden.UpdatedWarning = true;
								end
							end
						else
							local DateA = SplitGWPing[index];
							local DateB = SplitMYPing[index];
							if (libGuildWarden.CheckDate(DateA, DateB) == DateA) then
								--1 4 5
								--6 7 8
								local ConvertIndex = 1;
								if (index == 7) then
									ConvertIndex = 4;
								end

								if (index == 8) then
									ConvertIndex = 5;
								end

								if (not libGuildWarden.TempListMain["Sender"]["INeed" .. ConvertIndex]) then
									libGuildWarden.TempListMain["Sender"].INeed = true;
									libGuildWarden.TempListMain["Sender"]["INeed" .. ConvertIndex] = {};
									libGuildWarden.TempListMain["Sender"]["INeed" .. ConvertIndex].Name = arg4;
									libGuildWarden.SendAddonMessage("GW-Help", ConvertIndex, "WHISPER", arg4);
									if (ConvertIndex == 1) then
										libGuildWarden.TempListMain["Sender"]["INeed" .. ConvertIndex].UpdateName = "Realm";
										libGuildWarden.TempListMain["Sender"]["INeed" .. ConvertIndex].UpdateDate = DateA;
									end

									if (ConvertIndex == 4) then
										libGuildWarden.TempListMain["Sender"]["INeed" .. ConvertIndex].UpdateName = "Banned";
										libGuildWarden.TempListMain["Sender"]["INeed" .. ConvertIndex].UpdateDate = DateA;
									end

									if (ConvertIndex == 5) then
										libGuildWarden.TempListMain["Sender"]["INeed" .. ConvertIndex].UpdateName = "Notes";
										libGuildWarden.TempListMain["Sender"]["INeed" .. ConvertIndex].UpdateDate = DateA;
									end
									break;
								end
							end
						end
					end
				end
			end
		end

		--libGuildWarden.SendAddonMessage("GW-Notes", libGuildWardenSaveVar["Options"]["officersOption"], "GUILD");
		if (arg1 == "GW-Notes" and arg4 ~= MyName) then
			--This is outdated from 3.3.1 and under...
			if (not libGuildWarden.IsGuildLeader()) then
				libGuildWarden.SendText("Your Guild Master has an outdated Guild Warden, lol!");
			end
		end

		if (arg1 == "GW-Auto" and arg4 ~= MyName) then
			if (not libGuildWarden.IsGuildLeader()) then
				local tmpOptions = libGuildWarden.StringtoTable(arg2);
				if (tmpOptions.Option == true) then
					libGuildWarden.SetScanner(tmpOptions)
				else
					libGuildWarden.SetScanner(tmpOptions, true);
				end
				libGuildWarden.SetCheckBoxs();
			end
		end

		if (arg1 == "GW-List" and arg4 ~= MyName) then
			libGuildWarden.TempListMain["Sender"].INeed = true;
			local SplitGWList = {strsplit(",",arg2)};
			local Type = tonumber(SplitGWList[1]);
			local Count = SplitGWList[2];
			local Max = SplitGWList[3];
			local TmpListin = {};
			if (not libGuildWarden.TempListMain["Sender"]["INeed" .. Type]) then
				libGuildWarden.TempListMain["Sender"]["INeed" .. Type] = {};
			end

			libGuildWarden.TempListMain["Sender"]["INeed" .. Type].Name = arg4;
			libGuildWarden.TempListMain["Sender"]["INeed" .. Type].Count = Count;
			libGuildWarden.TempListMain["Sender"]["INeed" .. Type].Max = Max;
			libGuildWarden.TempListMain["Sender"]["INeed" .. Type].Timer = 0;
			local BarSettings = _G["GuildWardenStatusBarReceiving" .. Type];
			if (BarSettings) then
				local What = "None";
				if (Type== 1) then
					What = "Realm List";
				end

				if (Type == 2) then
					What = "Left List";
				end

				if (Type == 3) then
					What = "Joined List";
				end

				if (Type == 4) then
					What = "Banned List";
				end

				if (Type == 5) then
					What = "Note List";
				end

				BarSettings:SetMinMaxValues(0, libGuildWarden.TempListMain["Sender"]["INeed" .. Type].Max);
				local Pre = (libGuildWarden.TempListMain["Sender"]["INeed" .. Type].Count/libGuildWarden.TempListMain["Sender"]["INeed" .. Type].Max) * 100;
				Pre = strsub(tostring(Pre), 1, 3);
				BarSettings.value:SetText(Pre .. "%");
				BarSettings:SetValue(libGuildWarden.TempListMain["Sender"]["INeed" .. Type].Count);
				BarSettings.sendto:SetText(libGuildWarden.TempListMain["Sender"]["INeed" .. Type].Name .."/" .. What);
			end

			for index=4, #SplitGWList do
				local SplitGWItems = {strsplit(":",SplitGWList[index])};
				if (#SplitGWItems > 1) then
					if (SplitGWItems[2] ~= "" and SplitGWItems[1] ~= "") then
						TmpListin[SplitGWItems[1]] = SplitGWItems[2];
					end
				end
			end

			local TheName = TmpListin.Name;
			local TheID = TmpListin.ID;
			if (not TheName) then
				return;
			end

			if (Type == 1) then
				if (not libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName]) then
					libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName] = TmpListin;	
				else
					--libGuildWarden.SendText(TheName);
					local DateA = "00/00/00";
					local DateB = "00/00/00";
					if (TmpListin.Updated) then
						DateA = TmpListin.Updated;
					end

					if (TmpListin.Dateremoved) then
						DateA = TmpListin.Dateremoved;
					end

					if (libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].Updated) then
						DateB = libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].Updated;
					end

					if (libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].Dateremoved) then
						DateB = libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].DateremovedDateremoved;
					end

					if (libGuildWarden.CheckDate(DateA, DateB) == DateA) then
						libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName] = TmpListin;
					else
						if (TmpListin.Dateremoved) and (libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].Updated and libGuildWarden.CheckDate(DateA, DateB) == "Equal") then
							libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName] = TmpListin;
						else
							if (not TmpListin.Dateremoved and not libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].Dateremoved) then
								libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].Name = TheName;
								if (TmpListin.ID) then
									if (TmpListin.ID ~= "??") then
										if (not libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].ID) then
											libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].ID = TmpListin.ID; 
										end

										if (libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].ID == "??") then
											libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].ID = TmpListin.ID;
										end
									end
								end

								if (TmpListin.TMPID) then
									if (TmpListin.TMPID ~= "??") then
										if (not libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].TMPID) then
											libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].TMPID = TmpListin.TMPID; 
										end

										if (libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].TMPID == "??") then
											libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].TMPID = TmpListin.TMPID;
										end
									end
								end

								if (TmpListin.LVL) then
									if (TmpListin.LVL ~= "??" and TmpListin.LVL ~= "0" and TmpListin.LVL ~= 0) then
										if (not libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].LVL) then
											libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].LVL = TmpListin.LVL;
										end

										if (libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].LVL == "??" or libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].LVL == "0" or libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].LVL == 0) then
											libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].LVL = TmpListin.LVL;
										end
									end
								end

								if (TmpListin.Class) then
									if (TmpListin.Class ~= "??") then
										if (not libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].Class) then
											libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].Class = TmpListin.Class;
										end

										if (libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].Class == "??") then
											libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].Class= TmpListin.Class;
										end
									end
								end

								if (TmpListin.Race) then
									if (TmpListin.Race ~= "??") then
										if (not libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].Race) then
											libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].Race = TmpListin.Race;
										end

										if (libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].Race == "??") then
											libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].Race= TmpListin.Race;
										end
									end
								end

								if (TmpListin.Faction) then
									if (TmpListin.Faction ~= "??") then
										if (not libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].Faction) then
											libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].Faction = TmpListin.Faction;
										end

										if (libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].Faction == "??") then
											libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][TheName].Faction= TmpListin.Faction;
										end
									end
								end
							end
						end
					end
				end
			end	

			if (Type == 2) then
				TmpListin.Name = nil;
				if (not libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName][TheName]) then
					libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName][TheName] = TmpListin;
				else
					local Accept = true;
					local ADL = libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName][TheName].Dateleft;
					local BDL = TmpListin.Dateleft;
					local CDL = libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName][TheName].Dateremoved;

					if (libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName][TheName].Dateremoved) then
						if (libGuildWarden.CheckDate(CDL, BDL) ~= BDL) then
							Accept = false;
						end
					end

					if (ADL and BDL and Accept) then
						if (libGuildWarden.CheckDate(ADL, BDL) == ADL) then
							libGuildWardenSaveVar["Left"][libGuildWarden.Realm][guildName][TheName] = TmpListin;
						end
					end
				end
			end

			if (Type == 3) then
				TmpListin.Name = nil;
				if (not libGuildWardenSaveVar["Joined"][libGuildWarden.Realm][guildName][TheName]) then
					libGuildWardenSaveVar["Joined"][libGuildWarden.Realm][guildName][TheName] = TmpListin;
				else
					local ADL = libGuildWardenSaveVar["Joined"][libGuildWarden.Realm][guildName][TheName].Datejoined;
					local BDL = TmpListin.Datejoined;
					if (ADL and BDL) then
						if (libGuildWarden.CheckDate(ADL, BDL) == ADL) then
							libGuildWardenSaveVar["Joined"][libGuildWarden.Realm][guildName][TheName] = TmpListin;
						end
					end
				end
			end

			if (Type == 4) then
				TmpListin.Name = nil;
				if (not libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][TheID]) then										  
					libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][TheID] = TmpListin;
				else
					local DateA = "00/00/00";
					local DateB = "00/00/00";
					if (TmpListin.Datebanned) then
						DateA = TmpListin.Datebanned;
					end

					if (TmpListin.Dateremoved) then
						DateA = TmpListin.Dateremoved;
					end	

					if (libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][TheID].Datebanned) then
						DateB = libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][TheID].Datebanned;
					end

					if (libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][TheID].Dateremoved) then
						DateB = libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][TheID].Dateremoved;
					end  						 																	

					if (libGuildWarden.CheckDate(DateA, DateB) == DateA) then	
						libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][TheID] = TmpListin;
					else
						if (TmpListin.Dateremoved) and (libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][TheID].Datebanned and libGuildWarden.CheckDate(DateA, DateB) == "Equal") then
							if (libGuildWarden.CheckDate(DateA, DateB) == "Equal") then
								libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][TheID] = TmpListin;
							end
						end
					end
				end
			end

			if (Type == 5) then
				if (not libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][TheID]) then
					libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][TheID] = {};
				end

				if (TheName ~= "FAKE") then
					if (not libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][TheID][TheName]) then
						libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][TheID][TheName] = {};
					end
				end

				if (not libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][TheID].Main) then
					libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][TheID].Main = TmpListin.Main;
				end

				if (TheName ~= "FAKE") then
					if (not libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][TheID][TheName]) then
						libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][TheID][TheName] = {};
						libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][TheID][TheName].Name = TheName;
						libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][TheID][TheName].By = TmpListin.By;
						libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][TheID][TheName].Date = TmpListin.Date;
						libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][TheID][TheName].Removed = TmpListin.Removed;
						libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][TheID][TheName].Text = TmpListin.Text;
					else
						local DateA = "00/00/00";
						local DateB = "00/00/00";
						if (TmpListin.Date) then
							DateA = TmpListin.Date;
						end

						if (TmpListin.Removed) then
							DateA = TmpListin.Removed;
						end	

						if (libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][TheID][TheName].Date) then
							DateB = libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][TheID][TheName].Date;
						end

						if (libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][TheID][TheName].Removed) then
							DateB = libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][TheID][TheName].Removed;
						end 

						if (libGuildWarden.CheckDate(DateA, DateB) == DateA) then	
							libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][TheID][TheName].Name = TheName;
							libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][TheID][TheName].By = TmpListin.By;
							libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][TheID][TheName].Date = TmpListin.Date;
							libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][TheID][TheName].Removed = TmpListin.Removed;
							libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][TheID][TheName].Text = TmpListin.Text						
						else
							if (TmpListin.Removed) and (libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][TheID][TheName].Date) then
								if (libGuildWarden.CheckDate(DateA, DateB) == "Equal") then
									libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][TheID][TheName].Name = TheName;
									libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][TheID][TheName].By = TmpListin.By;
									libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][TheID][TheName].Date = TmpListin.Date;
									libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][TheID][TheName].Removed = TmpListin.Removed;
									libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][TheID][TheName].Text = TmpListin.Text 
								end
							end
						end
					end
				end
			end
		end

		if (arg1 == "GW-HelpNo" and arg4 ~= MyName) then  
			libGuildWarden.TempListMain["Sender"].INeed	= nil;
			local SplitGWList = {strsplit(",",arg2)};
			if (SplitGWList[1] == "Done") then
				local BarSettings = _G["GuildWardenStatusBarReceiving" .. SplitGWList[2]];
				if (BarSettings) then
					BarSettings:SetMinMaxValues(0, 100);
					BarSettings:SetValue(0);
					BarSettings.value:SetText("0%");
					BarSettings.sendto:SetText("Free to Receive...");
					if (libGuildWarden.TempListMain["Sender"]["INeed" .. SplitGWList[2]].UpdateName and libGuildWarden.TempListMain["Sender"]["INeed" .. SplitGWList[2]].UpdateDate) then
						libGuildWardenSaveVar["Updates"][libGuildWarden.TempListMain["Sender"]["INeed" .. SplitGWList[2]].UpdateName] = libGuildWarden.TempListMain["Sender"]["INeed" .. SplitGWList[2]].UpdateDate;
					end
					libGuildWarden.TempListMain["Sender"]["INeed" .. SplitGWList[2]] = nil;
				end
				libGuildWarden.SetPingToFalse();
			else
				if (SplitGWList[1] == "Sorry") then
					if (SplitGWList[2]) then
						libGuildWarden.ClearCantSink(SplitGWList[2]);
					end
				end
			end
			libGuildWarden.SendMyPing();
		end 
	 
		if (arg1 == "GW-Help" and arg4 ~= MyName) then
			if (libGuildWarden.TempListMain["Sender"].Send == true) then
				libGuildWarden.SendAddonMessage("GW-HelpNo", "Sorry," .. arg2, "WHISPER", arg4);
			else
				local whatheneeds = tonumber(arg2);
				local CountList = {};
				local Counter = 0;
				if (whatheneeds == 1) then
					for key, value in pairs(libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm]) do
						local Addthis = true;
						--[[
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

						if (value.Dateremoved) then
							Addthis = true;
						end
						]]--

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

						if (value.Updated) then
							if (string.find(value.Updated, ":") )then
								libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][key].Updated = string.replace(value.Updated, ":", ".");
								value.Updated = libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][key].Updated;
							end
						end

						if (value.Dateremoved) then
							if (string.find(value.Dateremoved, ":") )then
								libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][key].Dateremoved = string.replace(value.Dateremoved, ":", ".");
								value.Dateremoved = libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][key].Dateremoved;
							end
						end

						if (Addthis == true) then	
							Counter = Counter  + 1;
							CountList[Counter] = {};
							CountList[Counter].Name = key;	
							CountList[Counter].ID = value.ID;
							CountList[Counter].LVL = value.LVL;
							CountList[Counter].Class = value.Class;
							CountList[Counter].Race = value.Race;
							CountList[Counter].TMPID = value.TMPID;
							CountList[Counter].Faction = value.Faction;
							CountList[Counter].Updated = value.Updated;
							CountList[Counter].Dateremoved = value.Dateremoved;
							if (not value.Updated and not value.Dateremoved) then
								CountList[Counter].Updated = "00/00/00 00.00.00";
							end
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
							Counter = Counter  + 1;
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
							Counter = Counter  + 1;
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
							Counter = Counter  + 1;
							CountList[Counter] = {};
							CountList[Counter].Name = key;
							CountList[Counter].ID = key;
							CountList[Counter].Datebanned = value.Datebanned;	
							CountList[Counter].BannedReason = value.BannedReason;	
							CountList[Counter].BannedBy = value.BannedBy;
							CountList[Counter].Dateremoved = value.Dateremoved;	
							CountList[Counter].RemovedBy = value.RemovedBy;
						end
					end
				end

				if (whatheneeds == 5) then
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
									Counter = Counter  + 1;
									CountList[Counter] = {};
									CountList[Counter].Name = keysub
									CountList[Counter].Removed = valuesub.Removed;	
									CountList[Counter].Date = valuesub.Date;	
									CountList[Counter].Text = valuesub.Text;
									CountList[Counter].By = valuesub.By;
									CountList[Counter].ID = key
									CountList[Counter].Main = value.Main;
								end
							end

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
		hooksecurefunc("SendAddonMessage", libGuildWarden.HookedSendAddonMessage) ;
		for index=1, 10 do
			local ChatFrameMe = _G["ChatFrame" .. index];
			if (ChatFrameMe) then
				ChatFrameMe:HookScript("OnHyperlinkClick", libGuildWarden.HyperlinkClicked) ;
				ChatFrameMe:HookScript("OnHyperlinkEnter", libGuildWarden.HyperlinkEnter) ;
				ChatFrameMe:HookScript("OnHyperlinkLeave", libGuildWarden.HyperlinkLeave) ;
			end
		end

		for i=1, 30, 1 do
			if (WhoFrame) then
				local nameTexts = _G['WhoFrameButton'..i];
				if (nameTexts) then
					nameTexts:HookScript("OnEnter", libGuildWarden.OnEnter) ;
					nameTexts:HookScript("OnLeave", libGuildWarden.HyperlinkLeave) ;
				end

				local nameTexts = _G['ChannelMemberButton'..i]
				if (nameTexts) then
					nameTexts:HookScript("OnEnter", libGuildWarden.OnEnter) ;
					nameTexts:HookScript("OnLeave", libGuildWarden.HyperlinkLeave) ;
				end
			end
		end

		--[[
		local CountList = {};
		local Counter = 0;
		for key, value in pairs(libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm]) do
				Counter = Counter  + 1;
				CountList[Counter] = {};
				CountList[Counter] = libGuildWarden.CloneSimpleTable(libGuildWarden.GetPlayerInfo(key));	
		end

		--libGuildWarden.SendData("Mymoney", CountList)
		]]--
		RegisterAddonMessagePrefix("GW-List");
		RegisterAddonMessagePrefix("GW-PingData");
		RegisterAddonMessagePrefix("GW-Notes");
		RegisterAddonMessagePrefix("GW-Auto");
		RegisterAddonMessagePrefix("GW-Help");
		RegisterAddonMessagePrefix("GW-HelpNo");

		libGuildWarden.Loaded = 0;
		libGuildWarden.SendText("Hello!", true);
	end
end
