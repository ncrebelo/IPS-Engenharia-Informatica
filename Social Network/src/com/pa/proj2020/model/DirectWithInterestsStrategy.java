package com.pa.proj2020.model;

import java.io.Serializable;

/**
 * Class that represents an Direct Relation with interests in common, a type of a Relation
 */
public class DirectWithInterestsStrategy implements RelationStrategy, Serializable {

    /**
     * toString method
     *
     * @return string
     */
    @Override
    public String toString(){
        return "Direct with interests Relation";
    }
}
