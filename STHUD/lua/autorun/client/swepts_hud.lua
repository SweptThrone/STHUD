--STHUD S-Thud lol

CreateClientConVar( "sthud_font_name", "Arial" )

surface.CreateFont( "STHUDTEXT", {
	font = GetConVar("sthud_font_name"):GetString(), -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 48,
	outline = true,
	antialias = false
} )

surface.CreateFont( "STHUDTEXT_SMALL", {
	font = GetConVar("sthud_font_name"):GetString(), -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 24,
	outline = true,
	antialias = false
} )

local function GetCardinalDirection( deg )

	if deg >= 67.51 and deg <= 112.5 then
		return "N"
	elseif deg >= 112.51 and deg <= 157.5 then
		return "NW"
	elseif deg >= -157.51 and deg <= -112.5 then
		return "SW"
	elseif deg >= -112.51 and deg <= -67.5 then
		return "S"
	elseif deg >= -67.5 and deg <= -22.5 then
		return "SE"
	elseif deg >= -22.51 and deg <= 22.5 then
		return "E"
	elseif deg >= 22.51 and deg <= 67.5 then
		return "NE"
	end
	return "W"

end

local smoothHP = 100
local smoothAP = 100

local gradientr = Material( "vgui/gradient-r" )
local gradientl = Material( "vgui/gradient-l" )

CreateClientConVar( "sthud_time_red", "255" )
CreateClientConVar( "sthud_time_green", "255" )
CreateClientConVar( "sthud_time_blue", "255" )

CreateClientConVar( "sthud_dir_red", "255" )
CreateClientConVar( "sthud_dir_green", "255" )
CreateClientConVar( "sthud_dir_blue", "255" )

CreateClientConVar( "sthud_vel_red", "255" )
CreateClientConVar( "sthud_vel_green", "255" )
CreateClientConVar( "sthud_vel_blue", "255" )

CreateClientConVar( "sthud_fps_enabled", "1" )
CreateClientConVar( "sthud_ping_enabled", "1" )
CreateClientConVar( "sthud_time_enabled", "1" )
CreateClientConVar( "sthud_velocity_enabled", "1" )
CreateClientConVar( "sthud_nametag_enabled", "1" )
CreateClientConVar( "sthud_steamid_enabled", "1" )
CreateClientConVar( "sthud_healthbar_enabled", "1" )
CreateClientConVar( "sthud_armorbar_enabled", "1" )
CreateClientConVar( "sthud_healthnum_enabled", "1" )
CreateClientConVar( "sthud_armornum_enabled", "1" )
CreateClientConVar( "sthud_compass_enabled", "1" )
CreateClientConVar( "sthud_wepname_enabled", "1" )
CreateClientConVar( "sthud_clip1_enabled", "1" )
CreateClientConVar( "sthud_clip2_enabled", "1" )
CreateClientConVar( "sthud_reserve_enabled", "1" )

CreateClientConVar( "sthud_clock_seconds", "1" )
CreateClientConVar( "sthud_clock_military", "1" )
CreateClientConVar( "sthud_compass_mode", "3" )

CreateClientConVar( "sthud_swap_fpsping", "0" )
CreateClientConVar( "sthud_swap_clockcompass", "0" )

CreateClientConVar( "sthud_enabled", "1" )

concommand.Add( "sthud_setfont", function( ply, cmd, args )
	surface.CreateFont( "STHUDTEXT", {
		font = table.concat( args, " " ), -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		size = 48,
		outline = true,
		antialias = false
	} )

	surface.CreateFont( "STHUDTEXT_SMALL", {
		font = table.concat( args, " " ), -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		size = 24,
		outline = true,
		antialias = false
	} )
	
	GetConVar("sthud_font_name"):SetString( table.concat( args, " " ) )
end )

