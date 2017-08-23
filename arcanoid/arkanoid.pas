program arkanoid;

uses
  WinCrt , wingraph;

type
    point = record
        x, y : Integer;   
    end;
    ball = record
        x, y : Integer;
        dx, dy : Shortint;
        color, r : longword;
    end;
    platform = record
        x, y : SmallInt;
        dx, speedstep : Shortint;
        color, gap : longword; 
        w, h : Word;
    end;
    block = record
        x, y : Smallint;
        color : longword;
        w, h : Word

    end;
    bullet = record
        x, y : Real;
        color : longword;
        w, h : Word;
        r : Word;
    end;
    enemy = record
        x, y : Real;
        color : longword;
        w, h : Word
    end;
    pbullet = ^bulletlist;
    bulletlist = record
        b : bullet;
        prev : pbullet;
        next : pbullet;
    end;

var
    Gd,Gm,ErrCode,MaxX, MaxY : integer;
    ballstep, nbullets : integer;
    b : ball;
    platf : platform;
    bl : block;
    // bullets : array [1..100] of bullet;
    fBullet, lBullet : pbullet;
    enemies : array [1..100] of enemy;
    nenemies : Byte;
    isExit: Boolean;

procedure DrawEnemy(color : longword; en : enemy);
begin
    setcolor(color); 
    MoveTo(trunc(en.x), trunc(en.y));
    LineRel(0, -en.h);
    LineRel(en.w ,0);
    LineRel(0, en.h);
    LineRel(-en.w, 0);

end;

procedure DrawPlatform(var pl : platform; color : longword);
begin

    setcolor(color);
    MoveTo(pl.x, pl.y);
    LineRel(0, -pl.h);
    LineRel(pl.w ,0);
    LineRel(0, pl.h);
    LineRel(-pl.w, 0);

end;

procedure MovePlatform(var pl : platform; direction : Shortint);
begin
    // idea: if direction same - increase
    // if direction opposite - stop and don't erase previous platform
    case direction of
        -1: begin
            if pl.dx <= 0 then pl.dx := pl.dx - pl.speedstep
            else pl.dx := 0;
        end;
        1: begin
            if pl.dx >= 0 then pl.dx := pl.dx + pl.speedstep
            else pl.dx := 0;
        end;
    end;


    if (pl.x+pl.dx >= 0) and (pl.x+pl.w+pl.dx <= MaxX) then 
        begin
            if not (pl.dx = 0) then DrawPlatform(pl, 0);
            pl.x := pl.x + pl.dx;
        end;
        
end;

procedure FireBullet(pl : platform);
var
    addBullet: pbullet;    
begin

    //звук выстрела
    Sound(520, 30);        { Звук с частотой 520 Гц, на 30 миллисекунд }

    new(addBullet);

    addBullet^.b.x := trunc(pl.x + pl.w / 2);
    addBullet^.b.y := pl.y;
    addBullet^.b.color := LightGreen;
    addBullet^.b.w := 1;
    addBullet^.b.h := 1;
    addBullet^.b.r := 3;
    addBullet^.prev := nil;
    addBullet^.next := nil;

    if fBullet = nil then
        begin
            fBullet := addBullet;
            lBullet := addBullet
        end
    else
        begin
            addBullet^.next := fBullet;
            fBullet^.prev := addBullet;
            fBullet := addBullet;
        end;


 
end;

procedure KeyListener(key : Char; var pl : platform);
begin
    case key of
        #75: MovePlatform(pl, -1); //left arrow
        #77: MovePlatform(pl, 1); //right arrow
        #32: FireBullet(pl);
        #27: isExit := true;
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
    if (bl.y+bl.r >= MaxY) then bl.dy := -abs(bl.dy);
    if (bl.y-bl.r <= 0) then bl.dy := abs(bl.dy);
end;

procedure KillBullet(var currblt : pbullet);
begin
    if not (currblt^.prev = nil) then
        begin
            lBullet := currblt^.prev;
            lBullet^.next := nil;
            currblt^.prev := nil;
        end
    else
        begin
            fBullet := nil;
            lBullet := nil;
        end;
    Dispose(currblt);
    currblt := nil;
end;

procedure DrawBullets();
var
    ibullet, cindex: Integer;
    currblt : pbullet;
    ienem : integer;
