package com.pa.proj2020.model;

import com.pa.proj2020.utils.FileParser;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.io.IOException;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

class SocialNetworkTest {

    private int users = 50;
    private int relations = 360; //365 - 5, em que os 5 são relações inválidos (a sí próprios)

    private SocialNetwork socialNetwork;

    @BeforeEach
    void setUp() {
        try {
            socialNetwork = new SocialNetwork();
        } catch (IOException e) {
            System.out.println("Wrong file");
        }
    }

    @Test
    void invalidReadFile() {
        assertThrows(NullPointerException.class, () ->
                FileParser.getLines("ficheiro_inexistente", "inputFiles/")
        );
    }

    @Test
    void numVertices() {
        assertEquals(users, socialNetwork.getVertices().size());
    }

    @Test
    void numEdges() {
        assertEquals(relations, socialNetwork.getEdges().size());
    }

}