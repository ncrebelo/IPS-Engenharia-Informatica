package com.pa.proj2020.model;

import com.pa.proj2020.logger.Logger;
import java.io.Serializable;
import java.util.ArrayList;

/**
 * This class represents a user
 */
public class User implements Serializable {
    private int id;
    private String name;
    private Integer numberOfRelations;
    private UserStrategy userType;
    private ArrayList<Interest> interestList;

    /**
     * Constructor of the class user
     *
     * @param id
     * @param name
     */
    public User(int id, String name) {
        this.id = id;
        this.name = name;
        this.numberOfRelations = 0;
        interestList = new ArrayList<>();
        userType = new UserIncluded();
    }

    public void addToNumberOfRelations(){
        numberOfRelations++;
    }

    public int getNumberOfRelations(){
        return numberOfRelations;
    }

    public boolean hasInterest(Interest interest) {
        for (Interest i : interestList)
            if (interest.getId() == i.getId()) return true;

        return false;
    }

    public User(int id) {
        this.id = id;
        this.name = "" + id;
        interestList = new ArrayList<>();
    }

    //Com base na regra 6 da secção "Construção do modelo" é possível mudar um utilizador de Incluído para Adicionado
    public void setUserType(UserStrategy userType) {
        this.userType = userType;
    }

    //deve devolver UserConcrete ou UserAutomatic
    public String getUserType() {
        return userType.toString();
    }

    public ArrayList<Interest> getInterestList(){
        return interestList;
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        if (name != null && !name.isEmpty())
            this.name = name;
    }

    public int getNumberOfInterests(){
        return interestList.size();
    }

    public void addInterest(Interest interest){
        interestList.add(interest);
    }

    public String getInterests() {
        String interests = "";
        for (Interest i : interestList) {
            if (interests.length() > 0)
                interests += ", ";
            interests += i.getName() + ":" + i.getId();
        }
        return interests;
    }

    @Override
    public String toString() {
        return name;
    }
}
