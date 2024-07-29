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
        Waytype_names: array[1..4] of String;

    procedure AddPayloadWaypoint(wt:Byte; X,Y:single);
    procedure ResetPayloadWaypoints();
    procedure LoadPayloadWaypoints(Mapname: String);
    procedure RenderPayloadWaypoints();
    function GetWalkTotalSize():single;
    function GetWaySize(p1,p2: TPayloadWaypoint):single;
implementation
    procedure AddPayloadWaypoint(wt:Byte; X,Y:single);
    begin
        WriteLn('[PL][PAYLOAD] WAYPOINT ADDED: ' + Waytype_names[wt] + ':' + floattostr(X) + ':' + floattostr(Y));
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
            if not (PayloadWaypoints[_waycount].wayType = WAYTYPE_NONE) then begin
                PayloadWaypoints[_wpointer].wayType := WAYTYPE_NONE;
                PayloadWaypoints[_wpointer].X := 0;
                PayloadWaypoints[_wpointer].Y := 0;
            end;
        end;
        _wpointer := 1;
    end;

    procedure LoadPayloadWaypoints(Mapname: String);
    var 
        _filecontent,_filePath:String;
        _splittedlines:TStringList;
        _data:String;
        _x,_y:Single;
        _i,_j,_wt,_sc1,_sc2,_sl:Byte;
    begin
        WriteLn('[PL][PAYLOAD] Loading waypoints for map: '+Mapname)
        _filePath := Script.Dir + 'data/waypoints/'+Mapname+'.txt';
        WriteLn('[PL][PAYLOAD] '+_filePath);
        if FileExists(_filePath) then begin
            _filecontent := ReadFile(_filePath);
            _filecontent := copy(_filecontent, 1, Length(_filecontent)-2); // Remove lb
            _splittedlines := File.CreateStringList();
            _splittedlines.Text := _filecontent;

            for _i:=0 to _splittedlines.Count-1 do begin
                _data := _splittedlines.Strings[_i];
                _sc1 := 0;
                _sc2 := 0;
                _sl := Length(_data);

                for _j:=1 to _sl do begin
                    if _data[_j] = ';' then 
                    begin
                        if (_sc1 = 0) then 
                        begin 
                            _sc1 := _j;
                        end 
                        else if (_sc2 = 0) then 
                        begin
                            _sc2 := _j;
                            break;
                        end;
                    end;
                end;

                _x := strtofloat(copy(_data, _sc1+1, _sc2-_sc1-1));
                _y := strtofloat(copy(_data, _sc2+1, _sl-_sc2+1));


                if _data[1] = 'S' then _wt := WAYTYPE_START;
                if _data[1] = 'W' then _wt := WAYTYPE_WAYPOINT;
                if _data[1] = 'C' then _wt := WAYTYPE_CHECKPOINT;
                if _data[1] = 'E' then _wt := WAYTYPE_END;

                AddPayloadWaypoint(_wt, _x, _y);
            end;
        end else WriteLn('[PL][PAYLOAD][ERROR] Waypoints for map '+Mapname+' not found! Please, provide the waypoints creating a '+Mapname+'.txt in data > waypoints folder');
    end;

    function GetWalkTotalSize():single;
    var _r: single;
        _pwcount: Byte;
        _x,_y:single;
    begin
        _r := 0;
        for _pwcount:=2 to 254 do begin
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

        // Waytype names
        Waytype_names[WAYTYPE_START] := 'S';
        Waytype_names[WAYTYPE_CHECKPOINT] := 'C';
        Waytype_names[WAYTYPE_WAYPOINT] := 'W';
        Waytype_names[WAYTYPE_END] := 'E';
    end.

end.