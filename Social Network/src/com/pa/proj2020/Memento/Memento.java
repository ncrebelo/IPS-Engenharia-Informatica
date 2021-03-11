package com.pa.proj2020.Memento;

import com.pa.proj2020.adts.graph.Digraph;
import com.pa.proj2020.model.Relation;
import com.pa.proj2020.model.User;

public interface Memento {
    Digraph<User, Relation> getState();
}
