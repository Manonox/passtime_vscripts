function GetSteamID(player) {
    local steamID = NetProps.GetPropString(player, "m_szNetworkIDString")
    if (steamID != null) {
        return steamID
    }
}

// How in the actual fuck are these missing in the base library?
function min(a, b) {
    if (a < b) {
        return a;
    } else {
        return b;
    }
}

function max(a, b) {
    if (a > b) {
        return a;
    } else {
        return b;
    }
}

function clamp(x, minVal, maxVal) {
    return min(max(x, minVal), maxVal);
}


function AllPlayers() {
	local arr = [];
	for (local i = 1; i <= MaxClients().tointeger(); i++) {
		local player = PlayerInstanceFromIndex(i);
		if (player == null)
			continue;
		arr.push(player);
	}
	return arr;
}
