
local function visual()

	pls = player.GetAll()
	table.RemoveByValue( pls, LocalPlayer() )

        for k,v in pairs(pls) do
	        local spos = (v:EyePos() + Vector(0,0,10)):ToScreen()
	        local dist = math.Round(v:GetPos():Distance(LocalPlayer():GetPos())/70)

	        local trace = util.QuickTrace( LocalPlayer():EyePos(), v:EyePos() - LocalPlayer():EyePos(), player.GetAll() )
			local tcolor = team.GetColor(v:Team())

	        if (trace.Hit) then
	            v:SetMaterial("model_color")                  	
	            cam.Start3D() 
	            render.SetColorModulation(tcolor.r/255,tcolor.g/255,tcolor.b/255)
	            v:DrawModel() 
	            cam.End3D()  
	        else  
	            v:SetMaterial("")    
	        end

	 		draw.DrawText(" ["..dist.."m]", "TargetIDSmall", spos.x - 3, spos.y -46, Color(255, 255, 100, 255), TEXT_ALIGN_CENTER)
	 		draw.DrawText(v:Name(), "TargetIDSmall", spos.x, spos.y -32, tcolor, TEXT_ALIGN_CENTER)
			draw.DrawText(v:GetUserGroup(), "TargetIDSmall", spos.x, spos.y -18, Color(255, 255, 100, 255), TEXT_ALIGN_CENTER)
		end 

end

hook.Add("HUDPaint", "00_E", visual)

//by bandit410