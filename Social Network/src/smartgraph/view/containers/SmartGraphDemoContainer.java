/*
 * The MIT License
 *
 * Copyright 2019 Bruno Silva.
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

import com.pa.proj2020.adts.graph.DigraphAdjacencyList;
import com.pa.proj2020.model.Relation;
import com.pa.proj2020.model.SocialNetwork;
import com.pa.proj2020.model.User;
import com.pa.proj2020.observer.Subject;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.geometry.Insets;
import javafx.scene.control.CheckBox;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.HBox;
import javafx.stage.Stage;
import javafx.stage.StageStyle;
import javafx.scene.layout.VBox;
import smartgraph.view.Callback;
import smartgraph.view.Execution;
import smartgraph.view.graphview.SmartGraphPanel;
import smartgraph.view.statistics.StatisticBarGraph;

/**
 *
 * @author Bruno Silva
 */

public class SmartGraphDemoContainer extends BorderPane {

    public SmartGraphDemoContainer(SmartGraphPanel graphView, DigraphAdjacencyList<User, Relation> digraphAdjacencyList, Callback callback, SocialNetwork socialNetwork, Execution execution){
        setTop(new BarMenu(digraphAdjacencyList, callback, socialNetwork));

        setCenter(graphView);

        //create right pane with controls
        VBox right = new VBox(10);

        if(execution == Execution.INTERACTIVE) {
            ContentUserPane userPane = new ContentUserPane();
            right.getChildren().add(userPane.createField(callback));
        }

        ContentZoomPane zoomPane = new ContentZoomPane(graphView);
        right.getChildren().add(zoomPane.createSlider());

        right.setPadding(new Insets(10, 10, 10, 10));
        setRight(right);

        //create bottom pane with controls
        HBox bottom = new HBox(10);

        CheckBox automatic = new CheckBox("Automatic layout");
        automatic.selectedProperty().bindBidirectional(graphView.automaticLayoutProperty());

        bottom.getChildren().addAll(automatic);

        setBottom(bottom);
    }
}
