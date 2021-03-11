package com.pa.proj2020.model;

import java.util.*;

/**
 *  class that manages the statistics info
 */
public class Statistics {

    private List<User> usersList;
    private List<Relation> relationList;

    /**
     * Constructor for Class Statistics
     *
     * @param usersList
     */
    public Statistics(List<User> usersList){
        this.usersList= usersList;
    }

    public Statistics(ArrayList<Relation> relationList){
        this.relationList = relationList;
    }

    /**
     * Calculates the top 5 users with the most relations
     *
     * @return A HashMap with the top 5 users
     */
    public HashMap<String, Integer> top5UsersWithMoreRelations(){
        ArrayList<Integer> users = new ArrayList<>();
        for(User user : usersList){
            users.add(user.getNumberOfRelations());
        }

        HashMap<String, Integer> top5 = new HashMap<>();

        Collections.sort(users, Collections.reverseOrder());
        Integer count = 0;

        for(Integer i = 0; i < users.size(); i++){
            if(count < 5) {
                for (User u : usersList) {
                    if (u.getNumberOfRelations() == users.get(i)) {
                        if (top5.containsKey(u.getName())) {
                            continue;
                        } else {
                            top5.put(u.getName(), u.getNumberOfRelations());
                            count++;
                        }
                    }
                }
            }
        }

        return top5;
    }
}
