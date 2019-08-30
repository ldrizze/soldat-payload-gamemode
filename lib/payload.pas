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
            totalWalkSize: single;
            actualWalkSize: single;
            gameTime: Smallint; // In seconds
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

    procedure AddPayloadWaypoint(wt:Byte; X,Y:single);
    procedure ResetPayloadWaypoints();
    procedure LoadPayloadWaypoints(Mapname: String);
    procedure RenderPayloadWaypoints();
    function GetWalkTotalSize():single;
    function GetWaySize(p1,p2: TPayloadWaypoint):single;
implementation
    procedure AddPayloadWaypoint(wt:Byte; X,Y:single);
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
                Players.WorldText(200+_waycount, chr(215), 310, Waytype_colors[PayloadWaypoints[_waycount].wayType], 0.1, PayloadWaypoints[_waycount].X, PayloadWaypoints[_waycount].Y);
            end;
        end;
    end;

    procedure ResetPayloadWaypoints();
    var _waycount:Byte;
    begin
        for _waycount:=1 to 254 do begin
            if PayloadWaypoints[_waycount].wayType = WAYTYPE_END then break;
            if not (PayloadWaypoints[_waycount].wayType = WAYTYPE_NONE) do begin
                PayloadWaypoints[_wpointer].wayType := WAYTYPE_NONE;
                PayloadWaypoints[_wpointer].X := 0;
                PayloadWaypoints[_wpointer].Y := 0;
            end;
        end;
        _wpointer := 0;
    end;

    procedure LoadPayloadWaypoints(Mapname: String);
    var 
        _filecontent:String;
        _splittedlines,_data:TStringList;
        _i,_wt:Byte;
    begin
        filePath := Script.Dir + 'data\waypoints\'+Mapname+'.txt';
        if FileExists(filePath) then begin
            _filecontent := ReadFile(filePath);

            _splittedlines.Delimiter := sLineBreak;
            //_splittedlines.StrictDelimiter := true;
            _splittedlines.DelimitedText := _filecontent;

            for _i:=0 to Length(_splittedlines) do begin
                _data.Delimiter := ';';
                _data.StrictDelimiter := true;
                _data.DelimitedText := _splittedlines[i];

                if _data[0] = 'S' then _wt := WAYTYPE_START;
                if _data[0] = 'W' then _wt := WAYTYPE_WAYPOINT;
                if _data[0] = 'C' then _wt := WAYTYPE_CHECKPOINT;
                if _data[0] = 'E' then _wt := WAYTYPE_END;

                AddPayloadWaypoint(_wt, strtoint(_data[1]), strtoint(_data[2]));
            end;
        end;
    end;

    function GetWalkTotalSize():single;
    var _r: single;
        _pwcount: Byte;
        _x,_y:single;
    begin
        _r := 0;
        for _pwcount:=2 to 255 do begin
            _x := abs(PayloadWaypoints[_pwcount-1].X - PayloadWaypoints[_pwcount].X);
            _y := abs(PayloadWaypoints[_pwcount-1].Y - PayloadWaypoints[_pwcount].Y);
            _r := _r + ( sqrt( (_x*_x) + (_y*_y) ) );
            if PayloadWaypoints[_pwcount].wayType=WAYTYPE_END then break;
        end;
        Result := _r;
    end;

    function GetWaySize(p1,p2: TPayloadWaypoint):single;
    var _r: single;
        _x,_y:single;
    begin
        _x := abs(p1.X - p2.X);
        _y := abs(p1.Y - p2.Y);
        _r := sqrt( (_x*_x) + (_y*_y) );
        Result := _r;        
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
        AddPayloadWaypoint(WAYTYPE_START, -3336, -315);
        AddPayloadWaypoint(WAYTYPE_WAYPOINT, -2836, -350);
        AddPayloadWaypoint(WAYTYPE_CHECKPOINT, -2336, -315);
        AddPayloadWaypoint(WAYTYPE_WAYPOINT, -1836, -315);
        AddPayloadWaypoint(WAYTYPE_CHECKPOINT, -1436, -315);
        AddPayloadWaypoint(WAYTYPE_END, -1336, -315);
    end.

end.