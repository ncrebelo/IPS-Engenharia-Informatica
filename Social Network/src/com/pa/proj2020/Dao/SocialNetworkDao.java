package com.pa.proj2020.Dao;

import com.pa.proj2020.model.SocialNetwork;

public interface SocialNetworkDao {

    void saveModel(SocialNetwork model);

    SocialNetwork loadModel(String modelName);
}
