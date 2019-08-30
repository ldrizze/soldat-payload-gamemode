Unit PlayerClass;

interface
    uses Ultimate;
    type
        TPlayerClass = record
            _created: boolean;
            classType: Byte;
            playerID: Byte;
    end;

    const
        CLASS_TYPE_NONE = 0;
        CLASS_TYPE_PYRO = 1;
        CLASS_TYPE_HEAVY_ARMOR = 2;
        CLASS_TYPE_MEDIC = 3;
        CLASS_TYPE_SNIPER = 4;
        CLASS_TYPE_SPY = 5;
        CLASS_TYPE_FLANK = 6;
        CLASS_TYPE_RADIO = 7;
        CLASS_TYPE_GUNSLINGER = 8;

        TOTAL_CLASSES = 8;

    procedure CreatePlayerClass (classType: Byte; Player: TActivePlayer);
    procedure GetPlayerClass (PlayerID: Byte; var r: TPlayerClass);
    procedure DestroyPlayerClass (PlayerID: Byte);
    procedure SC3PlaySoundForAll (sound:String; emmiter:TActivePlayer); 
    procedure ResetWeaponsMenu(PlayerID: Byte);

    { ULTIMATE EFFECTS TRIGGER }
    { PYRO }
    procedure PyroUltimateEffectTrigger(Player: TActivePlayer);
    procedure PyroCancelUltimateEffectTrigger(Player: TActivePlayer);

    { HEAVY }
    procedure HeayArmorUltimateEffectTrigger(Player: TActivePlayer);
    procedure HeayArmorCancelUltimateEffectTrigger(Player: TActivePlayer);

    { SNIPER }
    procedure SniperUltimateEffect(Player: TActivePlayer);
    procedure SniperCacnelUltimateEffect(Player: TActivePlayer);

    { MEDIC }
    procedure MedicUltimateEffect(Player: TActivePlayer);
    procedure MedicCancelUltimateEffect(Player: TActivePlayer);

    { SPY }
    procedure SpyUltimateEffect(Player: TActivePlayer);
    procedure SpyCancelUltimateEffect(Player: TActivePlayer);

    { GUNSLINGER }
    procedure GunslingerUltimateEffect(Player: TActivePlayer);
    procedure GunslingerCancelUltimateEffect(Player: TActivePlayer);

    { RADIO }
    procedure RadioUltimateEffect(Player: TActivePlayer);
    procedure RadioCancelUltimateEffect(Player: TActivePlayer);

    { FLANK }
    procedure FlankUltimateEffect(Player: TActivePlayer);
    procedure FlankCancelUltimateEffect(Player: TActivePlayer);

    var 
        PlayerClassInstances: array[1..32] of TPlayerClass;
        ClassUltimateTime: array[1..TOTAL_CLASSES] of Byte;
        ClassDescription: array[1..TOTAL_CLASSES] of String;
