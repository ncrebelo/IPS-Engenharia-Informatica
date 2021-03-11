package com.pa.proj2020.Dao;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSyntaxException;
import com.pa.proj2020.model.SocialNetwork;
import java.io.*;


/**
 * Class that handles serialization and deserialization in JSON format
 * @apiNote must apply Gson.jar to project module
 */
public class SocialNetworkJSON implements SocialNetworkDao {

    private static final String STORAGE_DIR = ".\\src\\outputFiles\\";
    private static final String FILE_EXTENSION = ".json";
    private final String fileName;
    SocialNetwork model;


    public SocialNetworkJSON() {
        this.fileName = "model";

    }

    /**
     * writes and saves a model into a json format file
     * @param model
     */
    @Override
    public void saveModel(SocialNetwork model) {
        Gson gson = new GsonBuilder().setPrettyPrinting().create();

        try (FileWriter writer = new FileWriter(STORAGE_DIR + this.fileName + FILE_EXTENSION)) {
            gson.toJson(model, writer);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * reads and loads a model from a json format file
     * @param modelName
     * @return a saved state of the model
     */
    @Override
    public SocialNetwork loadModel(String modelName) {
        Gson gson = new Gson();

        try (FileReader reader = new FileReader(STORAGE_DIR + this.fileName + FILE_EXTENSION)) {
            model = gson.fromJson(reader, SocialNetwork.class);
            return model;
        } catch (JsonSyntaxException | IOException e) {
            e.printStackTrace();
        }
        return null;
        }
    }

