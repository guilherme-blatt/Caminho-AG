int x = 0, y = 0;                              //Variáveis que indicam o as coordenadas do destino
int xi, yi;                                    //Variáveis auxiliares para cálculo dos trajetos
int xinicio = 100, yinicio = 550;
int step = 30;                                 //Variável que indica o passo das linhas
float melhor_caminho[] = {0};                  //Vetor que armazena o melhor caminho encontrado até o momento
float melhor_fit = 999;                        //Variável que armazena o melhor valor de fit já encontrado
int gen = 0;

Obstaculo[] obs = new Obstaculo[4];            //Vetor com todos os obstáculos
Caminho cam = new Caminho();                   //Objeto que possui todos os caminhos e funcções de AG
void setup(){
  start();
  size(800, 600);
  
  //Opção para um ponto aleatório de destino
  //x = (int) random(0, 800);                  
  //y = (int) random(0, 500);
  
  //Posição do destino
  x = 650;                                     
  y = 50;
  
  //Definição dos obstáculos e suas coordenadas
  obs[0] = new Obstaculo(0, 550, 150, 30);     
  obs[1] = new Obstaculo(100, 700, 400, 30);
  obs[2] = new Obstaculo(200, 30, 300, 125);
  obs[3] = new Obstaculo(400, 30, 150, 125);
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
    obs[i].desenhar(); 

  gen++;
  for(int j = 0; j < 50; j++){
    desenha_caminho(cam.caminhos[j], color(0, 0, 255));
  }
  
  if(cam.fitness[0] < melhor_fit){
    melhor_fit = cam.fitness[0];
    melhor_caminho = cam.caminhos[0];
  }
  melhor_fit_gen = cam.fitness[0];
  
  textSize(18);
  fill(255, 0, 0);
  text("Best Fit Overall: " + melhor_fit, 10, 20);
  fill(0);
  text("Best Generation Fit: " + melhor_fit_gen, 10, 40);
  text("Generation: " + gen, 10, 60);
  desenha_caminho(melhor_caminho, color(255, 0, 0));
  //delay(500);
  
  cam.evolve();  
}

void desenha_caminho(float caminho[], color c){
    xi = xinicio;
    yi = yinicio;
    for(int i = 0; i < caminho.length; i++){
      int xii = (int)(xi - step*sin(caminho[i]));
      int yii = (int)(yi - step*cos(caminho[i]));
      
      boolean colisao = false;
      
      for(int k = 0; k < obs.length; k++){
        if(obs[k].lineRect(xi, yi, xii, yii)) colisao = true;
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
