local Fov = PassTime.CreateModule("Fov")

Fov.SetPlayerFOV <- function(player, fov) {
    if (!player || !player.IsValid())
		return;
    
    NetProps.SetPropInt(player, "m_iFOV", fov);
}

Fov.GetPlayerFOV <- function(player) {
    if (!player || !player.IsValid())
		return;
    
    return NetProps.GetPropInt(player, "m_iFOV");
}


if (!("store" in Fov)) {
	Fov.store <- {};
}

Fov.RestoreFOV <- function(player) {
	if (!player || !player.IsValid())
		return;
    local steamID = GetSteamID(player);
	if (!(steamID in Fov.store))
		return;
	local fovValue = Fov.store[steamID];
	Fov.SetPlayerFOV(player, fovValue);
	Fov.Log("Restored FOV " + fovValue + " for player " + player);
}

Fov.Hook.Add("player_command:fov", "SetPlayerFOV", function(params) {
	if (params.arguments.len() == 0)
		return;
	local player = params.player;
	if (!player || !player.IsValid())
		return;
	try {
		local fovValue = params.arguments[0].tointeger()
		fovValue = clamp(fovValue, 90, 110);
		
		local steamID = GetSteamID(params.player);
		Fov.store[steamID] <- fovValue;

		Fov.SetPlayerFOV(player, fovValue);
		Fov.Log("Set FOV to " + fovValue + " for player " + player);
	} catch (e) {
		Fov.Log("Invalid FOV value from player " + player);
	}
});

Fov.Hook.Add("player_spawn", "RestoreFOV", function(params) {
	if (!("userid" in params))
        return;
	local player = GetPlayerFromUserID(params.userid);
	Fov.RestoreFOV(player);
});

Fov.Hook.Add("teamplay_round_start", "RestoreFOV", function(params) {
	for (local i = 1; i <= MaxClients().tointeger(); i++) {
		local player = PlayerInstanceFromIndex(i);
		if (player == null) continue;
		Fov.RestoreFOV(player);
	}
});
