package com.pa.proj2020.adts.graph;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * ADT Digraph implementation that stores a collection of vertices
 * where each edge contains the references for the vertices it connects.
 *
 * @param <V> Type of element stored at a vertex
 * @param <E> Type of element stored at an edge
 */
public class DigraphAdjacencyList<V, E> implements Digraph<V, E>, Serializable {

    private Map<V, Vertex<V>> vertices;

    /**
     * Creates a empty graph.
     */
    public DigraphAdjacencyList(){
        this.vertices = new HashMap<>();
    }

    /**
     * Returns the total number of vertices of the graph.
     *
     * @return      total number of vertices
     */
    @Override
    public int numVertices() {
        return vertices.size();
    }

    /**
     * Returns the total number of edges of the graph.
     *
     * @return      total number of vertices
     */
    @Override
    public int numEdges() {
        Collection<Edge<E ,V>> list = edges();

        return list.size();
    }

    /**
     * Returns the vertices of the graph as a collection
     *
     * @return      collection of vertices
     */
    @Override
    public Collection<Vertex<V>> vertices() {
        List<Vertex<V>> list = new ArrayList<>();
        for (Vertex<V> v : vertices.values()) {
            list.add(v);
        }
        return list;
    }

    /**
     * Returns the edges of the graph as a collection.
     *
     * @return      collection of edges
     */
    @Override
    public Collection<Edge<E, V>> edges() {
        List<Edge<E ,V>> list = new ArrayList<>();
        for(Vertex<V> v: vertices.values()){
            MyVertex myVertex = checkVertex(v);
            List<Edge<E ,V>> newList =  myVertex.getEdges();
            for(Edge<E, V> e : newList){
                if(!list.contains(e)) {
                    list.add(e);
                }
            }
        }
        return list;
    }

    @Override
    public Collection<Edge<E, V>> incidentEdges(Vertex<V> inbound) throws InvalidVertexException{
        MyVertex vertex = checkVertex(inbound);

        List<Edge<E, V>> incidentEdges = new ArrayList<>();
        for(Edge<E, V> edge: vertex.getEdges()){
            Vertex<V>[] list=  edge.vertices();
            if(list[1] == vertex){
                incidentEdges.add(edge);
            }
        }
        return incidentEdges;
    }


    public Collection<Edge<E, V>> outboundEdges(Vertex<V> outbound) throws InvalidVertexException {
        MyVertex vertex = checkVertex(outbound);

        List<Edge<E, V>> outboundEdges = new ArrayList<>();
        for(Edge<E, V> edge : vertex.getEdges()){
            Vertex<V>[] list=  edge.vertices();
            if(list[0] == vertex){
                outboundEdges.add(edge);
            }
        }
        return outboundEdges;
    }

    /**
     * returns the opposite vertex of the vertex inserted
     *
     * @param v         vertex on one end of <code>e</code>
     * @param e         edge connected to <code>v</code>
     * @return          opposite vertex along <code>e</code>
     *
     * @exception InvalidVertexException    if the vertex is invalid for the graph
     * @exception InvalidEdgeException      if the edge is invalid for the graph
     */
    @Override
    public Vertex<V> opposite(Vertex<V> v, Edge<E, V> e) throws InvalidVertexException, InvalidEdgeException {
        checkVertex(v);
        MyEdge edge = checkEdge(e);

        if (!edge.contains(v)) {
            return null; /* this edge does not connect vertex v */
        }

        if (edge.vertices()[0] == v) {
            return edge.vertices()[1];
        } else {
            return edge.vertices()[0];
        }

    }


    @Override
    public synchronized boolean areAdjacent(Vertex<V> u, Vertex<V> v) throws InvalidVertexException {
        //we allow loops, so we do not check if u == v
        checkVertex(v);
        checkVertex(u);


        /* find and edge that contains both u and v */
        for (Edge<E, V> edge : edges()) {
            if (((MyEdge) edge).contains(u) && ((MyEdge) edge).contains(v)) {
                return true;
            }
        }
        return false;
    }


    /**
     * Inserts a new vertex with a given element, returning its reference.
     *
     * @param vElement      the element to store at the vertex
     *
     * @return              the reference of the newly created vertex
     *
     * @exception InvalidVertexException    if there already exists a vertex
     *                                      containing <code>vElement</code>
     *                                      according to the equality of
     *                                      {@link Object#equals(java.lang.Object) }
     *                                      method.
     */
    @Override
    public synchronized Vertex<V> insertVertex(V vElement) throws InvalidVertexException {
        if (existsVertexWith(vElement)) {
            throw new InvalidVertexException("There's already a vertex with this element.");
        }

        MyVertex newVertex = new MyVertex(vElement);

        vertices.put(vElement, newVertex);

        return newVertex;
    }

