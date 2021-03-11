package smartgraph.view.containers;

import com.pa.proj2020.adts.graph.DigraphAdjacencyList;
import com.pa.proj2020.adts.graph.Edge;
import com.pa.proj2020.adts.graph.Vertex;
import com.pa.proj2020.model.Relation;
import com.pa.proj2020.model.Statistics;
import com.pa.proj2020.model.User;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.chart.PieChart;
import javafx.scene.control.Tooltip;
import javafx.scene.layout.BorderPane;

import java.util.ArrayList;

public class PercentageOfRelationTypeGraph extends BorderPane {

    public PercentageOfRelationTypeGraph(DigraphAdjacencyList<User, Relation> digraphAdjacencyList){
        ArrayList<Relation> relations = new ArrayList<>();

        for(Edge<Relation, User> e : digraphAdjacencyList.edges()){
            relations.add(e.element());
        }

        Statistics statistics = new Statistics(relations);
        double directRelation = 0;
        double directWithInterests = 0;
        double indirectRelation = 0;

        for(Relation r: relations){
            if(r.getRelationType().equals("Direct Relation")){
                directRelation++;
            }else if(r.getRelationType().equals("Indirect Relation")){
                indirectRelation++;
            }else{
                directWithInterests++;
            }
        }

        ObservableList<PieChart.Data> pieChartData = FXCollections.observableArrayList(
                new PieChart.Data("Direct Relations", directRelation),
                new PieChart.Data("Indirect Relations", indirectRelation),
                new PieChart.Data("Direct with Interests", directWithInterests));

        PieChart pieChart = new PieChart(pieChartData);
        pieChart.setTitle("Types of Relations");

        setCenter(pieChart);
    }
}
