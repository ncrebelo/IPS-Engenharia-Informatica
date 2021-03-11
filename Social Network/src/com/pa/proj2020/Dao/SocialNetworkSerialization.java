package com.pa.proj2020.Dao;

import com.pa.proj2020.model.SocialNetwork;

import java.io.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Class that handles serialization and deserialization by implementing Serializable where needed
 */
public class SocialNetworkSerialization implements SocialNetworkDao{

    private static final String STORAGE_DIR = ".\\src\\outputFiles\\";
    private static final String FILE_EXTENSION = ".socialnetwork";
    private final String fileName;


    public SocialNetworkSerialization() {
        this.fileName = "model";

    }

    /**
     * writes and saves a model into a file
     * @param model
     */
    @Override
    public void saveModel(SocialNetwork model) {
        FileOutputStream fileOut = null;
        try {
            fileOut = new FileOutputStream(STORAGE_DIR + this.fileName + FILE_EXTENSION);
            ObjectOutputStream out = new ObjectOutputStream(fileOut);
            out.writeObject(model);
        } catch (IOException ex) {
            Logger.getLogger(SocialNetworkDao.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                fileOut.close();
            } catch (IOException ex) {
                Logger.getLogger(SocialNetworkDao.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    /**
     * reads and loads a model from a file
     * @param modelName
     * @return a saved state of the model
     */
    @Override
    public SocialNetwork loadModel(String modelName) {
        FileInputStream fileIn = null;
        try {
            fileIn = new FileInputStream(STORAGE_DIR + fileName + FILE_EXTENSION);
            try (ObjectInputStream in = new ObjectInputStream(fileIn)) {
                SocialNetwork model = (SocialNetwork) in.readObject();

                return model;
            }
        } catch (ClassNotFoundException | IOException ex) {
            Logger.getLogger(SocialNetworkDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
}
