int POP_SIZE = 50;
int NUMBER_SEG = 40;

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
 
 //Ordenar população - Bubble sort simples so pra dar aquela ordenada na primeira população
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
  //float fitness(int xii, int yii, int n_caminho){
  //  float fit = dist(x, y, xii, yii);
  //  //fitness[n_caminho] = fit;
  //  return fit;
  //}
  float fitness(float[] caminho){
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
      
      xi = xii;
      yi = yii;
    }
    float fit = dist(x, y, xi, yi);
    return fit;
  }
  
  void fitall(){
    for(int i = 0; i < POP_SIZE; i++){
      fitness[i] = fitness(caminhos[i]);
    }
  }
  
  //Crossover - 80% de chance de ser uma mistura dos pais, 20% de ser aleatorio
  float[] crossover(float[] caminho1, float[] caminho2){
    float filho[] = new float[NUMBER_SEG];
   
    for(int i = 0; i < NUMBER_SEG; i++){
      float p = random(0, 100);
      if(p < 80){
        filho[i] = ((p-1)*caminho1[i] + p*caminho2[i])/100; 
      }
      else filho[i] = random(-PI/2, PI/2);    
    }  
    return filho;   
  }
  
  //Mutação - Adiciona um valor pequeno pra cada parametro de cada filho - talvez seja melhor nao colocar sempre e diminuir o range de valores
  void mutate(){
    int i, j;
    for(i = 0; i < POP_SIZE; i++){
      j = (int)random(0, NUMBER_SEG);
      caminhosfilhos[i][j] += random(-PI/4, PI/4);
    }
  }
  
  //Reorganizar população - Criar um vetor com o dobro da populaçao, misturar a pop original com os filhos, ordenar todo mundo e pegar os POP_SIZE melhores
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
  
  //Seleção - Mantendo a pop ordenada, os melhores sempre serao os primeiros // Usar um vetor de filhos pra dobrar a populaçao e selecionar os melhores entre pais e filhos
  //Apos a evolve() a pop ja esta atualizada
  void evolve(){
    int bestFit = 0, secondBestFit = 1;
   
    for(int i = 0; i < (int) POP_SIZE/3; i++){
      if(i != bestFit && i!= secondBestFit){
        println(bestFit, secondBestFit, i);
        println(caminhos.length);
        caminhosfilhos[i] = crossover(caminhos[bestFit], caminhos[(int)random(0, POP_SIZE)]);
      }
    }
   
    for(int i =(int) POP_SIZE/3; i < (int) POP_SIZE; i++){
      if(i != bestFit && i!= secondBestFit){
        println(bestFit, secondBestFit, i);
        println(caminhos.length);
        caminhosfilhos[i] = crossover(caminhos[bestFit], caminhos[secondBestFit]);
      }
    }
    mutate();
    for(int i = 0; i < POP_SIZE; i++){
      fitnessfilhos[i] = fitness(caminhosfilhos[i]);
    }
    reorganize();
  }
 
}
