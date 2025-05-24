const ATTACKER_RESPAWN_TIME = 5; // s
const DEFENDER_RESPAWN_TIME = 3; // s


local RespawnTimes = PassTime.CreateModule("RespawnTimes");


RespawnTimes.CreateRespawnOverride <- function() {
	local respawnOverride = SpawnEntityFromTable("trigger_player_respawn_override", {
		origin = Vector(),
		spawnflags = 1,
		wait = 0.1,
		RespawnTime = 5,
		targetname = "spawn_timer",
	});

	respawnOverride.SetSize(Vector(-5, -5, -5), Vector(5, 5, 5));
	respawnOverride.SetSolid(2); // SOLID_BBOX

	return respawnOverride;
}

if (!("triggers" in RespawnTimes))
	RespawnTimes.triggers <- {};

RespawnTimes.Timer.Create("UpdateRespawnOverrides", -1, function() {
	local targetPlayers = {};
	foreach(player in AllPlayers()) {
		local team = player.GetTeam();
		local needsTrigger = team == 2 || team == 3;
		local entIndex = player.GetEntityIndex();
		if (needsTrigger) {
			targetPlayers[entIndex] <- player;
		}
	}

	foreach(index, trigger in RespawnTimes.triggers) {
		if (!(index in targetPlayers)) {
			if (trigger.IsValid())
				trigger.Destroy();
			delete RespawnTimes.triggers[index];
		}
	}

	foreach(index, player in targetPlayers) {
		if (!(index in RespawnTimes.triggers && RespawnTimes.triggers[index].IsValid())) {
			RespawnTimes.triggers[index] <- RespawnTimes.CreateRespawnOverride();
			if (!RespawnTimes.triggers[index]) {
				RespawnTimes.Log("Can't spawn trigger_player_respawn_override?");
				continue;
			}
		}

		RespawnTimes.UpdateRespawnOverride(player, RespawnTimes.triggers[index]);
	}
});


RespawnTimes.UpdateRespawnOverride <- function(player, ent) {
	local playerPos = player.GetCenter();
	ent.SetOrigin(playerPos);

	local closestGoal = PassTime.Goal.ClosestTo(playerPos);
	if (!closestGoal)
		return;
	// Opposite, bcs goal colors are swapped
	local closestGoalTeam = PassTime.Team.GetOpposite(closestGoal.GetTeam());
	local isDefender = closestGoalTeam == player.GetTeam();
	local respawnTime = ATTACKER_RESPAWN_TIME;
	if (isDefender) {
		respawnTime = DEFENDER_RESPAWN_TIME;
	}

	NetProps.SetPropFloat(ent, "m_flRespawnTime", respawnTime);
}
