----------------------------------------------------------------
--[[ Resource: Graphify Library
     Shaders: initial.lua
     Server: -
     Author: OvileAmriam, Ren712
     Developer: Aviril
     DOC: 29/09/2021 (OvileAmriam)
     Desc: Shader Initializer ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    fetchFileData = fetchFileData
}


-------------------
--[[ Variables ]]--
-------------------

AVAILABLE_SHADERS = {

    ["Utilities"] = {
        ["MTA_Helper"] = imports.fetchFileData("files/shaders/utilities/mta-helper.fx")
    },
    ["Bloom"] = {},
    ["World"] = {
        ["VS"] = {},
        ["No_VS"] = {}
    },
    ["Ped"] = {},
    ["Vehicle"] = {
        ["VS"] = {},
        ["No_VS"] = {}
    },
    ["Sky"] = {},
    ["Water"] = {}

}