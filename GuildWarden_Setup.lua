
function GuildWarden_Load(self)
	--libGuildWarden.Version = GetAddOnMetadata("Guild Warden", "Version")
	SlashCmdList["GuildWarden"] = GuildWarden_List_cmd;
	SLASH_GuildWarden1 = "/guildwarden";
	SLASH_GuildWarden2 = "/gw";
	SLASH_GuildWarden3 = "/warden";
	self:RegisterEvent("VARIABLES_LOADED");
	self:RegisterEvent("CHAT_MSG_ADDON");
	self:RegisterEvent("CHAT_MSG_SYSTEM");
	self:RegisterEvent("CHAT_MSG_GUILD");

	--self:RegisterEvent("UNIT_TARGET");
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT"); 
end

function GuildWarden_PopLoad(self)
	CreateFrame("button", "GuildWardenPopOk", frmGuildWardenPopup, "UIPanelButtonTemplate")
		GuildWardenPopOk:SetPoint("BOTTOM", frmGuildWardenPopup, "BOTTOM", -75, 10);
		GuildWardenPopOk:SetHeight(22);
		GuildWardenPopOk:SetWidth(100);
		GuildWardenPopOk:SetText("Ok");
		GuildWardenPopOk:SetScript("OnClick", function(self, button)
			frmGuildWardenPopup:Hide();
			if (libGuildWarden.YesNoFunction ~= nil) then
				libGuildWarden.YesNoFunction();
				if (frmGuildWardenAlts) then
					if (frmGuildWardenAlts:IsVisible()) then
						if (libGuildWarden.SelectedName) then
							libGuildWarden.SetAlts(libGuildWarden.SelectedName);
						end
					end
				end
				libGuildWarden.GetStatus();
			end
			libGuildWarden.YesNoFunction = nil;
			PlaySound("igMainMenuOptionCheckBoxOn");
		end);

	CreateFrame("button", "GuildWardenPopCancel", frmGuildWardenPopup, "UIPanelButtonTemplate")
		GuildWardenPopCancel:SetPoint("BOTTOM", frmGuildWardenPopup, "BOTTOM", 75, 10);
		GuildWardenPopCancel:SetHeight(22);
		GuildWardenPopCancel:SetWidth(100);
		GuildWardenPopCancel:SetText("Cancel");
		GuildWardenPopCancel:SetScript("OnClick", function(self, button)
			frmGuildWardenPopup:Hide();
			libGuildWarden.YesNoFunction = nil;
			PlaySound("igMainMenuOptionCheckBoxOn");
		end);

	CreateFrame("button", "GuildWardenPopClose", frmGuildWardenPopup, "UIPanelButtonTemplate")
		GuildWardenPopClose:SetPoint("BOTTOM", frmGuildWardenPopup, "BOTTOM", 0, 10);
		GuildWardenPopClose:SetHeight(22);
		GuildWardenPopClose:SetWidth(100);
		GuildWardenPopClose:SetText("Cancel");
		GuildWardenPopClose:SetScript("OnClick", function(self, button)
			frmGuildWardenPopup:Hide();
			libGuildWarden.YesNoFunction = nil;
			PlaySound("igMainMenuOptionCheckBoxOn");
		end);
		GuildWardenPopClose:Hide();

	CreateFrame("EditBox", "GuildWardenPopTextBox", frmGuildWardenPopup, "InputBoxTemplate")
		GuildWardenPopTextBox:SetPoint("TOP", frmGuildWardenPopup, "TOP", 0, -70);
		GuildWardenPopTextBox:SetHeight(22);
		GuildWardenPopTextBox:SetWidth(200);
 		GuildWardenPopTextBox:SetScript("OnTextChanged", function(self, isUserInput)
			local MyText = GuildWardenPopTextBox:GetText();
				MyText = string.gsub(MyText,":","");
				MyText = string.gsub(MyText,",","");
				MyText = string.gsub(MyText,"-","");
				MyText = string.gsub(MyText,"`","");
				MyText = string.gsub(MyText,"@","");

			GuildWardenPopTextBox:SetText(MyText);
		end);
		--GuildWardenPopCancelTextBox:SetAutoFocus(true);
		GuildWardenPopTextBox:Show();

	CreateFrame("button", "GuildWardenPopMoveBox", frmGuildWardenPopup, nil)
		GuildWardenPopMoveBox:SetPoint("TOP", frmGuildWardenPopup, "TOP", -7, 0);
		GuildWardenPopMoveBox:SetHeight(30);
		GuildWardenPopMoveBox:SetWidth(365);
		--GuildWardenPopCancelTextBox:SetAutoFocus(true);
		GuildWardenPopMoveBox:Show();

		frmGuildWardenPopup:SetMovable(true);
		GuildWardenPopMoveBox:SetScript("OnMouseDown", function(self, button)
			frmGuildWardenPopup:StartMoving();
			PlaySound("igMainMenuOptionCheckBoxOn");
		end);

		GuildWardenPopMoveBox:SetScript("OnMouseUp", function(self, button)
			frmGuildWardenPopup:StopMovingOrSizing();
			PlaySound("igMainMenuOptionCheckBoxOn");
		end);

	frmGuildWardenPopup:SetWidth(400);
	frmGuildWardenPopup:SetHeight(125);
	frmGuildWardenPopup:SetPoint("CENTER", UIParent, "CENTER", 0, 200);

	--libGuildWarden.ShowPopUp("Super Fun Test???");
end

