int x = 0, y = 0;
int step = 20;
Obstaculo[] obs = new Obstaculo[2];
Caminho cam = new Caminho();
void setup(){
  start();
  size(800, 600);
  
  
  //x = (int) random(0, 800);
  //y = (int) random(0, 500);
  x = 400;
  y = 100;
  
  obs[0] = new Obstaculo(0, 500, 200, 30);
  obs[1] = new Obstaculo(400, 400, 400, 30);
}

void draw(){
   background(255);
   
   //Desenha Inicio
   fill(0);
   ellipse(400, 550, 10, 10);
   
   //Desenha destino
  fill(0, 255, 0);
  ellipse(x, y, 10, 10);
  
  for(int i = 0; i < obs.length; i++)
    obs[i].desenhar();
  
  Caminho cam = new Caminho();
  
  for(int j = 0; j < cam.caminhos.length; j++){
    int xi = 400, yi = 550;
    for(int i = 0; i < cam.caminhos[j].length; i++){
      int xii = (int)(xi - step*sin(cam.caminhos[j][i]));
      int yii = (int)(yi - step*cos(cam.caminhos[j][i]));
      
      boolean colisao = false;
      
      for(int k = 0; k < obs.length; k++){
        if(obs[k].lineRect(xi, yi, xii, yii)) colisao = true;
      }
      
      if(colisao)
        break;
      
      stroke(0, 0, 255);
      line(xi, yi, xii, yii);
      stroke(0);
      
      xi = xii;
      yi = yii;
    }
    println("Caminho: ", j, ". Fitness: ", cam.fitness(xi, yi, j));
  }
  delay(1000);
    
}
