Unit UI;

interface
    type TUIElementEvent = procedure (data: Byte;Player: TActivePlayer; offset:Byte);
	type
		TUIElement = record
			elementType:Byte;
			x,y:Integer;
			// w,h:Integer;
			fColor,bColor:Longint;
			text:String;
			data:Byte;
			playerClickState:Byte;
			onClick,onHover,onBlur:TUIElementEvent;
	end;
	type
		TUICanvas = record
			enabled:Boolean;
			startLayer:Byte;
			elements: array[1..12] of TUIElement;
	end;

	const
		UI_TYPE_NONE = 0;
		UI_TYPE_BUTTON = 1;
		UI_TYPE_PLAIN_TEXT = 2;

	procedure UIAddButton(var r:TUICanvas; offset:Byte; x,y:Integer; fColor,bColor:Longint; text:String; data:Byte; oc,oh,ob:TUIElementEvent);
	procedure UIAddText(var r:TUICanvas; offset: Byte; x,y:Integer; fColor:Longint; text:String);
	procedure UIAddElement(var r:TUICanvas; offset:Byte; var el:TUIElement);

	procedure UIRenderCanvas(var c:TUICanvas; Player:TActivePlayer);
	procedure UIRenderButton(b:TUIElement; Player:TActivePlayer; l:Byte);
	procedure UIRenderText(t:TUIElement; Player:TActivePlayer; l:Byte);

	function UITestHover(c:TUIElement; Player:TActivePlayer):Boolean;
implementation

	procedure UIAddButton(var r:TUICanvas; offset:Byte; x,y:Integer; fColor,bColor:Longint; text:String; data:Byte; oc,oh,ob:TUIElementEvent);
	begin
		r.elements[offset].elementType := UI_TYPE_BUTTON;
		r.elements[offset].x := x;
		r.elements[offset].y := y;
		r.elements[offset].fColor := fColor;
		r.elements[offset].bColor := bColor;
		r.elements[offset].text := text;
		r.elements[offset].data := data;
		r.elements[offset].onClick := oc;
		r.elements[offset].onHover := oh;
		r.elements[offset].onBlur := ob;
	end;

	procedure UIAddText(var r:TUICanvas; offset: Byte; x,y:Integer; fColor:Longint; text:String);
	begin
		r.elements[offset].elementType := UI_TYPE_PLAIN_TEXT;
		r.elements[offset].x := x;
		r.elements[offset].y := y;
		r.elements[offset].fColor := fColor;
		r.elements[offset].bColor := 0;
		r.elements[offset].text := text;
		r.elements[offset].data := 0;
		r.elements[offset].onClick := nil;
		r.elements[offset].onHover := nil;
		r.elements[offset].onBlur := nil;		
	end;
	
	procedure UIAddElement(var r:TUICanvas; offset:Byte; var el:TUIElement);
	begin
		r.elements[offset] := el;
	end;

	procedure UIRenderCanvas(var c:TUICanvas; Player:TActivePlayer);
	var uicount:Byte; layerOffset:Byte;
	begin
		if c.enabled then begin
			layerOffset := 0;
			for uicount := 1 to 12 do begin
				if c.elements[uicount].elementType = UI_TYPE_BUTTON then begin
					UIRenderButton(c.elements[uicount], Player, c.startLayer + uicount-1 + layerOffset);
					layerOffset := layerOffset + 2;

					// Hover and blur functions
					if (UITestHover(c.elements[uicount], Player)) then begin
						if not (c.elements[uicount].onHover = nil) then c.elements[uicount].onHover(c.elements[uicount].data, Player, uicount);

						// Click function
						if (Player.KeyShoot) and (c.elements[uicount].playerClickState < 2) then c.elements[uicount].playerClickState := 1;
						if not (Player.KeyShoot) and (c.elements[uicount].playerClickState = 1) then c.elements[uicount].playerClickState := 2;

					end else begin
						if not (c.elements[uicount].onBlur = nil) then c.elements[uicount].onBlur(c.elements[uicount].data, Player, uicount);
						if not (Player.KeyShoot) and (c.elements[uicount].playerClickState < 2) then c.elements[uicount].playerClickState := 0;
					end;

					if c.elements[uicount].playerClickState = 2 then begin
						c.elements[uicount].playerClickState := 0;
						if not (c.elements[uicount].onClick = nil) then c.elements[uicount].onClick(c.elements[uicount].data, Player, uicount);
					end;

				end else

				if c.elements[uicount].elementType = UI_TYPE_PLAIN_TEXT then begin

					UIRenderText(c.elements[uicount], Player, c.startLayer + uicount-1 + layerOffset);
					layerOffset := layerOffset + 1;

				end;
			end;
		end;
	end;

	procedure UIRenderButton(b:TUIElement; Player:TActivePlayer; l:Byte);
	begin
    	Player.BigText(l, '-', 100, b.bColor, 1.5, b.x-25, b.y-170);
    	Player.BigText(l+1, b.text, 100, b.fColor, 0.05, b.x, b.y);
	end;

	procedure UIRenderText(t:TUIElement; Player:TActivePlayer; l:Byte);
	begin
    	Player.BigText(l, t.text, 100, t.fColor, 0.05, t.x, t.y);
	end;

	function UITestHover(c:TUIElement; Player:TActivePlayer):Boolean;
	var mX, mY: Single;
	begin
		Result := false;

		mX := Player.MouseAimX - (round(Player.X) - 650);
		mY := Player.MouseAimY - (round(Player.Y) - 485);

		// Player.Tell('[UI] '+floattostr(mX) + ',' + floattostr(mY));

		mX := round( (mX * 100) / 1296 );
		mY := round( (mY * 100) / 970 );

		mX := (mX/100) * 640;
		mY := (mY/100) * 480;


		if (mX > c.x-50) and (mX < c.x + 50) then
			if(mY > c.y-5) and (mY < c.y+20) then Result := true;

	end;

end.
