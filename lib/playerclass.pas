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

    procedure CreatePlayerClass (classType: Byte; Player: TActivePlayer);
    procedure GetPlayerClass (PlayerID: Byte; var r: TPlayerClass);
    procedure DestroyPlayerClass (PlayerID: Byte);

    { ULTIMATE EFFECTS TRIGGER }
    { PYRO }
    procedure PyroUltmateEffectTrigger(Player: TActivePlayer);
    procedure PyroCancelUltimateEffectTrigger(Player: TActivePlayer);

    var PlayerClassInstances: array[1..32] of TPlayerClass;
implementation

    { ULTIMATE EFFECTS TRIGGER }
    { PYRO }
    procedure PyroUltmateEffectTrigger(Player: TActivePlayer);
    var
        playerClass: TPlayerClass;
        NewPrimary, NewSecondary: TNewWeapon;
    begin
        GetPlayerClass(Player.ID, playerClass);
        Player.Say('FIRE!!!');

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
    end;

    procedure PyroCancelUltimateEffectTrigger(Player: TActivePlayer);
    var 
        playerClass: TPlayerClass;
        NewPrimary, NewSecondary: TNewWeapon;
    begin
        GetPlayerClass(Player.ID, playerClass);
        Player.Say('Need BACKUP!!');

        // Reset armor
        NewPrimary := TNewWeapon.Create();
        NewSecondary := TNewWeapon.Create();
        try
            NewPrimary.WType := 7; // M79
            NewPrimary.Ammo := 0; // Full one
            NewSecondary.WType := 0; // SOCOM
            NewSecondary.Ammo := 10; // To reload - for hands it doesn't matter.
            Players.Player[playerClass.playerID].ForceWeapon(TWeapon(NewPrimary), TWeapon(NewSecondary));
        finally
            NewPrimary.Free();
            NewSecondary.Free();
        end;
    end;

    { PLAYER CLASS CREATOR }
    procedure CreatePlayerClass (classType: Byte; Player: TActivePlayer);
        var NewPrimary, NewSecondary: TNewWeapon;
    begin
        WriteLn('[PLAYERCLASS] Creating class '+inttostr(classType)+' to:'+inttostr(Player.ID));
        PlayerClassInstances[Player.ID]._created := true;
        PlayerClassInstances[Player.ID].classType := classType;
        PlayerClassInstances[Player.ID].playerID := Player.ID

        // Create Class armor
        NewPrimary := TNewWeapon.Create();
        NewSecondary := TNewWeapon.Create();

        NewPrimary.Ammo := 0;
        NewSecondary.Ammo := 0;

        case classType of
            CLASS_TYPE_PYRO : begin  
                NewPrimary.WType := 7; // M79
                NewSecondary.WType := 0; // SOCOM
                CreateUltimate(Player.ID, 10, @PyroUltmateEffectTrigger, @PyroCancelUltimateEffectTrigger);
                try
                    Players.Player[Player.ID].ForceWeapon(TWeapon(NewPrimary), TWeapon(NewSecondary));
                finally
                    NewPrimary.Free();
                    NewSecondary.Free();
                end;
            end;
        end;

        WriteLn('[PLAYERCLASS] class '+inttostr(classType)+' created to:'+inttostr(PlayerClassInstances[Player.ID].playerID));
    end;

    procedure DestroyPlayerClass (PlayerID: Byte);
    begin
        PlayerClassInstances[PlayerID]._created := false;
        PlayerClassInstances[PlayerID].classType := 0;
        PlayerClassInstances[PlayerID].playerID := 0;
        ResetUltimate(PlayerID);
    end;

    procedure GetPlayerClass (PlayerID: Byte; var r: TPlayerClass);
    begin
        r := PlayerClassInstances[PlayerID];
    end;

    // Start All
    begin
        for i:=1 to 32 do begin 
            PlayerClassInstances[i]._created := false;
            PlayerClassInstances[i].classType := 0;
            PlayerClassInstances[i].playerID := 0;
        end;
    end.

end.