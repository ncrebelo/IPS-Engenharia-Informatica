package com.pa.proj2020.model;

import com.pa.proj2020.logger.Logger;
import com.pa.proj2020.utils.FileParser;

import java.io.IOException;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * Class that manages users' interest
 */
public class InterestManager implements Serializable {
    private HashMap<Integer, Interest> interestsMap;
    private HashMap<Integer, Integer[]> userInterests;

    /**
     * Constructor for class InterestManager
     * @param interestNames interest names file
     * @param interestsFile users' interests file
     * @param filePath path to files
     * @throws IOException file reading error
     */
    public InterestManager(String interestNames, String interestsFile, String filePath) throws IOException {
        interestsMap = new HashMap<>();
        userInterests = new HashMap<>();

        createInterests(FileParser.getLines(interestNames, filePath));
        populateInterests(FileParser.getLines(interestsFile, filePath));
    }

    /**
     * Create interest with id and names
     * @param lines lines from file
     */
    private void createInterests(List<String> lines) {
        for (String interest : lines) {
            String[] interestLine = interest.replaceAll("\\uFEFF", "").split(";");
            Interest i = new Interest(Integer.parseInt(interestLine[0]), interestLine[1]);

            interestsMap.put(Integer.parseInt(interestLine[0]), i);
        }
    }

    /**
     * Link each user id to a list of interests
     * @param lines lines from file
     */
    private void populateInterests(List<String> lines) {
        for (String line : lines) {
            String[] ids = line.replaceAll("\\uFEFF", "").split(";");
            Integer[] interests = new Integer[ids.length - 1];
            for (int i = 1; i < ids.length; i++) {
                interests[i - 1] = Integer.parseInt(ids[i]);
            }
            userInterests.put(Integer.parseInt(ids[0]), interests);
        }
    }

    /**
     * Adds interests to an user
     * @param user user
     */
    public void addInterests(User user) {
        if (user.getInterestList().isEmpty()) {
            Integer[] interestsToAdd = userInterests.get(user.getId());
            for (Integer i : interestsToAdd) {
                user.addInterest(interestsMap.get(i));
                Logger.getInstance().writeToLog(" | UserId: " + user.getId() + "| InterestId: " + i);
            }
        }
    }

    /**
     * @param user1 user 1
     * @param user2 user 2
     * @return list of common interests
     */
    public List<Interest> getCommonInterests(User user1, User user2) {
        if (user1 != null && user2 != null) {
            List<Interest> commonInterests = new ArrayList<>();
            for (Interest i1 : user1.getInterestList()) {
                for (Interest i2: user2.getInterestList()) {
                    if (i1.equals(i2) && !commonInterests.contains(i1))
                        commonInterests.add(i1);
                }
            }
            if (commonInterests.isEmpty())
                return null;
            else
                return commonInterests;
        }
        return null;
    }


}
