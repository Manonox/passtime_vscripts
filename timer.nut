local Timer = PassTime.CreateModule("Timer");


if (!("all" in Timer))
	Timer.all <- {};


Timer.Create <- function(name, time, func) {
	Timer.all[name] <- {
		name = name,
		last = Time(),
		time = time,
		func = func,
	};
}

Timer.Remove <- function(name) {
	if (name in Timer.all)
		delete Timer.all[name];
}


g_pt_Timer_think <- function() {
	PassTime.Hook.Incoming("think", null);
	PassTime.Hook.Incoming("tick", null);

	local time = Time();
	foreach(name, timer in Timer.all) {
		if (time - timer.last >= timer.time) {
			timer.last = time;
			try {
				timer.func();
			} catch (e) {
				Timer.Log("Error in '" + name.tostring() + "': " + e.tostring());
			}
		}
	}

	return -1;
}

Timer.CheckThinker <- function() {
	if (!(("thinker" in Timer) && Timer.thinker.IsValid()))
		Timer.thinker <- Entities.CreateByClassname("logic_relay");
	AddThinkToEnt(Timer.thinker, "g_pt_Timer_think");
}

Timer.CheckThinker();
Timer.Hook.Add("entities_reset", "RestartThink", function(params) {
	Timer.CheckThinker();
});


PassTime.CreateModuleExtension("Timer", function(id, table) {
	table.Timer <- {
		Create = function(name, time, func) {
			PassTime.Timer.Create(id + "_" + name, time, func);
		},
		Remove = function(name) {
			PassTime.Timer.Remove(id + "_" + name);
		},
	};
});
