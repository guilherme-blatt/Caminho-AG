class Caminho{
 float[] melhorcaminho = {0, 1, 1.1, 0.6, 0.8}; 
 
 float[][] caminhos = new float[10][20];
 float[] fitness = new float[10];
 
 Caminho(){
   for(int i = 0; i < 10; i++){
     for(int j = 0; j < 20; j++){
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
