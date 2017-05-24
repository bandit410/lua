
local mframe = vgui.Create( "DPanel" )
mframe:SetSize( ScrW(), ScrH() )
mframe:Center()

local html = vgui.Create( "HTML", mframe )
html:SetSize( ScrW(), ScrH() )
html:MakePopup()
html:OpenURL( "youtube.com/embed/pXpoRvJ7jBg?autoplay=1" )
html:SetMouseInputEnabled( false )

timer.Simple(104,function()

	mframe:Remove()

end)