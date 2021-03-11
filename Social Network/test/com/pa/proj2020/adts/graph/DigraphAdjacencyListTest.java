package com.pa.proj2020.adts.graph;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.Collection;

import static org.junit.jupiter.api.Assertions.*;

class DigraphAdjacencyListTest {
    private Graph<String, String> digraphAdjacencyList;

    private int elements;
    private int relationships;
    private Vertex<String> vertexA;
    private Vertex<String> vertexB;
    private Vertex<String> vertexF;
    private Edge<String, String> edge;


    @BeforeEach
    void setUp() {
        digraphAdjacencyList = new DigraphAdjacencyList<>();

        vertexA = digraphAdjacencyList.insertVertex("A");
        vertexB = digraphAdjacencyList.insertVertex("B");
        digraphAdjacencyList.insertVertex("C");
        digraphAdjacencyList.insertVertex("D");
        digraphAdjacencyList.insertVertex("E");
        vertexF = digraphAdjacencyList.insertVertex("F");
        elements = 6;

        edge = digraphAdjacencyList.insertEdge("A", "B", "AB");
        digraphAdjacencyList.insertEdge("B", "A", "BA");
        digraphAdjacencyList.insertEdge("A", "C", "AC");
        digraphAdjacencyList.insertEdge("A", "D", "AD");
        digraphAdjacencyList.insertEdge("B", "C", "BC");
        digraphAdjacencyList.insertEdge("C", "D", "CD");
        digraphAdjacencyList.insertEdge("B", "E", "BE");
        digraphAdjacencyList.insertEdge("F", "D", "DF");
        digraphAdjacencyList.insertEdge("F", "D", "DF2");
        relationships = 9;
    }

    @Test
    void vertices() {
        Collection<Vertex<String>> vertices = digraphAdjacencyList.vertices();

        assertEquals(elements, vertices.size());
        assertTrue(vertices.contains(vertexA));
        assertTrue(vertices.contains(vertexB));
    }

    @Test
    void edges() {
        Collection<Edge<String, String>> edges = digraphAdjacencyList.edges();

        assertEquals(relationships, edges.size());
        assertTrue(edges.contains(edge));
    }

    @Test
    void numVertices() {
        assertEquals(elements, digraphAdjacencyList.numVertices());
    }

    @Test
    void numEdges() {
        assertEquals(relationships, digraphAdjacencyList.numEdges());
    }

    @Test
    void invalidOpposite() {
        assertNull(digraphAdjacencyList.opposite(vertexF, edge));
    }

    @Test
    void opposite() {
        assertEquals(vertexB, digraphAdjacencyList.opposite(vertexA, edge));
    }

    @Test
    void areAdjacent() {
        assertTrue(digraphAdjacencyList.areAdjacent(vertexA, vertexB));

        assertFalse(digraphAdjacencyList.areAdjacent(vertexA, vertexF));
    }

    @Test
    void invalidInsertVertex() {
        assertThrows(InvalidVertexException.class, () ->
                digraphAdjacencyList.insertVertex("F"));
        numVertices();
    }

    @Test
    void insertVertex() {
        digraphAdjacencyList.insertVertex("G");
        elements++;
        numVertices();
    }

    @Test
    void invalidInsertEdge() {
        assertThrows(InvalidEdgeException.class, () ->
                digraphAdjacencyList.insertEdge("A", "B", "AB")
        );

        numEdges();
    }

    @Test
    void insertEdge() {
        digraphAdjacencyList.insertEdge("A", "F", "AF");
        relationships++;
        numEdges();
    }

    @Test
    void invalidRemoveVertex() {
        removeVertex();

        assertThrows(InvalidVertexException.class, () ->
                digraphAdjacencyList.removeVertex(vertexA)
        );
    }

    @Test
    void removeVertex() {
        digraphAdjacencyList.removeVertex(vertexA);
        elements--;

        numVertices();
    }

    @Test
    void invalidRemoveEdge() {
        removeEdge();

        assertThrows(InvalidEdgeException.class, () ->
                digraphAdjacencyList.removeEdge(edge)
        );
    }

    @Test
    void removeEdge() {
        digraphAdjacencyList.removeEdge(edge);
        relationships--;

        numEdges();
    }

    @Test
    void invalidReplace() {
        assertThrows(InvalidVertexException.class, () ->
            digraphAdjacencyList.replace(vertexA, "A")
        );

    }

    @Test
    void replace() {
        digraphAdjacencyList.replace(vertexA, "G");

        assertEquals("G", vertexA.element());
    }
}