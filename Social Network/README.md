## README

### Estrutura de dados selecionadas

 - Class DigraphAdjacencyList
Implementa a interface Digraph e foi concebido, tendo por base o trabalho efetuado nas
aulas teóricas e laboratoriais, para fazer face à proposta central do projeto, ou seja, a criação de um network de uma 
rede social.

 - HashMap
utilizado para guardar os vértices na classe DigraphAdjacencyList


 - ArrayList
utilizado para guardar os dados que são lidos do ficheiro Relationships.csv. 
É igualmente utilizado para guardar outros dados na classe DigraphAdjacencyList.



***

### Algoritmos de carregamento de dados

 - Class FileParser
O algoritmo existente permite a leitura e gravação dos dados contidos no ficheiro Relationships.csv.
Um ArrayList é utilizado para guardar e retornar esses mesmos dados para ser utilizado na classe SocialNetwork para construir
as relações existentes entre os diversos utilizadores (User). 
Na eventualidade do ficheiro não existir ou o nome estiver errado, retorna um IOException.

***

### Construção do modelo

 - A construção do modelo poderá ser visualizada, através do output na consola representado por uma Adjacency list
e/ou também pela apresentação gráfica presente na classe (main) de testes. 
Nele podemos conferir que cada user terá um número "x" de relacionamentos.

![smartgraph realtime](examples/relationships_network.png)

Um aspeto que notamos nesta parte, houve 5 entradas adicionais (das 365 relações). Estas 5 tem relação a si mesmo.

![](examples/repeated_relations.png) 

Ora, num contexto de uma rede social
não faz sentido que alguém siga, goste ou é amigo de si mesmo. Concluímos então que há uma incongruência de dados no ficheiro
de entrada por isso excluímos esses casos, e em particular, nos testes.


***

### Classe DigraphAdjancencyList

#### Métodos

- **numVertices()**

    - Retorna o número de vértices que estão dentro do graph
    - return : int
    
- **numEdges()**

    - Retorna o número de edges que estão dentro do graph
    - return : int    
    
- **vertices()**

    - Retorna os vertices do grafo em forma de Collection
    - return : Collection        

- **edges()**

    - Retorna os edges do grafo em forma de Collection
    - return : Collection  
    
- **incidentEdges()**

    - Retorna uma lista com os edges incidentes no vértice inserido, se não existirem edges incidentes retorna uma lista vazia
    - param : Vertex v
    - return : Collection      
    
- **outBoundEdges()**
    
    - Retorna uma lista com os edges de saida do vertice inserido, se não existirem edges de saida retorna uma lista vazia
    - param : Vertex v
    - return : Collection
    
- **opposite()**
    
    - Retorna o vértice oposto atraves do edge, ao vértice inserido, se o vertex e o edges inseridos nao tiverem ligados retorna null
    - param : Vertex v, Edge e
    - return : Vertex  

- **areAdjacent()**
    
    - Retorna true se os vertices inseridos estiverem conectados por um edge ou false se nao tiverem relacionados
    - param : Vertex u, Vertex v
    - return : boolean     
    
- **insertVertex()**
    
    - Insere um vértice no grafo
    - param : Vertex u, Vertex v, E edgeElement
    - return : Vertex    
 
- **insertEdge()**
    
    - Insere um edge ligado aos vértice inseridos
    - param : Vertex u, Vertex v
    - return : Edge     
    
- **insertEdge()**
    
    - Insere um edge ligado aos vértice inseridos
    - param : V vElement1, V vElement2, E edgeElement
    - return : Edge   
    
- **removeVertex()**
    
    - remove um vértice e retorna o element do vertice que foi apagado
    - param : Vertex v
    - return : V  

- **removeEdge()**
    
    - remove um edge e retorna o element do edge que foi apagado
    - param : Edge e
    - return : E    
    
- **replace()**
    
    - substitui o elemento do vertice inserido
    - param : Vertex v, V newElement
    - return : V   
    
- **replace()**
    
    - substitui o element do edge inserido
    - param : Edge e, E newElement
    - return : E  
    
- **getVertex()**
    
    - retorna o vertice com o element igual ao inserido
    - param :V newElement
    - return : Vertex     
    
- **vertexOf()**

    - retorna o um objeto da classe MyVertex com o element igual ao inserido
    - param :V vElement
    - return : MyVertex 
    
- **existsVertexWith()**

    - retorna true se existir um vertice com um element igual ao inserido e false se não existir
    - param :V vElement
    - return : boolean             
   
- **existsEdgeWith()**

    - retorna true se existir um edge com um element igual ao inserido e false se não existir
    - param :E edgeElement
    - return : boolean 
    
- **toString()**

    - return uma String com toda a informação do grafo
    - return : String 

- **checkVertex()**

    - retorna um obejto da classe MyVertex igual ao vertice inserido
    - param : Vertex v
    - return : MyVertex 
    
- **checkEdge()**

    - retorna um obejto da classe MyEdge igual ao edge inserido
    - param :Edge e
    - return : MyEdge        
    
#### Classe MyEdge e MyVertex

As classes MyEdge e MyVertex ajudam na implementação do Digraph, ajudam na representação de um edge ou vertice e a gerir os seus elementos.            

- **MyVertex** 
    - Implementa a classe Vertex<V>
    - Dentro de um objeto vertex existe uma lista de edges, os quais estão ligados a esse mesmo vertice.
    - Metodos:
        - element() // retorna o element
        - toString() // retorna uma string com a informação do vertice
        - getEdges() // retorna um ArrayList com os edges ligados ao vertice
        - removeEdge(Edge e) // remove o edge do vertice
        - addEdge(Edge e) // adiciona um edge ao vertice   
     
- **MyEdge** 
    - Implementa a classe Edge<E>
    - Dentro de um objeto edge existem dois vertices:
        - vertexOutbound // vertice de saida do edge
        - vertexInbound // vertice de entrada do edge
    - Metodos:
        - element() // retorna o element
        - toString() // retorna uma string com a informação do vertice
        - contains(Vertex v) // retorna true se o vertice inserido estiver ligado ao edge
        - vertices() // retorna uma Array em que [0] é o vertexOutbound e o [1] é o vertexInbound                
        
***             
