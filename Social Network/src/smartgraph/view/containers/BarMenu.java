package smartgraph.view.containers;

import com.pa.proj2020.Dao.SocialNetworkJSON;
import com.pa.proj2020.Dao.SocialNetworkSerialization;
import com.pa.proj2020.adts.graph.DigraphAdjacencyList;
import com.pa.proj2020.model.Relation;
import com.pa.proj2020.model.SocialNetwork;
import com.pa.proj2020.model.User;
import javafx.scene.Scene;
import javafx.scene.control.Menu;
import javafx.scene.control.MenuBar;
import javafx.scene.control.MenuItem;
import javafx.scene.layout.BorderPane;
import javafx.stage.Stage;
import javafx.stage.StageStyle;
import smartgraph.view.Callback;
import smartgraph.view.statistics.StatisticBarGraph;
import smartgraph.view.statistics.StatisticsText;


public class BarMenu extends BorderPane {
    private SocialNetworkSerialization dao;
    private SocialNetworkJSON daoJson;


    public BarMenu(DigraphAdjacencyList<User, Relation> digraphAdjacencyList, Callback onRestoreSerialization, SocialNetwork socialNetwork){

        MenuBar menuBar = new MenuBar();
        Menu statMenu = new Menu("Statistics");
        Menu modelOptions = new Menu("Model");
        Menu exportModel = new Menu("Export");
        Menu importModel = new Menu("Import");

        MenuItem textStats = new MenuItem("Text Statistics");
        MenuItem barStats = new MenuItem("Bar Graph Statistics");
        MenuItem graphStats = new MenuItem("Pie Chart Statistics");

        MenuItem exportSerialization = new MenuItem("Serialization");
        MenuItem exportJSON = new MenuItem("JSON");
        MenuItem importSerialization = new MenuItem("Serialization");
        MenuItem importJSON = new MenuItem("JSON");

        statMenu.getItems().addAll(graphStats, barStats, textStats);
        modelOptions.getItems().addAll(exportModel, importModel);
        exportModel.getItems().addAll(exportSerialization,exportJSON);
        importModel.getItems().addAll(importSerialization,importJSON);


        barStats.setOnAction(actionEvent -> setupStage(new Scene(new StatisticBarGraph(digraphAdjacencyList),1024, 768)));

        graphStats.setOnAction(actionEvent -> setupStage(new Scene(new PercentageOfRelationTypeGraph(digraphAdjacencyList),1024, 768)));

        textStats.setOnAction(actionEvent -> setupStage(new Scene(new StatisticsText(digraphAdjacencyList),1024, 768)));

        exportSerialization.setOnAction(actionEvent -> {
            dao = new SocialNetworkSerialization();
            dao.saveModel(socialNetwork);
        });

        exportJSON.setOnAction(actionEvent -> {
            daoJson = new SocialNetworkJSON();
            daoJson.saveModel(socialNetwork);
        });


        importSerialization.setOnAction((e) -> {
            dao = new SocialNetworkSerialization();
            onRestoreSerialization.callOnRestoreSerialization(dao.loadModel("model"));
            }
        );

        importJSON.setOnAction((e) -> {
            daoJson = new SocialNetworkJSON();
            onRestoreSerialization.callOnRestoreSerialization(daoJson.loadModel("model"));
            }
        );

        menuBar.getMenus().addAll(statMenu, modelOptions);
        setCenter(menuBar);
    }

    private void setupStage(Scene scene) {
        Stage stage = new Stage(StageStyle.DECORATED);
        stage.setTitle("Top 5 Bar Chart");
        stage.setMinHeight(500);
        stage.setMinWidth(800);
        stage.setScene(scene);
        stage.show();
    }

}
