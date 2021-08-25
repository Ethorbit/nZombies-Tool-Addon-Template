-- This is where you create the config Saver, Loader and Entity creation functionality

function nzMapping:TemplateEntity(data) -- This is both called when the config loads, and (usually) when the entity is created with the tool
	local ent = data.entity or ents.Create("template_tool_entity")

    -- Configure your entity here using the params
	if data.pos then
		ent:SetPos(data.pos)
	end

	if data.modelscale then
		ent:SetScale(data.modelscale)
	end

	ent:Spawn()

    if data.ply then -- The ply param may or may not exist, and it should only ever exist when called from where the tool calls us
        -- This is what the user sees when they undo (like from pressing Z) the entity
		undo.Create("Template Entity")
			undo.SetPlayer( data.ply )
			undo.AddEntity( ent )
		undo.Finish()
	end

	return ent
end

nzMapping:AddSaveModule("TemplateEntities", { -- This is what controls saving and loading from configs, arguably the most important thing to get right. MAKE SURE TO TEST SAVE AND LOAD your entity in a config.
	savefunc = function()
		local template_entities = {}

        -- Grabs all entities of our class and saves their properties into the config (our save module is isolated and won't conflict with other saved stuff, as long as the AddSaveModule key is unique)
		for _,v in pairs(ents.FindByClass("template_tool_entity")) do
			table.insert(template_entities, {
                pos = v:GetPos(),
                modelscale = v:GetScale()
			})
		end

		return template_entities
	end,
	loadfunc = function(data) -- Called for all the TemplateEntities from a saved config file, and returns their data
		for _,template_data in pairs(data) do
			nzMapping:TemplateEntity(template_data)
		end
	end,
	cleanents = {"template_tool_entity"},
})