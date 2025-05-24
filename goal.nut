local Goal = PassTime.CreateModule("Goal");


Goal.Get <- function(team) {
    if (!(team in Goal.goals))
        null;
    if (Goal.goals[team].len() == 0)
        return null;
    return Goal.goals[team][0];
}

Goal.GetAll <- function(team) {
    if (!(team in Goal.goals))
        null;
    return Goal.goals[team];
}

Goal.ClosestTo <- function(position) {
    local minDist = 1000000.0;
    local minGoal = null;
    foreach (team, list in Goal.goals) {
        foreach (goal in list) {
            local goalPos = goal.GetCenter();
            local dist = (goalPos - position).Length();
            if (dist < minDist) {
                minGoal = goal;
                minDist = dist;
            }
        }
    }

    return minGoal;
}


Goal.CollectGoals <- function() {
    Goal.goals <- {
        [2] = [],
        [3] = [],
    };

    for (local goal; goal = Entities.FindByClassname(goal, "func_passtime_goal");) {
        // Opposite, bcs goal teams are swapped..?
        local team = PassTime.Team.GetOpposite(goal.GetTeam());
        if (!(team in Goal.goals)) {
            Goal.Log("Weird goal detected..? (bad team)");
            continue;
        }

        Goal.goals[team].push(goal);
        Goal.Log(format("Found goal, team: %s (%d)", PassTime.Team.GetName(team), team));
    }
}

Goal.CollectGoals();
Goal.Hook.Add("entities_reset", "CollectGoals", function(params) {
    Goal.CollectGoals();
});
