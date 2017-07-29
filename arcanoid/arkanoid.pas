program arkanoid;

uses
  winCrt, wingraph;

type
    point = record
        x, y : Integer;   
    end;
    ball = record
        x, y : Integer;
        dx, dy : Shortint;
        color, r : Byte;
    end;
    platform = record
        x, y : SmallInt;
        dx : Shortint;
        color, gap : Byte; 
        w, h : Word;
    end;
    block = record
        x, y : Smallint;
        color : longword;
        w, h : Word

    end;

var
    Gd,Gm,ErrCode,MaxX, MaxY : integer;
    ballstep : integer;
    b : ball;
    platf : platform;
    bl : block;
    // ch : Char;
    keycode : Byte;

procedure DrawPlatform(var pl : platform; color : Byte);
begin
    { bl.x := bl.x + bl.dx;
    bl.y := bl.y + bl.dy;

    setcolor(0);
    circle(bl.x-bl.dx, bl.y-bl.dy, bl.r); }

    setcolor(color);
    MoveTo(pl.x, pl.y);
    LineRel(0, -pl.h);
    LineRel(pl.w ,0);
    LineRel(0, pl.h);
    LineRel(-pl.w, 0);

end;

procedure Drawblock(var bl : block);
begin

    setcolor(bl.color);
    MoveTo(bl.x, bl.y);
    LineRel(0, -bl.h);
    LineRel(bl.w ,0);
    LineRel(0, bl.h);
    LineRel(-bl.w, 0);


end;    

procedure MovePlatform(var pl : platform; xmove : Shortint);
begin

    if (pl.x+xmove >= 0) and (pl.x+pl.w+xmove <= MaxX) then 
        begin
            DrawPlatform(pl, 0);
            pl.x := pl.x + xmove;
        end;
        
end;

procedure KeyListener(key : Byte; var pl : platform);
begin
    case key of
        75: MovePlatform(pl, -pl.dx); //left arrow
        77: MovePlatform(pl, pl.dx);
        else 
            key := key;
    end;
end;

procedure DrawBall(var bl : ball; pl : platform);
begin
    bl.x := bl.x + bl.dx;
    bl.y := bl.y + bl.dy;

    setcolor(0);
    circle(bl.x-bl.dx, bl.y-bl.dy, bl.r);

    setcolor(bl.color);
    circle(bl.x, bl.y, bl.r);

    if (bl.y + bl.r >= pl.y-pl.h) and (bl.x >= pl.x) and (bl.x <= pl.x + pl.w) then bl.dy := -abs(bl.dy);

    if (bl.x+bl.r >= MaxX) or (bl.x-bl.r <= 0) then bl.dx := bl.dx * (-1);
    if (bl.y+bl.r >= MaxY) or (bl.y-bl.r <= 0) then bl.dy := bl.dy * (-1);
end;


begin
     gD := Detect;
     InitGraph(gD, gM,'');
     ErrCode := GraphResult;
     if ErrCode = grOk then
        begin
            ballstep := 10;
            MaxX := GetMaxX;
            MaxY := GetMaxY;

            b.r := 50;
            b.x := 2 * b.r;
            b.y := 2 * b.r;
            b.dy := ballstep;
            b.dx := ballstep;
            b.color := 15;

            platf.w := 111;
            platf.h := 10;
            platf.gap := 15;
            platf.color := 7;
            platf.dx := 39;
            platf.x := trunc(MaxX/2-platf.w/2);
            platf.y := trunc(MaxY-platf.gap);

            bl.w := 30;
            bl.h := 100;
            bl.color := LightBlue;
            bl.x := trunc(MaxX/2-bl.w/2);
            bl.y := trunc(MaxY/2+bl.h/2);

            repeat


            	 delay(30);

                if keypressed then keycode := ord(ReadKey) else keycode := 0;

                if keycode > 0 then KeyListener(keycode, platf);

                DrawBall(b, platf);
                DrawPlatform(platf, platf.color);
                Drawblock(bl);

			until CloseGraphRequest;
	        CloseGraph;
        end
     else Writeln('Graphics error:', GraphErrorMsg(ErrCode));

end.