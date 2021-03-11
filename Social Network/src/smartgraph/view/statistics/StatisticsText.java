package smartgraph.view.statistics;

import com.pa.proj2020.adts.graph.DigraphAdjacencyList;
import com.pa.proj2020.adts.graph.Vertex;
import com.pa.proj2020.model.Relation;
import com.pa.proj2020.model.User;
import javafx.geometry.Insets;
import javafx.geometry.Orientation;
import javafx.scene.control.Label;
import javafx.scene.control.ListView;
import javafx.scene.control.Separator;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.VBox;

import java.util.ArrayList;

/**
 * Creates a new window with text stats related do the socialNetwork
 */
public class StatisticsText extends BorderPane {
    private ArrayList<User> users;

    /**
     * Creates the components to show the graph
     *
     * @param digraphAdjacencyList digraph used in the socialNetwork
     */
    public StatisticsText(DigraphAdjacencyList<User, Relation> digraphAdjacencyList) {
        users = new ArrayList<>();

        int addedUsers = 0;
        int includedUsers = 0;
        VBox vBox = new VBox();
        vBox.setSpacing(10);
        vBox.setPadding(new Insets(20, 20, 20,20));

        Separator separator1 = new Separator();
        Separator separator2 = new Separator();
        Separator separator3 = new Separator();
        separator1.setOrientation(Orientation.HORIZONTAL);
        separator2.setOrientation(Orientation.HORIZONTAL);
        separator3.setOrientation(Orientation.HORIZONTAL);

        for (Vertex<User> v : digraphAdjacencyList.vertices()) {
            users.add(v.element());
        }

        ListView<String> listViewIncludedUsers = new ListView<String>();
        listViewIncludedUsers.setPrefHeight(150);
        listViewIncludedUsers.setPrefWidth(20);

        ListView<String> listViewAddedUsers= new ListView<String>();
        listViewAddedUsers.setPrefHeight(150);
        listViewAddedUsers.setPrefWidth(100);

        for(User u: users){
            if(u.getUserType().equals("Utilizador Incluido")) {
                String str = u.getId() + " -> " + u.getName();
                listViewIncludedUsers.getItems().add(str);
                includedUsers++;
            }
        }

        for(User u: users){
            if(u.getUserType().equals("Utilizador Adicionado")) {
                String str = u.getId() + " -> " + u.getName();
                listViewAddedUsers.getItems().add(str);
                addedUsers++;
            }
        }

        String userInfo = "";

        for(User u: users){
            User user = null;
            if(user == null){
                user = u;
            }else{
                if(user.getNumberOfRelations() < u.getNumberOfRelations()){
                    user = u;
                }
            }
            userInfo = user.getId() + " -> " + user.getName();
        }

        Label label = new Label("Total number of users: "+ users.size());
        Label addedUserNumLabel = new Label("Total number of added users: " +addedUsers);
        Label includedUserNumLabel = new Label("Total number of included users: " +includedUsers);
        Label labelView = new Label("Added users list: ");
        Label labelView2 = new Label("Included users list: ");
        Label userDirectRelation = new Label("User with the most direct relations: " + userInfo);



        vBox.getChildren().addAll(label, separator1 , addedUserNumLabel, labelView, listViewAddedUsers, separator2 ,includedUserNumLabel, labelView2, listViewIncludedUsers, separator3 ,userDirectRelation);
        this.setCenter(vBox);

    }


}
