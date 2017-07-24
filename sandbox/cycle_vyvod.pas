uses crt;
var
  y,u : byte;

begin
    writeln ('priwet');
    write('skolko mne picat strochek');
    readln(u);
    for y := 1 to u do
      begin
        textcolor(y);
        writeln('mama perestan krichat');
      end;
    readln;
end.