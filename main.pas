uses Collider, Payload, PlayerClass;

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

procedure RenderPlayerUI(Player: TActivePlayer);
    var i:Byte;
        calc:Smallint;
        ultColor:Longint;
        playerClass:TPlayerClass;
        playerUltimate:TUltimate;
        percentage:Byte;
        numericRepresentation:string;
begin

    // Ultimate bar
    Player.BigText(100, '||', 61, RGB(0,0,0), 0.1, 10, 383);
    Player.BigText(101, '||', 61, RGB(0,0,0), 0.1, 10, 372);
    Player.BigText(102, '||', 61, RGB(0,0,0), 0.1, 10, 361);
    Player.BigText(103, '||', 61, RGB(0,0,0), 0.1, 10, 350);
    Player.BigText(104, '||', 61, RGB(0,0,0), 0.1, 10, 339);
    Player.BigText(105, '||', 61, RGB(0,0,0), 0.1, 10, 328);

    Player.BigText(106, '_', 61, RGB(0,0,0), 0.08, 12, 318);
    Player.BigText(107, '_', 61, RGB(0,0,0), 0.08, 12, 384);

    // Desenha os %
    GetPlayerClass(Player.ID, playerClass);
    GetUltimate(Player.ID, playerUltimate);
    if playerClass._created then percentage := playerUltimate.percentage
    else percentage := 0;

    // Barrinhas
    for i:=10 to 22 do begin
        calc := i-9;
        calc := round((calc*100)/13);
        if playerUltimate.isActive then ultColor := RGB(255, 255, 255)
        else if percentage >= calc then begin 
            ultColor := RGB(0,255,0);
        end
        else ultColor := RGB(255,0,0);
        Player.BigText(i, '.', 120, ultColor, 0.24, 10, 298 + (5 * (22-i)));
    end;

    // Type
    if playerUltimate.isActive then numericRepresentation := 'Active!'
    else numericRepresentation := inttostr(percentage)+'%';
    Player.BigText(108, numericRepresentation, 61, RGB(255,255,255), 0.05, 10, 400);

end;

procedure Update(Ticks: Integer);
var 
    collisionDetector,i: Byte;
    playerClass:TPlayerClass;
    playerUltimate:TUltimate;
begin

    // Init vars
    Payload.isMoving := false;
    Payload.isContested := false;
    
    // Players events
    for i := 1 to 32 do begin
        
        if Players.Player[i].Alive then begin
            // Inside Collider check
            collisionDetector := CollisionBox_CollideWithXY(Payload.Collider, Players.Player[i].X, Players.Player[i].Y, 10, 10);
            if collisionDetector <> CollisionBox_NONE then Payload.OnPlayerCollision(Players.Player[i], collisionDetector);

            // External Collider check
            collisionDetector := CollisionBox_CollideWithXY(Payload.ExternalCollider, Players.Player[i].X, Players.Player[i].Y, 10, 10);
            if collisionDetector = CollisionBox_FULL then begin
                Payload.OnPlayerExternalCollision(Players.Player[i], collisionDetector);
            end;

            // Update player class
            GetPlayerClass(Players.Player[i].ID, playerClass);
            if playerClass._created then begin

                // Get the player ultimate
                GetUltimate(Players.Player[i].ID, playerUltimate);

                // Update ultimate percentage
                if not UltimateInstances[Players.Player[i].ID].isActive then begin
                    if (Ticks mod 60) = 0 then begin 
                        UltimateInstances[Players.Player[i].ID].percentage := UltimateInstances[Players.Player[i].ID].percentage + 20;
                    end;
                    
                    if UltimateInstances[Players.Player[i].ID].percentage >= 100 then begin 
                        UltimateInstances[Players.Player[i].ID].percentage := 100;
                    end;
                end;

                // Players that activate the ultimate
                if not (playerUltimate.isActive) and (Players.Player[i].KeyFlagThrow) and (UltimateInstances[Players.Player[i].ID].percentage=100) then UltimateInstances[Players.Player[i].ID].doTheUltimate(Players.Player[i]);
            end;

            // Update and render player UI
            RenderPlayerUI(Players.Player[i]);
        end;
    end;

    // Update payload position
    if Payload.isMoving and not Payload.isContested then begin
        Payload.xVel := Payload.xVel + Payload.velStep;
        if Payload.xVel > Payload.velMax then Payload.xVel := Payload.velMax;

        Payload.Collider.X := Payload.Collider.X + Payload.xVel;
        Payload.ExternalCollider.X := Payload.ExternalCollider.X + Payload.xVel;
    end else Payload.xVel := 0;

    // Render payload
    RenderPayload();
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
    if Player.Team = 1 then Payload.isContested := true;
end;

procedure OnPlayerCommand (Player: TActivePlayer; Text: string);
begin
    if Text='!coords' then Player.Tell(floattostr(Player.X) + ',' + floattostr(Player.Y));
    if Text='!class pyro' then begin
        Player.Tell('Changing your class to PYRO');
        CreatePlayerClass(CLASS_TYPE_PYRO, Player);
    end;
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
    for i:=1 to 32 do Players.Player[i].OnSpeak := @OnPlayerCommand;

end.