begin
    if not (fBullet = nil) then
        begin
            currblt := fBullet;
            while not (currblt = nil) do
                begin
                    setcolor(0);
                    circle(trunc(currblt^.b.x), trunc(currblt^.b.y), 3);

                    currblt^.b.y := currblt^.b.y - 3;

                    //check if any enemy here
                    for ienem := 1 to nenemies do
                        begin
                            //enemy starts to draw from left bottom corner
                            if (currblt^.b.y - currblt^.b.r < enemies[ienem].y) and (currblt^.b.y + currblt^.b.r > enemies[ienem].y - enemies[ienem].h) then
                                begin
                                    // if bullet hurts enemy then throw enemy back to top of the screen
                                    if (currblt^.b.x + currblt^.b.r > enemies[ienem].x) and (currblt^.b.x - currblt^.b.r < enemies[ienem].x + enemies[ienem].w) then
                                        begin
                                            //звук попадания во врага
                                            Sound(220, 100);        { Звук с частотой 220 Гц, на 100 миллисекунд }
                                            DrawEnemy(0, enemies[ienem]);
                                            enemies[ienem].x := random(MaxX - platf.w) + platf.w / 2;
                                            enemies[ienem].y := 0;
                                        end;
                                end;
                        end;

                    if currblt^.b.y <  0 then
                        begin
                            KillBullet(currblt);
                        end
                    else
                        begin
                            setcolor(currblt^.b.color);
                            circle(trunc(currblt^.b.x), trunc(currblt^.b.y), currblt^.b.r);
                            currblt := currblt^.next;
                        end;
                end;
        end; 
end;

procedure DrawEnemies();
var
    ie : integer;
    prevEnemy : enemy;
begin
    for ie := 1 to nenemies do
        begin
            prevEnemy := enemies[ie];
            enemies[ie].y := enemies[ie].y + 1;
            
            DrawEnemy(0, prevEnemy);
            DrawEnemy(enemies[ie].color, enemies[ie]);

            if enemies[ie].y >= MaxY then
                begin
                    DrawEnemy(0, enemies[ie]);
                    enemies[ie].y := 0;
                end;

        end;
end;

begin
     gD := Detect;
     InitGraph(gD, gM,'');
     ErrCode := GraphResult;
     if ErrCode = grOk then
        begin
            ballstep := 15;
            MaxX := GetMaxX;
            MaxY := GetMaxY;
            isExit := false;

            b.r := 50;
            b.x := 2 * b.r;
            b.y := 2 * b.r;
            b.dy := ballstep;
            b.dx := ballstep;
            b.color := LightRed;

            platf.w := 111;
            platf.h := 10;
            platf.gap := 15;
            platf.color := LightGreen;
            platf.dx := 9;
            platf.speedstep := 3;
            platf.x := trunc(MaxX/2-platf.w/2);
            platf.y := trunc(MaxY-platf.gap);

            bl.w := 30;
            bl.h := 100;
            bl.color := LightBlue;
            bl.x := trunc(MaxX/2-bl.w/2);
            bl.y := trunc(MaxY/2+bl.h/2);

            // nbullets := 0;
            fBullet := nil;
            lBullet := nil;

            //INITIALIZE ENEMIES
            enemies[1].color := LightRed;
            enemies[1].x := trunc(MaxX / 2);
            enemies[1].y := 1;
            enemies[1].w := 10;
            enemies[1].h := 10;

            enemies[2].color := LightRed;
            enemies[2].x := 100;
            enemies[2].y := 1;
            enemies[2].w := 10;
            enemies[2].h := 10;
            
            enemies[3].color := LightRed;
            enemies[3].x := trunc(MaxX / 2) + 400;
            enemies[3].y := 1;
            enemies[3].w := 10;
            enemies[3].h := 10;

            nenemies := 3;

            repeat

            	 delay(30);

                if KeyPressed then KeyListener(ReadKey, platf);

                // DrawBall(b, platf);
                DrawPlatform(platf, platf.color);
                // Drawblock(bl);
                DrawBullets();
                DrawEnemies(); //todo

			until CloseGraphRequest or isExit;
	        CloseGraph;
        end
     else Writeln('Graphics error:', GraphErrorMsg(ErrCode));

end.