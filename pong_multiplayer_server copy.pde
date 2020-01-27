import processing.net.*;

Client c;
Server s;
String receved;
int Rdata[];
//--------------------
//the data to be sent
int y;
int direction;
int ballY;
int ballX;
String sdata;
//---------------------
// consistent data
int Pspeed=10;
//---------------------
void setup() 
{
  size(500,500);
  frameRate(30);
  s = new Server(this,1234);
}

void draw() 
{    
  background(255);
  c = s.available();
  if( c!= null) 
  {
    receved=c.readString();
    receved = receved.substring(0, receved.indexOf("/n"));
    Rdata = int(split(receved, ' '));
    rect(50,Rdata[0],50,100);
    ellipse(Rdata[1],Rdata[2],50,50);
    fill(0);
    text(Rdata[4],width/2-20,height/2);
    text(Rdata[3],width/2+20,height/2);
  }
 fill(255);
 rect(400,y,50,100);
  y+=(Pspeed * direction);
  if(keyPressed == true) 
  {
    if(key == 'w') 
    {
      direction=-1;
    } else if(key == 's') 
    {
      direction=1;
    }
  } else 
  {
    direction=0;
  }
  sdata =  y + " " + "/n";
  s.write(sdata);
}
