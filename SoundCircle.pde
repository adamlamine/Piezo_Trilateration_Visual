class SoundCircle{

  float radius = 0;
  float xPos;
  float yPos;
  
  SoundCircle(float xPos, float yPos){
    this.xPos = xPos;
    this.yPos = yPos;
  }
  
  void drawSoundCircle(){
    this.radius+=soundSpeed;
    noFill();
    stroke(1);
    strokeWeight(2);
    circle(this.xPos, this.yPos, this.radius);
    strokeWeight(1);
    
    if(this.radius > 1440){
        circleList.remove(this);
    }
  }


}
