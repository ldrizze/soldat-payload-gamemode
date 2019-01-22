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

    { ULTIMATE EFFECTS TRIGGER }
    { PYRO }
    procedure PyroUltmateEffectTrigger(Player: TActivePlayer);
    procedure PyroCancelUltimateEffectTrigger(Player: TActivePlayer);

    var PlayerClassInstances: array[1..32] of TPlayerClass;
implementation

    { ULTIMATE EFFECTS TRIGGER }
    { PYRO }
    procedure PyroUltmateEffectTrigger(Player: TActivePlayer);
    begin
        UltimateInstances[Player.ID].isActive := true;
        Player.Say('FIRE!!!');
    end;

    procedure PyroCancelUltimateEffectTrigger(Player: TActivePlayer);
    var 
        playerClass: TPlayerClass;
    begin
        GetPlayerClass(Player.ID, playerClass);
        Player.Say('Need BACKUP!!');
    end;

    { PLAYER CLASS CREATOR }
    procedure CreatePlayerClass (classType: Byte; Player: TActivePlayer);
    begin
        WriteLn('[PLAYERCLASS] Creating PYRO:'+inttostr(Player.ID));
        PlayerClassInstances[Player.ID]._created := true;
        PlayerClassInstances[Player.ID].classType := classType;
        PlayerClassInstances[Player.ID].playerID := Player.ID

        case classType of
            CLASS_TYPE_PYRO : CreateUltimate(Player.ID, 5, @PyroUltmateEffectTrigger, @PyroCancelUltimateEffectTrigger);
        end;

        WriteLn('[PLAYERCLASS] PYRO created:'+inttostr(PlayerClassInstances[Player.ID].playerID));
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