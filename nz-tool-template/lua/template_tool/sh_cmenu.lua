-- Creates a helpful option in the Context Menu when you right-click the entity, 
-- which gives players a menu to continue editing it AFTER it has already been placed.

properties.Add( "Template Entity Settings", {
	MenuLabel = "Edit...",
	Order = 9001,
	PrependSpacer = true,
	MenuIcon = "icon16/pencil.png",

	Filter = function( self, ent, ply ) -- Return true to show this menu for the entity (For example, if you only have return true in this, every single entity will have this property menu)
		
        if (!IsValid(ent) or !IsValid(ply)) then return false end -- Entity is not valid, we return now so our below checks don't trigger lua errors
		if (ent:GetClass() != "template_tool_entity") then return false end -- Important, change the classname to your entity's class

        -- You almost always want this property to only exist in Creative Mode
		if !nzRound:InState( ROUND_CREATE ) then return false end 
		if (!ply:IsInCreative()) then return false end

		return true
        
	end,

	Action = function( self, ent ) -- When the user opens the context menu assigned to the entity (THIS RUNS CLIENTSIDE ONLY)
		local frame = vgui.Create("DFrame")
		frame:SetPos( 100, 100 )
		frame:SetSize( 300, 280 )
		frame:SetTitle( "Edit..." )
		frame:SetVisible( true )
		frame:SetDraggable( true )
		frame:ShowCloseButton( true )
		frame:MakePopup()
		frame:Center()
		
		local data = {}
		data.modelscale = ent:GetScale()

		local panel = nzTools.ToolData["template_tool"].interface(frame, data)
		panel:SetPos(10, 40)
		
		local data2 = panel.CompileData()
		panel.UpdateData = function(data)
			data2 = data
		end

		local submit = vgui.Create("DButton", frame)
		submit:SetText("Submit")
		submit:SetPos(50, 245)
		submit:SetSize(200, 25)
		submit.DoClick = function(self2)
			self:MsgStart()
				net.WriteEntity( ent )
				net.WriteTable( data2 )
			self:MsgEnd()
		end
	end,
	Receive = function( self, length, ply ) -- When the user presses the Submit button, it networks the data over to this function (THIS RUNS SERVERSIDE ONLY)
		local ent = net.ReadEntity()
		local data = net.ReadTable()

		if ( !self:Filter( ent, ply ) ) then return false end
		
		nzTools.ToolData["template_tool"].PrimaryAttack(nil, ply, {Entity = ent}, data)
	end
} )