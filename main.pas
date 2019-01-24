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
        ultColor := RGB(255,0,0);

        calc := i-9;
        calc := round((calc*100)/13);
        
        if percentage >= calc then begin
            if playerUltimate.isActive then ultColor := RGB(255, 255, 255)
            else ultColor := RGB(0,255,0);
        end;
        Player.BigText(i, '.', 120, ultColor, 0.24, 10, 298 + (5 * (22-i)));
    end;

    // Type
    if playerUltimate.isActive then numericRepresentation := inttostr(playerUltimate.duration - playerUltimate.durationCount)+'s'
    else numericRepresentation := inttostr(percentage)+'%';
    Player.BigText(108, numericRepresentation, 61, RGB(255,255,255), 0.05, 10, 400);

end;

procedure SC3GameLogicUpdate(Ticks: Integer);
var 
    collisionDetector,i: Byte;
    playerClass:TPlayerClass;
    playerUltimate:TUltimate;
    calc: Smallint;
begin

    // Init vars
    Payload.isMoving := false;
    Payload.isContested := false;
    
    {
        PLAYER UPDATE LOGIC
    }
    // Players events
    for i := 1 to 32 do begin
        
        // Only update events if player is alive
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

                // Update ultimate tick count
                UltimateInstances[Players.Player[i].ID].tickCount := UltimateInstances[Players.Player[i].ID].tickCount + Game.TickThreshold;
                if UltimateInstances[Players.Player[i].ID].tickCount > 60 then UltimateInstances[Players.Player[i].ID].tickCount := 60;

                // Update ultimate percentage
                if not UltimateInstances[Players.Player[i].ID].isActive then begin
                    if UltimateInstances[Players.Player[i].ID].tickCount = 60 then begin 
                        UltimateInstances[Players.Player[i].ID].percentage := UltimateInstances[Players.Player[i].ID].percentage + 50;
                        UltimateInstances[Players.Player[i].ID].tickCount := 0;
                    end;
                    
                    if UltimateInstances[Players.Player[i].ID].percentage >= 100 then begin 
                        UltimateInstances[Players.Player[i].ID].percentage := 100;
                    end;
                end;

                // Update all active ultimates
                if UltimateInstances[Players.Player[i].ID].isActive then begin
                    UltimateInstances[Players.Player[i].ID].tickCount := UltimateInstances[Players.Player[i].ID].tickCount + Game.TickThreshold;

                    // Update duration count
                    if UltimateInstances[Players.Player[i].ID].tickCount > 60 then begin
                        UltimateInstances[Players.Player[i].ID].tickCount := 0;
                        UltimateInstances[Players.Player[i].ID].durationCount := UltimateInstances[Players.Player[i].ID].durationCount + 1;
                        calc := UltimateInstances[Players.Player[i].ID].duration - UltimateInstances[Players.Player[i].ID].durationCount;
                        calc := calc * 100;
                        calc := calc div UltimateInstances[Players.Player[i].ID].duration;
                        Players.Player[i].Tell(inttostr(calc));
                        UltimateInstances[Players.Player[i].ID].percentage := calc;
                    end;

                    // Check if ultimate is ended
                    if UltimateInstances[Players.Player[i].ID].durationCount >= UltimateInstances[Players.Player[i].ID].duration then begin
                        UltimateInstances[Players.Player[i].ID].cancelUltimate(Players.Player[i]);
                        ResetUltimate(Players.Player[i].ID);
                    end;
                end;

                // Players that activate the ultimate
                if not (playerUltimate.isActive) and (Players.Player[i].KeyFlagThrow) and (UltimateInstances[Players.Player[i].ID].percentage=100) then begin 
                    UltimateInstances[Players.Player[i].ID].tickCount := 0;
                    UltimateInstances[Players.Player[i].ID].isActive := true;
                    UltimateInstances[Players.Player[i].ID].doTheUltimate(Players.Player[i]);
                end;
            end;

            // Render the player UI
            RenderPlayerUI(Players.Player[i]);
        end;
    end;
    {
        PLAYER UPDATE LOGIC
    }


    { 
        PAYLOAD UPDATE LOGIC
    }
    // Update payload position
    if Payload.isMoving and not Payload.isContested then begin
        Payload.xVel := Payload.xVel + Payload.velStep;
        if Payload.xVel > Payload.velMax then Payload.xVel := Payload.velMax;

        Payload.Collider.X := Payload.Collider.X + Payload.xVel;
        Payload.ExternalCollider.X := Payload.ExternalCollider.X + Payload.xVel;
    end else Payload.xVel := 0;

    // Render payload
    RenderPayload();
    RenderPayloadWaypoints();
    { 
        PAYLOAD UPDATE LOGIC
    }
end;

procedure OnPlayerCollidesOnPayload(Player: TActivePlayer; Side: Byte);
begin
    
    if Side = CollisionBox_LEFT then Player.SetVelocity(-0.5 - Payload.xVel, Player.VelY);
    if Side = CollisionBox_RIGHT then Player.SetVelocity((Payload.xVel) + Payload.xVel, Player.VelY);
    if Side = CollisionBox_UP then begin
        if Player.KeyUp and not Player.IsProne then Player.SetVelocity(Player.VelX, -3)
        else Player.SetVelocity(Player.VelX, -0.1);
    end;
    if Side = CollisionBox_DOWN then Player.SetVelocity(Player.VelX, (Payload.xVel) + Payload.xVel);

end;

procedure OnPlayerCollidesExternalPayloadCollider(Player: TActivePlayer; Side: Byte);
begin
    if Player.Team = 2 then Payload.isMoving := true;
    if Player.Team = 1 then Payload.isContested := true;
end;

procedure SC3OnPlayerCommand (Player: TActivePlayer; Text: string);
begin
    if Text='!coords' then Player.Tell(floattostr(Player.X) + ',' + floattostr(Player.Y));
    if Text='!class pyro' then begin
        Player.Tell('Changing your class to PYRO');
        CreatePlayerClass(CLASS_TYPE_PYRO, Player);
    end;
end;

procedure SC3OnPlayerLeave (Player: TActivePlayer; Kicked: Boolean);
begin
    DestroyPlayerClass(Player.ID);
end;

procedure SC3OnPlayerLeaveTeam (Player: TActivePlayer; Team: TTeam; Kicked: Boolean);
begin
    DestroyPlayerClass(Player.ID);
end;

begin
    // Setup Vars
    UltLevel := 0;

    // Create and setup the Payload and Payload Collider
    Payload.Collider := CollisionBox_Create(100, 50, -3336, -293);
    Payload.ExternalCollider := CollisionBox_Create(270, 144, -3406, -387);
    Payload.OnPlayerCollision := @OnPlayerCollidesOnPayload;
    Payload.OnPlayerExternalCollision := @OnPlayerCollidesExternalPayloadCollider;
    Payload.velStep := 0.1;
    Payload.velMax := 7;
    Payload.xVel := 0.0;

    // Set Clock tick to update game logic
    Game.TickThreshold := 1; // 100 ms tick test
    Game.OnClockTick := @SC3GameLogicUpdate;

    // Game on player leave
    Game.Teams[1].OnLeave := @SC3OnPlayerLeaveTeam;
    Game.Teams[2].OnLeave := @SC3OnPlayerLeaveTeam;
    Game.OnLeave := @SC3OnPlayerLeave;

    // Custom
    for i:=1 to 10 do Players.Player[i].OnSpeak := @SC3OnPlayerCommand;
end.