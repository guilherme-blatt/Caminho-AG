int POP_SIZE = 500;
int NUMBER_SEG = 150;
float MAX_ANGLE = PI;

class Caminho{
  float[] melhorcaminho = {0, 1, 1.1, 0.6, 0.8}; 
 
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
  void sort(){
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
  float fitness(float[] caminho){
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
  
  void fitall(){
    for(int i = 0; i < POP_SIZE; i++){
      fitness[i] = fitness(caminhos[i]);
    }
  }
  
  //Crossover - 70% de chance do novo parâmetro ser uma mistura dos pais, 30% de ser aleatório
  float[] crossover(float[] caminho1, float[] caminho2){
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
  void mutate(){
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
  void reorganize(){
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
  void evolve(){
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
