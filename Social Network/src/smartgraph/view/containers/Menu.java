package smartgraph.view.containers;

import javafx.geometry.Insets;
import javafx.scene.control.Button;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import smartgraph.view.ExecutionMode;

import java.io.IOException;


public class Menu extends BorderPane {

    public Menu(Stage stage, ExecutionMode executionMode) {
        VBox vBox = new VBox();
        vBox.setSpacing(10);
        vBox.setPadding(new Insets(20, 20, 20,20));

        Button button = new Button("INTERACTIVE MODE");
        button.prefWidthProperty().bind(vBox.widthProperty());
        button.setOnAction(e -> {
            try {
                executionMode.callInteractiveMode();
                stage.hide();
            } catch (IOException ioException) {
                ioException.printStackTrace();
            }
        });;

        Button button1 = new Button("AUTOMATIC MODE");
        button1.prefWidthProperty().bind(vBox.widthProperty());
        button1.setOnAction(e -> {
            try {
                executionMode.callAutomaticMode();
                stage.hide();
            } catch (IOException ioException) {
                ioException.printStackTrace();
            }

        });;


        vBox.getChildren().addAll(button, button1);
        this.setCenter(vBox);
    }
}
