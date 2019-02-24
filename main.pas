uses Collider, Payload, PlayerClass, UI;

var 
    Payload:TPayload;
    waypointOffset:Byte;
    waypointX:Single;
    waypointY:Single;
    fixTextTime:Smallint;
    checkPointQuantity:Byte;
    checkPointPerc: array[1..10] of Smallint;
    MainUI: array[1..10] of TUICanvas;
    _pwcount:Byte;
    _checkpointSize:single;
    _checkpointPerc:single;

const
  sLineBreak = {$IFDEF LINUX} #10 {$ENDIF} 
               {$IFDEF MSWINDOWS} #13#10 {$ENDIF};

procedure RenderPayload();
    var baseX, baseY: Single;
begin
    baseX := Payload.Collider.X - 40;
    baseY := Payload.Collider.Y + 20;

    // The Payload
    Players.WorldText(5, 'b', fixTextTime, RGB(80,80,80), 0.2, baseX + 110, baseY-46);
    Players.WorldText(6, 'l', fixTextTime, RGB(50,105,30), 0.3, baseX + 40, baseY-36);
    Players.WorldText(7, '`', fixTextTime, RGB(50,105,30), 1.0, baseX + 114, baseY-75); 
    Players.WorldText(8, '.', fixTextTime, RGB(50,105,30), 1.0, baseX + 100, baseY-172);   
    Players.WorldText(9, '.', fixTextTime, RGB(50,105,30), 1, baseX + 100, baseY-154);
    Players.WorldText(10, '.', fixTextTime, RGB(50,105,30), 1, baseX + 129, baseY-154);
    Players.WorldText(11, '_', fixTextTime, RGB(50,50,50), 0.5, baseX + 35, baseY-78);
    Players.WorldText(12, '_', fixTextTime, RGB(50,50,50), 0.5, baseX + 115, baseY-78);
    Players.WorldText(13, '_', fixTextTime, RGB(50,50,50), 0.5, baseX + 90, baseY-78);    
    Players.WorldText(14, '_', fixTextTime, RGB(50,105,30), 0.5, baseX + 35, baseY-80);
    Players.WorldText(15, '_', fixTextTime, RGB(120,120,120), 0.5, baseX + 115, baseY-80);
    Players.WorldText(16, '_', fixTextTime, RGB(50,105,30), 0.5, baseX + 90, baseY-80);
   
    Players.WorldText(17, chr(149), fixTextTime, RGB(80,80,80), 0.19, baseX + 55, baseY-10);
    Players.WorldText(18, chr(149), fixTextTime, RGB(80,80,80), 0.19, baseX + 145, baseY-10);
    Players.WorldText(19, '.', fixTextTime, RGB(80,80,80), 0.29, baseX + 53.5, baseY-29);
    Players.WorldText(20, '.', fixTextTime, RGB(80,80,80), 0.29, baseX + 61, baseY-29);
    Players.WorldText(21, '.', fixTextTime, RGB(80,80,80), 0.29, baseX + 143.5, baseY-29);
    Players.WorldText(22, '.', fixTextTime, RGB(80,80,80), 0.29, baseX + 151, baseY-29);


    Players.WorldText(23, '.', fixTextTime, RGB(105,215,190), 0.3, baseX + 137.5, baseY-61.5);      
    Players.WorldText(24, '`', fixTextTime, RGB(105,215,190), 0.7, baseX + 124, baseY-59);  
    Players.WorldText(25, '.', fixTextTime, RGB(105,215,190), 0.8, baseX + 109, baseY-141.5);
    Players.WorldText(26, '|', fixTextTime, RGB(50,105,30), 0.38, baseX + 123, baseY-49.3); 
    Players.WorldText(27, '.', fixTextTime, RGB(210,210,200), 0.3, baseX + 162.5, baseY-55.5); 
    Players.WorldText(28, '.', fixTextTime, RGB(210,40,0), 0.3, baseX + 38, baseY-38.5); 
    Players.WorldText(29, '.', fixTextTime, RGB(210,210,0), 0.1, baseX + 47, baseY-10); 
    
    Players.WorldText(30, '.', fixTextTime, RGB(200,0,0), 0.6, baseX + 77, baseY-94.5);
    Players.WorldText(31, chr(187), fixTextTime, RGB(240,0,0), 0.30, baseX + 56, baseY-39);
    Players.WorldText(32, '>', fixTextTime, RGB(200,0,0), 0.12, baseX + 103.5, baseY-16.5);
    Players.WorldText(33, '>', fixTextTime, RGB(200,0,0), 0.12, baseX + 101.5, baseY-16.5);
    Players.WorldText(34, '>', fixTextTime, RGB(200,0,0), 0.12, baseX + 99.5, baseY-16.5);
    Players.WorldText(35, '>', fixTextTime, RGB(200,0,0), 0.12, baseX + 97.5, baseY-16.5);
    Players.WorldText(36, '>', fixTextTime, RGB(200,0,0), 0.12, baseX + 95.5, baseY-16.5);
    
    Players.WorldText(38, '-', fixTextTime, RGB(170,170,170), 0.60, baseX + 56, baseY-72.5);
    Players.WorldText(39, '-', fixTextTime, RGB(130,130,130), 0.60, baseX + 56, baseY-71.5);
    Players.WorldText(40, '-', fixTextTime, RGB(100,100,100), 0.60, baseX + 56, baseY-70.5);
    Players.WorldText(41, '-', fixTextTime, RGB(80,80,80), 0.60, baseX + 56, baseY-69.5);
    Players.WorldText(42, '-', fixTextTime, RGB(60,60,60), 0.60, baseX + 56, baseY-68.5);
    Players.WorldText(43, '_', fixTextTime, RGB(40,40,25), 0.375, baseX + 56, baseY-67.0);
    Players.WorldText(44, 'Y', fixTextTime, RGB(10,10,10), 0.05, baseX + 97, baseY-2);
    Players.WorldText(45, 'Y', fixTextTime, RGB(10,10,10), 0.05, baseX + 66, baseY-2);

    Players.WorldText(46, chr(149), fixTextTime, RGB(60,60,60), 0.18, baseX + 56, baseY-8);
    Players.WorldText(47, chr(149), fixTextTime, RGB(60,60,60), 0.18, baseX + 146, baseY-8);
    Players.WorldText(48, '.', fixTextTime, RGB(60,60,60), 0.28, baseX + 54.5, baseY-27);
    Players.WorldText(49, '.', fixTextTime, RGB(60,60,60), 0.28, baseX + 62, baseY-27);
    Players.WorldText(50, '.', fixTextTime, RGB(60,60,60), 0.28, baseX + 144.5, baseY-27);
    Players.WorldText(51, '.', fixTextTime, RGB(60,60,60), 0.28, baseX + 152, baseY-27);

    Players.WorldText(52, chr(187), fixTextTime, RGB(45,90,18), 0.15, baseX + 123, baseY-18);
    Players.WorldText(54, '-', fixTextTime, RGB(255,100,0), 0.20, baseX + 148, baseY-2);
    Players.WorldText(55, '-', fixTextTime, RGB(255,200,0), 0.15, baseX + 150, baseY+8);
    Players.WorldText(56, '-', fixTextTime, RGB(255,100,0), 0.20, baseX + 58, baseY-2);
    Players.WorldText(57, '-', fixTextTime, RGB(255,200,0), 0.15, baseX + 60, baseY+8);

    // External Collider for moving the car
    //Players.WorldText(100, '`', 600, RGB(0,255,0), 0.1, Payload.ExternalCollider.X, Payload.ExternalCollider.Y-20);
    //Players.WorldText(101, '`', 600, RGB(0,255,0), 0.1, Payload.ExternalCollider.X + Payload.ExternalCollider.W, Payload.ExternalCollider.Y-20);
    //Players.WorldText(102, '`', 600, RGB(0,255,0), 0.1, Payload.ExternalCollider.X, Payload.ExternalCollider.Y + Payload.ExternalCollider.H-20);
    //Players.WorldText(103, '`', 600, RGB(0,255,0), 0.1, Payload.ExternalCollider.X + Payload.ExternalCollider.W, Payload.ExternalCollider.Y + Payload.ExternalCollider.H-20);
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
    Player.BigText(120, '||', fixTextTime, RGB(0,0,0), 0.1, 10, 383);
    Player.BigText(121, '||', fixTextTime, RGB(0,0,0), 0.1, 10, 372);
    Player.BigText(122, '||', fixTextTime, RGB(0,0,0), 0.1, 10, 361);
    Player.BigText(123, '||', fixTextTime, RGB(0,0,0), 0.1, 10, 350);
    Player.BigText(124, '||', fixTextTime, RGB(0,0,0), 0.1, 10, 339);
    Player.BigText(125, '||', fixTextTime, RGB(0,0,0), 0.1, 10, 328);

    Player.BigText(126, '_', fixTextTime, RGB(0,0,0), 0.08, 12, 318);
    Player.BigText(127, '_', fixTextTime, RGB(0,0,0), 0.08, 12, 384);

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
        Player.BigText(60+i, '.', fixTextTime, ultColor, 0.24, 10, 298 + (5 * (22-i)));
    end;

    // Type
    if playerUltimate.isActive then numericRepresentation := inttostr(playerUltimate.duration - playerUltimate.durationCount)+'s'
    else numericRepresentation := inttostr(percentage)+'%';
    Player.BigText(108, numericRepresentation, fixTextTime, RGB(255,255,255), 0.05, 10, 400);
