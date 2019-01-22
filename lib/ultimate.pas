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
            doTheUltimate: TUltimateEffectTrigger;
            cancelUltimate: TUltimateEffectTrigger;
    end;
    procedure CreateUltimate (PlayerID: Byte; duration:Byte; effectTrigger: TUltimateEffectTrigger; cancelUltimateTrigger: TUltimateEffectTrigger);
    procedure ResetUltimate (ult:TUltimate);
    procedure GetUltimate(PlayerID: Byte; var r: TUltimate);

    var UltimateInstances: array[1..32] of TUltimate;
implementation

    procedure CreateUltimate (PlayerID: Byte; duration:Byte; effectTrigger: TUltimateEffectTrigger; cancelUltimateTrigger: TUltimateEffectTrigger);
    begin
        UltimateInstances[PlayerID].tickCount := 0;
        UltimateInstances[PlayerID].percentage := 0;
        UltimateInstances[PlayerID].isActive := false;
        UltimateInstances[PlayerID].duration := duration;
        UltimateInstances[PlayerID].durationCount := 0;
        UltimateInstances[PlayerID].doTheUltimate := effectTrigger;
        UltimateInstances[PlayerID].cancelUltimate := cancelUltimateTrigger;
        UltimateInstances[PlayerID].data := 0;
    end;

    procedure GetUltimate(PlayerID: Byte; var r: TUltimate);
    begin
        r := UltimateInstances[PlayerID];
    end;

    procedure ResetUltimate (ult:TUltimate);
    begin
        ult.tickCount := 0;
        ult.percentage := 0;
        ult.isActive := false;
        ult.duration := 0;
        ult.durationCount := 0;
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