{$CODEPAGE CP1251}
uses
   Crt;
var
  iter, h : byte;
begin

  writeln('привет мама');
  writeln('Hello mammy! =)');
  write('сколько мне писать строчек');
  readln(h);

  {for iter := 1 to h do
    begin
      textcolor(iter);
      writeln('Мама, говорю тебе ',iter ,'-й раз - я тебя люблю!!!');
      writeln('привет мама')
    end;}

  {iter := 1;
  while iter <= h do
    begin
      textcolor(iter);
      writeln('Мама, говорю тебе ',iter ,'-й раз - я тебя люблю!!!');
      iter := iter + 1;
    end;}

  iter := 1;
  repeat
      textcolor(iter);
      writeln('Mama, I tell you ',iter ,' time - i love you!!!');
      iter := iter + 1;
  until iter > h;

  readln;

end.
