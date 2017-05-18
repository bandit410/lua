
local key = false
local mframe = nil
local id = 1
local pls = {}
local freecam = false
local camAng = Angle()
local fakeAng = Angle()
local sens = GetConVarNumber( "sensitivity" )

local function butsDecode(num)
	local vec = Vector()
	if num%4 >= 2 then vec = vec + Vector(0,0,1) end
	if num%16 >= 8 then vec = vec + Vector(1,0,0) end
	if num%32 >= 16 then vec = vec + Vector(-1,0,0) end
	if num%1024 >= 512 then vec = vec + Vector(0,1,0) end
	if num%2048 >= 1024 then vec = vec + Vector(0,-1,0) end
	if num%8 >= 4 then vec = vec*0.1 end
	if num%262144 >= 131072 then vec = vec*3 end
	vec:Rotate(camAng)
	return vec*2
end

local function menuOpen()
	if !IsValid(mframe) then

		local fullscreen = false;
		local ppos = {};
		local pname = {};
		freecam = false;	

		pls = player.GetAll();
		table.RemoveByValue(pls,LocalPlayer())
		if IsValid(pls[id]) then pls[id]:SetNoDraw( true ) end

		mframe = vgui.Create("DFrame");
		mframe:MakePopup();
		mframe:SetSize( 600, 400 );
		mframe:Center();
		mframe:SetTitle( "" );

		mframe.Paint = function()
			draw.RoundedBox( 0, 0, 0, 600, 400, Color(110,110,110,205) );	
			draw.RoundedBox( 0, 163, 99, 414, 264, Color(0,0,0,205) );	
			draw.RoundedBox( 0, 12, 65, 140, 323, Color(0,0,0,205) );
			draw.SimpleText("Cam-hack","CloseCaption_Bold",25,20,Color(255,255,255,255),TEXT_ALIGN_LEFT);	
			if IsValid(pls[id]) then draw.SimpleText(pls[id]:Name(),"ChatFont",363,77,Color(255,255,255,255),TEXT_ALIGN_CENTER) end
			draw.SimpleText("Player ID","DermaDefault",210,45,Color(255,255,255,255),TEXT_ALIGN_CENTER);
		end 

		mframe.OnClose = function()
			if IsValid(pls[id]) then pls[id]:SetNoDraw( false ) end
		end

		local slider = vgui.Create( "DNumSlider", mframe )
		slider:SetPos( 50, 44 );
		slider:SetSize( 500, 20 );		
		slider:SetMin( 0.99 );							
		slider:SetDecimals( 0 );
		slider:SetValue(1);	

		function slider:OnValueChanged( num )
			if IsValid(pls[id]) then pls[id]:SetNoDraw( false ) end
			id = math.Round(num)	
			if IsValid(pls[id]) then pls[id]:SetNoDraw( true ) end
		end	

		local pscroll = vgui.Create( "DScrollPanel", mframe );
		pscroll:SetPos( 12, 68 );
		pscroll:SetSize( 140, 320 );

		local layout = vgui.Create( "DListLayout", pscroll );
		layout:SetSize( 140, 320 );

		layout.Think = function()

			pls = player.GetAll()
			table.RemoveByValue(pls,LocalPlayer())
			slider:SetMax( #pls )	

			for k,v in pairs(pname) do
				if not IsValid(k) then
					v:Remove();
					pname[ k ] = nil;
				end
			end

			for k,v in pairs(pls) do
				if pname[ v ] == nil then
					local name = vgui.Create("DLabel", layout);
					name:SetSize(134,17);
					pname[ v ] = name;
				end
				pname[ v ]:SetText( "  "..k..". "..v:Name() );
			end

		end

		local prender = vgui.Create("DImage", mframe)

		prender.Paint = function()

			if IsValid(pls[id]) then
				local view = {};
					
				view.origin = pls[id]:EyePos()
				view.angles = pls[id]:EyeAngles()

				if not fullscreen then
					view.x, view.y = mframe:GetPos();
					view.x = view.x + 170;
					view.y = view.y + 107;
					view.w, view.h = 400, 250;			
				end

				render.RenderView( view )
			end

		end

		local fsbutton = vgui.Create( "DButton", mframe ) 
		fsbutton:SetText( "Full screen" );					
		fsbutton:SetPos( 270, 368 );					
		fsbutton:SetSize( 80, 25 );					
		fsbutton.DoClick = function()				
			fullscreen = not fullscreen
			if fullscreen then
				ppos.x, ppos.y = mframe:GetPos()
				mframe:SetPos(ScrW()/2-300,ScrH()-400)
			else
				mframe:SetPos(ppos.x, ppos.y)
			end
		end

		local fsbutton = vgui.Create( "DButton", mframe ) 
		fsbutton:SetText( "Free cam" )
		fsbutton:SetPos( 380, 368 )					
		fsbutton:SetSize( 80, 25 )										
		fsbutton.DoClick = function()				
			freecam = true;
			fakeAng = LocalPlayer():EyeAngles();
			camAng = LocalPlayer():EyeAngles();
			camPos = LocalPlayer():EyePos();
			mframe:Remove();
			if IsValid(pls[id]) then pls[id]:SetNoDraw( false ) end
		end

	else
		mframe:Remove()
		if IsValid(pls[id]) then pls[id]:SetNoDraw( false ) end
	end

end

hook.Add( "CalcView", "00_c", function( ply, pos, angles, fov )

	local view = {};

	view.origin = camPos;
	view.angles = camAng;
	view.fov = 75;
	view.drawviewer = true;

	if freecam then
		return view
	end
end)

hook.Add( "CreateMove", "00_mk", function(ucmd)

	if freecam then
		camAng = camAng + Angle(ucmd:GetMouseY() * sens/100, ucmd:GetMouseX() * -sens/100, 0);
		camAng:Normalize();
		camAng.p = math.Clamp(camAng.p,-90,90);
		ucmd:SetViewAngles(fakeAng);
		camPos = camPos + butsDecode(ucmd:GetButtons());
		ucmd:ClearButtons();
		ucmd:ClearMovement();
	end

	if input.IsKeyDown( KEY_HOME ) && !key then
		menuOpen()
	end
	key = input.IsKeyDown( KEY_HOME );
end )