implementation

    procedure SC3PlaySoundForAll (sound:String; emmiter:TActivePlayer);
    var _pcount:Byte;
    begin
        for _pcount := 1 to 32 do Players.Player[_pcount].PlaySound(sound, emmiter.X, emmiter.Y);
    end;

    { ULTIMATE EFFECTS TRIGGER }
    { PYRO }
    procedure PyroUltimateEffectTrigger(Player: TActivePlayer);
    begin
        GiveNewWeaponsUltimate(Player, 14, 255, 200, 0);
        SC3PlaySoundForAll('../scenery-gfx/payp.png', Player);
        Player.Say('Im on flames!!!');
    end;

    procedure PyroCancelUltimateEffectTrigger(Player: TActivePlayer);
    begin
        ResetWeaponsUltimate(Player);
    end;

    { HEAVY ARMOR }
    procedure HeayArmorUltimateEffectTrigger(Player: TActivePlayer);
    var _bfcount:Byte;
    begin
        for _bfcount := 1 to 32 do begin
            if (Players.Player[_bfcount].Alive) and (Players.Player[_bfcount].Team = Player.Team) then Players.Player[_bfcount].GiveBonus(3);
        end;

        SC3PlaySoundForAll('../scenery-gfx/payh.png', Player);
        Player.Say('I can eat your bullets!!!');
    end;

    procedure HeayArmorCancelUltimateEffectTrigger(Player: TActivePlayer);
    begin
    end;

    { SNIPER }
    procedure SniperUltimateEffect(Player: TActivePlayer);
    begin
        GiveNewWeaponsUltimate(Player, 15, 255, 1, 0);
        Player.Say('You can run but you can'+chr(39)+'t hide!');
    end;

    procedure SniperCacnelUltimateEffect(Player: TActivePlayer);
    begin
        ResetWeaponsUltimate(Player);
    end;

    { MEDIC }
    procedure MedicUltimateEffect(Player: TActivePlayer);
    var _pcount:Byte;
    begin
        for _pcount:=1 to 10 do if Players.Player[_pcount].Team=Player.Team then Players.Player[_pcount].Health := 150;
        Player.Say('I'+chr(39)+'ll protect you');
    end;

    procedure MedicCancelUltimateEffect(Player: TActivePlayer);
    begin
    end;

    { SPY }
    procedure SpyUltimateEffect(Player: TActivePlayer);
    begin
        Player.GiveBonus(1);
        GiveNewWeaponsUltimate(Player, 0, 0, 12, 12);
    end;

    procedure SpyCancelUltimateEffect(Player: TActivePlayer);
    begin
        ResetWeaponsUltimate(Player);
    end;
    
    { GUNSLINGER }
    procedure GunslingerUltimateEffect(Player: TActivePlayer);
    begin
        Player.GiveBonus(2);
    end;

    procedure GunslingerCancelUltimateEffect(Player: TActivePlayer);
    begin
    end;

    { RADIO }
    procedure RadioUltimateEffect(Player: TActivePlayer);
    begin
        CreateBullet(Player.MouseAimX-100, Player.MouseAimY-300, 0, 0, 100, 12, Player.ID);
        CreateBullet(Player.MouseAimX-50, Player.MouseAimY-300, 0, 0, 100, 12, Player.ID);
        CreateBullet(Player.MouseAimX, Player.MouseAimY-300, 0, 0, 100, 12, Player.ID);
        CreateBullet(Player.MouseAimX+50, Player.MouseAimY-300, 0, 0, 100, 12, Player.ID);
        CreateBullet(Player.MouseAimX+100, Player.MouseAimY-300, 0, 0, 100, 12, Player.ID);
    end;

    procedure RadioCancelUltimateEffect(Player: TActivePlayer);
    begin
    end;

    { FLANK }
    procedure FlankUltimateEffect(Player: TActivePlayer);
    var dx, dy, ar, velX, velY:Single;
    begin
        if UltimateInstances[Player.ID].data = 1 then begin
            dx := Player.MouseAimX - Player.X;
            dy := Player.MouseAimY - Player.Y;

            // WriteLn('dX: '+floattostr(dx)+' dY: '+floattostr(dy));

            ar := arctan(dx/dy);
            if dx > 0 then velX := abs(ar);
            if dx < 0 then velX := -1 * (abs(ar));
            if dy > 0 then velY := abs(ar);
            if dy < 0 then velY := -1 * (abs(ar));

            // WriteLn('velX: '+floattostr(velX)+' velY: '+floattostr(velY));

            Player.SetVelocity(velX*8, velY*8);
        end else UltimateInstances[Player.ID].data := 1;
        
    end;

    procedure FlankCancelUltimateEffect(Player: TActivePlayer);
    begin
        UltimateInstances[Player.ID].data := 0;
    end;   

    { PLAYER CLASS CREATOR }
    procedure CreatePlayerClass (classType: Byte; Player: TActivePlayer);
        var doUlt, cancelUt: TUltimateEffectTrigger;
    begin
        WriteLn('[PLAYERCLASS] Creating class '+inttostr(classType)+' to:'+inttostr(Player.ID));
        PlayerClassInstances[Player.ID]._created := true;
        PlayerClassInstances[Player.ID].classType := classType;
        PlayerClassInstances[Player.ID].playerID := Player.ID;

        // CLASS PYRO
        if classType=CLASS_TYPE_PYRO then begin
            doUlt := @PyroUltimateEffectTrigger;
            cancelUt := @PyroCancelUltimateEffectTrigger;
            Players[Player.ID].WeaponActive[7] := true;
        end;

        // CLASS HEAY ARMOR
        if classType=CLASS_TYPE_HEAVY_ARMOR then begin
            doUlt := @HeayArmorUltimateEffectTrigger;
            cancelUt := @HeayArmorCancelUltimateEffectTrigger;
            Players[Player.ID].WeaponActive[9] := true;
            Players[Player.ID].WeaponActive[3] := true;
        end;

        // CLASS SNIPER
        if classType=CLASS_TYPE_SNIPER then begin
            doUlt := @SniperUltimateEffect;
            cancelUt := @SniperCacnelUltimateEffect;
            Players[Player.ID].WeaponActive[8] := true;
            Players[Player.ID].WeaponActive[6] := true;
        end;

        // CLASS MEDIC
        if classType=CLASS_TYPE_MEDIC then begin
            doUlt := @MedicUltimateEffect;
            cancelUt := @MedicCancelUltimateEffect;
            Players[Player.ID].WeaponActive[2] := true;
            Players[Player.ID].WeaponActive[5] := true;
        end;

        // CLASS SPY
        if classType=CLASS_TYPE_SPY then begin
            doUlt := @SpyUltimateEffect;
            cancelUt := @SpyCancelUltimateEffect;
            Players[Player.ID].WeaponActive[1] := true;
            Players[Player.ID].WeaponActive[4] := true;
        end;

        // CLASS GUNSLINGER
        if classType=CLASS_TYPE_GUNSLINGER then begin
            doUlt := @GunslingerUltimateEffect;
            cancelUt := @GunslingerCancelUltimateEffect;
            Players[Player.ID].WeaponActive[1] := true;
        end;

        // CLASS RADIO
        if classType=CLASS_TYPE_RADIO then begin
            doUlt := @RadioUltimateEffect;
            cancelUt := @RadioCancelUltimateEffect;
            Players[Player.ID].WeaponActive[4] := true;
            Players[Player.ID].WeaponActive[7] := true;
            Players[Player.ID].WeaponActive[9] := true;
        end;

        // CLASS FLANK
        if classType=CLASS_TYPE_FLANK then begin
            doUlt := @FlankUltimateEffect;
            cancelUt := @FlankCancelUltimateEffect;
            Players[Player.ID].WeaponActive[2] := true;
            Players[Player.ID].WeaponActive[5] := true;
            Players[Player.ID].WeaponActive[6] := true;
        end;


        Player.Damage(Player.ID, 999);
        CreateUltimate(Player, ClassUltimateTime[classType], doUlt, cancelUt);
        WriteLn('[PLAYERCLASS] class '+inttostr(classType)+' created to:'+inttostr(PlayerClassInstances[Player.ID].playerID));
    end;

    procedure ResetWeaponsMenu(PlayerID: Byte);
    var _wcount:Byte;
    begin
        for _wcount:=1 to 10 do Players[PlayerID].WeaponActive[_wcount] := false;
    end;

    procedure DestroyPlayerClass (PlayerID: Byte);
    begin
        WriteLn('[PLAYERCLASS] Destroying class to:'+inttostr(PlayerID));
        PlayerClassInstances[PlayerID]._created := false;
        PlayerClassInstances[PlayerID].classType := 0;
        PlayerClassInstances[PlayerID].playerID := 0;
        ResetUltimate(PlayerID);
        ResetWeaponsMenu(PlayerID);
        WriteLn('[PLAYERCLASS] Destroying class successful to:'+inttostr(PlayerID));
    end;

    procedure GetPlayerClass (PlayerID: Byte; var r: TPlayerClass);
    begin
        r := PlayerClassInstances[PlayerID];
    end;

    // Start All
    var filePath:String;
    begin
        // Initialize vars
        for i:=1 to 32 do begin 
            PlayerClassInstances[i]._created := false;
            PlayerClassInstances[i].classType := 0;
            PlayerClassInstances[i].playerID := 0;
        end;

        // Ultimate durations
        ClassUltimateTime[CLASS_TYPE_PYRO] := 10;
        ClassUltimateTime[CLASS_TYPE_HEAVY_ARMOR] := 1;
        ClassUltimateTime[CLASS_TYPE_MEDIC] := 1;
        ClassUltimateTime[CLASS_TYPE_SNIPER] := 5;
        ClassUltimateTime[CLASS_TYPE_SPY] := 25;
        ClassUltimateTime[CLASS_TYPE_FLANK] := 10;
        ClassUltimateTime[CLASS_TYPE_RADIO] := 1;
        ClassUltimateTime[CLASS_TYPE_GUNSLINGER] := 15;

        // Classes description
        for i:=1 to TOTAL_CLASSES do begin
            filePath := Script.Dir + 'data\classes\'+inttostr(i)+'.txt';
            if FileExists(filePath) then ClassDescription[i] := ReadFile(filePath)
            else ClassDescription[i] := '';
        end;
    end.

end.