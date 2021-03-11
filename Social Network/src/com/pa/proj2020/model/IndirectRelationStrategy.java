package com.pa.proj2020.model;

import java.io.Serializable;

/**
 * Class that represents an Indirect Relation, a type of a Relation
 */
public class IndirectRelationStrategy implements RelationStrategy, Serializable {

    /**
     * toString method
     *
     * @return string
     */
    @Override
    public String toString(){
        return "Indirect Relation";
    }
}
