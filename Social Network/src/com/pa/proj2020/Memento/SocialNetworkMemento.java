package com.pa.proj2020.Memento;

import com.pa.proj2020.adts.graph.Digraph;
import com.pa.proj2020.adts.graph.DigraphAdjacencyList;
import com.pa.proj2020.adts.graph.Edge;
import com.pa.proj2020.adts.graph.Vertex;
import com.pa.proj2020.model.Relation;
import com.pa.proj2020.model.SocialNetwork;
import com.pa.proj2020.model.User;


public class SocialNetworkMemento implements Memento{
    public DigraphAdjacencyList<User, Relation> mementoModel;

    public SocialNetworkMemento(SocialNetwork socialNetwork){
        this.mementoModel = new DigraphAdjacencyList<>();

        for(Vertex<User> v : socialNetwork.getVertices()){
            this.mementoModel.insertVertex(v.element());
        }
        for(Edge<Relation, User> e: socialNetwork.getEdges()){
            this.mementoModel.insertEdge(e.vertices()[0], e.vertices()[1], e.element());
        }
    }

    @Override
    public Digraph<User, Relation> getState() {
        return mementoModel;
    }

}
