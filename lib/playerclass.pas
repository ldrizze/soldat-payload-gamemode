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
        CLASS_TYPE_PYRO = 1;
        CLASS_TYPE_HEAVY_ARMOR = 2;
        CLASS_TYPE_MEDIC = 3;
        CLASS_TYPE_SNIPER = 4;
        CLASS_TYPE_SPY = 5;
        CLASS_TYPE_FLANK = 6;
        CLASS_TYPE_RADIO = 7;
        CLASS_TYPE_GUNSLINGER = 8;

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

    var 
        PlayerClassInstances: array[1..32] of TPlayerClass;
        ClassUltimateTime: array[1..8] of Byte;
implementation

    procedure SC3PlaySoundForAll (sound:String; emmiter:TActivePlayer);
    var _pcount:Byte;
    begin
        for _pcount := 1 to 32 do Players.Player[_pcount].PlaySound(sound, emmiter.X, emmiter.Y);
    end;

    { ULTIMATE EFFECTS TRIGGER }
    { PYRO }
    procedure PyroUltimateEffectTrigger(Player: TActivePlayer);
    var
        playerClass: TPlayerClass;
        NewPrimary, NewSecondary: TNewWeapon;
    begin
        GetPlayerClass(Player.ID, playerClass);

        UltimateInstances[Player.ID].primaryWeaponHold := Player.Primary.WType;
        UltimateInstances[Player.ID].secondaryWeaponHold := Player.Secondary.WType;

        // Create Flamer armor
        NewPrimary := TNewWeapon.Create();
        NewSecondary := TNewWeapon.Create();
        try
            NewPrimary.WType := 14; //FLAMER
            NewPrimary.Ammo := 200; // Full one
            NewSecondary.WType := 255; // Hands
            NewSecondary.Ammo := 0; // To reload - for hands it doesn't matter.
            Players.Player[playerClass.playerID].ForceWeapon(TWeapon(NewPrimary), TWeapon(NewSecondary));
        finally
            NewPrimary.Free();
            NewSecondary.Free();
        end;
        SC3PlaySoundForAll('../scenery-gfx/payp.png', Player);
        Player.Say('Im on flames!!!');
    end;

    procedure PyroCancelUltimateEffectTrigger(Player: TActivePlayer);
    var 
        playerClass: TPlayerClass;
    begin
        GetPlayerClass(Player.ID, playerClass);
        ResetWeaponUltimate(Player);
    end;

    { HEAVY ARMOR }
    procedure HeayArmorUltimateEffectTrigger(Player: TActivePlayer);
    var _bfcount:Byte;
        playerClass: TPlayerClass;
    begin
        GetPlayerClass(Player.ID, playerClass);
        for _bfcount := 1 to 32 do begin
            if (Players.Player[_bfcount].Alive) and (Players.Player[_bfcount].Team = Player.Team) then Players.Player[_bfcount].GiveBonus(3);
        end;

        SC3PlaySoundForAll('../scenery-gfx/payh.png', Player);
        Player.Say('I can eat your bullets!!!');
    end;

    procedure HeayArmorCancelUltimateEffectTrigger(Player: TActivePlayer);
    begin
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
        ClassUltimateTime[CLASS_TYPE_SNIPER] := 15;
        ClassUltimateTime[CLASS_TYPE_SPY] := 1;
        ClassUltimateTime[CLASS_TYPE_FLANK] := 10;
        ClassUltimateTime[CLASS_TYPE_RADIO] := 5;
        ClassUltimateTime[CLASS_TYPE_GUNSLINGER] := 15;
    end.

end.