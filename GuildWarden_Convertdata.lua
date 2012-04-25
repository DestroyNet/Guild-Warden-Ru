function libGuildWarden.ConvertAll()

	local guildName, guildRankName, guildRankIndex = libGuildWarden.GetGuildInfo();
	
	
	if (MainMyID) then
		libGuildWardenSaveVar["MainMyID"] = MainMyID;
		--MainMyID = nil;
	end
	
	if (libWardenLeftGuildList) then
	   libGuildWarden.SendText("Converting Started", true);
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
	    			local IDITs = "Error" .. value.Name;
	    			
	    			if (value.TMPID) then
	    				if (value.TMPID ~= "??") then
	    					IDITs = value.TMPID;
	    				end
	    			end
	    			if (value.ID) then
	    				if (value.ID ~= "??") then
	    					IDITs = value.ID;
	    				end
	    			end	    			
	    			if (not libGuildWardenSaveVar["Banned"][value.Server]) then
	    				libGuildWardenSaveVar["Banned"][value.Server] = {};
	    			end
	    			if (not libGuildWardenSaveVar["Banned"][value.Server][GuildName]) then
	    				libGuildWardenSaveVar["Banned"][value.Server][GuildName] = {};
	    			end	 
					if (IDITs) then
						if (not libGuildWardenSaveVar["Banned"][value.Server][GuildName][IDITs]) then
							libGuildWardenSaveVar["Banned"][value.Server][GuildName][IDITs] = {};
						end					
						if (Tag == "BannedDate") then
							Tag = "Datebanned";
						end   
						if (Tag == "RemovedDate") then
							Tag = "Dateremoved";
						end 
						libGuildWardenSaveVar["Banned"][value.Server][GuildName][IDITs][Tag] = sub1value;
	    			end	    				    			
	    		else
			    	if (sub1key == "Date") then
			    		libGuildWardenSaveVar["PlayerInfo"][value.Server][value.Name]["Updated"] = sub1value;
			    	else
						libGuildWardenSaveVar["PlayerInfo"][value.Server][value.Name][sub1key] = sub1value;
					end	    		
	    		end
	    		
	    

			end
			
		end			
		--libGuildWardenSaveVar["Notes"][libGuildWarden.Realm]
		
							   
	   Playerslist = nil;
	end
	
	
		
	if (libWardenNoteList) then
	   for key, value in pairs(libWardenNoteList) do	
			if (not libGuildWardenSaveVar["Notes"]) then
				libGuildWardenSaveVar["Notes"] = {};
			end
			
            if (not libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][key]) then
            	libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][key] = {};
            end
		
			for sub1key, sub1value in pairs(libWardenNoteList[key]) do
            	if (not libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][key][sub1key]) then
            		libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][key][sub1key] = {};
            	end            
				for sub2key, sub2value in pairs(libWardenNoteList[key][sub1key]) do			
					libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName][key][sub1key][sub2key] = sub2value ;    	        	
				end	    

			end
			
		end	
		libWardenNoteList = nil;
		libGuildWarden.SendText("Converting Done", true);	
	end	
	
   for key, value in pairs(libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm]) do 
  		if (value.ID) then
  			if (value.ID ~= "??") then
  				value.TMPID = nil;
  			end
		end 
   end	
--[[   
    for key, value in pairs(libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName]) do
		if (strfind(key, "WildhammerWildhammer")) then
			libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][key] = {};
			libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][key].RemovedBy = UnitName("player");         			
			libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName][key].Dateremoved = date("%m/%d/%y %H.%M.%S");		
		end
	end  
    for key, value in pairs(libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm]) do
		if (strfind(key, "Wildhammer")) then
			libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][key] = {};
			libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][key].Dateremoved = date("%m/%d/%y %H.%M.%S");
			libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][key].Name = Name;		
		end
	end  
]]--	
	
		--libGuildWarden.RemoveBanPlayer
		--libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name] = {};
		--libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name].Dateremoved = date("%m/%d/%y %H.%M.%S");
		--libGuildWardenSaveVar["PlayerInfo"][libGuildWarden.Realm][Name].Name = Name;
		--libGuildWardenSaveVar["Banned"][libGuildWarden.Realm][guildName]
--[[
   local CountList = {};
   for key, value in pairs(libGuildWardenSaveVar["Notes"]) do
		CountList[key] = value;		
   end
--      libGuildWardenSaveVar["Notes"] = {};
	  libGuildWardenSaveVar["Notes"][libGuildWarden.Realm] = {};
	  libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName] = {};
	  
      libGuildWardenSaveVar["Notes"][libGuildWarden.Realm][guildName] = CountList;
]]--
   
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