function GuildWarden_OptionsLoad(panel)
	libGuildWarden.Version = GetAddOnMetadata("Warden", "Version")
	panel.okay = function (self)
		local red, green, blue = GuildWardenColorPicker:GetColorRGB();
		libGuildWardenSaveVar["Color"].red = red;
		libGuildWardenSaveVar["Color"].green = green;
		libGuildWardenSaveVar["Color"].blue = blue;

		libGuildWarden.SaveCheckBoxs();
		libGuildWarden.SetCheckBoxs();
	end

	panel.cancel =
	function (self)
		GuildWardenColorPicker:SetColorRGB(libGuildWardenSaveVar["Color"].red, libGuildWardenSaveVar["Color"].green, libGuildWardenSaveVar["Color"].blue);
		libGuildWarden.SetCheckBoxs();
	end

	panel.name = "Guild Warden " .. libGuildWarden.Version;

	InterfaceOptions_AddCategory(panel);

	CreateFrame("CheckButton", "GW_GlobalTalkOption", panel, "UICheckButtonTemplate")--InterfaceOptionsCheckButtonTemplate --UICheckButtonTemplate
		GW_GlobalTalkOption:SetPoint("TOPLEFT", panel, "TOPLEFT", 5, -5);
		GW_GlobalTalkOptionText:SetText("Let me talk, in chat window.");
		GW_GlobalTalkOption:Show();
		GW_GlobalTalkOption:SetChecked(true);

	CreateFrame("CheckButton", "GW_SystemTalkOption", panel, "UICheckButtonTemplate")--InterfaceOptionsCheckButtonTemplate --UICheckButtonTemplate
		GW_SystemTalkOption:SetPoint("TOPLEFT", GW_GlobalTalkOption, "BOTTOMLEFT", 25, 5);
		GW_SystemTalkOptionText:SetText("Let me tell you what i'm doing.");
		GW_SystemTalkOption:Show();
		GW_SystemTalkOption:SetChecked(true);

	CreateFrame("CheckButton", "GW_WhoOption", panel, "UICheckButtonTemplate")--InterfaceOptionsCheckButtonTemplate --UICheckButtonTemplate
		GW_WhoOption:SetPoint("TOPLEFT", GW_SystemTalkOption, "BOTTOMLEFT", 0, 5);
		GW_WhoOptionText:SetText("Let me tell you alts on system function. (log in, /who, ...)");
		GW_WhoOption:Show();
		GW_WhoOption:SetChecked(true);

	CreateFrame("CheckButton", "GW_SinkOption", panel, "UICheckButtonTemplate")--InterfaceOptionsCheckButtonTemplate --UICheckButtonTemplate
		GW_SinkOption:SetPoint("TOPLEFT", GW_WhoOption, "BOTTOMLEFT", 0, 5);
		GW_SinkOptionText:SetText("Let me tell you sink date fails.");
		GW_SinkOption:Show();
		GW_SinkOption:SetChecked(true);

	CreateFrame("CheckButton", "GW_ThrotalOption", panel, "UICheckButtonTemplate")--InterfaceOptionsCheckButtonTemplate --UICheckButtonTemplate
		GW_ThrotalOption:SetPoint("TOPLEFT", GW_SinkOption, "BOTTOMLEFT", -25, 5);
		GW_ThrotalOptionText:SetText("Let me throtal back sending when your laggy.");
		GW_ThrotalOption:Show();
		GW_ThrotalOption:SetChecked(true);

	CreateFrame("CheckButton", "GW_MouseOverOption", panel, "UICheckButtonTemplate")--InterfaceOptionsCheckButtonTemplate --UICheckButtonTemplate
		GW_MouseOverOption:SetPoint("TOPLEFT", GW_ThrotalOption, "BOTTOMLEFT", 0, 5);
		GW_MouseOverOptionText:SetText("Let me show mouse over tooltips.");
		GW_MouseOverOption:Show();
		GW_MouseOverOption:SetChecked(true);

	CreateFrame("CheckButton", "GW_guildMOTDOption", panel, "UICheckButtonTemplate")--InterfaceOptionsCheckButtonTemplate --UICheckButtonTemplate
		GW_guildMOTDOption:SetPoint("TOPLEFT", GW_MouseOverOption, "BOTTOMLEFT", 0, 5);
		GW_guildMOTDOptionText:SetText("Show Guild Message of the Day when I first log-in.");
		GW_guildMOTDOption:Show();
		GW_guildMOTDOption:SetChecked(true);

	CreateFrame("CheckButton", "GW_OfficersOption", panel, "UICheckButtonTemplate")--InterfaceOptionsCheckButtonTemplate --UICheckButtonTemplate
		GW_OfficersOption:SetPoint("TOPLEFT", GW_guildMOTDOption, "BOTTOMLEFT", 0, 5);
		GW_OfficersOptionText:SetText("Only officers can read notes. (GM Only)");
		GW_OfficersOption:Show();
		GW_OfficersOption:SetChecked(true);
		GW_OfficersOption:Disable()

	CreateFrame("CheckButton", "GW_AutoInviteOption", panel, "UICheckButtonTemplate")--InterfaceOptionsCheckButtonTemplate --UICheckButtonTemplate
		GW_AutoInviteOption:SetPoint("TOPLEFT", GW_OfficersOption, "BOTTOMLEFT", 0, 5);
		GW_AutoInviteOptionText:SetText("Only Guild Master can edit auto invite options. (GM Only)");
		GW_AutoInviteOption:Show();
		GW_AutoInviteOption:SetChecked(true);
		GW_AutoInviteOption:Disable()

	CreateFrame("CheckButton", "GW_InvitePopUp", panel, "UICheckButtonTemplate")--InterfaceOptionsCheckButtonTemplate --UICheckButtonTemplate
		GW_InvitePopUp:SetPoint("TOPLEFT", GW_AutoInviteOption, "BOTTOMLEFT", 0, 5);
		GW_InvitePopUpText:SetText("Show message box when someone new request to join the guild.");
		GW_InvitePopUp:Show();
		GW_InvitePopUp:SetChecked(true);
end

