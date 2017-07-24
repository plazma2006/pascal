uses
   crt, graph;

const
   nObjects = 30;

type
   arrPixelsType = array [1..6, 1..nObjects] of integer;

var
   gd, gm, gerr : integer;
   maxX, maxY : integer;
   arrPixels : arrPixelsType;
   ch : char;

procedure fillPixels(var arrP : arrPixelsType);
var
   i : integer;
begin
  for i := 1 to nObjects do
     begin
        arrp[6, i] := random(30) + 1; //radius
        arrP[1, i] := random(640)+arrp[6, i]; //x
        arrP[2, i] := random(480)+arrp[6, i]; //y
        arrP[3, i] := random(5) + 1; //dx
        arrP[4, i] := random(5) + 1; //dy
        arrP[5, i] := random(15) + 1; //color
        {choose random color -> random(15)}
     end;
end;

function CalcDSpeed(code : integer) : integer;
var
   res : integer;
begin

        if code = 43 then
           begin
              res := 1;
              writeln('res = +1');
           end
        else
           begin
              if code = 45 then
                 begin
                    res := -1;
                    writeln('res = -1');
                 end
              else
                 res := 0;
           end;

   CalcDSpeed := res;
end;

procedure CalcNewSpeed(var arrP : arrPixelsType; chr : char);
var
   i : integer;
   ds : integer;
begin
        ds := CalcDSpeed(ord(chr));
        for i := 1 to nObjects do
                begin
                        if (arrP[3, i] + ds >= 0) then arrP[3, i] := arrP[3, i] + ds;
                        if (arrP[4, i] + ds >= 0) then arrP[4, i] := arrP[4, i] + ds;

                        arrP[1, i] := arrP[1, i] + arrP[3, i];
                        arrP[2, i] := arrP[2, i] + arrP[4, i];

                end;
end;

procedure DrawBlackObjects(arrP : arrPixelsType);
var
   i : integer;
begin
        for i := 1 to nObjects do
                begin
                        setcolor(0);
                        circle(arrP[1, i] - arrP[3, i], arrP[2, i] - arrP[4, i], arrP[6, i]);
                end;
end;

procedure DrawColorObjects(arrP : arrPixelsType);
var
   i : integer;
begin
        for i := 1 to nObjects do
                begin
                        setcolor(arrP[5, i]);
                        circle(arrP[1, i], arrP[2, i], arrP[6, i]);
                end;
end;

procedure DrawBlackCurrentObjects(arrP : arrPixelsType);
var
   i : integer;
begin
        for i := 1 to nObjects do
                begin
                        setcolor(0);
                        circle(arrP[1, i], arrP[2, i], arrP[6, i]);
                end;
end;

procedure CheckObjectsDirection(var arrP : arrPixelsType);
var
   i : integer;
begin
        for i := 1 to nObjects do
                begin
                        if (arrP[1, i] + arrP[6, i]> maxX) or (arrP[1, i]  - arrP[6, i]< 1) then  arrP[3, i] := -arrP[3, i];
                        if (arrP[2, i]  + arrP[6, i]> maxY) or (arrP[2, i]  - arrP[6, i]< 1) then  arrP[4, i] := -arrP[4, i];
                end;
end;

procedure drawpixels(var arrP : arrPixelsType; chr : char);
var
   i : integer;
begin

        if ord(chr) = 114 then //r = key
           begin
              DrawBlackCurrentObjects(arrP);
              fillPixels(arrP);
           end;

        CalcNewSpeed(arrP, chr);
        DrawColorObjects(arrP);
        DrawBlackObjects(arrP);
        CheckObjectsDirection(arrP);

end;


begin
   gd := Detect;
   InitGraph(gd, gm, '');
   gerr := Graphresult;
   if gerr = grOk then
     begin

        {initial coordinates}
        fillPixels(arrPixels);

        {size limits}
        maxX := getMaxX;
        maxY := getMaxY;

        repeat
           if keypressed then ch := ReadKey else ch := '1';
           drawPixels(arrPixels, ch);

        until ord(ch) = 27;

        CloseGraph;

     end;

end.