end;

procedure RenderGameUI(Player: TActivePlayer);
var x,y,barSize,payloadPerc,cX,pX:Smallint;
    _cc:Byte;
begin
    x := 360;
    y := -70;
    barSize := 125;
    payloadPerc := round((Payload.actualWalkSize*100)/Payload.totalWalkSize);
    pX := round((barSize*payloadPerc)/100);

    Player.BigText(200, '_', fixTextTime, RGB(255, 255, 255), 0.5, x, y);
    Player.BigText(201, '_', fixTextTime, RGB(255, 255, 255), 0.5, x+58 , y);

    // Payload position
    Player.BigText(203, chr(187), fixTextTime, RGB(0, 255, 0), 0.08, x + pX, y+92);

    // Checkpoints position
    for _cc:=1 to checkPointQuantity do begin
        cX := round((checkPointPerc[_cc] * barSize)/100);
        Player.BigText(204+_cc, chr(149), fixTextTime, RGB(0, 255, 0), 0.1, x + cX, y+82);
    end;

end;

procedure RenderGameTimer(Player: TActivePlayer);
var h,m,x:Smallint;
begin
    x := 360;
    h := Payload.gameTime div 60;
    m := Payload.gameTime mod 60;
    Player.BigText(202, inttostr(h)+':'+inttostr(m), fixTextTime, RGB(255, 255, 255), 0.1, x+35, 0);
