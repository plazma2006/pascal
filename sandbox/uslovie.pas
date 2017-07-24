uses CRT;
var
  a : byte; {0..255}
begin

  write('Сколько Вам лет?');
  readln(a);

  if a = 1 then writeln('123') else writeln('345');

  if (a = 1) then
    begin
      writeln('123');
    end
  else
    begin
      writeln('345');
    end;


  if (a < 10) then
    begin
      writeln('Ты карапуз');
    end
  else
    begin

      if (a >= 10) AND (a <= 18) then
        begin
          writeln('Ого! Да ты подросток!');
        end
      else
        begin
          writeln('Сударь, да вы уже взрослый!');
        end;

    end;
  readln;
end.
