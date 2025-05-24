local Hook = PassTime.CreateModule("Hook");

if (!("all" in Hook))
	Hook.all <- {};
if (!("events" in Hook))
	Hook.events <- {};

Hook.Add <- function(eventname, key, func) {
	local fullEventname = "OnGameEvent_" + eventname
	if (!(eventname in PassTime.Hook.all)) {
		PassTime.Hook.all[eventname] <- {};
		PassTime.Hook.events[fullEventname] <- function(params) {
			PassTime.Hook.Incoming(eventname, params);
		};

		__CollectGameEventCallbacks(PassTime.Hook.events)
	}

	PassTime.Hook.all[eventname][key] <- func;
}

Hook.Remove <- function(eventname, key) {
	if (!(eventname in PassTime.Hook.all))
		return;
	if (!key in (PassTime.Hook.all[eventname]))
		return;
	delete PassTime.Hook.all[eventname][key];
}

Hook.Incoming <- function(eventname, params) {
	if (!(eventname in PassTime.Hook.all))
		return;
	foreach(key, func in PassTime.Hook.all[eventname]) {
		func(params);
	}
}

PassTime.CreateModuleExtension("Hook", function(id, table) {
	table.Hook <- {
		Add = function(eventname, key, func) {
			PassTime.Hook.Add(eventname, id + "_" + key, func);
		},
		Remove = function(eventname, key) {
			PassTime.Hook.Remove(eventname, id + "_" + key);
		},
	};
});
