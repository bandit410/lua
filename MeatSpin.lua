
local html = vgui.Create"HTML"
html:Dock(FILL)
html:MakePopup()
html:SetMouseInputEnabled( false )
html:SetHTML[[ <style>
			body {
				background-image: url(https://images.encyclopediadramatica.rs/3/3d/Meatspin.gif);
				background-size: contain; 
				background-position: center;
				background-repeat: no-repeat;
				background-color: RGB(0, 0, 0);
			}
		</style> ]]

html.Think = function()

	gui.HideGameUI()
	RunConsoleCommand'+voicerecord'

end

sound.PlayURL("https://raw.githubusercontent.com/int410/materials/master/sounds/MEATSPIN.mp3", "noblock", function( snd )

	if snd then

		snd:EnableLooping( true )
		sound1 = snd;

	end

end)
