class Piezo{

  float xPos;
  float yPos;
  float deltaTime = 0;
  float deltaZeroTime = 0;
  color c = color(0,0,0);
  boolean collided = false;
  
  Piezo(float xPos, float yPos){
      this.xPos = xPos;
      this.yPos = yPos;
  }
  
  boolean collides(SoundCircle sc){
    if( dist(this.xPos, this.yPos, sc.xPos, sc.yPos) < sc.radius){
      this.c = color(0,255,0);
      this.collided = true;
      if(!measurementStarted){
        measurementStarted = true;
        measurementStart = currentTime;
      }
      this.deltaTime = currentTime - measurementStart;
      this.deltaZeroTime = currentTime - impactTime;
      return true;
    } else {
      this.c = color(0,0,0);
      return false;
    }
  }
  
  void drawPiezo(){
    fill(this.c);
    circle(this.xPos, this.yPos, 20);
    textSize(32);
    fill(50);
  }
  
  void reset(){
    this.c = color(0,0,0);
    this.collided = false;
  }

}