function libGuildWarden.SetupStatusBars()
	CreateFrame("StatusBar", "GuildWardenStatusBarSending", frmGuildWardenSharing)
		GuildWardenStatusBarSending:SetPoint("TOPRIGHT", frmGuildWardenSharing, "TOPRIGHT", -10, -25)
		GuildWardenStatusBarSending:SetWidth(200)
		GuildWardenStatusBarSending:SetHeight(20)
		GuildWardenStatusBarSending:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
		GuildWardenStatusBarSending:GetStatusBarTexture():SetHorizTile(false)
		GuildWardenStatusBarSending:GetStatusBarTexture():SetVertTile(false)
		GuildWardenStatusBarSending:SetStatusBarColor(0.65, 0, 0)

		GuildWardenStatusBarSending.bg = GuildWardenStatusBarSending:CreateTexture(nil, "BACKGROUND")
		GuildWardenStatusBarSending.bg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
		GuildWardenStatusBarSending.bg:SetAllPoints(true)
		GuildWardenStatusBarSending.bg:SetVertexColor(0.35, 0, 0)

		GuildWardenStatusBarSending.sendto = GuildWardenStatusBarSending:CreateFontString(nil, "OVERLAY")
		GuildWardenStatusBarSending.sendto:SetPoint("LEFT", GuildWardenStatusBarSending, "LEFT", 4, 0)
		GuildWardenStatusBarSending.sendto:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
		GuildWardenStatusBarSending.sendto:SetJustifyH("LEFT")
		GuildWardenStatusBarSending.sendto:SetShadowOffset(1, -1)
		GuildWardenStatusBarSending.sendto:SetTextColor(1, 1, 1)
		GuildWardenStatusBarSending.sendto:SetText("Готов к отправке")

		GuildWardenStatusBarSending.value = GuildWardenStatusBarSending:CreateFontString(nil, "OVERLAY")
		GuildWardenStatusBarSending.value:SetPoint("RIGHT", GuildWardenStatusBarSending, "LEFT", 0, 0)
		GuildWardenStatusBarSending.value:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
		GuildWardenStatusBarSending.value:SetJustifyH("LEFT")
		GuildWardenStatusBarSending.value:SetShadowOffset(1, -1)
		GuildWardenStatusBarSending.value:SetTextColor(0, 1, 0)
		GuildWardenStatusBarSending.value:SetText("0%")

		GuildWardenStatusBarSending.info = GuildWardenStatusBarSending:CreateFontString(nil, "OVERLAY")
		GuildWardenStatusBarSending.info:SetPoint("RIGHT", GuildWardenStatusBarSending, "LEFT", -45, 0)
		GuildWardenStatusBarSending.info:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
		GuildWardenStatusBarSending.info:SetJustifyH("LEFT")
		GuildWardenStatusBarSending.info:SetShadowOffset(1, -1)
		GuildWardenStatusBarSending.info:SetTextColor(1, 0, 0)
		GuildWardenStatusBarSending.info:SetText("Отправка:" )

		GuildWardenStatusBarSending:Show();

		GuildWardenStatusBarSending:SetMinMaxValues(0, 100);
		GuildWardenStatusBarSending:SetValue(0);


		local StatusBar = CreateFrame("StatusBar", "GuildWardenStatusBarReceiving1", frmGuildWardenSharing)
			StatusBar:SetPoint("TOPRIGHT", GuildWardenStatusBarSending, "BOTTOMRIGHT", 0, -10)
			StatusBar:SetWidth(200)
			StatusBar:SetHeight(20)
			StatusBar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
			StatusBar:GetStatusBarTexture():SetHorizTile(false)
			StatusBar:GetStatusBarTexture():SetVertTile(false)
			StatusBar:SetStatusBarColor(0, 0, 0.65)

			StatusBar.bg = StatusBar:CreateTexture(nil, "BACKGROUND")
			StatusBar.bg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
			StatusBar.bg:SetAllPoints(true)
			StatusBar.bg:SetVertexColor(0, 0, 0.35)

			StatusBar.sendto = StatusBar:CreateFontString(nil, "OVERLAY")
			StatusBar.sendto:SetPoint("LEFT", StatusBar, "LEFT", 4, 0)
			StatusBar.sendto:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
			StatusBar.sendto:SetJustifyH("LEFT")
			StatusBar.sendto:SetShadowOffset(1, -1)
			StatusBar.sendto:SetTextColor(1, 1, 1)
			StatusBar.sendto:SetText("Готов к получению")

			StatusBar.value = StatusBar:CreateFontString(nil, "OVERLAY")
			StatusBar.value:SetPoint("RIGHT", StatusBar, "LEFT", 0, 0)
			StatusBar.value:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
			StatusBar.value:SetJustifyH("LEFT")
			StatusBar.value:SetShadowOffset(1, -1)
			StatusBar.value:SetTextColor(0, 1, 0)
			StatusBar.value:SetText("0%")

			StatusBar.info = StatusBar:CreateFontString(nil, "OVERLAY")
			StatusBar.info:SetPoint("RIGHT", StatusBar, "LEFT", -45, 0)
			StatusBar.info:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
			StatusBar.info:SetJustifyH("LEFT")
			StatusBar.info:SetShadowOffset(1, -1)
			StatusBar.info:SetTextColor(0, 0, 1)
			StatusBar.info:SetText("Получение:" )

			StatusBar:Show();

			StatusBar:SetMinMaxValues(0, 100);
			StatusBar:SetValue(0);

		for index=2, 5 do
			StatusBar = CreateFrame("StatusBar", "GuildWardenStatusBarReceiving" .. index, frmGuildWardenSharing)
			StatusBar:SetPoint("TOPRIGHT", "GuildWardenStatusBarReceiving" .. (index - 1), "BOTTOMRIGHT", 0, 0)
			StatusBar:SetWidth(200)
			StatusBar:SetHeight(20)
			StatusBar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
			StatusBar:GetStatusBarTexture():SetHorizTile(false)
			StatusBar:GetStatusBarTexture():SetVertTile(false)
			StatusBar:SetStatusBarColor(0, 0, 0.65)

			StatusBar.bg = StatusBar:CreateTexture(nil, "BACKGROUND")
			StatusBar.bg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
			StatusBar.bg:SetAllPoints(true)
			StatusBar.bg:SetVertexColor(0, 0, 0.35)

			StatusBar.sendto = StatusBar:CreateFontString(nil, "OVERLAY")
			StatusBar.sendto:SetPoint("LEFT", StatusBar, "LEFT", 4, 0)
			StatusBar.sendto:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
			StatusBar.sendto:SetJustifyH("LEFT")
			StatusBar.sendto:SetShadowOffset(1, -1)
			StatusBar.sendto:SetTextColor(1, 1, 1)
			StatusBar.sendto:SetText("Готов к получению")

			StatusBar.value = StatusBar:CreateFontString(nil, "OVERLAY")
			StatusBar.value:SetPoint("RIGHT", StatusBar, "LEFT", 0, 0)
			StatusBar.value:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
			StatusBar.value:SetJustifyH("LEFT")
			StatusBar.value:SetShadowOffset(1, -1)
			StatusBar.value:SetTextColor(0, 1, 0)
			StatusBar.value:SetText("0%")

			StatusBar.info = StatusBar:CreateFontString(nil, "OVERLAY")
			StatusBar.info:SetPoint("RIGHT", StatusBar, "LEFT", -45, 0)
			StatusBar.info:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
			StatusBar.info:SetJustifyH("LEFT")
			StatusBar.info:SetShadowOffset(1, -1)
			StatusBar.info:SetTextColor(0, 0, 1)
			StatusBar.info:SetText("Получение:" )

			StatusBar:Show();

			StatusBar:SetMinMaxValues(0, 100);
			StatusBar:SetValue(0);
		end


		StatusBar = CreateFrame("StatusBar", "GuildWardenStatusBarPing", frmGuildWardenSharing)
			StatusBar:SetPoint("TOPRIGHT", GuildWardenStatusBarReceiving5, "BOTTOMRIGHT", 0, -10)
			StatusBar:SetWidth(200)
			StatusBar:SetHeight(20)
			StatusBar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
			StatusBar:GetStatusBarTexture():SetHorizTile(false)
			StatusBar:GetStatusBarTexture():SetVertTile(false)
			StatusBar:SetStatusBarColor(0, 0.65, 0)

			StatusBar.bg = StatusBar:CreateTexture(nil, "BACKGROUND")
			StatusBar.bg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
			StatusBar.bg:SetAllPoints(true)
			StatusBar.bg:SetVertexColor(0, 0.35, 0)

			StatusBar.sendto = StatusBar:CreateFontString(nil, "OVERLAY")
			StatusBar.sendto:SetPoint("LEFT", StatusBar, "LEFT", 4, 0)
			StatusBar.sendto:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
			StatusBar.sendto:SetJustifyH("LEFT")
			StatusBar.sendto:SetShadowOffset(1, -1)
			StatusBar.sendto:SetTextColor(1, 1, 1)
			StatusBar.sendto:SetText("Готов к пингу")

			StatusBar.value = StatusBar:CreateFontString(nil, "OVERLAY")
			StatusBar.value:SetPoint("RIGHT", StatusBar, "LEFT", 0, 0)
			StatusBar.value:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
			StatusBar.value:SetJustifyH("LEFT")
			StatusBar.value:SetShadowOffset(1, -1)
			StatusBar.value:SetTextColor(0, 1, 0)
			StatusBar.value:SetText("0%")

			StatusBar.info = StatusBar:CreateFontString(nil, "OVERLAY")
			StatusBar.info:SetPoint("RIGHT", StatusBar, "LEFT", -45, 0)
			StatusBar.info:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
			StatusBar.info:SetJustifyH("LEFT")
			StatusBar.info:SetShadowOffset(1, -1)
			StatusBar.info:SetTextColor(0, 1, 0)
			StatusBar.info:SetText("Пинг:" )

			StatusBar:Show();

			StatusBar:SetMinMaxValues(0, 100);
			StatusBar:SetValue(0);

		StatusBar = CreateFrame("StatusBar", "GuildWardenStatusUpdate1", frmGuildWardenSharing)
			StatusBar:SetPoint("TOPRIGHT", GuildWardenStatusBarPing, "BOTTOMRIGHT", 0, -53)
			StatusBar:SetWidth(frmGuildWardenSharing:GetWidth() - 25)
			StatusBar:SetHeight(10)
			StatusBar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
			StatusBar:GetStatusBarTexture():SetHorizTile(false)
			StatusBar:GetStatusBarTexture():SetVertTile(false)
			StatusBar:SetStatusBarColor(0, 0.65, 0)

			StatusBar.bg = StatusBar:CreateTexture(nil, "BACKGROUND")
			StatusBar.bg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
			StatusBar.bg:SetAllPoints(true)
			StatusBar.bg:SetVertexColor(0, 0.35, 0)

			StatusBar.value = StatusBar:CreateFontString(nil, "OVERLAY")
			StatusBar.value:SetPoint("CENTER", StatusBar, "CENTER", 0, 0)
			StatusBar.value:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
			StatusBar.value:SetJustifyH("LEFT")
			StatusBar.value:SetShadowOffset(1, -1)
			StatusBar.value:SetTextColor(1, 1, 1)
			StatusBar.value:SetText("0%")

			StatusBar:Show();

			StatusBar:SetMinMaxValues(0, 900);
			StatusBar:SetValue(0);

		local Slider = CreateFrame("Slider", "GuildWardenSliderTH", frmGuildWardenSharing, "OptionsSliderTemplate")
			Slider:SetPoint("TOPRIGHT", GuildWardenStatusBarPing, "BOTTOMRIGHT", 0, -10)
			Slider:SetWidth(200)
			Slider:SetHeight(20)

			Slider:SetMinMaxValues(1, 15);
			Slider:SetValue(libGuildWardenSaveVar["SendSpeed"]);


			Slider.info = Slider:CreateFontString(nil, "OVERLAY")
			Slider.info:SetPoint("RIGHT", Slider, "LEFT", -5, 0)
			Slider.info:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
			Slider.info:SetJustifyH("LEFT")
			Slider.info:SetShadowOffset(1, -1)
			Slider.info:SetTextColor(1, 0, 0)
			Slider.info:SetText("Скорость отправки:" )

			Slider.rate = Slider:CreateFontString(nil, "OVERLAY")
			Slider.rate:SetPoint("TOP", Slider, "BOTTOM", 0, -5)
			Slider.rate:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
			Slider.rate:SetJustifyH("LEFT")
			Slider.rate:SetShadowOffset(1, -1)
			Slider.rate:SetTextColor(1, 1, 1)
			Slider.rate:SetText("Отправка займёт 10 минут" ) 
			--Slider:SetValueStep(1);
			Slider:SetScript("OnValueChanged", function(self, value)
				libGuildWarden.CalSpeed(value);
				libGuildWardenSaveVar["SendSpeed"] = value;
			end);

			Slider:Show();

		StatusBar = CreateFrame("StatusBar", "GuildWardenStatusUpdate2", frmGuildWardenSharing)
			StatusBar:SetPoint("CENTER", GuildWardenSliderTH, "CENTER", 0, 0)
			StatusBar:SetWidth(180)
			StatusBar:SetHeight(10)
			StatusBar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
			StatusBar:GetStatusBarTexture():SetHorizTile(false)
			StatusBar:GetStatusBarTexture():SetVertTile(false)
			StatusBar:SetStatusBarColor(0.65, 0, 0)

			StatusBar.bg = StatusBar:CreateTexture(nil, "BACKGROUND")
			StatusBar.bg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
			StatusBar.bg:SetAllPoints(true)
			StatusBar.bg:SetVertexColor(0.35, 0, 0)

			StatusBar.value = StatusBar:CreateFontString(nil, "OVERLAY")
			StatusBar.value:SetPoint("CENTER", StatusBar, "CENTER", 0, 0)
			StatusBar.value:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
			StatusBar.value:SetJustifyH("LEFT")
			StatusBar.value:SetShadowOffset(1, -1)
			StatusBar.value:SetTextColor(1, 1, 1)
			StatusBar.value:SetText("0%")

			StatusBar:Show();

			StatusBar:SetMinMaxValues(0, 15);
			StatusBar:SetValue(0);

		StatusBar = CreateFrame("StatusBar", "GuildWardenStatusBarGlobal", frmGuildWardenSharing)
			StatusBar:SetPoint("BOTTOM", frmGuildWardenSharing, "BOTTOM", 80, 30)
			StatusBar:SetWidth(150)
			StatusBar:SetHeight(10)
			StatusBar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
			StatusBar:GetStatusBarTexture():SetHorizTile(false)
			StatusBar:GetStatusBarTexture():SetVertTile(false)
			StatusBar:SetStatusBarColor(0.65, 0, 0)

			StatusBar.bg = StatusBar:CreateTexture(nil, "BACKGROUND")
			StatusBar.bg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
			StatusBar.bg:SetAllPoints(true)
			StatusBar.bg:SetVertexColor(0.35, 0, 0)

			StatusBar.sendto = StatusBar:CreateFontString(nil, "OVERLAY")
			StatusBar.sendto:SetPoint("LEFT", StatusBar, "LEFT", 4, 0)
			StatusBar.sendto:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
			StatusBar.sendto:SetJustifyH("LEFT")
			StatusBar.sendto:SetShadowOffset(1, -1)
			StatusBar.sendto:SetTextColor(1, 1, 1)
			StatusBar.sendto:SetText("0 в сек.")

			StatusBar.value = StatusBar:CreateFontString(nil, "OVERLAY")
			StatusBar.value:SetPoint("RIGHT", StatusBar, "LEFT", 0, 0)
			StatusBar.value:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
			StatusBar.value:SetJustifyH("LEFT")
			StatusBar.value:SetShadowOffset(1, -1)
			StatusBar.value:SetTextColor(0, 1, 0)
			StatusBar.value:SetText("0%")
			StatusBar.tooltipTitle = "Скорость отправки"
			StatusBar.tooltipText = "показывает отправку данных всех аддонов"
			StatusBar:SetScript("OnEnter", function(self)
								GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
								GameTooltip:AddLine(self.tooltipTitle);			
								GameTooltip:AddLine( HIGHLIGHT_FONT_COLOR_CODE .. self.tooltipText .. FONT_COLOR_CODE_CLOSE);	
								GameTooltip:Show();
							end)
			StatusBar:SetScript("OnLeave", function(self) GameTooltip_Hide() end)
			StatusBar:Show();

			StatusBar:SetMinMaxValues(0, libGuildWarden.GlobalSendingRate);
			StatusBar:SetValue(0);

		StatusBar = CreateFrame("StatusBar", "GuildWardenStatusBarGlobalIn", frmGuildWardenSharing)
			StatusBar:SetPoint("BOTTOM", frmGuildWardenSharing, "BOTTOM", 80, 12)
			StatusBar:SetWidth(150)
			StatusBar:SetHeight(10)
			StatusBar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
			StatusBar:GetStatusBarTexture():SetHorizTile(false)
			StatusBar:GetStatusBarTexture():SetVertTile(false)
			StatusBar:SetStatusBarColor(0, 0, 0.65)

			StatusBar.bg = StatusBar:CreateTexture(nil, "BACKGROUND")
			StatusBar.bg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
			StatusBar.bg:SetAllPoints(true)
			StatusBar.bg:SetVertexColor(0, 0, 0.35)

			StatusBar.sendto = StatusBar:CreateFontString(nil, "OVERLAY")
			StatusBar.sendto:SetPoint("LEFT", StatusBar, "LEFT", 4, 0)
			StatusBar.sendto:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
			StatusBar.sendto:SetJustifyH("LEFT")
			StatusBar.sendto:SetShadowOffset(1, -1)
			StatusBar.sendto:SetTextColor(1, 1, 1)
			StatusBar.sendto:SetText("0 per sec")

			StatusBar.value = StatusBar:CreateFontString(nil, "OVERLAY")
			StatusBar.value:SetPoint("RIGHT", StatusBar, "LEFT", 0, 0)
			StatusBar.value:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
			StatusBar.value:SetJustifyH("LEFT")
			StatusBar.value:SetShadowOffset(1, -1)
			StatusBar.value:SetTextColor(0, 1, 0)
			StatusBar.value:SetText("0%")
			StatusBar.tooltipTitle = "Скорость получения"
			StatusBar.tooltipText = "показывает получение данных всеми аддонами"
			StatusBar:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
				GameTooltip:AddLine(self.tooltipTitle);			
				GameTooltip:AddLine( HIGHLIGHT_FONT_COLOR_CODE .. self.tooltipText .. FONT_COLOR_CODE_CLOSE);	
				GameTooltip:Show();
			end)

			StatusBar:SetScript("OnLeave", function(self) GameTooltip_Hide() end)
			StatusBar:Show();

			StatusBar:SetMinMaxValues(0, libGuildWarden.GlobalReceivingRate);
			StatusBar:SetValue(0);

			libGuildWarden.CalSpeed(libGuildWardenSaveVar["SendSpeed"]);
