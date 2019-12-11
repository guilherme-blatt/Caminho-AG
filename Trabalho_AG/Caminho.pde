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
 
 //Ordenar população - Bubble sort simples so pra dar aquela ordenada
  void sort(float[] caminhos){
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
            auxcaminhos[k] = caminhos[j+1][k];
            caminhos[j+1][k] = caminhos[j][k];
            caminhos[j][k] = auxcaminhos[j+1][k];
          }
        }
      }
    }
  }
 
  //Avaliação - Indica se ta avaliando um filho ou nao
  float fitness(int xii, int yii, int n_caminho, int filho){
    float fit = dist(x, y, xii, yii);
    if(filho == 0){
      fitness[n_caminho] = fit;
    }
    else{
      fitnessfilhos[n_caminho] = fit;
    }
    return fit;
  }
 
  //Seleção - Mantendo a pop ordenada, os melhores sempre serao os primeiros // Usar um vetor de filhos pra dobrar a populaçao e selecionar os melhores entre pais e filhos
   void select(){
   int bestFit = 0, secondBestFit = 1;
   
   for(int i = 0; i < (int) POP_SIZE/3; i++){
      if(i != bestFit && i!= secondBestFit){
        println(bestFit, secondBestFit, i);
        println(caminhos.length);
        caminhosfilhos[i] = crossover(caminhos[bestFit], caminhos[(int)random(0, POP_SIZE)] );
      }
   }
   
   for(int i =(int) POP_SIZE/3; i < (int) POP_SIZE; i++){
      if(i != bestFit && i!= secondBestFit){
        println(bestFit, secondBestFit, i);
        println(caminhos.length);
        caminhosfilhos[i] = crossover(caminhos[bestFit], caminhos[secondBestFit] );
      }
   }
 }
 
  
  //Crossover - 80% de chance de ser uma mistura dos pais, 20% de ser aleatorio
  float[] crossover(float[] caminho1, float[] caminho2){
   float filho[] = new float[NUMBER_SEG];
   
   for(int i = 0; i < NUMBER_SEG; i++){
     float p = random(0, 100);
     if(p < 80){
       filho[i] = (p*caminho1[i] + (p-1)*caminho2[i])/100; 
     }
     else{
       filho[i] = random(-PI/2, PI/2);
     }     
   }   
   return filho;   
 }
  
  //Mutação - Adiciona um valor pequeno pra cada parametro de cada filho - talvez seja melhor nao colocar sempre e diminuir o range de valores
  void mutate(){
    int i;
    float j;
    for(i = 0; i < POP_SIZE; i++){
      j = random(0, NUMBER_SEG);
      caminhosfilhos[i][j] += random(-PI/4, PI/4);
    }
  }
  
  //Reorganizar população
  void reorganize(){
    //Criar um vetor com o dobro da populaçao, misturar a pop original com os filhos, ordenar todo mundo e pegar os POP_SIZE melhores
  }
 
}
