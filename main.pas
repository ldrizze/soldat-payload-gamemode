uses Collider, Payload;

var 
    Payload:TPayload;
    UltLevel:Byte;

procedure RenderPayload();
begin
    Players.WorldText(1, '\', 600, RGB(255,0,0), 0.1, Payload.Collider.X, Payload.Collider.Y-20);
    Players.WorldText(2, '\', 600, RGB(255,0,0), 0.1, Payload.Collider.X + Payload.Collider.W, Payload.Collider.Y-20);
    Players.WorldText(3, '/', 600, RGB(255,0,0), 0.1, Payload.Collider.X, Payload.Collider.Y + Payload.Collider.H-20);
    Players.WorldText(4, '/', 600, RGB(255,0,0), 0.1, Payload.Collider.X + Payload.Collider.W, Payload.Collider.Y + Payload.Collider.H-20);

    Players.WorldText(5, '|', 600, RGB(0,255,0), 0.1, Payload.ExternalCollider.X, Payload.ExternalCollider.Y-20);
    Players.WorldText(6, '|', 600, RGB(0,255,0), 0.1, Payload.ExternalCollider.X + Payload.ExternalCollider.W, Payload.ExternalCollider.Y-20);
    Players.WorldText(7, '|', 600, RGB(0,255,0), 0.1, Payload.ExternalCollider.X, Payload.ExternalCollider.Y + Payload.ExternalCollider.H-20);
    Players.WorldText(8, '|', 600, RGB(0,255,0), 0.1, Payload.ExternalCollider.X + Payload.ExternalCollider.W, Payload.ExternalCollider.Y + Payload.ExternalCollider.H-20);

end;

procedure RenderPlayerUI(Player: TActivePlayer; UltimateLevel:Byte);
    var i:Byte;
        ultColor:Longint;
begin

    // Ultimate bar
    Player.BigText(100, '||', 120, RGB(0,0,0), 0.1, 10, 383);
    Player.BigText(101, '||', 120, RGB(0,0,0), 0.1, 10, 372);
    Player.BigText(102, '||', 120, RGB(0,0,0), 0.1, 10, 361);
    Player.BigText(103, '||', 120, RGB(0,0,0), 0.1, 10, 350);
    Player.BigText(104, '||', 120, RGB(0,0,0), 0.1, 10, 339);
    Player.BigText(105, '||', 120, RGB(0,0,0), 0.1, 10, 328);

    Player.BigText(106, '_', 120, RGB(0,0,0), 0.08, 12, 318);
    Player.BigText(107, '_', 120, RGB(0,0,0), 0.08, 12, 384);

    // Barrinhas
    for i:=10 to 22 do begin
        if UltimateLevel >= i-9 then ultColor := RGB(0,255,0)
        else ultColor := RGB(255,0,0);
        Player.BigText(i, '.', 120, ultColor, 0.24, 10, 298 + (5 * (22-i)));
    end;

end;

procedure Update(Ticks: Integer);
var 
    collisionDetector,i: Byte;
begin

    // Init vars
    Payload.isMoving := false;
    if (Ticks mod 60) = 0 then begin
        UltLevel := UltLevel + 1;
    end;
    if UltLevel > 13 then UltLevel := 0;

    // Render payload
    RenderPayload();
    
    // Players events
    for i := 1 to 32 do begin
        
        // Inside Collider check
        if Players.Player[i].Alive then begin
            collisionDetector := CollisionBox_CollideWithXY(Payload.Collider, Players.Player[i].X, Players.Player[i].Y, 10, 10);
            if collisionDetector <> CollisionBox_NONE then Payload.OnPlayerCollision(Players.Player[i], collisionDetector);
        end;

        // External Collider check
        if Players.Player[i].Alive then begin
            collisionDetector := CollisionBox_CollideWithXY(Payload.ExternalCollider, Players.Player[i].X, Players.Player[i].Y, 10, 10);
            if collisionDetector = CollisionBox_FULL then begin
                Payload.OnPlayerExternalCollision(Players.Player[i], collisionDetector);
            end;
        end;

        // Players that activate the ultimate
        // if Players.Player[i].Alive and Players.Player[i].KeyFlagThrow then Players.Player[i].Say('I GOT YOU IN MY SIGHTS!');

        // Update and render player UI
        if Players.Player[i].Alive then RenderPlayerUI(Players.Player[i], UltLevel);
    end;

    // Update payload position
    if Payload.isMoving = true then begin
        Payload.xVel := Payload.xVel + Payload.velStep;
        if Payload.xVel > Payload.velMax then Payload.xVel := Payload.velMax;

        Payload.Collider.X := Payload.Collider.X + Payload.xVel;
        Payload.ExternalCollider.X := Payload.ExternalCollider.X + Payload.xVel;
    end else Payload.xVel := 0;
end;

procedure OnPlayerCollidesOnPayload(Player: TActivePlayer; Side: Byte);
begin
    
    if Side = CollisionBox_LEFT then Player.SetVelocity(-0.15 - Payload.xVel, Player.VelY);
    if Side = CollisionBox_RIGHT then Player.SetVelocity(0.15 + Payload.xVel, Player.VelY);
    if Side = CollisionBox_UP then begin
        if Player.KeyUp and not Player.IsProne then Player.SetVelocity(Player.VelX, -3)
        else Player.SetVelocity(Player.VelX, -0.1);
    end;
    if Side = CollisionBox_DOWN then Player.SetVelocity(Player.VelX, 0.15 + Payload.xVel);

end;

procedure OnPlayerCollidesExternalPayloadCollider(Player: TActivePlayer; Side: Byte);
begin
    if Player.Team = 2 then Payload.isMoving := true;
end;

procedure OnPlayerCommand (Player: TActivePlayer; Text: string);
begin
    if Text='!coords' then Player.Tell(floattostr(Player.X) + ',' + floattostr(Player.Y));
end;

begin
    // Setup Vars
    UltLevel := 0;

    // Create and setup the Payload and Payload Collider
    Payload.Collider := CollisionBox_Create(100, 50, -3336, -293);
    Payload.ExternalCollider := CollisionBox_Create(270, 144, -3406, -387);
    Payload.OnPlayerCollision := @OnPlayerCollidesOnPayload;
    Payload.OnPlayerExternalCollision := @OnPlayerCollidesExternalPayloadCollider;
    Payload.velStep := 0.002;
    Payload.velMax := 0.3;
    Payload.xVel := 0.0;

    // Set Clock tick to update game logic
    Game.TickThreshold := 1;
    Game.OnClockTick := @Update;

    // Custom 
    Players.Player[1].OnSpeak := @OnPlayerCommand;

end.