end;

procedure SC3GameLogicUpdate(Ticks: Integer);
var 
    collisionDetector,i: Byte;
    playerClass:TPlayerClass;
    playerUltimate:TUltimate;
    calc: Smallint;
begin

    if not Payload.isEnd then begin
    // Init vars
    Payload.isMoving := false;
    Payload.isContested := false;
    
    {
        PLAYER UPDATE LOGIC
    }
    // Players events
    for i := 1 to 10 do begin
        
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

                // Update ultimate percentage
                if not UltimateInstances[Players.Player[i].ID].isActive then begin
                    if UltimateInstances[Players.Player[i].ID].tickCount > 120 then UltimateInstances[Players.Player[i].ID].tickCount := 120;

                    if UltimateInstances[Players.Player[i].ID].tickCount = 120 then begin 
                        UltimateInstances[Players.Player[i].ID].percentage := UltimateInstances[Players.Player[i].ID].percentage + 50;
                        UltimateInstances[Players.Player[i].ID].tickCount := 0;
                    end;
                    
                    if UltimateInstances[Players.Player[i].ID].percentage >= 100 then begin 
                        UltimateInstances[Players.Player[i].ID].percentage := 100;
                    end;
                end;

                // Update all active ultimates
                if UltimateInstances[Players.Player[i].ID].isActive then begin
                    // UltimateInstances[Players.Player[i].ID].tickCount := UltimateInstances[Players.Player[i].ID].tickCount + Game.TickThreshold;

                    // Update duration count
                    if UltimateInstances[Players.Player[i].ID].tickCount > 60 then begin
                        UltimateInstances[Players.Player[i].ID].tickCount := 0;
                        UltimateInstances[Players.Player[i].ID].durationCount := UltimateInstances[Players.Player[i].ID].durationCount + 1;
                        calc := UltimateInstances[Players.Player[i].ID].duration - UltimateInstances[Players.Player[i].ID].durationCount;
                        calc := calc * 100;
                        calc := calc div UltimateInstances[Players.Player[i].ID].duration;
                        // Players.Player[i].Tell(inttostr(calc));
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

                // GAMBIARRA -> FLANK CLASS
                if  (Players.Player[i].KeyFlagThrow) and (playerUltimate.isActive) and (PlayerClassInstances[Players.Player[i].ID].classType=CLASS_TYPE_FLANK) then UltimateInstances[Players.Player[i].ID].doTheUltimate(Players.Player[i]);
            end;

            // Render the player UI
            UIRenderCanvas(MainUI[i], Players.Player[i]);
            if (Ticks mod 60)=0 then RenderPlayerUI(Players.Player[i]);
            if (Ticks mod 120)=0 then RenderGameUI(Players.Player[i]);
            if (Ticks mod 60)=0 then RenderGameTimer(Players.Player[i]);
        end;
    end;
    {
        PLAYER UPDATE LOGIC
    }


    { 
        PAYLOAD UPDATE LOGIC
    }
    // Update payload position
    if Payload.isMoving and not Payload.isContested and not Payload.isEnd then begin

        // Payload velocity
        Payload.xVel := Payload.xVel + Payload.velStep;
        if Payload.xVel > Payload.velMax then Payload.xVel := Payload.velMax;
        Payload.actualWalkSize := Payload.actualWalkSize + Payload.xVel;

        // Calculate left X distance to the next waypoint
        waypointX := PayloadWaypoints[waypointOffset].X - Payload.Collider.X;
        waypointY := PayloadWaypoints[waypointOffset].Y - Payload.Collider.Y;
        
        // WriteLn('[MAIN] waypointX: '+floattostr(waypointX));

        // Update X position of Payload
        if waypointX > 0 then begin
            Payload.Collider.X := Payload.Collider.X + Payload.xVel;
            Payload.ExternalCollider.X := Payload.ExternalCollider.X + Payload.xVel;
        end else if waypointX < 0 then begin
            Payload.Collider.X := Payload.Collider.X - Payload.xVel;
            Payload.ExternalCollider.X := Payload.ExternalCollider.X - Payload.xVel;
        end;

        // If waypointY is not 0, then track X% of the end
        if waypointY <> 0 then begin
            // WriteLn('[MAIN] waypointY: '+floattostr(waypointY));

            waypointY := (Payload.xVel*100)/(abs(waypointX));

            // WriteLn('[MAIN] MID waypointY: '+floattostr(waypointY));

            waypointY := waypointY/100;
            waypointY := (PayloadWaypoints[waypointOffset].Y - Payload.Collider.Y) * waypointY;

            // WriteLn('[MAIN] New waypointY: '+floattostr(waypointY));

            if waypointX > 0 then begin
                Payload.Collider.Y := Payload.Collider.Y + waypointY;
                Payload.ExternalCollider.Y := Payload.ExternalCollider.Y + waypointY;
            end else if waypointX < 0 then begin
                Payload.Collider.Y := Payload.Collider.Y - waypointY;
                Payload.ExternalCollider.Y := Payload.ExternalCollider.Y - waypointY;
            end;
        end;

        // Detect collision payload x waypoint
        if CollisionBox_CollideWithXY(Payload.Collider, PayloadWaypoints[waypointOffset].X, PayloadWaypoints[waypointOffset].Y, 10, 10) = CollisionBox_FULL then begin
            WriteLn('[MAIN] Waypoint REACHED!');
            if PayloadWaypoints[waypointOffset].wayType = WAYTYPE_END then Payload.isEnd := true
            else begin
                if PayloadWaypoints[waypointOffset].wayType = WAYTYPE_CHECKPOINT then Payload.gameTime := Payload.gameTime + 120;
                waypointOffset := waypointOffset+1;
            end;
        end;

    end else begin
        if not (Payload.xVel = 0) then begin
            Payload.xVel := Payload.xVel - 0.02;
            if Payload.xVel < 0 then Payload.xVel := 0;
        end;
    end;

    // Upodate game time
    if (Ticks mod 60)=0 then Payload.gameTime := Payload.gameTime-1;

    // Render payload
    RenderPayload();
    if (Ticks mod 300)=0 then RenderPayloadWaypoints();
    { 
        PAYLOAD UPDATE LOGIC
    }
    end;
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
var PCLASS:Byte;
begin
    PCLASS := CLASS_TYPE_NONE;
    if Text='!coords' then Player.Tell(floattostr(Player.X) + ',' + floattostr(Player.Y));
    if Text='!class pyro' then begin
        Player.Tell('Changing your class to PYRO');
        DestroyPlayerClass(Player.ID);
        PCLASS := CLASS_TYPE_PYRO;
    end;
    if Text='!class heavy' then begin
        Player.Tell('Changing your class to HEAVY ARMOR');
        DestroyPlayerClass(Player.ID);
        PCLASS := CLASS_TYPE_HEAVY_ARMOR;
    end;
    if Text='!class medic' then begin
        Player.Tell('Changing your class to MEDIC');
        DestroyPlayerClass(Player.ID);
        PCLASS := CLASS_TYPE_MEDIC;
    end;
    if Text='!class sniper' then begin
        Player.Tell('Changing your class to SNIPER');
        DestroyPlayerClass(Player.ID);
        PCLASS := CLASS_TYPE_SNIPER;
    end;
    if Text='!class spy' then begin
        Player.Tell('Changing your class to SPY');
        PCLASS := CLASS_TYPE_SPY;
    end;
    if Text='!class gunslinger' then begin
        Player.Tell('Changing your class to GUNSLINGER');
        PCLASS := CLASS_TYPE_GUNSLINGER;
    end;
    if Text='!class radio' then begin
        Player.Tell('Changing your class to RADIO');
        PCLASS := CLASS_TYPE_RADIO;
    end;
    if Text='!class flank' then begin
        Player.Tell('Changing your class to FLANK');
        PCLASS := CLASS_TYPE_FLANK;
    end;

    if Text='!c' then MainUI[Player.ID].enabled := true;

    if PCLASS <> CLASS_TYPE_NONE then begin
        DestroyPlayerClass(Player.ID);
        CreatePlayerClass(PCLASS, Player);
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