end

function libGuildWarden.SetUpSideBar()
	frmGuildWardenAlts:SetParent(GuildFrame);
	frmGuildWardenAlts:SetPoint("BOTTOMLEFT", GuildFrame, "BOTTOMRIGHT", 0, -15);
	GuildAltsContainer.update = GuildAlts_Update;
	HybridScrollFrame_CreateButtons(GuildAltsContainer, "GuildAltsButtonTemplate", 0, 0, "TOPLEFT", "TOPLEFT", 0, -2, "TOP", "BOTTOM");
	GuildAltsContainerScrollBar.doNotHide = true;

	CreateFrame("button", "GuildWardenAddBtn1", frmGuildWardenAlts, "UIPanelButtonTemplate")
		GuildWardenAddBtn1:SetPoint("TOPLEFT", frmGuildWardenAlts, "BOTTOMLEFT", 0, 0);
		GuildWardenAddBtn1:SetHeight(22);
		GuildWardenAddBtn1:SetWidth(130);
		GuildWardenAddBtn1:SetText("Добавить альта");
		GuildWardenAddBtn1:SetScript("OnClick", function(self, button)

			libGuildWarden.SelectedMainsName = libGuildWarden.SelectedName;
			libGuildWarden.YesNoFunction	= function()
				local altsname = GuildWardenPopTextBox:GetText();
				local Mainsname = libGuildWarden.SelectedMainsName;
				local tmpinfo = libGuildWarden.GetPlayerInfo(Mainsname);
				local subString = strsub(altsname, 1, 1);
				local NsubString = strsub(altsname, 2, strlen(altsname));

				if (strlower(strupper(subString) .. strlower(NsubString)) ==	strlower(altsname)) then
					altsname = strupper(subString) .. strlower(NsubString);
				end

				local tmpALTinfo = libGuildWarden.GetPlayerInfo(altsname);
				local NumberAlts = libGuildWarden.GetAlts(altsname);
				local NumberMains = libGuildWarden.GetAlts(Mainsname);
				local Count = 0;
				local Solved = nil;
				for key, value in pairs(NumberAlts) do
					Count = Count + 1;
				end

				NumberAlts = Count;
				Count = 0;
				for key, value in pairs(NumberMains) do
					Count = Count + 1;
				end

				NumberMains = Count;
				-- To catch errors in merging
				if (tmpALTinfo) then
					if (tmpALTinfo.ID and tmpALTinfo.ID ~= "??") then
						if (tmpinfo.ID and tmpinfo.ID ~= "??") then
							libGuildWarden.YesNoFunction	= nil;
							libGuildWarden.ShowPopUp("Both chars have Warden data \n Can't Add Sorry" , "Закрыть", "Закрыть", true);
							return;
						else
							--Revers what they want me to do
							libGuildWarden.SetPlayerInfo(Mainsname, "TMPID", tmpALTinfo.ID);
							Solved = true;
						end
					else
						if (tmpALTinfo.TMPID and tmpALTinfo.TMPID ~= "??") then
							if (NumberMains < 2 and NumberAlts > 1) then
								--Revers what they want me to do
								libGuildWarden.SetPlayerInfo(Mainsname, "TMPID", tmpALTinfo.TMPID);
								Solved = true;
							end
						end
					end
				end
				-- To catch errors in merging

				if (not Solved) then
					if (tmpinfo.ID and tmpinfo.ID ~= "??") then
						libGuildWarden.SetPlayerInfo(altsname, "TMPID", tmpinfo.ID);
					else
						if (tmpinfo.TMPID and tmpinfo.TMPID ~= "??") then
							libGuildWarden.SetPlayerInfo(altsname, "TMPID", tmpinfo.TMPID);
						else
							local NewID = libGuildWarden.MakeUserID(Mainsname);
							libGuildWarden.SetPlayerInfo(altsname, "TMPID", NewID);
							--libGuildWarden.SendText("New ID made for " .. Mainsname .. ". ID: " .. NewID, true);
						end
					end
				end

				libGuildWarden.SendSingalPlayer(altsname);
				libGuildWarden.SelectedName = Mainsname;
				libGuildWarden.SortAltsList();
				GuildAlts_Update();
				libGuildWardenSaveVar["Updates"]["Realm"] = date("%m/%d/%y %H.%M.%S");
			end;

			libGuildWarden.ShowPopUp("Введите имя альта \n" .. libGuildWarden.SelectedMainsName, "Добавить", "Отмена");
			--StaticPopup_Show ("GuildWarden_AddAlt")
		end);

	CreateFrame("button", "GuildWardenBannedBtn1", frmGuildWardenAlts, "UIPanelButtonTemplate")
		GuildWardenBannedBtn1:SetPoint("TOPLEFT", GuildWardenAddBtn1, "TOPRIGHT", 0, 0);
		GuildWardenBannedBtn1:SetHeight(22);
		GuildWardenBannedBtn1:SetWidth(120);
		GuildWardenBannedBtn1:SetText("Забанить всех");
		GuildWardenBannedBtn1:SetScript("OnClick", function(self, button)
			if (GuildWardenBannedBtn1:GetText() == "Забанить всех") then
				libGuildWarden.SelectedMainsName = libGuildWarden.SelectedName;
				--StaticPopup_Show ("GuildWarden_AddBanned")
				libGuildWarden.YesNoFunction = function()
					local reason = GuildWardenPopTextBox:GetText();
					local Mainsname = libGuildWarden.SelectedMainsName;
					libGuildWarden.BanPlayer(Mainsname, reason);
				end;
				libGuildWarden.ShowPopUp("Введите причину бана \n" ..libGuildWarden.SelectedName, "Бан", "Отмена");
			else
				libGuildWarden.SelectedMainsName = libGuildWarden.SelectedName;
				libGuildWarden.YesNoFunction = function()
					libGuildWarden.RemoveBanPlayer(libGuildWarden.SelectedMainsName);
				end;
				libGuildWarden.ShowPopUp("Remove ban on \n" ..libGuildWarden.SelectedMainsName .. "\nIf you do, you can't not ban again for 2 days", "Remove!", "Cancel", true);
			end
		end);

		GuildNotesContainer.update = GuildNotes_Update;
		HybridScrollFrame_CreateButtons(GuildNotesContainer, "GuildNotesButtonTemplate", 0, 0, "TOPLEFT", "TOPLEFT", 0, -2, "TOP", "BOTTOM");
		GuildNotesContainerScrollBar.doNotHide = true;

		frmGuildWardenInfo:SetParent(GuildFrame);
		frmGuildWardenInfo:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 0, 0);
		frmGuildWardenInfo:SetHeight(424 - 150);
		frmGuildWardenInfo:SetWidth(338);
		frmGuildWardenInfo:Hide();

		libGuildWarden.SetupLabels();

		libGuildWarden.SetAltsView();
		libGuildWarden.SetNotesView();
