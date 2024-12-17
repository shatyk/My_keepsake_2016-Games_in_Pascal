program Gonka;
uses graphABC;

type tcars = record
  x,y:integer;
  cl:picture;
end;

var pers,bg:Picture;
i,x,y,Left,Right,n,g,dy,car,r,upr,spd:integer;

mass:array [1..3] of tcars;
grg:array [1..3] of Picture;

procedure KeyDown(Key:integer);
  begin
    if Key=vk_Left then Left:=1;
    if Key=vk_Right then Right:=1;
  end;

procedure KeyUp(Key:integer);
  begin
    if Key=vk_Left then Left:=0;
    if Key=vk_Right then Right:=0;
  end;

begin
SetWindowSize(300,500);
OnKeyDown:=KeyDown;
OnKeyUp:=KeyUp;

bg:=Picture.Create('img/bg.png');

while True do
begin

for i:=1 to 3 do
    mass[i].x:=random(250);

mass[1].y:=-500;
mass[2].y:=-300; 
mass[3].y:=-100; 

for i:=1 to 3 do
    begin
      grg[i]:=Picture.Create('img/'+i.ToString+'p.png');
      r:=random(3);
      mass[i].cl:=picture.Create('img/'+r.ToString+'.png');
    end;
    
for i:=1 to 3 do
    begin
      grg[i].Draw(65*i,60);
      textout(65*i,45,i);
    end;
    
textout(10,10,'Введите номер машины:');
SetBrushColor(clPink);
textout(10,150,'1 - Обычная машина');
SetBrushColor(clRed);
textout(10,180,'2 - Спортивная машина.');
SetBrushColor(clYellow);
textout(10,210,'3 - Суперкар.');
    
redraw;

readln(car);
  case car of
    1 : begin
          pers:=Picture.Create('img/1p.png');
          upr:=3;
          spd:=2;
        end;
    2 : begin
          pers:=Picture.Create('img/2p.png');
          upr:=4;
          spd:=3;
        end;
    3 : begin
          pers:=Picture.Create('img/3p.png');
          upr:=5;
          spd:=4;
        end;
  end;
  
x:=125;
y:=400;
n:=0;
g:=0;
        
LockDrawing;

while g=0 do
  begin  
    ClearWindow;
    bg.Draw(0,0);
    if x>250 then x:=250;
    if x<0 then x:=0;
    pers.Draw(x,y);
    
    if Right=1 then x:=x+upr;
    if Left=1 then x:=x-upr;
    
    dy:=spd + (n div 10);
    
    for i:=1 to 3 do
      begin
        mass[i].y:=mass[i].y+dy;
        mass[i].cl.Draw(mass[i].x,mass[i].y);
        if mass[i].y>500 then
          begin
            r:=random(3);
            mass[i].cl:=picture.Create('img/'+r.ToString+'.png');
            mass[i].y:=-100;
            mass[i].x:=random(250);
            n:=n+1;
          end
      end;  
      
    for i:=1 to 3 do
      if (x<mass[i].x+50) and (x+50>mass[i].x) and (y<mass[i].y+75) and (y+75>mass[i].y)
      then g:=1;
      
      
      textout(0,0,n);
    
    redraw;
    sleep(1);
  end;

SetBrushColor(clLightGreen);
clearwindow;
textout(20,20,'Игра окончена. Вы набрали очков:');
textout(250,20,n);
textout(20,50, 'Нажмите Enter что бы сыграть еще раз.');
redraw;
readln();
clearwindow;
SetBrushColor(clWhite);
Left:=0;
Right:=0;

end;

end.