procedure SC3OnPlayerJoin(Player: TActivePlayer; Team: TTeam);
var _wcount:Byte;
begin
    for _wcount:=1 to 10 do Players[Player.ID].WeaponActive[_wcount] := false;
end;

procedure SC3BeforeMapChange(Next: string);
var _pcount:Byte;
begin
    for _pcount:=1 to 32 do DestroyPlayerClass(_pcount);
end;

function SC3OnPlayerDamage(Shooter, Victim: TActivePlayer; Damage: Single; BulletId: Byte): Single;
var calc:Smallint;
begin
    if (Shooter.ID <> Victim.ID) and not UltimateInstances[Shooter.ID].isActive then begin
        if Damage > 100 then calc := 10 else begin
            calc := round(Damage);
            calc := calc div 10;
        end;
        calc := UltimateInstances[Shooter.ID].percentage + calc;
        if calc > 100 then UltimateInstances[Shooter.ID].percentage := 100
        else UltimateInstances[Shooter.ID].percentage := calc;
    end;

    if (UltimateInstances[Shooter.ID].isActive) and (PlayerClassInstances[Shooter.ID].classType=CLASS_TYPE_GUNSLINGER) then Damage := Damage/3;

    if (UltimateInstances[Shooter.ID].isActive) and (PlayerClassInstances[Shooter.ID].classType=CLASS_TYPE_SNIPER) and (Damage>=Victim.Health) then begin
        WriteLn('[MAIN] Bow damage from:'+inttostr(Shooter.ID)+' to:'+inttostr(Victim.ID));
        CreateBullet(Victim.X-10, Victim.Y, fixTextTime, 0, fixTextTime, 7, Shooter.ID);
    end;

    Result := Damage;

