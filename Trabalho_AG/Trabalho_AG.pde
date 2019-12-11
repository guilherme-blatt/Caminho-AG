int x = 0, y = 0;                              //Variáveis que indicam o as coordenadas do destino
int xi, yi;                                    //Variáveis auxiliares para cálculo dos trajetos
int xinicio = 400, yinicio = 550;
int step = 20;                                 //Variável que indica o passo das linhas
float melhor_caminho[] = {0};                  //Vetor que armazena o melhor caminho encontrado até o momento
float melhor_fit = 999;                        //Variável que armazena o melhor valor de fit já encontrado
int gen = 0;

Obstaculo[] obs = new Obstaculo[2];            //Vetor com todos os obstáculos
Caminho cam = new Caminho();                   //Objeto que possui todos os caminhos e funcções de AG
void setup(){
  start();
  size(800, 600);
  
  //Opção para um ponto aleatório de destino
  //x = (int) random(0, 800);                  
  //y = (int) random(0, 500);
  
  //Posição do destino
  x = 400;                                     
  y = 100;
  
  //Definição dos obstáculos e suas coordenadas
  obs[0] = new Obstaculo(0, 450, 200, 30);     
  obs[1] = new Obstaculo(300, 500, 400, 30);
  cam = new Caminho();          
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
  
 // Caminho cam = new Caminho(); //APENAS PARA TESTE
 

  gen++;
  for(int j = 0; j < cam.caminhos.length; j++){

    desenha_caminho(cam.caminhos[j], color(0, 0, 255));
    if(cam.fitness(xi, yi, j) < melhor_fit){
      melhor_fit = cam.fitness(xi, yi, j);
      melhor_caminho = cam.caminhos[j];
    }
    
    if(cam.fitness(xi, yi, j) < melhor_fit_gen){
      melhor_fit_gen = cam.fitness(xi, yi, j);
    }
   // println("Caminho: ", j, ". Fitness: ", cam.fitness(xi, yi, j));
    
  }
  textSize(18);
  fill(255, 0, 0);
  text("Best Fit Overall: " + melhor_fit, 10, 20);
  fill(0);
  text("Best Generation Fit: " + melhor_fit_gen, 10, 40);
  text("Generation: " + gen, 10, 60);
  desenha_caminho(melhor_caminho, color(255, 0, 0));
  delay(50);
  
  
  cam.evoluir();
    
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
      
      if(colisao)
        break;
      
      if(dist(xii, yii, x, y) < 10)
        break;
      
      stroke(c);
      line(xi, yi, xii, yii);
      stroke(0);
      
      xi = xii;
      yi = yii;
    }  
}
