int POP_SIZE = 50;
int NUMBER_SEG = 40;

class Caminho{
 float[] melhorcaminho = {0, 1, 1.1, 0.6, 0.8}; 
 
 float[][] caminhos = new float[POP_SIZE][NUMBER_SEG];
 float[] fitness = new float[POP_SIZE];
 
 Caminho(){
   for(int i = 0; i < POP_SIZE; i++){
     for(int j = 0; j < NUMBER_SEG; j++){
        caminhos[i][j] = random(-PI/2, PI/2);   
     }
   }
 }
 
 float fitness(int xii, int yii, int n_caminho){
   float fit = dist(x, y, xii, yii);
   fitness[n_caminho] = fit;
   
   return fit;
 }
 
 
 void evoluir(){
   int bestFit = 0, secondBestFit = 0, worstFit = 0;
   
   for(int i = 0; i < fitness.length; i++){
       if(fitness[i] < fitness[bestFit]){
          bestFit = i; 
       }
   }
   
   for(int i = 0; i < fitness.length; i++){
       if(fitness[i] < fitness[secondBestFit] && i != bestFit){
          secondBestFit = i; 
       }
   }
   
   for(int i = 0; i < fitness.length; i++){
       if(fitness[i] > fitness[worstFit]){
          worstFit = i; 
       }
   }
   
   for(int i = 0; i < (int) POP_SIZE/3; i++){
      if(i != bestFit && i!= secondBestFit){
        println(bestFit, secondBestFit, i);
        println(caminhos.length);
         caminhos[i] = cruzamento(caminhos[bestFit], caminhos[(int)random(0, POP_SIZE)] );
      }
   }
   
   for(int i =(int) POP_SIZE/3; i < (int) POP_SIZE; i++){
      if(i != bestFit && i!= secondBestFit){
        println(bestFit, secondBestFit, i);
        println(caminhos.length);
         caminhos[i] = cruzamento(caminhos[bestFit], caminhos[secondBestFit] );
      }
   }
     
     
   
   
 }
 
 float[] cruzamento(float[] caminho1, float[] caminho2){
   float filho[] = new float[NUMBER_SEG];
   
   for(int i = 0; i < NUMBER_SEG; i++){
     float p = random(0, 100);
     if(p < 40){
       filho[i] = caminho1[i]; 
     }
     else if(p < 80){
       filho[i] = caminho2[i]; 
     }
     else{
       filho[i] = random(-PI/2, PI/2);
     }     
   }   
   return filho;   
 }
}
