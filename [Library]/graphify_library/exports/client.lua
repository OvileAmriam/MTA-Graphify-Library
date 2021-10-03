----------------------------------------------------------------
--[[ Resource: Graphify Library
     Script: exports: client.lua
     Server: -
     Author: OvileAmriam, Ren712
     Developer: Aviril
     DOC: 29/09/2021 (OvileAmriam)
     Desc: Client Sided Exports ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    tonumber = tonumber,
    isElement = isElement,
    getElementType = getElementType,
    destroyElement = destroyElement,
    disableNormals = disableNormals,
    dxSetShaderValue = dxSetShaderValue,
    engineApplyShaderToWorldTexture = engineApplyShaderToWorldTexture,
    engineRemoveShaderFromWorldTexture = engineRemoveShaderFromWorldTexture
}


---------------------------------------
--[[ Function: Retrieves Layer RTs ]]--
---------------------------------------

function getLayerRTs()

    if isGraphifySupported then 
        return createdRTs
    end
    return false

end


--------------------------------------------------
--[[ Function: Sets Normal Generation's State ]]--
--------------------------------------------------

function setNormalGenerationState(...)

    if isGraphifySupported then
        return imports.disableNormals(...)
    end
    return false

end


------------------------------------------
--[[ Function: Sets Sky-Map's Texture ]]--
------------------------------------------

function setSkyMapTexture(texture)

    if isGraphifySupported and texture and imports.isElement(texture) and (imports.getElementType(texture) == "texture") then
        return imports.dxSetShaderValue(createdShaders.sky_RT_Input_Transform.shader, "skyMapTexture", texture)
    end
    return false

end


--------------------------------------------
--[[ Function: Sets Ambience Multiplier ]]--
--------------------------------------------

function setAmbienceMutiplier(multiplier)

    if isGraphifySupported then
        multiplier = imports.tonumber(multiplier) or false
        for i, j in imports.pairs(createdShaders) do
            if (i ~= "__SORT_ORDER__") and j.ambientSupport then
                imports.dxSetShaderValue(j.shader, "ambienceMultiplier", multiplier)
            end
        end
        return true
    end
    return false

end


-------------------------------------------------
--[[ Functions: Sets/Retrieves Emissive Mode ]]--
-------------------------------------------------

function setEmissiveMode(state)

    if isGraphifySupported then
        if state == true then
            return createEmissiveMode()
        elseif state == false then
            return destroyEmissiveMode()
        end
    end
    return false

end

function getEmissiveMode()

    if isGraphifySupported then
        return emissiveMapCache.state
    end
    return false

end


-------------------------------------------------
--[[ Function: Sets Texture's Emissive State ]]--
-------------------------------------------------

function setTextureEmissiveState(texture, type, state)

    if isGraphifySupported and texture and type and ((state == true) or (state == false)) then
        type = ((type == "object") and "world") or type
        local emissiveShader = emissiveMapCache.validEmissiveTypes[type]
        if emissiveShader then
            local setterFunction = (state and imports.engineApplyShaderToWorldTexture) or imports.engineRemoveShaderFromWorldTexture
            return setterFunction(emissiveShader.shader, texture)
        end
    end
    return false

end


-------------------------------------------------
--[[ Functions: Creates/Destroys Control-Map ]]--
-------------------------------------------------

function createControlMap(...)

    return generateControlMap(...)

end

function destroyControlMap(shader)

    if isGraphifySupported and controlMapCache.controlMaps[shader] then
        imports.destroyElement(shader)
    end
    return true

end

