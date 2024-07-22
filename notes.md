# Init logic

Set game update tick as **SC3GameLogicUpdate** procedure

Create player UI and commands in init script, so it's created once

# Update logic

If payload is not set to end (_Payload.isEnd_) then begin Iterate over players

Check if the player is colliding with the payload XY using
**CollisionBox_CollideWithXY** passing the _Payload.ExternalCollider_ to check collision with player, fixing the player collider as  10 width and 10 height

If it collides, trigger the procedure **OnPlayerCollidesExternalPayloadCollider** defined in the _CreatePayload_ procedure

The _OnPlayerCollidesExternalPayloadCollider_ procedure check if the colliding player is from Team Alpha or Team Bravo and set **Payload.isContested** to true and **Payload.isMoving** to true respectively

After the Payload collision check, update the player classes by ticking the ultimate instances. Firstly, check if the ultimate is **not active** then update the percentage by **50** percent (test purposes)

So check the all **active ultimes** and decrease the ultimate percentage based on ultimate **duration** setting. If the duration count is more than or equal the duration then reset the ultimate using the **ResetUltimate** procedure



