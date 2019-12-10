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
  
}
