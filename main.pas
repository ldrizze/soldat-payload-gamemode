uses Collider, Payload;

var 
    Payload: TPayload;

procedure Update(Ticks: Integer);
var collisionDetector: Byte;
begin

    Players.WorldText(1, #48, 60, RGB(255,0,0), 0.1, Payload.Collider.X, Payload.Collider.Y);
    Players.WorldText(2, #48, 60, RGB(255,0,0), 0.1, Payload.Collider.X+Payload.Collider.W-20, Payload.Collider.Y);

    Players.WorldText(3, #48, 60, RGB(255,0,0), 0.1, Payload.Collider.X, Payload.Collider.Y+Payload.Collider.H-20);
    Players.WorldText(4, #48, 60, RGB(255,0,0), 0.1, Payload.Collider.X+Payload.Collider.W-20, Payload.Collider.Y+Payload.Collider.H-20);
    
    //Players.Player[1].Tell(floattostr(Players.Player[1].X) + ',' + floattostr(Players.Player[1].Y));
    collisionDetector := CollisionBox_CollideWithXY(Payload.Collider, Players.Player[1].X, Players.Player[1].Y, 10, 20);
    if collisionDetector <> CollisionBox_NONE then Payload.OnPlayerCollision(Players.Player[1], collisionDetector);

end;

procedure OnPlayerCollidesOnPayload(Player: TActivePlayer; Side: Byte);
begin

    Player.Tell('Payload collision at: '+inttostr(Side));
    Player.Tell('Player Position: '+floattostr(Player.X)+','+floattostr(Player.Y));
    Player.Tell('Payload Position: '+floattostr(Payload.Collider.X)+','+floattostr(Payload.Collider.Y));
    
    if Side = CollisionBox_LEFT then Player.SetVelocity(-0.1, Player.VelY);
    if Side = CollisionBox_RIGHT then Player.SetVelocity(0.1, Player.VelY);
    if Side = CollisionBox_UP then Player.SetVelocity(Player.VelX, -0.1);
    if Side = CollisionBox_DOWN then Player.SetVelocity(Player.VelX, 0.1);

end;


procedure OnPlayerCommand (Player: TActivePlayer; Text: string);
begin
    if Text='!coords' then Player.Tell(floattostr(Player.X) + ',' + floattostr(Player.Y));
end;

begin
    
    // Create the Payload Collider
    Payload.Collider := CollisionBox_Create(200, 200, -100, -500.0);
    Payload.OnPlayerCollision := @OnPlayerCollidesOnPayload;

    // Set Clock tick to update game logic
    Game.TickThreshold := 1;
    Game.OnClockTick := @Update;

    Players.Player[1].OnSpeak := @OnPlayerCommand;

end.