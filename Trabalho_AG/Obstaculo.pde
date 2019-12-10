class Obstaculo{
  int x1, x2, y1, y2;
  
  Obstaculo(int posx, int sizex, int posy, int sizey){
     x1 = posx;
     x2 = posx + sizex;
     y1 = posy;
     y2 = posy + sizey;
     
  }
  
  void desenhar(){
     fill(50);
     rect(x1, y1, x2-x1, y2-y1);
  }
  
  boolean inside(int x, int y){
   if((x > x1 && x < x2) && (y > y1 && y < y2))
     return true;
     
    return false;
  }
  
boolean lineRect(float x1, float y1, float x2, float y2) {
        
        // check if the line has hit any of the rectangle's sides
        // uses the Line/Line function below
        boolean left =   lineLine(x1,y1,x2,y2, this.x1, this.y1, this.x1, this.y2);
        boolean right =  lineLine(x1,y1,x2,y2, this.x2, this.y1, this.x2, this.y2);
        boolean top =    lineLine(x1,y1,x2,y2, this.x1, this.y1, this.x2, this.y1);
        boolean bottom = lineLine(x1,y1,x2,y2, this.x1, this.y2, this.x2, this.y2);
        
        // if ANY of the above are true, the line
        // has hit the rectangle
        if (left || right || top || bottom) {
        return true;
    }
    return false;
}
  
  
boolean lineLine(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
        
        // calculate the direction of the lines
        float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
        float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
        
        // if uA and uB are between 0-1, lines are colliding
        if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
        
        // optionally, draw a circle where the lines meet
        float intersectionX = x1 + (uA * (x2-x1));
        float intersectionY = y1 + (uA * (y2-y1));
        fill(255,0,0);
        noStroke();
        //ellipse(intersectionX, intersectionY, 20, 20);
        
        return true;
    }
    return false;
}
}
