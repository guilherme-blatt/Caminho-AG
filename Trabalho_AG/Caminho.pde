int POP_SIZE = 100;
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
 
  
}
