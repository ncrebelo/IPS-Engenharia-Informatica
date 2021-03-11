package com.pa.proj2020.model;

import com.pa.proj2020.logger.Logger;

import java.io.Serializable;

/**
 *  Represents an interest, each user has a number of interests,
 *  and a relation can have common interests between users
 */
public class Interest implements Serializable {
    private int id;
    private String name;
    /**
     * Constructor for Class Interest
     *
     * @param id interest id
     * @param name interest name
     */
    public Interest(int id, String name){
        this.id = id;
        this.name = name;
    }

    /**
     * returns the interest id
     *
     * @return id
     */
    public int getId() {
        return id;
    }

    /**
     * returns the interest name
     *
     * @return name
     */
    public String getName() {
        return name;
    }
}
