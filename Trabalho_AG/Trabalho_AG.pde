int x = 650, y = 50;                           //Variáveis que indicam o as coordenadas do destino
int xinicio = 100, yinicio = 550;              //Coordenadas do ponto de ínicio
int xi, yi;                                    //Variáveis auxiliares para cálculo dos trajetos

int step = 30;                                 //Variável que indica o tamanho do passo das linhas
int gen = 0;                                   //Variável que indica a geração atual

Obstaculo[] obs = new Obstaculo[4];            //Vetor com todos os obstáculos
Caminho cam = new Caminho();                   //Objeto que possui todos os caminhos e funcções de AG

void setup(){
  start();
  size(800, 600);
  
  //Definição dos obstáculos e suas coordenadas
  /*obs[0] = new Obstaculo(0, 550, 150, 30);     
  obs[1] = new Obstaculo(100, 700, 400, 30);
  obs[2] = new Obstaculo(200, 30, 300, 125);
  obs[3] = new Obstaculo(400, 30, 150, 125);*/
  
  obs[0] = new Obstaculo(600, 100, 150, 30);     
  obs[1] = new Obstaculo(0, 700, 400, 30);
  obs[2] = new Obstaculo(670, 30, 100, 50);
  
  /*obs[0] = new Obstaculo(0, 700, 150, 30);
  obs[1] = new Obstaculo(100, 700, 300, 30);
  obs[2] = new Obstaculo(0, 700, 450, 30);*/
  
  
  //Inicia o objeto Caminho
  cam = new Caminho();
  cam.fitall();
  cam.sort();
}

void draw(){
   background(255);
   
   //Desenha Inicio
   fill(0);
   ellipse(xinicio, yinicio, 10, 10);
   
  //Desenha destino
  fill(0, 255, 0);
  ellipse(x, y, 10, 10);
  
  //Variavel para armarzenar o melhor fit da geração
  float melhor_fit_gen = 999;
  
  //Desenha todos obstáculos
  for(int i = 0; i < obs.length; i++)
    if(obs[i] != null) obs[i].desenhar();
 
  //Incrementa a geração
  gen++;
  
  //Desenha todos os caminhos na tela na cor azul
  for(int j = 0; j < 200; j++){
    desenha_caminho(cam.caminhos[j], color(0, 0, 255));
  }
  
  melhor_fit_gen = cam.fitness[0];

  //Escreve texto na tela e desenha o melhor caminho em vermelho
  textSize(18);
  fill(255, 0, 0);
  fill(0);
  text("Best Generation Fit: " + melhor_fit_gen, 10, 20);
  text("Generation: " + gen, 10, 40);
  desenha_caminho(cam.caminhos[0], color(255, 0, 0));
  //delay(500);
  
  cam.evolve();  
}

//Escolhe a posição do final manualmente
void mouseClicked(){
   x = mouseX;
   y = mouseY;
   cam.fitall();
    cam.sort();
}


void desenha_caminho(float caminho[], color c){
    xi = xinicio;
    yi = yinicio;
    for(int i = 0; i < caminho.length; i++){
      int xii = (int)(xi - step*sin(caminho[i]));
      int yii = (int)(yi - step*cos(caminho[i]));
      
      boolean colisao = false;
      
      for(int k = 0; k < obs.length; k++){
        if(obs[k] != null && obs[k].lineRect(xi, yi, xii, yii)) colisao = true;
      }
      
      if(xii < 0 || yii < 0 || xii >= width - 1 || yii >= height - 1) colisao = true;
      
      if(colisao)
        break;
      
      stroke(c);
      line(xi, yi, xii, yii);
      stroke(0);
      
      xi = xii;
      yi = yii;
      
      if(dist(xii, yii, x, y) < 10)
        break;
    }  
}
