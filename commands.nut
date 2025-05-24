local Commands = PassTime.CreateModule("Commands");
PassTime.Commands <- Commands;

Commands.Hook.Add("player_say", "ev_player_command", function(params) {
	local words = split(params.text, " ", true);
	local strTextFirstWord = words[0];

	if (!(strTextFirstWord.len() > 1 && strTextFirstWord[0] == '!'))
		return;

	local player = GetPlayerFromUserID(params.userid);
	if (!player || !player.IsValid())
		return;

	local command = strTextFirstWord.slice(1).tolower();
	local arguments = words.slice(1);

	local steamID = GetSteamID(player);
	PassTime.Log("Player " + player + " with SteamID " + steamID + " sent command: " + command);

	local commandEventParams = {
		player = player,
		arguments = arguments,
		fulltext = params.text,
	};

	PassTime.Hook.Incoming("player_command:" + command, commandEventParams);
})
