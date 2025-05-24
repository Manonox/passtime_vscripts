if(!("PassTime" in getroottable())) {
	PassTime <- {};
}

function PassTime::Log(msg) {
	printl("[PassTime] " + msg)
}


PassTime.moduleExtensions <- {};

function PassTime::CreateModule(id) {
	if(!(id in PassTime)) {
		PassTime[id] <- {
			id = id,
			Log = function(msg) {
				printl("[PassTime - " + id + "] " + msg);
			},
		};

		foreach (key, func in PassTime.moduleExtensions) {
			func(id, PassTime[id]);
		}
	}
	
	return PassTime[id];
}

function PassTime::CreateModuleExtension(key, func) {
	PassTime.moduleExtensions[key] <- func;
}


DoIncludeScript("passtime/util", this);

DoIncludeScript("passtime/hook", this);
DoIncludeScript("passtime/reset", this);
DoIncludeScript("passtime/timer", this);
DoIncludeScript("passtime/team", this);
DoIncludeScript("passtime/goal", this);
DoIncludeScript("passtime/commands", this);
