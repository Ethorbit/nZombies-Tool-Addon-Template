-- Since this is a thirdparty addon, it loads inconsistently with nZombies
-- We will use this file to run our tool files AFTER the gamemode loads

if SERVER then 
    AddCSLuaFile("template_tool/sh_tool.lua")
    AddCSLuaFile("template_tool/sh_cmenu.lua")

    hook.Add("Initialize", "ToolTemplate_Initialize", function() -- Wait until the gamemode loads first.
        include("template_tool/sh_tool.lua")
        include("template_tool/sh_cmenu.lua")
        include("template_tool/sv_save-load.lua")
    end)
end

if CLIENT then
    hook.Add("InitPostEntity", "ToolTemplate_Initialize", function() -- Wait
        include("template_tool/sh_tool.lua")
        include("template_tool/sh_cmenu.lua")
    end)
end