    @Override
    public synchronized Edge<E, V> insertEdge(Vertex<V> u, Vertex<V> v, E edgeElement)
            throws InvalidVertexException, InvalidEdgeException {

        if (existsEdgeWith(edgeElement)) {
            throw new InvalidEdgeException("There's already an edge with this element.");
        }

        MyVertex outVertex = checkVertex(u);
        MyVertex inVertex = checkVertex(v);

        MyEdge newEdge = new MyEdge(edgeElement, outVertex, inVertex);

        outVertex.addEdge(newEdge);
        inVertex.addEdge(newEdge);

        vertices.put(outVertex.element(), outVertex);
        vertices.put(inVertex.element(), inVertex);

        return newEdge;
    }

    @Override
    public synchronized Edge<E, V> insertEdge(V vElement1, V vElement2, E edgeElement)
            throws InvalidVertexException, InvalidEdgeException {

        if (existsEdgeWith(edgeElement)) {
            throw new InvalidEdgeException("There's already an edge with this element.");
        }

        if (!existsVertexWith(vElement1)) {
            throw new InvalidVertexException("No vertex contains " + vElement1);
        }
        if (!existsVertexWith(vElement2)) {
            throw new InvalidVertexException("No vertex contains " + vElement2);
        }

        MyVertex outVertex = vertexOf(vElement1);
        MyVertex inVertex = vertexOf(vElement2);

        MyEdge newEdge = new MyEdge(edgeElement, outVertex, inVertex);

        outVertex.addEdge(newEdge);
        inVertex.addEdge(newEdge);

        vertices.put(outVertex.element(), outVertex);
        vertices.put(inVertex.element(), inVertex);

        return newEdge;

    }

    /**
     * Removes a vertex, along with all of its incident edges, and returns the element
     * stored at the removed vertex.
     *
     * @param v     vertex to remove
     *
     * @return      element stored at the removed vertex
     *
     * @exception InvalidVertexException if <code>v</code> is an invalid vertex for the graph
     */
    @Override
    public synchronized V removeVertex(Vertex<V> v) throws InvalidVertexException {
        checkVertex(v);

        V element = v.element();

        //remove incident edges
        /*Iterable<Edge<E, V>> incidentEdges = incidentEdges(v);
        for (Edge<E, V> edge : incidentEdges) {
            edges.remove(edge.element());
        }*/

        vertices.remove(v.element());

        return element;
    }

    /**
     * Removes an edge and updates the vertices that were connected, return its element.
     *
     * @param e     edge to remove
     *
     * @return      element stored at the removed edge
     *
     * @exception InvalidEdgeException if <code>e</code> is an invalid edge for the graph.
     */
    @Override
    public synchronized E removeEdge(Edge<E, V> e) throws InvalidEdgeException {
        MyEdge myEdge = checkEdge(e);
        MyVertex inboundVertex = checkVertex(myEdge.vertexInbound);
        MyVertex outboundVertex = checkVertex(myEdge.vertexOutbound);

        inboundVertex.removeEdge(e);
        outboundVertex.removeEdge(e);

        vertices.replace(inboundVertex.element(), inboundVertex);
        vertices.replace(outboundVertex.element(), outboundVertex);

        E element = e.element();

        return element;
    }

    /**
     * Replaces the element of a given vertex with a new element and returns the
     * previous element stored at <code>v</code>.
     *
     * @param v             vertex to replace its element
     * @param newElement    new element to store in <code>v</code>
     *
     * @return              previous element previously stored in <code>v</code>
     *
     * @exception InvalidVertexException    if the vertex <code>v</code> is invalid for the graph, or;
     *                                      if there already exists another vertex containing
     *                                      the element <code>newElement</code>
     *                                      according to the equality of
     *                                      {@link Object#equals(java.lang.Object) }
     *                                      method.
     */
    @Override
    public V replace(Vertex<V> v, V newElement) throws InvalidVertexException {
        if (existsVertexWith(newElement)) {
            throw new InvalidVertexException("There's already a vertex with this element.");
        }

        MyVertex vertex = checkVertex(v);

        V oldElement = vertex.element;
        vertex.element = newElement;

        return oldElement;
    }

    /**
     * Replaces the element of a given edge with a new element and returns the
     * previous element stored at <code>e</code>.
     *
     * @param e             edge to replace its element
     * @param newElement    new element to store in <code>e</code>
     *
     * @return              previous element previously stored in <code>e</code>
     *
     * @exception InvalidVertexException    if the edge <code>e</code> is invalid for the graph, or;
     *                                      if there already exists another edge containing
     *                                      the element <code>newElement</code>
     *                                      according to the equality of
     *                                      {@link Object#equals(java.lang.Object)}
     *                                      method.
     */
    @Override
    public E replace(Edge<E, V> e, E newElement) throws InvalidEdgeException {
        if (existsEdgeWith(newElement)) {
            throw new InvalidEdgeException("There's already an edge with this element.");
        }

        MyEdge edge = checkEdge(e);

        E oldElement = edge.element;
        edge.element = newElement;

        return oldElement;
    }