hook.Add( "PopulateToolMenu", "STHUDSettings", function()
	spawnmenu.AddToolMenuOption( "Options", "STHUD", "sthud_config", "STHUD Config", "", "", function( panel )
		panel:ClearControls()
		panel:CheckBox( "Enable STHUD?", "sthud_enabled" )
		panel:Help( "You can change the font of the HUD with the command sthud_font_name" )
		panel:Help( "Example: sthud_setfont Comic Sans MS" )
		panel:Help( "Entering an invalid font will throw two errors and default to Sans Serif" )
		panel:Help( "" )
		panel:Help( "Color of the clock at the top of the screen:" )
		panel:NumSlider( "Time: Red", "sthud_time_red", 0, 255, 0 )
		panel:NumSlider( "Time: Green", "sthud_time_green", 0, 255, 0 )
		panel:NumSlider( "Time: Blue", "sthud_time_blue", 0, 255, 0 )
		panel:Help( "Color of the compass at the bottom of the screen:" )
		panel:NumSlider( "Compass: Red", "sthud_dir_red", 0, 255, 0 )
		panel:NumSlider( "Compass: Green", "sthud_dir_green", 0, 255, 0 )
		panel:NumSlider( "Compass: Blue", "sthud_dir_blue", 0, 255, 0 )
		panel:Help( "Color of the spedometer at the top-right of the screen:" )
		panel:NumSlider( "Spedometer: Red", "sthud_vel_red", 0, 255, 0 )
		panel:NumSlider( "Spedometer: Green", "sthud_vel_green", 0, 255, 0 )
		panel:NumSlider( "Spedometer: Blue", "sthud_vel_blue", 0, 255, 0 )
		panel:Help( "Swappers:" )
		panel:CheckBox( "Swap FPS and ping", "sthud_swap_fpsping" )
		panel:CheckBox( "Swap clock and compass", "sthud_swap_clockcompass" )
		panel:Help( "Extra settings:" )
		panel:CheckBox( "Time: Show seconds?", "sthud_clock_seconds" )
		panel:CheckBox( "Time: 24-hour mode?", "sthud_clock_military" )
		panel:Help( "1 = Degrees, 2 = Cardinals, 3 = Combined:" )
		panel:NumSlider( "Compass mode:", "sthud_compass_mode", 1, 3, 0 )
		panel:Help( "Toggle any parts of the HUD:" )
		panel:CheckBox( "FPS meter", "sthud_fps_enabled" )
		panel:CheckBox( "Ping meter", "sthud_ping_enabled" )
		panel:CheckBox( "Time meter", "sthud_time_enabled" )
		panel:CheckBox( "Spedometer", "sthud_velocity_enabled" )
		panel:CheckBox( "Name tag", "sthud_nametag_enabled" )
		panel:CheckBox( "SteamID", "sthud_steamid_enabled" )
		panel:CheckBox( "Health number", "sthud_healthnum_enabled" )
		panel:CheckBox( "Health bar", "sthud_healthbar_enabled" )
		panel:CheckBox( "Armor number", "sthud_armornum_enabled" )
		panel:CheckBox( "Armor bar", "sthud_armorbar_enabled" )
		panel:CheckBox( "Compass", "sthud_compass_enabled" )
		panel:CheckBox( "Weapon name", "sthud_wepname_enabled" )
		panel:CheckBox( "Primary mag", "sthud_clip1_enabled" )
		panel:CheckBox( "Secondary ammo", "sthud_clip2_enabled" )
		panel:CheckBox( "Reserve ammo", "sthud_reserve_enabled" )
		panel:Help( "STHUD made by SweptThrone" )
		panel:Help( "http://discord.gg/Tg8SUDv" )
	end )
end )

local pinfo = ""

hook.Add( "InitPostEntity", "SetupPInfo", function()

	pinfo = LocalPlayer():SteamID()

	timer.Create( "switch" .. LocalPlayer():EntIndex() .. "info", 10, 0, function()
		if pinfo == LocalPlayer():SteamID() then
			pinfo = LocalPlayer():SteamID64()
		else
			pinfo = LocalPlayer():SteamID()
		end
	end )
	
end )

