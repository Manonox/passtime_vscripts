local Reset = PassTime.CreateModule("Reset");


// Probably too many
local resetEvents = [
	"round_start",
	"scorestats_accumulated_reset",
	"teamplay_round_start",
	"teamplay_waiting_begins",
	"teamplay_setup_finished",
	"teamplay_round_active",
	"teamplay_restart_round",
	"teamplay_ready_restart",
];

foreach(resetEvent in resetEvents) {
	Reset.Hook.Add(resetEvent, "ev_entities_reset", function(params) {
		PassTime.Hook.Incoming("entities_reset", null);
	});
}