end;

procedure SC3OnPlayerKill(Killer, Victim: TActivePlayer; BulletId: Byte);
begin
    if UltimateInstances[Victim.ID].isActive then ResetUltimate(Victim.ID);
end;

procedure OnButtonClassClick(data:Byte;Player:TActivePlayer;offset:Byte);
begin
    if data <> CLASS_TYPE_NONE then begin
        DestroyPlayerClass(Player.ID);
        CreatePlayerClass(data, Player);
        // MainUI[Player.ID].elements[offset].fColor := RGB(0,0,0);
        // MainUI[Player.ID].elements[offset].bColor := RGB(255,255,255);
    end;
    MainUI[Player.ID].enabled := false;
end;

procedure OnButtonClassHover(data:Byte;Player:TActivePlayer;offset:Byte);
begin
    MainUI[Player.ID].elements[offset].fColor := RGB(255, 255, 255);

    if data <> CLASS_TYPE_NONE then
        MainUI[Player.ID].elements[11].text := ClassDescription[data]
    else MainUI[Player.ID].elements[11].text := 'Exit from this menu';
end;

procedure OnButtonClassBlur(data:Byte;Player:TActivePlayer;offset:Byte);
begin
    MainUI[Player.ID].elements[offset].fColor := RGB(0, 0, 0);
