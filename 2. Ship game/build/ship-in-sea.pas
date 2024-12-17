program shipinsea;

uses graphABC;

type pl1 = record
  x, y, hp:integer;
  pic:picture;
end;

var
  i, esmX, esmY, esmHP, left, right, nloX, nloDX, space, bombY, bombX, bombDY, kill, blastCD, blastSL, blastX, blastY, gaov, sl:integer;
  bg, esm, nlo, bomb, blast: picture;
  
  plm: array [1..10] of pl1;
  plmDX: array [1..10] of integer;    //рандомная скорость подлодок  

procedure KeyDown(Key:integer);
begin
  if (key=vk_left) and (esmHP>=0) then left:=1;
  if (key=vk_right) and (esmHP>=0) then right:=1; 
  if (key=vk_space) and (esmHP>=0) then space:=1;
end;

procedure KeyUp(Key:integer);
begin
  if key=vk_left then left:=0;
  if key=vk_right then right:=0; 
end;

function checkPL():integer;
var i:integer;
begin
checkPL:=0;
  for i:=1 to 6 do
    begin
      if (bombX+15<plm[i].x+120) and (bombX+25>plm[i].x)
      and (bombY+24<plm[i].y+8) and (bombY+25>plm[i].y+4) 
      then checkPL:=i;
    end;
end;

function checkESM():integer;
begin
  checkESM:=0;
  if (blastX<esmX+140) and (blastX+5>esmX)
  and (blastY<esmY+50) and (blastY+10>esmY)
  then checkESM:=1;
end;

BEGIN
while true do
begin

ClearWindow;

SetFontSize(15);
SetFontColor(clblack);
setbrushstyle(bsclear);
textout(5, 150, 'Выберете сложность:');
textout(5, 170, '1 - легко');
textout(5, 190, '2 - нормально');
textout(5, 210, '3 - сложно');
redraw;
readln(sl);

case sl of
  1 : begin
        bombDY:=3;
        blastSL:=30;
      end;
  2 : begin
        bombDY:=2;
        blastSL:=25;
      end;
  3 : begin
        bombDY:=1;
        blastSL:=15;
      end;
end;

SetFontSize(11);
setwindowsize(700,500);
OnKeyDown:=KeyDown;
OnKeyUp:=KeyUp;
randomize;

esmx:=270;
nloX:=300; nloDX:=5;
bombY:=270; bombX:=300;
blastY:=80;
esmY:=230;
esmHP:=5;
gaov:=0;
space:=0;

for i:=1 to 6 do
  plmDX[i]:=random(7)+2;
  
for i:=1 to 6 do
  begin
    plm[i].pic := picture.Create('img/pl1r.png');
    plm[i].x := random(581);
    plm[i].y := random(68)+400;
    plm[i].hp := random(3)+1;
  end;

bg:=picture.Create('img/bg.png');
esm:=picture.Create('img/esm5r.png');
nlo:=picture.Create('img/nlo.png');
bomb:=picture.Create('img/bomb.png');
plm[7].pic:=picture.Create('img/pl1l.png');
blast:=picture.Create('img/blast.png');

LockDrawing;

while gaov<6 do
begin
  ClearWindow;
  bg.Draw(0,0);
  blastCD:=blastCd + 1;
  
  if left=1 then  begin 
  esmX:=esmX - esmHP; esm:=picture.Create('img/esm'+esmHP.ToString+'l.png'); end;
  if right=1 then begin
  esmX:=esmX + esmHP; esm:=picture.Create('img/esm'+esmHP.ToString+'r.png'); end;
  
  if esmX<0 then esmX:=0;
  if esmX>560 then esmX:=560;
  
  SetFontColor(clyellow);
  setbrushstyle(bsclear);
  
  for i:=1 to 6 do
    begin
      plm[i].x:=plm[i].x + plmDX[i];
      if plm[i].y<>0 then begin plm[i].pic.Draw(plm[i].x + 7, plm[i].y); textout(plm[i].x, plm[i].y, plm[i].hp); end;
      if (plm[i].x>580) then begin
      plmDX[i]:=-plmDX[i]; plm[i].pic:=picture.Create('img/pl1l.png'); plm[7].pic:=picture.Create('img/pl2l.png'); end;
      if (plm[i].x<0) then begin
      plmDX[i]:=-plmDX[i]; plm[i].pic:=picture.Create('img/pl1r.png'); plm[7].pic:=picture.Create('img/pl2r.png'); end;
      if checkPL=i then plm[i].hp:=plm[i].hp - 1;
      if plm[i].hp=0 then 
        begin
          bombY:=500;
          plm[7].x:=plm[i].x;
          plm[7].y:=plm[i].y;
          plm[i].y:=0;
          kill:=2;
          plm[i].hp:=-1;
          gaov:=gaov + 1;
        end;
    end;
    
  if (plm[7].y<>500) and (kill=2) then 
    begin
      plm[7].y:=plm[7].y + 5;
      plm[7].pic.Draw(plm[7].x, plm[7].y);
    end else kill:=1;
  
  nloX:=nloX + nloDX;
  if (nloX<5) or (nloX>620) or (random(100) = 28) then nloDX:=-nloDX;
  nlo.Draw(nloX, 5);
  
  if checkESM=1 then esmHP:=esmHP - 1;
  
  if (blastCD<=blastSL) then blastX:=nloX + 36;
  if blastCD>blastSL then
    if (checkESM=1) or (blastY>270) then
      begin
        blastCD:=0; blastY:=80;
      end
    else
      begin
        blast.Draw(blastX, blastY);
        blastY:=blastY + 6;
      end;
  
  esm.Draw(esmX, esmY);
  
  SetFontColor(clgreen);
  textout(esmX, esmY, esmHP);
  
  if space=0 then bombX:=esmX + 63; 
  if  space=1 then
    if (checkPL>0) or (bombY>500) then 
      begin
        space:=0; bombY:=270;
      end
    else
      begin
        bomb.draw(bombX,bombY);
        bombY:=bombY + bombDY;
      end;
    
  if esmHP<0 then gaov:=7;
    
  sleep(1);
  redraw;
end;

if gaov=7 then 
  begin
    SetFontSize(20);
    SetFontColor(clred);
    textout(5, 95, 'Вы проиграли. Нажмите ентер и сыграйте еще раз.');
  end
else
  begin
    SetFontSize(10);
    SetFontColor(clgreen);
    case sl of
      1 : begin
            textout(5, 95, 'Вы победили (сложность: легко). Пройдите игру на более высокой сложности, чтобы получить приз.');
            textout(5, 120, 'Можете нажать на ентер, и сыграть еще разок.');
          end;
      2 : begin
            textout(5, 95, 'Вы победили (сложность: нормально). Скинте скрин разрабу игры, и он выдаст вам сижку при встрече.');
            textout(5, 120, 'Можете нажать на ентер, и сыграть еще разок.');
          end;
      3 : begin
            textout(5, 95, 'Вы победили (сложность: сложно). Скинте скрин разрабу игры, и он выдаст вам ДВЕ сижки при встрече.');
            textout(5, 120, 'Можете нажать на ентер, и сыграть еще разок.');
          end;
    end;
  end;
redraw;

readln();

end;
END.