end

function libGuildWarden.SetupLabels()
	frmGuildWardenInfo.CharGuild = frmGuildWardenInfo:CreateFontString(nil, "OVERLAY")
	frmGuildWardenInfo.CharGuild:SetPoint("TOP", frmGuildWardenInfo, "TOP", 0, -25)
	frmGuildWardenInfo.CharGuild:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
	frmGuildWardenInfo.CharGuild:SetJustifyH("LEFT")
	frmGuildWardenInfo.CharGuild:SetShadowOffset(1, -1)
	frmGuildWardenInfo.CharGuild:SetTextColor(1, 1, 0)
	frmGuildWardenInfo.CharGuild:SetText("<No Guild>")

	frmGuildWardenInfo.CharMain = frmGuildWardenInfo:CreateFontString(nil, "OVERLAY")
	frmGuildWardenInfo.CharMain:SetPoint("TOP", frmGuildWardenInfo, "TOP", 0, -45)
	frmGuildWardenInfo.CharMain:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
	frmGuildWardenInfo.CharMain:SetJustifyH("LEFT")
	frmGuildWardenInfo.CharMain:SetShadowOffset(1, -1)
	frmGuildWardenInfo.CharMain:SetTextColor(1, 1, 0)
	frmGuildWardenInfo.CharMain:SetText("[Not Set]")

	frmGuildWardenInfo.CharName = frmGuildWardenInfo:CreateFontString(nil, "OVERLAY")
	frmGuildWardenInfo.CharName:SetPoint("TOPLEFT", frmGuildWardenInfo, "TOPLEFT", 10, -65)
	frmGuildWardenInfo.CharName:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
	frmGuildWardenInfo.CharName:SetJustifyH("LEFT")
	frmGuildWardenInfo.CharName:SetShadowOffset(1, -1)
	frmGuildWardenInfo.CharName:SetTextColor(1, 1, 0)
	frmGuildWardenInfo.CharName:SetText("Name: No Name")

	frmGuildWardenInfo.CharLVL = frmGuildWardenInfo:CreateFontString(nil, "OVERLAY")
	frmGuildWardenInfo.CharLVL:SetPoint("TOPLEFT", frmGuildWardenInfo.CharName, "BOTTOMLEFT", 0, -2)
	frmGuildWardenInfo.CharLVL:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
	frmGuildWardenInfo.CharLVL:SetJustifyH("LEFT")
	frmGuildWardenInfo.CharLVL:SetShadowOffset(1, -1)
	frmGuildWardenInfo.CharLVL:SetTextColor(1, 1, 0)
	frmGuildWardenInfo.CharLVL:SetText("Level: 0") 

	frmGuildWardenInfo.CharJoined = frmGuildWardenInfo:CreateFontString(nil, "OVERLAY")
	frmGuildWardenInfo.CharJoined:SetPoint("TOPLEFT", frmGuildWardenInfo.CharLVL, "BOTTOMLEFT", 0, -2)
	frmGuildWardenInfo.CharJoined:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
	frmGuildWardenInfo.CharJoined:SetJustifyH("LEFT")
	frmGuildWardenInfo.CharJoined:SetShadowOffset(1, -1)
	frmGuildWardenInfo.CharJoined:SetTextColor(1, 1, 0)
	frmGuildWardenInfo.CharJoined:SetText("Joined: NA")

	frmGuildWardenInfo.CharBanned = frmGuildWardenInfo:CreateFontString(nil, "OVERLAY")
	frmGuildWardenInfo.CharBanned:SetPoint("TOPLEFT", frmGuildWardenInfo.CharJoined, "BOTTOMLEFT", 0, -2)
	frmGuildWardenInfo.CharBanned:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
	frmGuildWardenInfo.CharBanned:SetJustifyH("LEFT")
	frmGuildWardenInfo.CharBanned:SetShadowOffset(1, -1)
	frmGuildWardenInfo.CharBanned:SetTextColor(1, 0, 0)
	frmGuildWardenInfo.CharBanned:SetText("Banned: NA")

	frmGuildWardenInfo.CharBannedBy = frmGuildWardenInfo:CreateFontString(nil, "OVERLAY")
	frmGuildWardenInfo.CharBannedBy:SetPoint("TOPLEFT", frmGuildWardenInfo.CharBanned, "BOTTOMLEFT", 0, -2)
	frmGuildWardenInfo.CharBannedBy:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
	frmGuildWardenInfo.CharBannedBy:SetJustifyH("LEFT")
	frmGuildWardenInfo.CharBannedBy:SetShadowOffset(1, -1)
	frmGuildWardenInfo.CharBannedBy:SetTextColor(1, 0, 0)
	frmGuildWardenInfo.CharBannedBy:SetText("Banned By: NA") 

	frmGuildWardenInfo.CharBannedR = frmGuildWardenInfo:CreateFontString(nil, "OVERLAY")
	frmGuildWardenInfo.CharBannedR:SetPoint("TOPLEFT", frmGuildWardenInfo.CharBannedBy, "BOTTOMLEFT", 0, -2)
	frmGuildWardenInfo.CharBannedR:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
	frmGuildWardenInfo.CharBannedR:SetJustifyH("LEFT")
	frmGuildWardenInfo.CharBannedR:SetShadowOffset(1, -1)
	frmGuildWardenInfo.CharBannedR:SetTextColor(1, 0, 0)
	frmGuildWardenInfo.CharBannedR:SetText("Reason: NA") 								 

	frmGuildWardenInfo.CharFaction = frmGuildWardenInfo:CreateFontString(nil, "OVERLAY")
	frmGuildWardenInfo.CharFaction:SetPoint("TOPRIGHT", frmGuildWardenInfo, "TOPRIGHT", -5, -65)
	frmGuildWardenInfo.CharFaction:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
	frmGuildWardenInfo.CharFaction:SetJustifyH("LEFT")
	frmGuildWardenInfo.CharFaction:SetShadowOffset(1, -1)
	frmGuildWardenInfo.CharFaction:SetTextColor(1, 1, 0)
	frmGuildWardenInfo.CharFaction:SetText("Фракция: н/д")

	frmGuildWardenInfo.CharClass = frmGuildWardenInfo:CreateFontString(nil, "OVERLAY")
	frmGuildWardenInfo.CharClass:SetPoint("TOPRIGHT", frmGuildWardenInfo.CharFaction, "BOTTOMRIGHT", 0, -2)
	frmGuildWardenInfo.CharClass:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
	frmGuildWardenInfo.CharClass:SetJustifyH("LEFT")
	frmGuildWardenInfo.CharClass:SetShadowOffset(1, -1)
	frmGuildWardenInfo.CharClass:SetTextColor(1, 1, 0)
	frmGuildWardenInfo.CharClass:SetText("Класс: н/д")
	 
	frmGuildWardenInfo.CharRace = frmGuildWardenInfo:CreateFontString(nil, "OVERLAY")
	frmGuildWardenInfo.CharRace:SetPoint("TOPRIGHT", frmGuildWardenInfo.CharClass, "BOTTOMRIGHT", 0, -2)
	frmGuildWardenInfo.CharRace:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
	frmGuildWardenInfo.CharRace:SetJustifyH("LEFT")
	frmGuildWardenInfo.CharRace:SetShadowOffset(1, -1)
	frmGuildWardenInfo.CharRace:SetTextColor(1, 1, 0)
	frmGuildWardenInfo.CharRace:SetText("Раса: н/д")

	frmGuildWardenInfo.CharLeft = frmGuildWardenInfo:CreateFontString(nil, "OVERLAY")
	frmGuildWardenInfo.CharLeft:SetPoint("TOPRIGHT", frmGuildWardenInfo.CharRace, "BOTTOMRIGHT", 0, -2)
	frmGuildWardenInfo.CharLeft:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
	frmGuildWardenInfo.CharLeft:SetJustifyH("LEFT")
	frmGuildWardenInfo.CharLeft:SetShadowOffset(1, -1)
	frmGuildWardenInfo.CharLeft:SetTextColor(1, 1, 0)
	frmGuildWardenInfo.CharLeft:SetText("Дата ухода: н/д")

	frmGuildWardenInfo.CharRank = frmGuildWardenInfo:CreateFontString(nil, "OVERLAY")
	frmGuildWardenInfo.CharRank:SetPoint("TOPRIGHT", frmGuildWardenInfo.CharLeft, "BOTTOMRIGHT", 0, -2)
	frmGuildWardenInfo.CharRank:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
	frmGuildWardenInfo.CharRank:SetJustifyH("LEFT")
	frmGuildWardenInfo.CharRank:SetShadowOffset(1, -1)
	frmGuildWardenInfo.CharRank:SetTextColor(1, 1, 0)
	frmGuildWardenInfo.CharRank:SetText("Звание: н/д")

 	CreateFrame("button", "GuildWardenSetMain", frmGuildWardenInfo, "UIPanelButtonTemplate")
		GuildWardenSetMain:SetPoint("BOTTOMLEFT", frmGuildWardenInfo, "BOTTOMLEFT", 10, 10);
		GuildWardenSetMain:SetHeight(22);
		GuildWardenSetMain:SetWidth(110);
		GuildWardenSetMain:SetText("Сделать мейном");
		GuildWardenSetMain:SetScript("OnClick", function(self, button)
			libGuildWarden.YesNoFunction = function()
				local Name = string.gsub(frmGuildWardenInfo.CharName:GetText(),"Имя: ","");
				local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
				local ID = nil;
				ID = libGuildWarden.ReturnID(Name);
				if (not ID) then
					ID = libGuildWarden.MakeUserID(Name);
				end			 

				if (not libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][ID]) then
					libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][ID] = {};
				end		 
				libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][ID].Main = Name;
				libGuildWarden.ShowUserBox(Name);
				libGuildWarden.SendSingalMain(ID);
				libGuildWardenSaveVar["Updates"]["Notes"] = date("%m/%d/%y %H.%M.%S");
				libGuildWarden.SendText(Name .. " назначен мейном", true);
			end;
			libGuildWarden.ShowPopUp("Назначить ".. string.gsub(frmGuildWardenInfo.CharName:GetText(),"Имя: ","") .. " мейном?", "Да", "Нет", true);
		end);

	CreateFrame("button", "GuildWardenDeleteChar", frmGuildWardenInfo, "UIPanelButtonTemplate")
		GuildWardenDeleteChar:SetPoint("BOTTOM", frmGuildWardenInfo, "BOTTOM", 5, 10);
		GuildWardenDeleteChar:SetHeight(22);
		GuildWardenDeleteChar:SetWidth(100);
		GuildWardenDeleteChar:SetText("Удалить");
		GuildWardenDeleteChar:SetScript("OnClick", function(self, button)
			local Name = string.gsub(frmGuildWardenInfo.CharName:GetText(),"Имя: ","");
			local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
			--local ID = nil;
			--ID = libGuildWarden.ReturnID(Name);											
			local UserData = libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name];
			if (UserData) then
				if (not UserData.ID or UserData.ID == "??") then
					if (not UserData.LVL or tostring(UserData.LVL) == "??" or tostring(UserData.LVL) == "0" or tostring(UserData.LVL) == "-1") then
						if (not libGuildWarden.GetPlayersGuildIndex(Name)) then
							libGuildWarden.YesNoFunction = function()
								if (frmGuildWardenInfo) then
									local Name = libGuildWarden.SelectedMainsName;
									libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name] = {};
									libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name].Dateremoved = date("%m/%d/%y %H.%M.%S");
									libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name].Name = Name;
								end
								libGuildWarden.ShowUserBox(Name);
							end;
							--libGuildWarden.YesNoText = "Delete " .. Name .. "?";
							libGuildWarden.SelectedMainsName = Name;
							--StaticPopup_Show ("GuildWarden_YesNo");
							libGuildWarden.ShowPopUp("\nУдалить " .. Name .. "?", "Да", "Нет", true);
							return;
						end
					end

					if (GuildWardenDeleteChar:GetText() == "Remove Alt") then
						libGuildWarden.YesNoFunction = function()
															libGuildWarden.MakeUserID(libGuildWarden.SelectedMainsName);
														end;

						libGuildWarden.SelectedMainsName = Name;
						libGuildWarden.ShowPopUp("\nУдалить альта " .. Name .. "?", "Да", "Нет", true);
						return;
					end
				end
			end

			if (libGuildWarden.IsGuildLeader() and not libGuildWarden.GetPlayersGuildIndex(Name)) then
				libGuildWarden.YesNoFunction = function()
					if (frmGuildWardenInfo) then
						local Name = libGuildWarden.SelectedMainsName;
						libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name] = {};
						libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name].Dateremoved = date("%m/%d/%y %H.%M.%S");
						libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name].Name = Name;
					end
					libGuildWarden.ShowUserBox(Name);
				end;

				libGuildWarden.SelectedMainsName = Name;
				libGuildWarden.ShowPopUp("\nУдалить " .. Name .. "?", "Да", "Нет", true);
				return;
			end
		end);

	CreateFrame("button", "GuildWardenNewNote", frmGuildWardenInfo, "UIPanelButtonTemplate")
		GuildWardenNewNote:SetPoint("BOTTOMRIGHT", frmGuildWardenInfo, "BOTTOMRIGHT", -10, 10);
		GuildWardenNewNote:SetHeight(22);
		GuildWardenNewNote:SetWidth(100);
		GuildWardenNewNote:SetText("Заметка");
		GuildWardenNewNote:SetScript("OnClick", function(self, button)
			local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
			local ThisID = libGuildWarden.ReturnID(libGuildWarden.SelectedName);
			if (not ThisID) then
				ThisID = libGuildWarden.MakeUserID(libGuildWarden.SelectedName);
			end

			libGuildWarden.TempListMain["Notes"]["Selection"] = {};
			libGuildWarden.TempListMain["Notes"]["Selection"].ID = ThisID;
			libGuildWarden.YesNoFunction	= function()
				local altsname = GuildWardenPopTextBox:GetText();
				if (altsname ~= "Main") then
					local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
					local ThisID = libGuildWarden.TempListMain["Notes"]["Selection"].ID;
					if (not libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][ThisID]) then
						libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][ThisID] = {};
					end
					libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][ThisID][altsname] = {};
					libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][ThisID][altsname].Name = altsname;
					libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][ThisID][altsname].Text = altsname;
					libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][ThisID][altsname].Date = date("%m/%d/%y %H.%M.%S");
					libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][ThisID][altsname].By = UnitName("player");
					libGuildWarden.SendText("Заметка создана.", true);
					libGuildWarden.SendSingalNotes(ThisID,	altsname);
					libGuildWarden.SortNotesList();
					 GuildNotes_Update();

				end
			end;
			libGuildWarden.ShowPopUp("Введите название заметки:","Добавить", "Отмена");
			--StaticPopup_Show ("GuildWarden_NewNote");
		end);
