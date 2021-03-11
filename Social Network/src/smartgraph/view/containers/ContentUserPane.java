/*
 * The MIT License
 *
 * Copyright 2019 brunomnsilva.
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
package smartgraph.view.containers;

import com.pa.proj2020.Memento.CareTaker;

import com.pa.proj2020.Memento.NoMementoException;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.Node;
import javafx.scene.control.*;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;

import smartgraph.view.Callback;

/**
 * This class provides zooming and panning for a JavaFX node.
 *
 * It shows the zoom level with a slider control and reacts to mouse scrolls and
 * mouse dragging.
 *
 * The content node is out forward in the z-index so it can react to mouse
 * events first. The node should consume any event not meant to propagate to
 * this pane.
 *
 * @author brunomnsilva
 */



public class ContentUserPane extends BorderPane {



    public ContentUserPane() {
    }

    public Node createField(Callback callback) {
        VBox container = new VBox(2);

        TextField textField = new TextField();
        Label label = new Label("Enter the user ID:");

        HBox form = new HBox(10);

        textField.setPromptText("1, 2, 3, etc...");
        textField.textProperty().addListener((observable, oldValue, newValue) -> {
            if (newValue.matches("\\d*")) return;
            textField.setText(newValue.replaceAll("[^\\d]", ""));
        });

        HBox form2 = new HBox(10);

        TextField textField2 = new TextField();
        Label label2 = new Label("Enter userId to add indirect relations...");

        textField2.setPromptText("1, 2, 3, etc...");
        textField2.textProperty().addListener((observable, oldValue, newValue) -> {
            if (newValue.matches("\\d*")) return;
            textField.setText(newValue.replaceAll("[^\\d]", ""));
        });

        Button button = new Button("ADD");
        Button button2 = new Button("UNDO");
        Button button3 = new Button("ADD");

        form.getChildren().addAll(textField, button, button2);
        form2.getChildren().addAll(textField2, button3);
        container.getChildren().addAll(label, form, label2, form2);

        button.setOnAction((a)-> {
            callback.callOnAddUser(textField.getText());
            textField.setText("");

        });

        button3.setOnAction((a)-> {
            callback.callOnAddIndirectRelationships(textField2.getText());
            textField2.setText("");
        });

        return container;
    }

}
