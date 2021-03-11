package smartgraph.view.statistics;


import com.pa.proj2020.model.Interest;
import com.pa.proj2020.model.User;
import javafx.geometry.Insets;
import javafx.geometry.Orientation;
import javafx.scene.control.Label;
import javafx.scene.control.ListView;
import javafx.scene.control.Separator;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.VBox;
import java.util.ArrayList;

public class UserDetails extends BorderPane {
    private ArrayList<com.pa.proj2020.model.User> users;

    public UserDetails(User user) {
        users = new ArrayList<>();

        VBox vBox = new VBox();
        vBox.setSpacing(10);
        vBox.setPadding(new Insets(20, 20, 20,20));

        Separator separator1 = new Separator();
        Separator separator2 = new Separator();
        Separator separator3 = new Separator();
        separator1.setOrientation(Orientation.HORIZONTAL);
        separator2.setOrientation(Orientation.HORIZONTAL);
        separator3.setOrientation(Orientation.HORIZONTAL);


        ListView<String> listViewInterests = new ListView<String>();
        listViewInterests.setPrefHeight(350);
        listViewInterests.setPrefWidth(20);
        
        for(Interest u: user.getInterestList()){
            String str = u.getId() + " -> " + u.getName();
            listViewInterests.getItems().add(str);
        }

        Label label = new Label("User:"  );
        Label label1 = new Label(user.getId() + " -> " + user.getName());

        Label labelView2 = new Label("Interest users list: ");

        vBox.getChildren().addAll(label, label1, separator1, labelView2, listViewInterests);
        this.setCenter(vBox);
    }
}