end

function libGuildWarden.SetupRequests()
	local tmpTableA1 = libGuildWarden.GetScanner();
	local tmpCheck = CreateFrame("CheckButton", "GW_RequestOption", frmGuildWardenRequests, "UICheckButtonTemplate")--InterfaceOptionsCheckButtonTemplate --UICheckButtonTemplate
	tmpCheck:SetPoint("TOPLEFT", frmGuildWardenRequests, "TOPLEFT", 7, -25);
	_G[tmpCheck:GetName() .. "Text"]:SetText("Включить автосканирование");
	tmpCheck:Show();
	tmpCheck:SetChecked(tmpTableA1.Enabled);
	tmpCheck:SetScript("OnClick", function(self, button, down)
		local tmpTableA1 = {};
		if (GW_RequestOption:GetChecked()) then
			tmpTableA1.Enabled = true;
		else
			tmpTableA1.Enabled = false;
		end
		libGuildWarden.SetScanner(tmpTableA1);
	end);

	local Slider = CreateFrame("Slider", "GuildWardenSliderRequest", frmGuildWardenRequests, "OptionsSliderTemplate")
		Slider:SetPoint("TOPLEFT", GW_RequestOption, "BOTTOMLEFT", 120, -10)
		Slider:SetWidth(200)
		Slider:SetHeight(20)

		Slider:SetMinMaxValues(15, 60);
		Slider:SetValue(tmpTableA1.Timer);

		Slider.info = Slider:CreateFontString(nil, "OVERLAY")
		Slider.info:SetPoint("RIGHT", Slider, "LEFT", -5, 0)
		Slider.info:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
		Slider.info:SetJustifyH("LEFT")
		Slider.info:SetShadowOffset(1, -1)
		Slider.info:SetTextColor(1, 1, 1)
		Slider.info:SetText("Автосканирование:" )

		Slider.rate = Slider:CreateFontString(nil, "OVERLAY")
		Slider.rate:SetPoint("TOP", Slider, "BOTTOM", 0, -5)
		Slider.rate:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
		Slider.rate:SetJustifyH("LEFT")
		Slider.rate:SetShadowOffset(1, -1)
		Slider.rate:SetTextColor(1, 1, 1)
		Slider.rate:SetText("Сканировать каждые " .. tmpTableA1.Timer .. " минут");
		--Slider:SetValueStep(1);
		Slider:SetScript("OnValueChanged", function(self, value)
			local Version1 = {strsplit(".",value)}
			local tmpTableA2 = {};
			tmpTableA2.Timer = Version1[1];
			libGuildWarden.SetScanner(tmpTableA2);
			tmpTableA2 = libGuildWarden.GetScanner();
			self.rate:SetText("Сканировать каждые " .. tmpTableA1.Timer .. " минут");
			if (libGuildWarden.GuildRequests) then
				libGuildWarden.GuildRequests.Timer = tmpTableA2.Timer*60;
				libGuildWarden.GuildRequests.runloop = false;
				libGuildWarden.GuildRequests.runindex = 1;
			end
		end);

		Slider:Show();

	local Slider = CreateFrame("Slider", "GuildWardenSliderRequestLevel", frmGuildWardenRequests, "OptionsSliderTemplate")
		Slider:SetPoint("TOPLEFT", GuildWardenSliderRequest, "BOTTOMLEFT", 0, -30)
		Slider:SetWidth(200)
		Slider:SetHeight(20)

		Slider:SetMinMaxValues(1, 85);
		Slider:SetValue(tmpTableA1.lowestLVL);


		Slider.info = Slider:CreateFontString(nil, "OVERLAY")
		Slider.info:SetPoint("RIGHT", Slider, "LEFT", -5, 0)
		Slider.info:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
		Slider.info:SetJustifyH("LEFT")
		Slider.info:SetShadowOffset(1, -1)
		Slider.info:SetTextColor(1, 1, 1)
		Slider.info:SetText("Отклонять:" )

		Slider.rate = Slider:CreateFontString(nil, "OVERLAY")
		Slider.rate:SetPoint("TOP", Slider, "BOTTOM", 0, -5)
		Slider.rate:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
		Slider.rate:SetJustifyH("LEFT")
		Slider.rate:SetShadowOffset(1, -1)
		Slider.rate:SetTextColor(1, 1, 1)
		Slider.rate:SetText("Отклонять персонажей ниже " .. tmpTableA1.lowestLVL .. " уровня");
		--Slider:SetValueStep(1);
		Slider:SetScript("OnValueChanged", function(self, value)
			local Version1 = {strsplit(".",value)}
			local tmpTableA2 = {};
			tmpTableA2.lowestLVL = Version1[1];
			libGuildWarden.SetScanner(tmpTableA2);
			tmpTableA2 = libGuildWarden.GetScanner();
			self.rate:SetText("Отклонять персонажей ниже " .. tmpTableA2.lowestLVL .. " уровня");
		end);

		Slider:Show();

	local Slider = CreateFrame("Slider", "GuildWardenSliderRequestDKLevel", frmGuildWardenRequests, "OptionsSliderTemplate")
			Slider:SetPoint("TOPLEFT", GuildWardenSliderRequestLevel, "BOTTOMLEFT", 0, -30)
			Slider:SetWidth(200)
			Slider:SetHeight(20)

			Slider:SetMinMaxValues(55, 85);
			Slider:SetValue(tmpTableA1.lowestDKLVL);

			Slider.info = Slider:CreateFontString(nil, "OVERLAY")
			Slider.info:SetPoint("RIGHT", Slider, "LEFT", -5, 0)
			Slider.info:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
			Slider.info:SetJustifyH("LEFT")
			Slider.info:SetShadowOffset(1, -1)
			Slider.info:SetTextColor(1, 1, 1)
			Slider.info:SetText("Отклонять ДК:" )

			Slider.rate = Slider:CreateFontString(nil, "OVERLAY")
			Slider.rate:SetPoint("TOP", Slider, "BOTTOM", 0, -5)
			Slider.rate:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
			Slider.rate:SetJustifyH("LEFT")
			Slider.rate:SetShadowOffset(1, -1)
			Slider.rate:SetTextColor(1, 1, 1)
			Slider.rate:SetText("Отклонять рыцарей смерти ниже " .. tmpTableA1.lowestDKLVL.. " уровня");
			--Slider:SetValueStep(1);
			Slider:SetScript("OnValueChanged", function(self, value)
				local Version1 = {strsplit(".",value)}
				local tmpTableA2 = {};
				tmpTableA2.lowestDKLVL = Version1[1];
				libGuildWarden.SetScanner(tmpTableA2);
				tmpTableA2 = libGuildWarden.GetScanner();
				self.rate:SetText("Отклонять ДК ниже " .. tmpTableA2.lowestDKLVL.. " уровня");
			end);

		Slider:Show();

	local StatusBar = CreateFrame("StatusBar", "GuildWardenStatusBarRequest", frmGuildWardenRequests)
		StatusBar:SetPoint("LEFT", GuildWardenSliderRequest, "LEFT", 13, 0)
		StatusBar:SetWidth(177)
		StatusBar:SetHeight(10)
		StatusBar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
		StatusBar:GetStatusBarTexture():SetHorizTile(false)
		StatusBar:GetStatusBarTexture():SetVertTile(false)
		StatusBar:SetStatusBarColor(0, 0.65, 0)

		StatusBar.bg = StatusBar:CreateTexture(nil, "BACKGROUND")
		StatusBar.bg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
		StatusBar.bg:SetAllPoints(true)
		StatusBar.bg:SetVertexColor(0, 0.35, 0)

		StatusBar.sendto = StatusBar:CreateFontString(nil, "OVERLAY")
		StatusBar.sendto:SetPoint("CENTER", StatusBar, "CENTER", 0, 0)
		StatusBar.sendto:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
		StatusBar.sendto:SetJustifyH("LEFT")
		StatusBar.sendto:SetShadowOffset(1, -1)
		StatusBar.sendto:SetTextColor(1, 1, 1)
		StatusBar.sendto:SetText("0% (30 минут)")

		StatusBar:Show();

		StatusBar:SetMinMaxValues(0, 100);
		StatusBar:SetValue(50);

	 	CreateFrame("button", "GuildWardenScanNow", frmGuildWardenRequests, "UIPanelButtonTemplate")
			GuildWardenScanNow:SetPoint("BOTTOMRIGHT", frmGuildWardenRequests, "BOTTOMRIGHT", -20, 20);
			GuildWardenScanNow:SetHeight(22);
			GuildWardenScanNow:SetWidth(110);
			GuildWardenScanNow:SetText("Просканировать");
			GuildWardenScanNow:SetScript("OnClick", function(self, button)
				libGuildWarden.GuildRequests.runloop = true;
				libGuildWarden.GuildRequests.runindex = 1;
			end); 
end
