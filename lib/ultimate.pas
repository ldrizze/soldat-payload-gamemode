Unit Ultimate;

interface
    type TUltimateEffectTrigger = procedure (Player: TActivePlayer);
    type
        TUltimate = record
            tickCount: Smallint;
            percentage: Byte;
            isActive: Boolean;
            duration: Byte;
            durationCount: Byte;
            data: Byte;
            damageHold: Byte;
            primaryWeaponHold: Byte;
            secondaryWeaponHold: Byte;
            doTheUltimate: TUltimateEffectTrigger;
            cancelUltimate: TUltimateEffectTrigger;
    end;
    procedure CreateUltimate (Player: TActivePlayer; duration:Byte; effectTrigger: TUltimateEffectTrigger; cancelUltimateTrigger: TUltimateEffectTrigger);
    procedure ResetUltimate (PlayerID: Byte);
    procedure GetUltimate(PlayerID: Byte; var r: TUltimate);
    procedure ResetWeaponsUltimate(Player: TActivePlayer);
    procedure GiveNewWeaponsUltimate(Player: TActivePlayer; primary, secondary: Byte; pAmmo, sAmmo: Smallint);

    var UltimateInstances: array[1..32] of TUltimate;
implementation

    procedure CreateUltimate (Player: TActivePlayer; duration:Byte; effectTrigger: TUltimateEffectTrigger; cancelUltimateTrigger: TUltimateEffectTrigger);
    begin
        UltimateInstances[Player.ID].tickCount := 0;
        UltimateInstances[Player.ID].percentage := 0;
        UltimateInstances[Player.ID].isActive := false;
        UltimateInstances[Player.ID].duration := duration;
        UltimateInstances[Player.ID].durationCount := 0;
        UltimateInstances[Player.ID].doTheUltimate := effectTrigger;
        UltimateInstances[Player.ID].cancelUltimate := cancelUltimateTrigger;
        UltimateInstances[Player.ID].data := 0;
        UltimateInstances[Player.ID].primaryWeaponHold := Player.Primary.WType;
        UltimateInstances[Player.ID].secondaryWeaponHold := Player.Secondary.WType;
    end;

    procedure GetUltimate(PlayerID: Byte; var r: TUltimate);
    begin
        r := UltimateInstances[PlayerID];
    end;

    procedure ResetUltimate (PlayerID: Byte);
    begin
        UltimateInstances[PlayerID].tickCount := 0;
        UltimateInstances[PlayerID].percentage := 0;
        UltimateInstances[PlayerID].isActive := false;
        UltimateInstances[PlayerID].durationCount := 0;
        UltimateInstances[PlayerID].damageHold := 0;
    end;

    procedure ResetWeaponsUltimate(Player: TActivePlayer);
    var
        ult: TUltimate;
        NewPrimary, NewSecondary: TNewWeapon;
    begin
        ult := UltimateInstances[Player.ID];

        // Reset armor
        NewPrimary := TNewWeapon.Create();
        NewSecondary := TNewWeapon.Create();
        try
            NewPrimary.WType := ult.primaryWeaponHold;
            NewPrimary.Ammo := 0;
            NewSecondary.WType := ult.secondaryWeaponHold;
            NewSecondary.Ammo := 0;
            Player.ForceWeapon(TWeapon(NewPrimary), TWeapon(NewSecondary));
        finally
            NewPrimary.Free();
            NewSecondary.Free();
        end;
    end;

    procedure GiveNewWeaponsUltimate(Player: TActivePlayer; primary, secondary: Byte; pAmmo, sAmmo: Smallint);
    var NewPrimary, NewSecondary: TNewWeapon;
    begin
        UltimateInstances[Player.ID].primaryWeaponHold := Player.Primary.WType;
        UltimateInstances[Player.ID].secondaryWeaponHold := Player.Secondary.WType;

        // Create Flamer armor
        NewPrimary := TNewWeapon.Create();
        NewSecondary := TNewWeapon.Create();
        try
            NewPrimary.WType := primary; //FLAMER
            NewPrimary.Ammo := pAmmo; // Full one
            NewSecondary.WType := secondary; // Hands
            NewSecondary.Ammo := sAmmo; // To reload - for hands it doesn't matter.
            Player.ForceWeapon(TWeapon(NewPrimary), TWeapon(NewSecondary));
        finally
            NewPrimary.Free();
            NewSecondary.Free();
        end;
    end;

    var i:Byte;
    begin
        for i:=1 to 32 do begin
            UltimateInstances[i].tickCount := 0;
            UltimateInstances[i].percentage := 0;
            UltimateInstances[i].isActive := false;
            UltimateInstances[i].duration := 0;
            UltimateInstances[i].durationCount := 0;
            UltimateInstances[i].data := 0;
        end;
    end.
end.