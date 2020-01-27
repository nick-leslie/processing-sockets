import processing.net.*;

Client c;
String receved;
int Rdata[];
//--------------------
//the data to be sent
int y;
int direction;
PVector ballpos = new PVector( 0, 0);
String sdata;
int clientScore;
int serverScore;
//---------------------
//other data that needs to be the same over server and client
int Pspeed=10;
PVector velocity = PVector.random2D();
int radius= 25;
void setup() 
{
  size(500,500);
  frameRate(30);
  c = new Client(this,"127.0.0.01",1234);
  ballpos = new PVector( width/2 , height/2);
  velocity.mult(5);
}
void draw() 
{
  background(255);
  //--------------------------------------
  // this code is for the players actions
  rect(50,y,50,100);
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
  //--------------------------
  // ball handling code 
  ballpos.add(velocity);
  if (ballpos.x > width-radius) {
     ballpos= new PVector(width/2 , height/2);
     velocity = PVector.random2D();
     velocity.mult(5);
     serverScore+=1;
    } else if (ballpos.x < radius) {
      ballpos= new PVector(width/2 , height/2);
      velocity = PVector.random2D();
      velocity.mult(5);
      clientScore+=1;
    } else if (ballpos.y > height-radius) {
      ballpos.y = height-radius;
      velocity.y *= -1;
    } else if (ballpos.y < radius) {
      ballpos.y = radius;
      velocity.y *= -1;
    }
    ellipse(ballpos.x,ballpos.y,radius*2,radius*2);
  //---------------------------
  // ball collition detection  for the client side
  float testX = ballpos.x;
  float testY = ballpos.y;
  //50 is the defalt x
  if(ballpos.x < 50) testX = 50;
  else if(ballpos.x > 50 + 50) testX=50+50;
  if (ballpos.y < y) testY = y;
  else if(ballpos.y > y + 100) testY = y + 100;
  
  float distX = ballpos.x-testX;
  float distY = ballpos.y-testY;
  float distance = sqrt( (distX*distX) + (distY*distY) );
  
  if(distance <= radius) 
  {
    velocity.x *=-1;
    ballpos.x = 100+radius;
  }
  //---------------------------
  //sending data back to the server
  sdata = y + " " + int(ballpos.x) + " " + int(ballpos.y) + " " + clientScore + " " + serverScore + " " + "/n";
  c.write(sdata);
  if(c.available() > 0) 
  {
    fill(0);
    text(serverScore,width/2-20,height/2);
    text(clientScore,width/2+20,height/2);
    fill(255);
    receved=c.readString();
    receved = receved.substring(0, receved.indexOf("/n"));
    Rdata = int(split(receved, ' '));
    //creates paddle and ball if the server is online
    rect(400,(Rdata[0] + Pspeed),50,100);
    //----------------------------------------
     // now for the server side
    float testXS = ballpos.x;
    float testYS = ballpos.y;
    //50 is the defalt x
    if(ballpos.x < 400) testXS = 400;
    else if(ballpos.x > 400 + 50) testX=400+50;
    if (ballpos.y < Rdata[0]) testYS = Rdata[0];
    else if(ballpos.y > Rdata[0] + 100) testYS = Rdata[0] + 100;
    
    float distXS = ballpos.x-testXS;
    float distYS = ballpos.y-testYS;
    float distanceS = sqrt( (distXS*distXS) + (distYS*distYS) );
    
    if(distanceS <= radius) 
    {
      velocity.x *=-1;
      ballpos.x = 400-radius;
    }
  }
}
