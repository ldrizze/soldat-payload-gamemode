Unit Payload;

interface
    type TOnPlayerCollision = procedure (Player: TActivePlayer; Side: Byte);
    type
        TPayload = record
        	xVel: single;
        	velStep: single;
        	velMax: single;
        	isMoving: boolean;
            isContested: boolean;
            isReached: boolean;
            isEnd: boolean;
            reachTickCount: Smallint;
            Collider: CollisionBox;
            ExternalCollider: CollisionBox;
            OnPlayerCollision, OnPlayerExternalCollision: TOnPlayerCollision;
        end;
    type 
        TPayloadWaypoint = record
            wayType: Byte;
            X,Y: single;
        end;

    const
        WAYTYPE_START = 1;
        WAYTYPE_CHECKPOINT = 2;
        WAYTYPE_WAYPOINT = 3;
        WAYTYPE_END = 4;
        WAYTYPE_NONE = 0;

    var 
        PayloadWaypoints: array[1..255] of TPayloadWaypoint;
        _wpointer:Byte;
        Waytype_colors: array[1..4] of Longint;

    procedure AddWaypoint(wt:Byte; X,Y:single);
    procedure RenderPayloadWaypoints();
implementation
    procedure AddWaypoint(wt:Byte; X,Y:single);
    begin
        PayloadWaypoints[_wpointer].wayType := wt;
        PayloadWaypoints[_wpointer].X := X;
        PayloadWaypoints[_wpointer].Y := Y;
        _wpointer := _wpointer+1;
    end;

    procedure RenderPayloadWaypoints();
    var _waycount:Byte;
    begin
        for _waycount:=1 to 254 do begin
            if not (PayloadWaypoints[_waycount].wayType = WAYTYPE_NONE) then begin
                Players.WorldText(100+_waycount, chr(215), 61, Waytype_colors[PayloadWaypoints[_waycount].wayType], 0.1, PayloadWaypoints[_waycount].X, PayloadWaypoints[_waycount].Y);
            end;
        end;
    end;

    var _waycount:Byte;
    begin
        _wpointer := 1;
        for _waycount:=1 to 254 do PayloadWaypoints[_waycount].wayType := WAYTYPE_NONE;

        // Waytype colors
        Waytype_colors[WAYTYPE_START] := RGB(0,255,0);
        Waytype_colors[WAYTYPE_CHECKPOINT] := RGB(0,0,255);
        Waytype_colors[WAYTYPE_WAYPOINT] := RGB(255,255,0);
        Waytype_colors[WAYTYPE_END] := RGB(255,0,0);

        // Map Waypoints
        AddWaypoint(WAYTYPE_START, -3336, -293);
        AddWaypoint(WAYTYPE_WAYPOINT, -2836, -350);
        AddWaypoint(WAYTYPE_CHECKPOINT, -2336, -293);
        AddWaypoint(WAYTYPE_WAYPOINT, -1836, -293);
        AddWaypoint(WAYTYPE_END, -1336, -293);
    end.

end.