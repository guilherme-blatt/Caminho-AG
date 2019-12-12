# Caminho-AG

Guilherme Blatt

Igor Rodrigues

## Vídeo
Abaixo é possível ver um vídeo criado para demostrar o funcionamento do programa


## Idéia
O problema consiste em um ponto inicial e um ponto final, e é necessário achar um caminho entre esses pontos, sendo que existem obstáculos no caminho

O algoritmo deverá atráves de várias gerações achar um caminho que consiga passar por todos obstáculos.

## Modelagem
O caminho é definido por um vetor contendo ângulos de -PI a PI, e cada passo tem um comprimento fixo. Vale ressaltar que o ângulo é relativo a direção
a ser apontada, e não tem relação com o ângulo anterior. Assim, um traço xi+1 é definido por xi+1 = xi - step*sin(caminho[i]), no qual caminho é o vetor
que possui todos os ângulos do trajeto.

## Plataforma
A plataforma escolhida foi o Processing 3.0, que permite uma implementação gráfica de maneira simplificada, permitindo que um esforço maoior seja
colocado no algoritmo em si. Além disso, é possível fazer uma compilação em java para que o programa seja rodado em outros computadores.

## Algoritmo


## Como rodar
É possível rodar o programa de duas maneiras distintas:
### Utilizando Processing 3.0
É possível baixar o Processing 3.0, abrir o arquivo Trabalho-AG.pde e clicando em play
### Rodando arquivo compilado
A outra opção é entrar na pasta application.windows64 e rodando o arquivo Trabalho_AG.exe, que necessita de Java instalado

Também foi exportada um arquivo para linux mas esse não chegou a ser testado.