end;

begin
    // Setup Vars
    waypointOffset := 2;
    fixTextTime := 200;
    checkPointQuantity := 0;
    _checkpointSize := 0;
    _checkpointSize := 0;

    // Create and setup the Payload and Payload Collider
    Payload.Collider := CollisionBox_Create(150, 70, PayloadWaypoints[1].X, PayloadWaypoints[1].Y);
    Payload.ExternalCollider := CollisionBox_Create(300, 200, PayloadWaypoints[1].X-100, PayloadWaypoints[1].Y-100);
    Payload.OnPlayerCollision := @OnPlayerCollidesOnPayload;
    Payload.OnPlayerExternalCollision := @OnPlayerCollidesExternalPayloadCollider;
    Payload.velStep := 0.002;
    Payload.velMax := 0.3;
    Payload.xVel := 0.0;
    Payload.isEnd := false;
    Payload.isReached := false;
    Payload.actualWalkSize := 0;
    Payload.gameTime := 300;

    Payload.totalWalkSize := GetWalkTotalSize();
    WriteLn('[MAIN] Payload Waypoint total walk size: '+floattostr(Payload.totalWalkSize));

    // Init vars for Game UI
    for _pwcount:=2 to 254 do begin
        _checkpointSize := _checkpointSize + GetWaySize(PayloadWaypoints[_pwcount-1], PayloadWaypoints[_pwcount]);
        if PayloadWaypoints[_pwcount].wayType=WAYTYPE_CHECKPOINT then begin
            WriteLn('[MAIN] Checkpoint size: '+floattostr(_checkpointSize));
            checkPointQuantity := checkPointQuantity + 1;
            _checkpointPerc := (_checkpointSize*100)/Payload.totalWalkSize;
            checkPointPerc[checkPointQuantity] := round(_checkpointPerc);
            WriteLn('[MAIN] Checkpoint Perc: '+inttostr(checkPointPerc[checkPointQuantity]));
        end;
        if PayloadWaypoints[_pwcount].wayType=WAYTYPE_END then break;
    end;

    // Set Clock tick to update game logic
    Game.TickThreshold := 1; // 100 ms tick test
    Game.OnClockTick := @SC3GameLogicUpdate;

    // Game on player leave
    Game.OnJoin := @SC3OnPlayerJoin;
    Game.Teams[1].OnLeave := @SC3OnPlayerLeaveTeam;
    Game.Teams[2].OnLeave := @SC3OnPlayerLeaveTeam;
    Game.OnLeave := @SC3OnPlayerLeave;

    // Map events
    Map.OnBeforeMapChange := @SC3BeforeMapChange;

    // Custom
    for i:=1 to 10 do begin 
        Players.Player[i].OnSpeak := @SC3OnPlayerCommand;
        Players.Player[i].OnDamage := @SC3OnPlayerDamage;
        Players.Player[i].OnKill := @SC3OnPlayerKill;

        // Player Interface
        MainUI[i].startLayer := 10;
        MainUI[i].enabled := false;

        UIAddButton(MainUI[i], 1, 100, 100, RGB(0,0,0), RGB(255,0,0), 'Pyro', CLASS_TYPE_PYRO, @OnButtonClassClick, @OnButtonClassHover, @OnButtonClassBlur);
        UIAddButton(MainUI[i], 2, 100, 130, RGB(0,0,0), RGB(255,0,0), 'Heavy Armor', CLASS_TYPE_HEAVY_ARMOR, @OnButtonClassClick, @OnButtonClassHover, @OnButtonClassBlur);
        UIAddButton(MainUI[i], 3, 100, 160, RGB(0,0,0), RGB(255,0,0), 'Medic', CLASS_TYPE_MEDIC, @OnButtonClassClick, @OnButtonClassHover, @OnButtonClassBlur);
        UIAddButton(MainUI[i], 4, 100, 190, RGB(0,0,0), RGB(255,0,0), 'Sniper', CLASS_TYPE_SNIPER, @OnButtonClassClick, @OnButtonClassHover, @OnButtonClassBlur);
        UIAddButton(MainUI[i], 5, 100, 220, RGB(0,0,0), RGB(255,0,0), 'Spy', CLASS_TYPE_SPY, @OnButtonClassClick, @OnButtonClassHover, @OnButtonClassBlur);
        UIAddButton(MainUI[i], 6, 100, 250, RGB(0,0,0), RGB(255,0,0), 'Flank', CLASS_TYPE_FLANK, @OnButtonClassClick, @OnButtonClassHover, @OnButtonClassBlur);
        UIAddButton(MainUI[i], 7, 100, 280, RGB(0,0,0), RGB(255,0,0), 'Radio', CLASS_TYPE_RADIO, @OnButtonClassClick, @OnButtonClassHover, @OnButtonClassBlur);
        UIAddButton(MainUI[i], 8, 100, 310, RGB(0,0,0), RGB(255,0,0), 'Gunslinger', CLASS_TYPE_GUNSLINGER, @OnButtonClassClick, @OnButtonClassHover, @OnButtonClassBlur);
        UIAddButton(MainUI[i], 9, 100, 400, RGB(255,255,255), RGB(0,255,0), 'Exit', CLASS_TYPE_NONE, @OnButtonClassClick, @OnButtonClassHover, @OnButtonClassBlur);

        UIAddText(MainUI[i], 10, 80, 80, RGB(0,0,0), 'Chose your class:');
        UIAddText(MainUI[i], 11, 350, 80, RGB(255,255,255), '');
    end;
end.