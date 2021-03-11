package com.pa.proj2020.model;

import java.io.Serializable;

/**
 * Class that represents a Direct Relation, a type of a Relation
 */
public class DirectRelationStrategy implements RelationStrategy, Serializable {

    /**
     * toString method
     *
     * @return string
     */
    @Override
    public String toString(){
        return "Direct Relation";
    }
}
