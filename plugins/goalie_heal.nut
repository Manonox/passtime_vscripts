const RADIUS = 500; // hu
const HEAL_DELAY = 0.5; // s
const HEAL_AMOUNT = 5; // hp
const GOAL_HEIGHT_LIMIT_OFFSET = 196; // hu


local GoalieHeal = PassTime.CreateModule("GoalieHeal");


GoalieHeal.HealPlayer <- function(player, value) {
    if (player.GetHealth() >= player.GetMaxHealth()) return;
    player.SetHealth(min(player.GetHealth() + value, player.GetMaxHealth()));
}


GoalieHeal.Timer.Create("Heal", HEAL_DELAY, function() {
    foreach (player in AllPlayers()) {
        local team = player.GetTeam();
        local goal = PassTime.Goal.Get(team);
        if (!goal)
            return;

        local goalPosition = goal.GetCenter();
        local playerPosition = player.GetCenter();

        local distSqr = (playerPosition - goalPosition).Length2DSqr();
        local verticalDiff = playerPosition.z - goalPosition.z;
        if (distSqr < RADIUS * RADIUS && verticalDiff < GOAL_HEIGHT_LIMIT_OFFSET) {
            GoalieHeal.HealPlayer(player, HEAL_AMOUNT);
        }
    }
});

