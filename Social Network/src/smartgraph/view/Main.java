/* 
 * The MIT License
 *
 * Copyright 2019 brunomnsilva@gmail.com.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package smartgraph.view;

import com.pa.proj2020.Memento.CareTaker;
import com.pa.proj2020.adts.graph.DigraphAdjacencyList;
import com.pa.proj2020.adts.graph.Edge;

import com.pa.proj2020.adts.graph.Vertex;
import com.pa.proj2020.model.*;
import javafx.application.Application;
import javafx.scene.Scene;
import javafx.stage.Stage;
import javafx.stage.StageStyle;
import smartgraph.view.containers.Menu;
import smartgraph.view.containers.SmartGraphDemoContainer;
import smartgraph.view.graphview.SmartCircularSortedPlacementStrategy;
import smartgraph.view.graphview.SmartGraphPanel;
import smartgraph.view.graphview.SmartGraphProperties;
import smartgraph.view.graphview.SmartPlacementStrategy;

import smartgraph.view.statistics.UserDetails;

import java.io.IOException;

public class Main extends Application {
    SocialNetwork socialNetwork;
    CareTaker careTaker;

    @Override
    public void start(Stage stage) throws Exception {
        this.socialNetwork = new SocialNetwork();
        careTaker = new CareTaker(socialNetwork);

        ExecutionMode executionMode = new ExecutionMode() {
            @Override
            public void callInteractiveMode() throws IOException {
                startGraph(Execution.INTERACTIVE);
            }

            @Override
            public void callAutomaticMode() throws IOException {
                startGraph(Execution.AUTOMATIC);
            }
        };

        Scene scene = new Scene(new Menu(stage, executionMode),50, 75);
        stage.setTitle("JavaFX SmartGraph Visualization");
        stage.setMinHeight(130);
        stage.setMinWidth(260);
        stage.setScene(scene);
        stage.show();
    }


    private DigraphAdjacencyList<User, Relation>  initGraph(Execution execution) throws IOException {
        if (execution == Execution.AUTOMATIC){
            return buildTotalGraph();
        }else {
            return buildInteractiveGraph();
        }
    }


    private SmartGraphProperties initProperties(Execution execution) throws IOException {
        if (execution == Execution.AUTOMATIC){
            return new SmartGraphProperties("smartgraph.automatic.properties");
        }else {
            return new SmartGraphProperties("smartgraph.interactive.properties");
        }
    }

    private void updateVertexStyle(DigraphAdjacencyList<User, Relation> graph, SmartGraphPanel<User, Relation> graphView){
         /*
        After creating, you can change the styling of some element.
        This can be done at any time afterwards.
        */
        Vertex<User> v1;

        for (Vertex<User> user: graph.vertices()) {
            if(user.element().getUserType().equals("Utilizador Adicionado") ){
                v1 = user;
                if (graph.numVertices() > 0) {
                    graphView.getStylableVertex(v1).setStyle("-fx-fill: #5DADE2; -fx-stroke:  #1B4F72;");
                }
            }else if(user.element().getUserType().equals("Utilizador Incluido")){
                v1 = user;
                if (graph.numVertices() > 0) {
                    graphView.getStylableVertex(v1).setStyle("-fx-fill: #52BE80; -fx-stroke: #145A32;");
                }
            }
        }

    }

    private void updateEdgeStyle(DigraphAdjacencyList<User, Relation> graph, SmartGraphPanel<User, Relation> graphView){
        for(Edge<Relation, User> edge: graph.edges()){
            Relation relation = edge.element();

            if(relation.getRelationType().equals("Direct Relation") ){
                graphView.getStylableEdge(edge).setStyle("-fx-stroke: #EC7063;");
            } else if(relation.getRelationType().equals("Indirect Relation")){
                graphView.getStylableEdge(edge).setStyle("-fx-stroke: #F4D03F");
            }else{
                graphView.getStylableEdge(edge).setStyle("-fx-stroke: #EB984E;");
            }
        }
    }


    public Callback initListeners(SmartGraphPanel<User, Relation> graphView, Execution execution){
      return new Callback() {
            @Override
            public void callOnAddUser(String userId) {
                if (userId != null && !"".equals(userId))
                    socialNetwork.addElement(graphView, Integer.parseInt(userId));
                //careTaker.saveState();
            }

            @Override
            public void callOnUndoUser() {

            }

            @Override
            public void callOnAddIndirectRelationships(String userId) {
                if (userId != null && !"".equals(userId))
                    socialNetwork.addIndirectRelationships(graphView, Integer.parseInt(userId));
                //careTaker.saveState();
            }

            @Override
            public void callOnRestoreSerialization(SocialNetwork value) {
                if (execution == Execution.INTERACTIVE){
                    socialNetwork.restoreInteractiveGraph(value.getInteractiveDigraphAdjacencyList(), graphView);
                }
            }
        };
    }

    private void addVertexAction(SmartGraphPanel<User, Relation> graphView){
        /*
        Bellow you can see how to attach actions for when vertices and edges are double clicked
         */
        graphView.setVertexDoubleClickAction(graphVertex -> {
            User user = graphVertex.getUnderlyingVertex().element();

            Scene scene1 = new Scene(new UserDetails(user),1024, 768);

            Stage stage1 = new Stage(StageStyle.DECORATED);
            stage1.setTitle("User Details");
            stage1.setMinHeight(500);
            stage1.setMinWidth(800);
            stage1.setScene(scene1);
            stage1.show();

            //toggle different styling
            if( !graphVertex.removeStyleClass("myVertex") ) {
                graphVertex.addStyleClass("myVertex");
            }
        });
    }

    private void addEdgeAction(SmartGraphPanel<User, Relation> graphView){

        graphView.setEdgeDoubleClickAction(graphEdge -> {
            System.out.println("Edge contains element: " + graphEdge.getUnderlyingEdge().element());
            //dynamically change the style when clicked
            graphEdge.setStyle("-fx-stroke: black; -fx-stroke-width: 2;");
        });
    }

    private void initScene(SmartGraphPanel<User, Relation> graphView, DigraphAdjacencyList<User, Relation> graph, Execution execution){
        Callback callback = initListeners(graphView, execution);

        Scene scene = new Scene(new SmartGraphDemoContainer(graphView, graph, callback, socialNetwork, execution), 1024, 768);

        Stage stage = new Stage(StageStyle.DECORATED);
        stage.setTitle("JavaFX SmartGraph Visualization");
        stage.setMinHeight(500);
        stage.setMinWidth(800);
        stage.setScene(scene);
        stage.show();
    }

    public void startGraph(Execution execution) throws IOException {
        this.socialNetwork = new SocialNetwork();
        DigraphAdjacencyList<User, Relation> graph = this.initGraph(execution);
        SmartGraphProperties properties = this.initProperties(execution);
        SmartPlacementStrategy strategy = new SmartCircularSortedPlacementStrategy();
        SmartGraphPanel<User, Relation> graphView = new SmartGraphPanel<>(graph, properties, strategy);

        this.updateVertexStyle(graph, graphView);
        this.updateEdgeStyle(graph, graphView);

       this.initScene(graphView, graph, execution);

        graphView.init();

        this.addVertexAction(graphView);
        this.addEdgeAction(graphView);

        graphView.setAutomaticLayout(execution == Execution.INTERACTIVE);
    }

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        launch(args);
    }

    private DigraphAdjacencyList<User, Relation> buildTotalGraph() throws IOException {
        return socialNetwork.getDigraphAdjacencyList();
    }

    private DigraphAdjacencyList<User, Relation> buildInteractiveGraph() throws IOException {
        return socialNetwork.getInteractiveDigraphAdjacencyList();
    }

}
