-- This is your tool that will be selectable in the Q-Menu in Creative Mode
-- players will be able to click it in the list which will then set their toolgun to
-- to this

nzTools:CreateTool("template_tool", {
	displayname = "Template Entity Placer",
	desc = "LMB: Place Template Entity with Given Parameters, RMB: Remove Template Entity",
	condition = function(wep, ply)
		return true
	end,

    -- Explanation of the function paramaters:
    -- wep is the toolgun itself, 
    -- ply is the dude using this tool, 
    -- tr is a trace table (See the properties of it here: https://wiki.facepunch.com/gmod/Structures/TraceResult)
    -- data is what our tool saves and what the config sends our tool and what you'd want to send to your save/load modules

	PrimaryAttack = function(wep, ply, tr, data) -- When user left-clicks with the tool, usually where you want to create the entity.
		if (IsValid(tr.Entity) and tr.Entity:GetClass() == "template_tool_entity") then -- We're editing an existing entity
			data.pos = tr.Entity:GetPos()		
			data.entity = tr.Entity
		else 
			data.pos = tr.HitPos
			data.ply = ply
		end

        nzMapping:TemplateEntity(data)
	end,
	SecondaryAttack = function(wep, ply, tr, data) -- When user right-clicks with the tool, usually where you want to delete the entity.
		if IsValid(tr.Entity) and tr.Entity:GetClass() == "template_tool_entity" then
			tr.Entity:Remove()
		end
	end,
	Reload = function(wep, ply, tr, data)

	end,
	OnEquip = function(wep, ply, data)

	end,
	OnHolster = function(wep, ply, data)

	end
}, {
	displayname = "Template Entity Placer",
	desc = "LMB: Place Template Entity with Given Parameters, RMB: Remove Template Entity",
	icon = "icon16/asterisk_yellow.png", -- You can either use a .png shipped with your addon, OR (preferrably) go to your GarrysMod/garrysmod/garrysmod_dir.vpk (open with a program like GCFScape) and into materials/icon_16/
	weight = 10, -- The more weight, the lower this tool appears in the tool list.
	condition = function(wep, ply) -- Return true for the tool to be visible, false to hide.
		return nzTools.Advanced -- This will make it so "Advanced" mode has to be checked to see this
	end,

    -- The interface, the frame is the tool selection's panel. We want to build off of that for our tool. 
    -- This is called from the tool menu and also from the C-menu panel (if you set one up).
	interface = function(frame, data) 
        local valz = {}
        -- Assign valz to data values 
		valz["ModelScale"] = data.modelscale

		local DProperties = vgui.Create( "DProperties", frame )
		DProperties:SetSize( 400, 450 )
		DProperties:SetPos( 10, 10 )
		DProperties:Dock(FILL) 
		
		function DProperties.CompileData() -- Example: if a user were to change our float panel's value to 420.0, this function adds that value to the data that will save into configs soon.
			data.modelscale = valz["ModelScale"]
			return data
		end
		
		function DProperties.UpdateData(data)
			nzTools:SendData(data, "template_tool")
		end
		
		local ModelScale_Row = DProperties:CreateRow("Model Settings", "Scale" )
		ModelScale_Row:Setup("Float", {min = 0.0, max = 20.0})
		ModelScale_Row:SetValue(valz["ModelScale"])
		ModelScale_Row.DataChanged = function( _, val ) valz["ModelScale"] = val DProperties.UpdateData(DProperties.CompileData()) end
		ModelScale_Row:SetToolTip("You dummy, this changes the scale of the model!")

		return DProperties	
	end,

    -- Default values, ALWAYS set one. Make sure it matches the data table's variable name, the one we assign our valz table's key to
	defaultdata = { 
		modelscale = 1.0
	}
})