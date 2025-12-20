# Payload mode for Soldat game

This script is intended to be an "new game mode" for Soldat game. Like the payload game mode from Overwatch, this new game mode comes with player classes, ultimates and the challenge to deliver a the payload to the enemy base.

# Installation and initialization

Clone/copy this repository to Soldat's server script folder. It can be named whatever you want. It's important to follow a few rules:

- Disable anti-cheat kick, some ultimates can be considered cheating
- Lower the sandbox level to 1 (set the Sandbox option to 1 in server.ini)
- Use only maps that already has a waypoint file created for it. To see if has a waypoint file, check th data > waypoints folder, there's a file with same map name but with a .txt extension
- To create a new waypoint file check the [data/README.MD](https://github.com/ldrizze/soldat-payload-gamemode/tree/master/data) in the data > waypoints folder

# Script tips
Some tips about the script, how to extend it and how to read the unit files.

## Init logic
The init logic makes sure that the game is ready to start and initializes the payload, UI, player classes and ultimates. It not will work if there's no payload waypoint file created for the map.

## Update logic
The update logic is divided in four major steps (a.k.a render stages): UI render, HUD render, player specific UI (life and ultimate time) and payload render. You can see the render stages by searching for _\_renderStage_.

### Collision
If payload is not set to end (_Payload.isEnd_) then begin Iterate over players. Check if the player is colliding with the payload XY using
**CollisionBox_CollideWithXY** passing the _Payload.ExternalCollider_ to check collision with player, fixing the player collider as  10 width and 10 height. If it collides, trigger the procedure **OnPlayerCollidesExternalPayloadCollider** defined in the _CreatePayload_ procedure. The _OnPlayerCollidesExternalPayloadCollider_ procedure check if the colliding player is from Team Alpha or Team Bravo and set **Payload.isContested** to true and **Payload.isMoving** to true respectively. After the Payload collision check, update the player classes by ticking the ultimate instances.

### Player classes and ultimes
Firstly, check if the ultimate is **not active** then update the percentage by **50** percent (test purposes). So check the all **active ultimes** and decrease the ultimate percentage based on ultimate **duration** setting. If the duration count is more than or equal the duration then reset the ultimate using the **ResetUltimate** procedure.

### UI and text
The player's UI is made using purely text that's rely in some proportions that are:

```
WorldText Point distances (text scale 1.0):
	Above: 17
	Sides: 29
```
