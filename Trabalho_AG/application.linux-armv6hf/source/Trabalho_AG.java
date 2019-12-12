import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Trabalho_AG extends PApplet {

int x = 650, y = 50;                           //Variáveis que indicam o as coordenadas do destino
int xinicio = 100, yinicio = 550;              //Coordenadas do ponto de ínicio
int xi, yi;                                    //Variáveis auxiliares para cálculo dos trajetos

int step = 30;                                 //Variável que indica o tamanho do passo das linhas
int gen = 0;                                   //Variável que indica a geração atual

Obstaculo[] obs = new Obstaculo[4];            //Vetor com todos os obstáculos
Caminho cam = new Caminho();                   //Objeto que possui todos os caminhos e funcções de AG

public void setup(){
  start();
  
  
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

public void draw(){
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
public void mouseClicked(){
   x = mouseX;
   y = mouseY;
   cam.fitall();
    cam.sort();
}


public void desenha_caminho(float caminho[], int c){
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
int POP_SIZE = 500;
int NUMBER_SEG = 150;
float MAX_ANGLE = PI;

class Caminho{
  float[] melhorcaminho = {0, 1, 1.1f, 0.6f, 0.8f}; 
 
  float[][] caminhos = new float[POP_SIZE][NUMBER_SEG];
  float[][] caminhosfilhos = new float[POP_SIZE][NUMBER_SEG];
  float[] fitness = new float[POP_SIZE];
  float[] fitnessfilhos = new float[POP_SIZE];
  
  //Iniciar população
  Caminho(){
    for(int i = 0; i < POP_SIZE; i++){
      for(int j = 0; j < NUMBER_SEG; j++){
        caminhos[i][j] = random(-PI/2, PI/2);   
      }
    }
  }
 
 //Ordenar população - Bubble sort para ordenar a primeira população
  public void sort(){
    int i, j, k; 
    float[] auxcaminho = new float[NUMBER_SEG];
    float auxfit;
    for(i = 0; i < POP_SIZE - 1; i++){
      for(j = 0; j < POP_SIZE - 1; j++){
        if(fitness[j] > fitness[j+1]){
          auxfit = fitness[j+1];
          fitness[j+1] = fitness[j];
          fitness[j] = auxfit;
          for(k = 0; k < NUMBER_SEG; k++){
            auxcaminho[k] = caminhos[j+1][k];
            caminhos[j+1][k] = caminhos[j][k];
            caminhos[j][k] = auxcaminho[k];
          }
        }
      }
    }
  }
 
  //Avaliação
  public float fitness(float[] caminho){
    xi = xinicio;
    yi = yinicio;
    float fit = 999;
    float punicao = 0;
    int k = 1;
    for(int i = 0; i < caminho.length; i++){
      int xii = (int)(xi - step*sin(caminho[i]));
      int yii = (int)(yi - step*cos(caminho[i]));
      
      boolean colisao = false;
      
      for(k = 0; k < obs.length; k++){
        if(obs[k] != null && obs[k].lineRect(xi, yi, xii, yii)) colisao = true;
      }
      
      if(xii < 0 || yii < 0 || xii >= width - 1 || yii >= height - 1) colisao = true;
      
      if(colisao){
        punicao = (1000 - i*60);
        if(punicao < 0) punicao = 0;
        break;
      }
      
      xi = xii;
      yi = yii;
      
     float afit = dist(xii, yii, x, y);
     if(afit < fit){
        fit = afit;
        if(fit < 10){
          fit = 10;
          break;
        }
     }
      

    }
    return fit + punicao;
  }
  
  public void fitall(){
    for(int i = 0; i < POP_SIZE; i++){
      fitness[i] = fitness(caminhos[i]);
    }
  }
  
  //Crossover - 70% de chance do novo parâmetro ser uma mistura dos pais, 30% de ser aleatório
  public float[] crossover(float[] caminho1, float[] caminho2){
    float filho[] = new float[NUMBER_SEG];
   
    for(int i = 0; i < NUMBER_SEG; i++){
      float p = random(0, 100);
      if(p < 70){
        filho[i] = ((100-p)*caminho1[i] + p*caminho2[i])/100; 
      }
      else filho[i] = random(-MAX_ANGLE, MAX_ANGLE);    
    }  
    return filho;   
  }
  
  //Mutação - Altera parâmetros aleatórios dos filhos
  public void mutate(){
    int imax, jmax;
    imax = (int) random(0, POP_SIZE);
    
    for(int i = 0; i < imax; i++){
      jmax = (int) random(0, NUMBER_SEG);
      for(int j = 0; j < jmax; j++){
         caminhosfilhos[(int)random(0,POP_SIZE)][(int)random(0,NUMBER_SEG)] = random(-MAX_ANGLE, MAX_ANGLE); 
      }
    }
  }
  
  //Reorganizar população - Cria um vetor com o dobro da população, mistura a população original com os filhos, ordena todo mundo e pega os POP_SIZE melhores
  public void reorganize(){
    float[][] dobrocaminhos = new float[2*POP_SIZE][NUMBER_SEG];
    float[] dobrofitness = new float[2*POP_SIZE];
    int i, j;
    //Copia os originais e os filhos num vetor maior
    for(i = 0; i < POP_SIZE; i++){
      for(j = 0; j < NUMBER_SEG; j++){
        dobrocaminhos[i][j] = caminhos[i][j];
        dobrofitness[i] = fitness[i];
        dobrocaminhos[i+POP_SIZE][j] = caminhosfilhos[i][j];
        dobrofitness[i+POP_SIZE] = fitnessfilhos[i];
      }
    }
    //Ordena todo mundo
    int k; 
    float[] auxcaminho = new float[NUMBER_SEG];
    float auxfit;
    for(i = 0; i < 2*POP_SIZE - 1; i++){
      for(j = 0; j < 2*POP_SIZE - 1; j++){
        if(dobrofitness[j] > dobrofitness[j+1]){
          auxfit = dobrofitness[j+1];
          dobrofitness[j+1] = dobrofitness[j];
          dobrofitness[j] = auxfit;
          for(k = 0; k < NUMBER_SEG; k++){
            auxcaminho[k] = dobrocaminhos[j+1][k];
            dobrocaminhos[j+1][k] = dobrocaminhos[j][k];
            dobrocaminhos[j][k] = auxcaminho[k];
          }
        }
      }
    }
    //Copia os POP_SIZE primeiros para formar a nova população
    for(i = 0; i < POP_SIZE; i++){
        fitness[i] = dobrofitness[i];
        for(k = 0; k < NUMBER_SEG; k++){
          caminhos[i][k] = dobrocaminhos[i][k];
        }
    }
  }
  
  //Seleção - Mantendo a pop ordenada, os melhores sempre serão os primeiros - Usa um vetor de filhos pra dobrar a populaçao e selecionar os melhores entre pais e filhos
  //Apos a evolve() a pop ja esta atualizada
  public void evolve(){
    int bestFit = 0, secondBestFit = 1;
    //caminhosfilhos = caminhos;
   
    for(int i = 0; i < (int) POP_SIZE*2/5; i++){
      if(i != bestFit && i!= secondBestFit){
        //println(bestFit, secondBestFit, i);
        //println(caminhos.length);
        caminhosfilhos[i] = crossover(caminhos[bestFit], caminhos[(int)random(0, POP_SIZE)]);
      }
    }
   
    for(int i =(int) POP_SIZE*2/5; i < (int) POP_SIZE*4/5; i++){
      if(i != bestFit && i!= secondBestFit){
       // println(bestFit, secondBestFit, i);
        //println(caminhos.length);
        caminhosfilhos[i] = crossover(caminhos[bestFit], caminhos[secondBestFit]);
      }
    }

    for(int i =(int) POP_SIZE*4/5; i < (int) POP_SIZE; i++){
      for(int j = 0; j < NUMBER_SEG; j++){
        //caminhosfilhos[i] = crossover(caminhos[(int)(random(POP_SIZE/10))], caminhosfilhos[i]);
        caminhosfilhos[i][j] = random(-MAX_ANGLE, MAX_ANGLE); 
      }
    }
    
    mutate();
    for(int i = 0; i < POP_SIZE; i++){
      fitnessfilhos[i] = fitness(caminhosfilhos[i]);
    }
    reorganize();
  }
 
}
class Obstaculo{
  int x1, x2, y1, y2;
  
  Obstaculo(int posx, int sizex, int posy, int sizey){
     x1 = posx;
     x2 = posx + sizex;
     y1 = posy;
     y2 = posy + sizey;
     
  }
  
  public void desenhar(){
     fill(50);
     rect(x1, y1, x2-x1, y2-y1);
  }
  
  public boolean inside(int x, int y){
   if((x > x1 && x < x2) && (y > y1 && y < y2))
     return true;
     
    return false;
  }
  
public boolean lineRect(float x1, float y1, float x2, float y2) {
        
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
  
  
public boolean lineLine(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
        
        // calculate the direction of the lines
        float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
        float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
        
        // if uA and uB are between 0-1, lines are colliding
        if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
        
        // optionally, draw a circle where the lines meet
        /*float intersectionX = x1 + (uA * (x2-x1));
        float intersectionY = y1 + (uA * (y2-y1));
        fill(255,0,0);
        noStroke();
        ellipse(intersectionX, intersectionY, 20, 20);*/
        
        return true;
    }
    return false;
}
}
  public void settings() {  size(800, 600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Trabalho_AG" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