hook.Add( "HUDPaint", "DrawSTHUD", function()

	if GetConVar( "sthud_enabled" ):GetBool() then

	local ply = LocalPlayer()
	if pinfo == "" then
		pinfo = LocalPlayer():SteamID()
		timer.Create( "switch" .. LocalPlayer():EntIndex() .. "info", 10, 0, function()
			if pinfo == LocalPlayer():SteamID() then
				pinfo = LocalPlayer():SteamID64()
			else
				pinfo = LocalPlayer():SteamID()
			end
		end )
	end
	--==================================
	--=======STUFF ON THE RIGHT=========
	--==================================
	if ply:Alive() and IsValid(ply) and IsValid(wep) then
		local wep = ply:GetActiveWeapon()
		local amo = wep:Clip1()
		local maxmag = wep:GetMaxClip1()
		if amo == -1 then amo = 0 end
		--==========WEAPON==========
		if GetConVar( "sthud_wepname_enabled" ):GetBool() then
			surface.SetFont( "STHUDTEXT" )
			surface.SetTextColor( ply:GetWeaponColor().x * 255, ply:GetWeaponColor().y * 255, ply:GetWeaponColor().z * 255, 255 )
			if wep:GetPrimaryAmmoType() == -1 or ( !GetConVar( "sthud_reserve_enabled" ):GetBool() and !GetConVar( "sthud_clip1_enabled" ):GetBool() and !GetConVar( "sthud_clip2_enabled" ):GetBool() ) then
				surface.SetTextPos( ScrW() - surface.GetTextSize(wep:GetPrintName()) - 15, ScrH() - 54 )
			elseif !GetConVar( "sthud_reserve_enabled" ):GetBool() or wep:Clip1() == -1 or ( !GetConVar( "sthud_clip2_enabled" ):GetBool() and !GetConVar( "sthud_clip1_enabled" ):GetBool() ) then
				surface.SetTextPos( ScrW() - surface.GetTextSize(wep:GetPrintName()) - 15, ScrH() - 94 )
			else
				surface.SetTextPos( ScrW() - surface.GetTextSize(wep:GetPrintName()) - 15, ScrH() - 134 )
			end
			
			surface.DrawText( wep:GetPrintName() )
		end
		
		--==========RESERVE AMMO==========
		if wep:GetPrimaryAmmoType() != -1 then
			surface.SetFont( "STHUDTEXT" )
			local reserve = ply:GetAmmoCount( wep:GetPrimaryAmmoType() )
			local factor_res = ( reserve / maxmag ) - 2
			local rg, rr = 0, 0
			if reserve >= (2 * wep:GetMaxClip1()) and reserve < (3 * wep:GetMaxClip1()) then
				rg = 255
				rr = 255 - ( factor_res * 255 )
			elseif reserve < (2 * wep:GetMaxClip1()) then
				rg = 255 + ( factor_res * 255 )
				rr = 255
			elseif reserve >= (3 * wep:GetMaxClip1()) then
				rg = 255
				rr = 0
			end
			if GetConVar( "sthud_reserve_enabled" ):GetBool() then
				surface.SetTextColor( rr, rg, 0, 255 )
				surface.SetTextPos( ScrW() - surface.GetTextSize(ply:GetAmmoCount( wep:GetPrimaryAmmoType() ) .. " x " .. game.GetAmmoName(wep:GetPrimaryAmmoType())) - 15, ScrH() - 54 )
				surface.DrawText( ply:GetAmmoCount( wep:GetPrimaryAmmoType() ) .. " x " .. game.GetAmmoName(wep:GetPrimaryAmmoType()) )
			end
		end
		--==========CURRENT MAGAZINE===========
		if wep:GetMaxClip1() > 0 then
			local factor = 255 / (wep:GetMaxClip1() / 2)
			local ag, ar = 0,0
			if amo >= (0.5 * wep:GetMaxClip1()) then
				ag = 255
				ar = 255 - (factor * (amo - (wep:GetMaxClip1() / 2)))
			elseif amo < (0.5 * wep:GetMaxClip1()) then
				ag = (factor * (amo))
				ar = 255
			else
				ag = 255
				ar = 0
			end
			if GetConVar( "sthud_clip1_enabled" ):GetBool() then
				surface.SetFont( "STHUDTEXT" )
				surface.SetTextColor( ar, ag, 0, 255 )
				if !GetConVar( "sthud_reserve_enabled" ):GetBool() then
					surface.SetTextPos( ScrW() - surface.GetTextSize("> " .. amo) - 15, ScrH() - 54 )
				else
					surface.SetTextPos( ScrW() - surface.GetTextSize("> " .. amo) - 15, ScrH() - 94 )
				end
				surface.DrawText( "> " .. amo )
			end
		
		--==========SECONDARY AMMO==========
			if GetConVar( "sthud_clip2_enabled" ):GetBool() then
				if wep:GetSecondaryAmmoType() != -1 then
					surface.SetFont( "STHUDTEXT" )
					if ply:GetAmmoCount( wep:GetSecondaryAmmoType() ) > 0 then
						surface.SetTextColor( 0, 255, 0, 255 )
					else
						surface.SetTextColor( 255, 0, 0, 255 )
					end
					if !GetConVar( "sthud_clip1_enabled" ):GetBool() then
						if GetConVar( "sthud_wepname_enabled" ):GetBool() and !GetConVar( "sthud_reserve_enabled" ):GetBool() then
							surface.SetTextPos( ScrW() - surface.GetTextSize(ply:GetAmmoCount( wep:GetSecondaryAmmoType() ) .. " < ") - 20, ScrH() - 54 )
						elseif !GetConVar( "sthud_wepname_enabled" ):GetBool() and !GetConVar( "sthud_reserve_enabled" ):GetBool() then
							surface.SetTextPos( ScrW() - surface.GetTextSize(ply:GetAmmoCount( wep:GetSecondaryAmmoType() ) .. " < ") - 20, ScrH() - 54 )
						else
							surface.SetTextPos( ScrW() - surface.GetTextSize(ply:GetAmmoCount( wep:GetSecondaryAmmoType() ) .. " <") - 15, ScrH() - 94 )
						end
					elseif !GetConVar( "sthud_reserve_enabled" ):GetBool() then
						if !GetConVar( "sthud_clip1_enabled" ):GetBool() and !GetConVar( "sthud_wepname_enabled" ):GetBool() then
							surface.SetTextPos( ScrW() - surface.GetTextSize(ply:GetAmmoCount( wep:GetSecondaryAmmoType() ) .. " <") - 15, ScrH() - 94 )
						else
							surface.SetTextPos( ScrW() - surface.GetTextSize(ply:GetAmmoCount( wep:GetSecondaryAmmoType() ) .. " < ") - surface.GetTextSize( "> " .. amo ) - 15, ScrH() - 54 )
						end
					else
						surface.SetTextPos( ScrW() - surface.GetTextSize(ply:GetAmmoCount( wep:GetSecondaryAmmoType() ) .. " < ") - surface.GetTextSize( "> " .. amo ) - 15, ScrH() - 94 )
					end
					surface.DrawText( ply:GetAmmoCount( wep:GetSecondaryAmmoType() ) .. " < " )
				end
			end
		end
	end
	
	--==================================
	--=======STUFF ON THE LEFT=========
	--==================================

	--==========HEALTH==========
	local hp = ply:Health()
	local g, r = 0, 0
	if hp >= 50 then
		g = 255
		r = 255 - (5.1 * (hp - 50))
	elseif hp < 50 then
		g = (5.1 * (hp))
		r = 255
	else
		g = 255
		r = 0
	end
	
	if GetConVar( "sthud_healthnum_enabled" ):GetBool() then
		surface.SetFont( "STHUDTEXT" )
		surface.SetTextColor( r, g, 0, 255 )
		surface.SetTextPos( 25, ScrH() - 54 )
		surface.DrawText( ply:Health() )
	end
	
	if GetConVar( "sthud_healthbar_enabled" ):GetBool() then
		if !GetConVar( "sthud_healthnum_enabled" ):GetBool() then
			draw.RoundedBox( 4, 25, ScrH() - 51, 312, 40, Color(0,0,0) )
		else
			draw.RoundedBox( 4, surface.GetTextSize("100") + 48, ScrH() - 51, 312, 40, Color(0,0,0) )
		end
		smoothHP = Lerp( 10 * FrameTime(), smoothHP, hp )
		surface.SetMaterial( gradientl )
		surface.SetDrawColor( Color(255,0,0) )
		if !GetConVar( "sthud_healthnum_enabled" ):GetBool() then
			surface.DrawTexturedRect( 30, ScrH() - 45, 300, 28 )
		else
			surface.DrawTexturedRect( surface.GetTextSize("100") + 54, ScrH() - 45, 300, 28 )
		end
		surface.SetMaterial( gradientr )
		surface.SetDrawColor( Color(0,255,0) )
		if !GetConVar( "sthud_healthnum_enabled" ):GetBool() then
			surface.DrawTexturedRect( 30, ScrH() - 45, 300, 28 )
		else
			surface.DrawTexturedRect( surface.GetTextSize("100") + 54, ScrH() - 45, 300, 28 )
		end
		surface.SetDrawColor( Color(0,0,0) )
		if !GetConVar( "sthud_healthnum_enabled" ):GetBool() then
			surface.DrawRect( 30 + ( smoothHP * 3 ), ScrH() - 45, 302 - ( smoothHP * 3 ), 28 )
		else
			surface.DrawRect( surface.GetTextSize("100") + 54 + ( smoothHP * 3 ), ScrH() - 45, 302 - ( smoothHP * 3 ), 28 )
		end
		--draw.RoundedBox( 4, surface.GetTextSize("100") + 54, ScrH() - 44, smoothHP * 3, 28, Color(r,g,0) )
	end
	
	--==========ARMOR==========
	local ap = ply:Armor()
	local r2, g2, b2 = 0, 0, 0
	if ap >= 50 then
		r2 = 255 - (5.1 * (ap - 50))
		g2 = (2.56 * (ap - 50))
		b2 = 255 - (128 - (2.56 * (ap - 50)))
	elseif ap < 50 then
		r2 = 255
		g2 = 0
		b2 = 128 + (2.56 * (ap - 50))
	else
		r2, g2, b2 = 0, 128, 255
	end
	
	local IS_HEALTH_INFO_DISABLED = !GetConVar( "sthud_healthnum_enabled" ):GetBool() and !GetConVar( "sthud_healthbar_enabled" ):GetBool()
	local IS_ARMOR_INFO_DISABLED = !GetConVar( "sthud_armornum_enabled" ):GetBool() and !GetConVar( "sthud_armorbar_enabled" ):GetBool()
	local IS_STEAMID_DISABLED = !GetConVar( "sthud_steamid_enabled" ):GetBool()
	
	if GetConVar( "sthud_armornum_enabled" ):GetBool() then
		surface.SetFont( "STHUDTEXT" )
		surface.SetTextColor( r2, g2, b2, 255 )
		if IS_HEALTH_INFO_DISABLED then
			surface.SetTextPos( 25, ScrH() - 54 )
		else
			surface.SetTextPos( 25, ScrH() - 94 )
		end
		surface.DrawText( ply:Armor() )
	end
	
	if GetConVar( "sthud_armorbar_enabled" ):GetBool() then
	
		if !GetConVar( "sthud_armornum_enabled" ):GetBool() then
			if IS_HEALTH_INFO_DISABLED then
				draw.RoundedBox( 4, 25, ScrH() - 51, 312, 40, Color(0,0,0) )
			else
				draw.RoundedBox( 4, 25, ScrH() - 90, 312, 40, Color(0,0,0) )
			end
		else
			if IS_HEALTH_INFO_DISABLED then
				draw.RoundedBox( 4, surface.GetTextSize("100") + 48, ScrH() - 51, 312, 40, Color(0,0,0) )
			else
				draw.RoundedBox( 4, surface.GetTextSize("100") + 48, ScrH() - 90, 312, 40, Color(0,0,0) )
			end
		end
		
				smoothAP = Lerp( 10 * FrameTime(), smoothAP, ap )
				surface.SetMaterial( gradientl )
				surface.SetDrawColor( Color(255,0,0) )
		
		if !GetConVar( "sthud_armornum_enabled" ):GetBool() then
			if IS_HEALTH_INFO_DISABLED then
				surface.DrawTexturedRect( 30, ScrH() - 45, 300, 28 )
			else
				surface.DrawTexturedRect( 30, ScrH() - 84, 300, 28 )
			end
		else
			if IS_HEALTH_INFO_DISABLED then
				surface.DrawTexturedRect( surface.GetTextSize("100") + 55, ScrH() - 45, 300, 28 )
			else
				surface.DrawTexturedRect( surface.GetTextSize("100") + 55, ScrH() - 84, 300, 28 )
			end
		end
		
				surface.SetMaterial( gradientr)
				surface.SetDrawColor( Color(0,128,255) )
		
		if !GetConVar( "sthud_armornum_enabled" ):GetBool() then
			if IS_HEALTH_INFO_DISABLED then
				surface.DrawTexturedRect( 30, ScrH() - 45, 300, 28 )
			else
				surface.DrawTexturedRect( 30, ScrH() - 84, 300, 28 )
			end
		else
			if IS_HEALTH_INFO_DISABLED then
				surface.DrawTexturedRect( surface.GetTextSize("100") + 55, ScrH() - 45, 300, 28 )
			else
				surface.DrawTexturedRect( surface.GetTextSize("100") + 55, ScrH() - 84, 300, 28 )
			end
		end
		
				surface.SetDrawColor( Color(0,0,0) )
		
		if !GetConVar( "sthud_armornum_enabled" ):GetBool() then
			if IS_HEALTH_INFO_DISABLED then
				surface.DrawRect( 30 + ( smoothAP * 3 ), ScrH() - 45, 302 - ( smoothAP * 3 ), 28 )
			else
				surface.DrawRect( 30 + ( smoothAP * 3 ), ScrH() - 84, 302 - ( smoothAP * 3 ), 28 )
			end
		else
			if IS_HEALTH_INFO_DISABLED then
				surface.DrawRect( surface.GetTextSize("100") + 55 + ( smoothAP * 3 ), ScrH() - 45, 302 - ( smoothAP * 3 ), 28 )
			else
				surface.DrawRect( surface.GetTextSize("100") + 55 + ( smoothAP * 3 ), ScrH() - 84, 302 - ( smoothAP * 3 ), 28 )
			end
		end
	end
	--==========PLAYER NAME==========
	if GetConVar( "sthud_nametag_enabled" ):GetBool() then
		surface.SetFont( "STHUDTEXT" )
		surface.SetTextColor( ply:GetPlayerColor().x * 255, ply:GetPlayerColor().y * 255, ply:GetPlayerColor().z * 255, 255 )
		if IS_HEALTH_INFO_DISABLED and IS_ARMOR_INFO_DISABLED and IS_STEAMID_DISABLED then
			surface.SetTextPos( 25, ScrH() - 54 )
		elseif ( IS_HEALTH_INFO_DISABLED and IS_ARMOR_INFO_DISABLED ) or ( IS_HEALTH_INFO_DISABLED and IS_STEAMID_DISABLED ) or ( IS_ARMOR_INFO_DISABLED and IS_STEAMID_DISABLED ) then
			surface.SetTextPos( 25, ScrH() - 100 )
		elseif IS_HEALTH_INFO_DISABLED or IS_ARMOR_INFO_DISABLED or IS_STEAMID_DISABLED then
			surface.SetTextPos( 25, ScrH() - 146 )
		else
			surface.SetTextPos( 25, ScrH() - 186 )
		end
		surface.DrawText( ply:Name() )
	end
	
	--==========STEAMID==========
	if GetConVar( "sthud_steamid_enabled" ):GetBool() then
		surface.SetFont( "STHUDTEXT" )
		surface.SetTextColor( ply:GetPlayerColor().x * 255, ply:GetPlayerColor().y * 255, ply:GetPlayerColor().z * 255, 255 )
		if IS_HEALTH_INFO_DISABLED and IS_ARMOR_INFO_DISABLED then
			surface.SetTextPos( 25, ScrH() - 54 )
		elseif IS_HEALTH_INFO_DISABLED or IS_ARMOR_INFO_DISABLED then
			surface.SetTextPos( 25, ScrH() - 100 )
		else
			surface.SetTextPos( 25, ScrH() - 140 )
		end
		surface.DrawText( pinfo )
	end
	--==================================
	--=======STUFF ON THE TOP==========
	--==================================
	
	--==========TIME==========
	local timtext = "err"
	if GetConVar( "sthud_time_enabled" ):GetBool() then
		if GetConVar( "sthud_clock_seconds" ):GetBool() then
			timtext = os.date( "%H:%M:%S" , os.time() )
		else
			timtext = os.date( "%H:%M" , os.time() )
		end
		
		if !GetConVar( "sthud_clock_military" ):GetBool() then
			local timexpl = string.Explode( ":", timtext, false )
			local thehour = tonumber( timexpl[1] )
			if thehour > 12 or thehour == 0 then
				thehour = math.abs( thehour - 12 )
				if GetConVar( "sthud_clock_seconds" ):GetBool() then
					timtext = thehour .. os.date( ":%M:%S", os.time() ) .. " PM"
				else
					timtext = thehour .. os.date( ":%M", os.time() ) .. " PM"
				end
			else
				if GetConVar( "sthud_clock_seconds" ):GetBool() then
					timtext = os.date( "%H:%M:%S" , os.time() ) .. " AM"
				else
					timtext = os.date( "%H:%M" , os.time() ) .. " AM"
				end
			end
		end
		
		surface.SetFont( "STHUDTEXT_SMALL" )
		surface.SetTextColor( GetConVar( "sthud_time_red" ):GetInt(), GetConVar( "sthud_time_green" ):GetInt(), GetConVar( "sthud_time_blue" ):GetInt(), 255 )
		if GetConVar( "sthud_swap_clockcompass" ):GetBool() then
			surface.SetTextPos( ScrW() / 2 - (surface.GetTextSize( timtext ) / 2), ScrH() - 24 )
		else
			surface.SetTextPos( ScrW() / 2 - (surface.GetTextSize( timtext ) / 2), 5 )
		end
		surface.DrawText( timtext )
	end
	--==========SPEED==========
	if GetConVar( "sthud_velocity_enabled" ):GetBool() then
		local spdtext = "vel: " .. math.Round( LocalPlayer():GetVelocity():Length() )
		surface.SetFont( "STHUDTEXT_SMALL" )
		surface.SetTextColor( GetConVar( "sthud_vel_red" ):GetInt(), GetConVar( "sthud_vel_green" ):GetInt(), GetConVar( "sthud_vel_blue" ):GetInt(), 255 )
		surface.SetTextPos( ScrW() - (surface.GetTextSize( spdtext ) + 10 ), 5 )
		surface.DrawText( spdtext )
	end
	--==========FPS==========
	local fpstext = "fps: " .. math.Round( 1/FrameTime() )
	if GetConVar( "sthud_fps_enabled" ):GetBool() then
		surface.SetFont( "STHUDTEXT_SMALL" )
		if 1/FrameTime() < 60 and 1/FrameTime() > 30 then
			surface.SetTextColor( 255, 255, 0, 255 )
		elseif 1/FrameTime() <= 30 then
			surface.SetTextColor( 255, 0, 0, 255 )
		else
			surface.SetTextColor( 0, 255, 0, 255 )
		end
		if !GetConVar( "sthud_swap_fpsping" ):GetBool() then
			surface.SetTextPos( 5 , 5 )
		else
			surface.SetTextPos( 5 , 29 )
		end
		surface.DrawText( fpstext )
	end
	--==========PING==========
	local pingtext = "ms: " .. math.Round( LocalPlayer():Ping() )
	if GetConVar( "sthud_ping_enabled" ):GetBool() then
		surface.SetFont( "STHUDTEXT_SMALL" )
		if LocalPlayer():Ping() >= 100 and LocalPlayer():Ping() < 300 then
			surface.SetTextColor( 255, 255, 0, 255 )
		elseif LocalPlayer():Ping() >= 300 then
			surface.SetTextColor( 255, 0, 0, 255 )
		else
			surface.SetTextColor( 0, 255, 0, 255 )
		end
		if GetConVar( "sthud_swap_fpsping" ):GetBool() or !GetConVar( "sthud_fps_enabled" ):GetBool() then
			surface.SetTextPos( 5 , 5 )
		else
			surface.SetTextPos( 5 , 29 )
		end
		surface.DrawText( pingtext )
	end
	--==========COMPASS==========
	if GetConVar( "sthud_compass_enabled" ):GetBool() then
		local angtext = math.Round( LocalPlayer():EyeAngles().y ) .. "°"
		local dirtext = GetCardinalDirection( math.Round( LocalPlayer():EyeAngles().y ) )
		surface.SetFont( "STHUDTEXT_SMALL" )
		surface.SetTextColor( GetConVar( "sthud_dir_red" ):GetInt(), GetConVar( "sthud_dir_green" ):GetInt(), GetConVar( "sthud_dir_blue" ):GetInt(), 255 )
		if GetConVar( "sthud_swap_clockcompass" ):GetBool() then
			surface.SetTextPos( ScrW() / 2 - (surface.GetTextSize( "|" ) / 2), 5 )
		else
			surface.SetTextPos( ScrW() / 2 - (surface.GetTextSize( "|" ) / 2), ScrH() - 24 )
		end
		surface.DrawText( "|" )
		if GetConVar( "sthud_swap_clockcompass" ):GetBool() then
			surface.SetTextPos( ScrW() / 2 - (surface.GetTextSize( angtext ) + 5 ), 5 )
		else
			surface.SetTextPos( ScrW() / 2 - (surface.GetTextSize( angtext ) + 5 ), ScrH() - 24 )
		end
		if GetConVar( "sthud_compass_mode" ):GetInt() == 1 or GetConVar( "sthud_compass_mode" ):GetInt() == 3 then 
			surface.DrawText( angtext )
		end
		if GetConVar( "sthud_swap_clockcompass" ):GetBool() then
			surface.SetTextPos( ScrW() / 2 + 7, 5 )
		else
			surface.SetTextPos( ScrW() / 2 + 7, ScrH() - 24 )
		end
		if GetConVar( "sthud_compass_mode" ):GetInt() == 2 or GetConVar( "sthud_compass_mode" ):GetInt() == 3 then
			surface.DrawText( dirtext )
		end
	end
	
	end
	
end )

local hide = {
	CHudAmmo = true,
	CHudBattery = true,
	CHudHealth = true,
	CHudSecondaryAmmo = true
}

hook.Add( "HUDShouldDraw", "HideDefaults_ST", function(n)
	if GetConVar( "sthud_enabled" ):GetBool() then
		if (hide[n]) then return false end
	end
	--returning breaks shit, dont do it
end )