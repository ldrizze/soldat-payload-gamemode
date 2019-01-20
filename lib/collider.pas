Unit Collider;

interface
    type
        CollisionBox = record
            X, Y: single;
            W, H: integer;
    end;

    const
        CollisionBox_NONE           = 0;
        CollisionBox_UP             = 1;
        CollisionBox_DOWN           = 2;
        CollisionBox_LEFT           = 3;
        CollisionBox_RIGHT          = 4;
        CollisionBox_UP_LEFT        = 5;
        CollisionBox_UP_RIGHT       = 6;
        CollisionBox_BOTTOM_LEFT    = 7;
        CollisionBox_BOTTOM_RIGHT   = 8;
        CollisionBox_FULL           = 9;

    
    function CollisionBox_Create(W,H: integer; X,Y: single):CollisionBox;

    function CollisionBox_CheckDOWN(C: CollisionBox; Y: single; H: integer):boolean;
    function CollisionBox_CheckUP(C: CollisionBox; Y: single; H: integer):boolean;
    function CollisionBox_CheckRIGHT(C: CollisionBox; X: single; W: integer):boolean;
    function CollisionBox_CheckLEFT(C: CollisionBox; X: single; W: integer):boolean;
    function CollisionBox_CheckFULL(C: CollisionBox; X, Y: single; W,H: integer):boolean;
    function CollisionBox_CheckFULLLR(C: CollisionBox; X: single; W: integer):boolean;
    function CollisionBox_CheckFULLUD(C: CollisionBox; Y: single; H: integer):boolean;
    function CollisionBox_CollideWithXY(C: CollisionBox; X,Y: single; W,H: integer):Byte;

implementation

    function CollisionBox_Create(W,H: integer; X,Y: single):CollisionBox;
    var CB: CollisionBox;
    begin
    	CB.W := W;
        CB.H := H;

        CB.X := X;
        CB.Y := Y;

        Result := CB;
    end;
    
    function CollisionBox_CheckDOWN(C: CollisionBox; Y: single; H: integer):boolean;
    begin
        Result := false;
        if (Y > C.Y) and (Y < C.Y+C.H) and (Y+H > C.Y+C.H) then Result := true;
    end;

    function CollisionBox_CheckUP(C: CollisionBox; Y: single; H: integer):boolean;
    begin
        Result := false;
        if (Y < C.Y) and (Y+H > C.Y) and (Y+H < C.Y+C.H) then Result := true;
    end;

    function CollisionBox_CheckRIGHT(C: CollisionBox; X: single; W: integer):boolean;
    begin
        Result := false;
        if (X > C.X) and (X < C.X+C.W) and (X+W > C.X) and (X+W > C.X+C.W) then Result := true;
    end;

    function CollisionBox_CheckLEFT(C: CollisionBox; X: single; W: integer):boolean;
    begin
        Result := false;
        if (X < C.X) and (X < C.X+C.W) and (X+W > C.X) and (X+W < C.X+C.W) then Result := true;
    end;

    function CollisionBox_CheckFULLLR(C: CollisionBox; X: single; W: integer):boolean;
    begin
        if (X > C.X) and (X+W < C.X+C.W) then Result := true;
    end;

    function CollisionBox_CheckFULLUD(C: CollisionBox; Y: single; H: integer):boolean;
    begin
        if (Y > C.Y) and (Y+H < C.Y+C.H) then Result := true;
    end;

    function CollisionBox_CheckFULL(C: CollisionBox; X, Y: single; W,H: integer):boolean;
    begin
        Result := false;
        if (X > C.X) and (X+W < C.X+W) and (Y > C.Y) and (Y+H < C.Y+C.H) then Result := true;
    end;


    function CollisionBox_CollideWithXY(C: CollisionBox; X,Y: single; W,H: integer):Byte;
    begin
        Result := CollisionBox_NONE;

        // UP
        if CollisionBox_CheckUP(C, Y, H) and CollisionBox_CheckFULLLR(C, X, W) then Result := CollisionBox_UP;

        // DOWN
        if CollisionBox_CheckDOWN(C, Y, H) and CollisionBox_CheckFULLLR(C, X, W) then Result := CollisionBox_DOWN;

        // LEFT
        if CollisionBox_CheckLEFT(C, X, W) and CollisionBox_CheckFULLUD(C, Y, H) then Result := CollisionBox_LEFT;

        // RIGHT
        if CollisionBox_CheckRIGHT(C, X, W) and CollisionBox_CheckFULLUD(C, Y, H) then Result := CollisionBox_RIGHT;

        // UP_LEFT
        //if CollisionBox_CheckLEFT(C, X, W) and CollisionBox_CheckUP(C, X, W) then Result := CollisionBox_UP_LEFT;

        // UP RIGHT
        //if CollisionBox_CheckRIGHT(C, X, W) and CollisionBox_CheckUP(C, X, W) then Result := CollisionBox_UP_RIGHT;
        

    end;    


end.