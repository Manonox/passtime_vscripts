local Team = PassTime.CreateModule("Team");


Team.names <- { [2] = "RED", [3] = "BLU" };
Team.GetName <- function(team) {
    if (!(team in Team.names))
        return "Unknown";
    return Team.names[team];
}

local oppositeTeam = { [2] = 3, [3] = 2 };
Team.GetOpposite <- function(team) {
    if (!(team in oppositeTeam)) return team;
    return oppositeTeam[team];
}