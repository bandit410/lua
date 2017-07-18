
--hook.Add('Initialize',"InitTab",function()

--local ApiURL = "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=C9E4E47AB57681D140D9924A16196EC8&steamids=76561198001328021"

local list ={
  banni = -1,
  players = 5,
  admins = 228,
  devs = 1337,
  owners = math.huge,
}
 
surface.CreateFont('WireTabMain',
{
        font = "Lucida Console",
        size = 13,
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
})
 

local Scoreboard	
local AvatarBox


local function ScoreboardDraw()
	
	if IsValid(Scoreboard) then
		
		Scoreboard:Show()
			
	else

		Scoreboard = vgui.Create('DPanel',nil,'Scoreboard')
		Scoreboard:MakePopup()
		Scoreboard:SetKeyboardInputEnabled( false )
		Scoreboard:SetSize(800,480+25)
		Scoreboard:Center()
		Scoreboard.Paint = function(s,w,h) end
		Scoreboard.lines = {}
		
		Scoreboard._Update = function(self)
		
			local get_sorted = player.GetAll()
			
			table.sort(get_sorted,function(a,b) return (list[a:GetUserGroup()] or 1) > (list[b:GetUserGroup()] or 1) end) 
			
			if self.plys then

				for k, v in pairs(Scoreboard.lines) do
 
					if !IsValid(k) then v:Remove() end

				end
				-- PrintTable( self.plys:GetChildren()[1]:GetChildren() )
				-- PrintTable( Scoreboard.lines ) 				
				for k,v in pairs(get_sorted) do
						
					local s_fix = v:GetNWString("gsapi_fixtime")
					
					v.TimePlayed = (s_fix=="" and v:GetNWInt("gsapi_playtime")) or (s_fix~="" and s_fix) or -1
					if !Scoreboard.lines[ v ] then Scoreboard:MakePlayerLine(v) end
					Scoreboard:UpdatePlayerLine(v) 
								
				end
						
						//print("scoreboard resorted")
			end
				
		end
			
		concommand.Add("scoreboard_update",function() Scoreboard:_Update() end)
			
		local p = vgui.Create('DPanel',Scoreboard)
		p:SetSize(800,480)
		--p:Center()
		p:SetPos(0,25)
		p.Paint = function(self,w,h)

			draw.RoundedBox(0,0,100,w,h,Color(142,202,112))
				
			draw.RoundedBox(0,0,100,w,20,Color(114,143,83))
				
			surface.SetDrawColor(Color(114,143,83))
			surface.DrawOutlinedRect(0,100,w,h-100)
			
			draw.SimpleText(player.GetCount().." #username","WireTabMain",5     ,100+10 ,Color(255,255,255),0,1)
			draw.SimpleText("#gmod_timeplayed","WireTabMain",400-40,100+10        ,Color(255,255,255),0,1)
			draw.SimpleText("#killos","WireTabMain",800-200,100+10  ,Color(255,255,255),0,1)
			draw.SimpleText("#dezes","WireTabMain",800-120,100+10   ,Color(255,255,255),0,1)
			draw.SimpleText("#pingas","WireTabMain",800-60,100+10   ,Color(255,255,255),0,1)
	
		end                    
			
		local yos = p:Add('DHTML')
		yos:SetPos(800-200,-8   )
		yos:SetSize(200,116     )
		yos:SetHTML[[ <img src="http://195.2.252.214/files/yo_bg2.png" height=100/> ]]
		
			local rest = yos:Add('DButton')
			rest:SetSize(200,116)
			rest:SetText("")
			rest.Paint = function() end
			rest.DoRightClick = function()
				local menu = DermaMenu()
				menu:AddSubMenu( "cpp.Restart() (no changelevel)"):AddOption("ARE YOU SERIOUSLY",function() LocalPlayer():ConCommand("lua_run_sv if not cpp then require'wbcpp' end cpp.Restart()") end)
				menu:Open()
			end
		
		local yos_bg = p:Add('DHTML')
		yos_bg:SetPos(800-316-10,480-316-5)
		yos_bg:SetSize(316+16,316+16)
		yos_bg:SetHTML[[ <img src="http://195.2.252.214/files/yo_bg.png" width=316/> ]]
		
		--http://195.2.252.214/files/yo_bg.png
		
		local plys = p:Add'DPanelList'
		plys:SetSize(800,480-(100+20))
		plys:SetPos(0,100+20+1)
		plys:SetSpacing(1)
		plys:EnableVerticalScrollbar( true )

		Scoreboard.plys = plys
		
		local mats = {		
			owners          = Material'icon16/server_chart.png',
			admins          = Material'icon16/shield.png',
			devs            = Material'icon16/script.png',
			banni           = Material'icon16/cancel.png',
			players         = Material'icon16/user.png',
			time_played     = Material'icon16/time.png',
			e2power         = Material'icon16/cog.png',
			film            = Material'icon16/film.png',
			monitor_link    = Material'icon16/monitor_link.png',
		} 

		Scoreboard.MakePlayerLine = function(self, ply) 

			local change = true
			local line = vgui.Create'DCollapsibleCategory'
			line:SetLabel''
			line:SetExpanded(ply.Expanded or false)
			line:SetSize(800,20)
					
			line.OnToggle = function(self,status)
				ply.Expanded = status
			end
					
			line.DoRightClick = function() iin.OpenClientMenu(ply) end 
					
			line.Paint = function(self,w,h)
				--self:Think()
				draw.RoundedBox(0,0,0,w,h,team.GetColor(ply:Team())--[[Color(146,174,0)]])    
														
				draw.SimpleText(ply:Nick(),"WireTabMain",20+4+1,10+1,Color(0,0,0),0,1)
				draw.SimpleText(ply:Nick(),"WireTabMain",20+4,10,Color(255,255,255),0,1) --nick
				
				draw.SimpleText(ply:Frags(),"WireTabMain",800-200+8+1,10+1,Color(0,0,0),0,1) --kills
				draw.SimpleText(ply:Frags(),"WireTabMain",800-200+8,10,Color(255,255,255),0,1) --kills
				
				draw.SimpleText(ply:Deaths(),"WireTabMain",800-120+8+1,10+1,Color(0,0,0),0,1) --deth
				draw.SimpleText(ply:Deaths(),"WireTabMain",800-120+8,10,Color(255,255,255),0,1) --deth
				
				draw.SimpleText(ply:Ping(),"WireTabMain",800-60+8+1,10+1,Color(0,0,0),0,1) --ping
				draw.SimpleText(ply:Ping(),"WireTabMain",800-60+8,10,Color(255,255,255),0,1) --ping
				
				local fixtime = ply:GetNWString("gsapi_fixtime")
	
				if type(ply.TimePlayed)=="number" and ply.TimePlayed>=0 then
				
						surface.SetDrawColor(255,255,255)      
						surface.SetMaterial(mats['time_played'])
						surface.DrawTexturedRect(400-18,2,16,16)
					
						local hours_ = math.Round(ply.TimePlayed/60)..' hours'
						draw.SimpleText(hours_,"WireTabMain",400+1,10+1,Color(0,0,0),0,1)
						draw.SimpleText(hours_,"WireTabMain",400,10,Color(255,255,255),0,1) 
						
				elseif fixtime~="" then
						
						surface.SetDrawColor(255,255,255)      
						surface.SetMaterial(mats['time_played'])
						surface.DrawTexturedRect(400-18,2,16,16)
						
						local hours_ = fixtime..' hours'
						draw.SimpleText(hours_,"WireTabMain",400+1,10+1,Color(0,0,0),0,1)
						draw.SimpleText(hours_,"WireTabMain",400,10,Color(255,255,255),0,1) 

				else
					
					draw.SimpleText("Private Profile","WireTabMain",400+1-25,10+1,Color(0,0,0),0,1)
					draw.SimpleText("Private Profile","WireTabMain",400-25,10,Color(255,255,255),0,1)

				end
						
			end
					
			local Property = vgui.Create('DPanel')
			Property:SetPos(0,20)
			Property:SetSize(800,40)
			Property:SetParent( line )
			line.Contents = Property
				
			local AdminButPanel = Property:Add'DPanelList'
			AdminButPanel:EnableHorizontal(true)
			AdminButPanel:SetSpacing(1)
			AdminButPanel:SetSize(200,40)
			AdminButPanel:SetPos(10,5)
			
			local function AddAdminButton(name,func)

				local aButton = vgui.Create'DButton'
				--aButton:SetSize(30,15)
				aButton:SetText(name)
				aButton:SetSize(#name*10,15)
				aButton.Paint = function(self,w,h)
					draw.RoundedBox(0,0,0,w,h,Color(255,255,255))
					surface.SetDrawColor(Color(114,143,83))
						surface.DrawOutlinedRect(0,0,w,h)
				end
				
				aButton.DoClick = func
				aButton.DoRightClick = func
			
				AdminButPanel:AddItem(aButton)

			end
					
			AddAdminButton("goto",function() RunConsoleCommand('iin','goto',ply:EntIndex() )end)
			AddAdminButton("tp",function() RunConsoleCommand('iin','tp',ply:EntIndex())end)
			AddAdminButton("Admin",function() iin.OpenClientMenu(ply) end)
					
			local Mute = vgui.Create("DImageButton",Property)
			Mute:SetSize(32,32)
			Mute:SetPos(800-32-4,6)
			Mute:SetTooltip("Заглушить/Разглушить")
			Mute:SetImage("icon32/"..(ply:IsMuted() and '' or 'un').."muted.png")
				
			Mute.DoClick = function()
				ply:SetMuted(!ply:IsMuted())
				Mute:SetImage("icon32/"..(ply:IsMuted() and '' or 'un').."muted.png") 
			end
						
			line:InvalidateLayout()
				
			local ava = vgui.Create('AvatarImage',line)
			ava:SetPlayer(ply,16)
			ava:SetSize(20,20)
			ava:SetPos(0,0)
			
			local avabox = vgui.Create('DButton',ava)
			avabox:SetSize(28,28)
			avabox:SetText('')
			avabox.Paint = function() end

			avabox.DoRightClick = function()

				local a=DermaMenu()
				
				a:AddOption("Копировать SteamID",function() SetClipboardText(ply:SteamID()) end):SetIcon'icon16/computer.png'
				a:AddOption("Копировать ник",function() SetClipboardText(ply:Name()) end):SetIcon'icon16/color_swatch.png'
				a:AddOption("Индекс Ентити",function() chat.AddText(Color(255,187,0),"● ",ply,Color(255,255,255),'\'s EntIndex = ',Color(191,255,255),ply:EntIndex()..'') end):SetIcon'icon16/bin_closed.png'
				a:AddOption("Открыть профиль",function() ply:ShowProfile() end):SetIcon'icon16/book_open.png'
				a:AddOption("Копировать ссылку на профиль",function() SetClipboardText(ply:IsBot() and 'it\'s fucking bot!!!' or "http://steamcommunity.com/profiles/"..ply:SteamID64()) end):SetIcon'icon16/book.png'
				a:AddOption("Копировать cid",function() SetClipboardText(ply:IsBot() and 'it\'s fucking bot!!!' or ply:SteamID64()) end):SetIcon'icon16/computer.png'
					
				a:Open()

			end

			avabox.DoClick = function()

					ply:ShowProfile()

			end
			
			avabox.OnCursorEntered = function()    

				AvatarBox:SetPos( gui.MouseX()-184-15, gui.MouseY()-184 )
				AvatarBox:SetPlayer( ply, 184 )
				AvatarBox:Show()
			
			end
			
			avabox.OnCursorExited = function(self)

				AvatarBox:Hide()

			end                    
			
			plys:AddItem(line)
			self.lines[ ply ] = line

		end


		Scoreboard.UpdatePlayerLine = function(self, ply) 

			local mat_tags = {} 
			
			if ply:GetUserGroup() == 'owners' then table.insert(mat_tags,mats['owners']) elseif
			ply:GetUserGroup() == 'banni' then table.insert(mat_tags,mats['banni']) else

				if ply:IsSuperAdmin() then table.insert(mat_tags,mats["devs"]) end 
				if ply:IsAdmin() then table.insert(mat_tags,mats["admins"]) end 
				if ply:GetNWBool('E2PowerAccess') then table.insert(mat_tags,mats["e2power"]) end               
				if ply:GetNWBool('PlayXAcсess') then table.insert(mat_tags,mats["film"]) end
				if ply:IsBot() then table.insert(mat_tags,mats["monitor_link"]) end 

			end
				
			local Property = self.lines[ ply ].Contents 
			
			Property.Paint = function(self,w,h)

				draw.RoundedBox(0,0,0,800,1,Color(255,255,255))
				draw.SimpleText("Tags: ","WireTabMain",10,10+20,Color(255,255,255),0,1) --ping
				
				for id,mat in next,mat_tags do
					
					surface.SetDrawColor(255,255,255)      
						surface.SetMaterial(mat)
						surface.DrawTexturedRect(35+id*18,2+20,16,16)
				
				end

			end
			---
			---
			---
		end
		

	end --if Scoreboard   


	if !IsValid(AvatarBox) then

		AvatarBox = vgui.Create('AvatarImage',nil,'AvatarBox')
		AvatarBox:SetSize( 184, 184 )
		AvatarBox:Hide()
			
	end		


end


hook.Add("ScoreboardShow","TabScoreboardDraw",function()

	ScoreboardDraw()
	Scoreboard:_Update()
	return false

end)


hook.Add("ScoreboardHide","TabScoreboardRemove",function()

	if IsValid(Scoreboard) then Scoreboard:Hide() end

end)


--end)
