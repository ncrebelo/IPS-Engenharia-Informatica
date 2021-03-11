package smartgraph.view.statistics;

import com.pa.proj2020.adts.graph.DigraphAdjacencyList;
import com.pa.proj2020.adts.graph.Vertex;
import com.pa.proj2020.model.Relation;
import com.pa.proj2020.model.Statistics;
import com.pa.proj2020.model.User;
import javafx.scene.chart.BarChart;
import javafx.scene.chart.CategoryAxis;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.XYChart;
import javafx.scene.layout.BorderPane;
import java.math.BigDecimal;
import java.util.*;

/**
 * Creates a new window with a bar graph,
 * it shows the top 5 users with the most relations
 */
public class StatisticBarGraph extends BorderPane{

    /**
     * Creates the components to show the graph
     *
     * @param digraphAdjacencyList digraph used in the socialNetwork
     */
    public StatisticBarGraph(DigraphAdjacencyList<User, Relation> digraphAdjacencyList){
        ArrayList<User> users = new ArrayList<>();

        for(Vertex<User> vertex :digraphAdjacencyList.vertices()){
            users.add(vertex.element());
        }

        Statistics statistics = new Statistics(users);

        final CategoryAxis x = new CategoryAxis();
        final NumberAxis y = new NumberAxis();
        final BarChart barChart = new BarChart(x, y);

        barChart.setTitle("Top 5 users with the most relations");
        x.setLabel("Users");
        y.setLabel("Number of Relations");

        XYChart.Series<String, Integer> series = new XYChart.Series<>();
        series.setName("User");


        for(Map.Entry<String, Integer> item : statistics.top5UsersWithMoreRelations().entrySet()){
            series.getData().add(new XYChart.Data<>(item.getKey(), item.getValue()));
        }

        Collections.sort(series.getData(), new Comparator<XYChart.Data<String, Integer>>() {
            @Override
            public int compare(XYChart.Data<String, Integer> o1, XYChart.Data<String, Integer> o2) {
                Number xValue1 =(Number) o1.getYValue();
                Number xValue2 =(Number) o2.getYValue();
                return -new BigDecimal(xValue1.toString()).compareTo(new BigDecimal(xValue2.toString()));
            }
        });

        barChart.getData().add(series);
        this.setCenter(barChart);
    }
}
