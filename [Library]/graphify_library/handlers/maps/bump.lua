----------------------------------------------------------------
--[[ Resource: Graphify Library
     Script: handlers: maps: bump.lua
     Server: -
     Author: OvileAmriam, Ren712
     Developer: Aviril
     DOC: 29/09/2021 (OvileAmriam)
     Desc: Bump Map Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    unpack = unpack,
    isElement = isElement,
    getElementType = getElementType,
    syncRTWithShader = syncRTWithShader,
    getControlMap = getControlMap,
    dxCreateShader = dxCreateShader,
    dxSetShaderValue = dxSetShaderValue,
    engineApplyShaderToWorldTexture = engineApplyShaderToWorldTexture
}


--------------------------------------
--[[ Function: Generates Bump Map ]]--
--------------------------------------

function generateBumpMap(texture, type, bumpMap)

    type = ((type == "object") and "world") or type
    if not texture or not type or not normalMapCache.validNormalTypes[type] or not bumpMap or not imports.isElement(bumpMap) or (imports.getElementType(bumpMap) ~= "texture") or normalMapCache.normalMaps.textures[texture] then return false end

    local textureControlMap, textureNormalMap = imports.getControlMap(texture), getNormalMap(texture)
    local createdNormalMap = textureControlMap or textureNormalMap or false
    if not createdNormalMap then
        createdNormalMap = imports.dxCreateShader(imports.unpack(normalMapCache.validNormalTypes[type].rwData))
        normalMapCache.normalMaps.shaders[createdNormalMap] = {
            texture = texture,
            type = type,
            shaderMaps = {}
        }
        normalMapCache.normalMaps.textures[texture] = createdNormalMap
        if normalMapCache.validNormalTypes[type].syncRT then
            imports.syncRTWithShader(createdNormalMap)
        end
        for i, j in imports.pairs(normalMapCache.validNormalTypes[type].parameters) do
            imports.dxSetShaderValue(createdNormalMap, i, imports.unpack(j))
        end
    end
    --TODO: STORE IN PROPER REFERENCE...
    normalMapCache.normalMaps.shaders[createdNormalMap].shaderMaps.bump = bumpMap
    imports.dxSetShaderValue(createdNormalMap, "enableBumpMap", true)
    imports.dxSetShaderValue(createdNormalMap, "bumpTexture", bumpMap)
    if not textureControlMap then
        imports.engineApplyShaderToWorldTexture(createdNormalMap, texture)
    end
    return createdNormalMap

end