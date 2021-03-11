package com.pa.proj2020.model;

import com.pa.proj2020.logger.Logger;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Class that represents a relation between users
 */
public class Relation implements Serializable {
    private RelationStrategy relationStrategy;
    private String info;
    private ArrayList<Interest> commonInterestsList;

    /**
     * Constructor for Class Interest
     *
     * @param info info about the relation
     */
    public Relation(String info){
        relationStrategy = new DirectRelationStrategy();
        commonInterestsList = new ArrayList<>();
        this.info = info;
    }

    /**
     * Constructor for Class Interest
     *
     * @param relationStrategy type of strategy of the relation
     * @param info info about the relation
     */
    public Relation(RelationStrategy relationStrategy, String info) {
        this.relationStrategy = relationStrategy;
        commonInterestsList = new ArrayList<>();
        this.info = info;
    }

    /**
     * returns the relation info
     *
     * @return info
     */
    public String getInfo() {
        return info;
    }

    /**
     * returns the relation type
     *
     * @return relation type
     */
    public String getRelationType(){
        return relationStrategy.toString();
    }

    /**
     * returns an ArrayList of the common interests of the relation
     *
     * @return commonInterestList
     */
    public ArrayList<Interest> getCommonInterestsList(){
        return commonInterestsList;
    }

    /**
     * returns the number of common interests
     *
     * @return number of common interests
     */
    public int getNumberOfInterests(){
        return commonInterestsList.size();
    }

    /**
     * returns a string with the common interests
     *
     * @return common interests in a String
     */
    public String getCommonInterests() {
        String interests = "";
        for (Interest i : commonInterestsList) {
            if (interests.length() > 0)
                interests += ", ";
            interests += i.getId() + ":" + i.getName();
        }
        if ("".equals(interests)) return "Não tem interesses partilhados";
        return interests;
    }

    /**
     * Adds a set of common interest in a relation
     *
     * @param interests a list with the common interests
     */
    public void addCommonInterests(List<Interest> interests){
        commonInterestsList.addAll(interests);
    }

    /**
     * sets the type of relation strategy
     *
     * @param relationStrategy
     */
    public void setRelationStrategy(RelationStrategy relationStrategy) {
        if (relationStrategy != null)
            this.relationStrategy = relationStrategy;
    }

    /**
     * checks if the relation has common interests
     *
     * @return true if has common interest, else returns false
     */
    public boolean hasCommonInterest(){
        return this.getCommonInterestsList().size() > 0;
    }

    /**
     * toString method
     *
     * @return string
     */
    @Override
    public String toString() {
        int size = commonInterestsList.size();
        return size > 0 ? size + "" : "";
    }
}