    /**
     * returns the vertex with the element inserted
     *
     * @param element            element
     *
     * @return             vertex
     *
     */
    public Vertex<V> getVertex(V element){
        if(this.existsVertexWith(element)){
            return vertices.get(element);
        }

        return null;
    }

    private MyVertex vertexOf(V vElement) {
        for (Vertex<V> v : vertices.values()) {
            if (v.element().equals(vElement)) {
                return (MyVertex) v;
            }
        }
        return null;

    }

    /**
     * checks if exists a vertex with the given element
     *
     * @param vElement            element
     *
     * @return  true if exists, false otherwise.
     *
     */
    private boolean existsVertexWith(V vElement) {
        return vertices.containsKey(vElement);
    }

    /**
     * checks if exists a edge with the given element
     *
     * @param eElement            element
     *
     * @return  true if exists, false otherwise.
     *
     */
    private boolean existsEdgeWith(E eElement) {
        /*for(Vertex<V> vertex: vertices.values()){
            MyVertex myVertex = checkVertex(vertex);
            for(Edge<E, V> e : myVertex.getEdges()){
                return e.element() == edgeElement;
            }
        }*/
        for (Edge<E, V> edge : edges()) {
            return edge.element() == eElement;
        }

        return false;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder(
                String.format("Graph with %d vertices and %d edges:\n", numVertices(), numEdges())
        );

        sb.append("--- Vertices: \n");
        for (Vertex<V> v : vertices.values()) {
            sb.append("\t").append(v.toString()).append("\n");
        }
        sb.append("\n--- Edges: \n");
        Collection<Edge<E, V>> list = edges();
        for (Edge<E, V> e : list) {
            sb.append("\t").append(e.toString()).append("\n");
        }
        return sb.toString();
    }

    class MyVertex implements Vertex<V>, Serializable {

        ArrayList<Edge<E, V>> edgeList;
        V element;

        public MyVertex(V element) {
            this.element = element;
            edgeList = new ArrayList<>();
        }

        @Override
        public V element() {
            return this.element;
        }

        @Override
        public String toString() {
            return "Vertex{" + element + '}';
        }

        public ArrayList<Edge<E, V>> getEdges(){
            return edgeList;
        }

        public void removeEdge(Edge<E, V> e){
            edgeList.remove(e);
        }

        public void addEdge(Edge<E, V> e){
            edgeList.add(e);
        }
    }

    class MyEdge implements Edge<E, V>, Serializable {

        E element;
        Vertex<V> vertexOutbound;
        Vertex<V> vertexInbound;

        public MyEdge(E element, Vertex<V> vertexOutbound, Vertex<V> vertexInbound) {
            this.element = element;
            this.vertexOutbound = vertexOutbound;
            this.vertexInbound = vertexInbound;
        }

        @Override
        public E element() {
            return this.element;
        }

        public boolean contains(Vertex<V> v) {
            return (vertexOutbound == v || vertexInbound == v);
        }

        @Override
        public Vertex<V>[] vertices() {
            Vertex[] vertices = new Vertex[2];
            vertices[0] = vertexOutbound;
            vertices[1] = vertexInbound;

            return vertices;
        }

        @Override
        public String toString() {
            return "Edge{{" + element + "}, vertexOutbound=" + vertexOutbound.toString()
                    + ", vertexInbound=" + vertexInbound.toString() + '}';
        }
    }

    /**
     * Checks whether a given vertex is valid and belongs to this graph
     *
     * @param v
     * @return
     * @throws InvalidVertexException
     */
    private MyVertex checkVertex(Vertex<V> v) throws InvalidVertexException {
        if(v == null) throw new InvalidVertexException("Null vertex.");

        MyVertex vertex;
        try {
            vertex = (MyVertex) v;
        } catch (ClassCastException e) {
            throw new InvalidVertexException("Not a vertex.");
        }

        if (!vertices.containsKey(vertex.element)) {
            throw new InvalidVertexException("Vertex does not belong to this graph.");
        }

        return vertex;
    }

    /**
     * Checks whether a given edge is valid and belongs to this graph
     *
     * @param e
     * @return
     * @throws InvalidVertexException
     */
    private MyEdge checkEdge(Edge<E, V> e) throws InvalidEdgeException {
        if(e == null) throw new InvalidEdgeException("Null edge.");

        MyEdge edge;
        try {
            edge = (MyEdge) e;
        } catch (ClassCastException ex) {
            throw new InvalidVertexException("Not an adge.");
        }

        if (!edges().contains(edge)) {
            throw new InvalidEdgeException("Edge does not belong to this graph.");
        }

        return edge;
    }
}
