package com.pa.proj2020.model;

import com.pa.proj2020.Memento.Memento;
import com.pa.proj2020.Memento.Originator;
import com.pa.proj2020.Memento.SocialNetworkMemento;
import com.pa.proj2020.adts.graph.*;
import com.pa.proj2020.logger.Logger;
import com.pa.proj2020.utils.FileParser;
import smartgraph.view.graphview.SmartGraphPanel;
import smartgraph.view.graphview.SmartStylableNode;


import java.io.IOException;
import java.io.Serializable;
import java.util.*;

/**
 * Class that handles the building of the social network model
 */
public class SocialNetwork implements Originator, Serializable {
    private static final String FILES_PATH = "inputFiles/";
    private static final String FILE_INTEREST_NAMES = "interest_names.csv";
    private static final String FILE_INTERESTS = "interests.csv";
    private static final String FILE_USERNAMES = "user_names.csv";
    private static final String FILE_RELATIONS = "relationships.csv";

    private DigraphAdjacencyList<User, Relation> digraphAdjacencyList;
    private DigraphAdjacencyList<User, Relation> interactiveDigraphAdjacencyList;
    private InterestManager interestManager;

    /**
     * Constructor for class SocialNetwork
     *
     * @throws IOException file exception
    */
    public SocialNetwork() throws IOException {
        this.digraphAdjacencyList = new DigraphAdjacencyList();
        this.interactiveDigraphAdjacencyList = new DigraphAdjacencyList();
        this.interestManager = new InterestManager(FILE_INTEREST_NAMES, FILE_INTERESTS, FILES_PATH);

        List<String> usersIds = this.readFile(FILE_RELATIONS);

        populateDigraph(usersIds);
    }

    public DigraphAdjacencyList<User, Relation> getDigraphAdjacencyList() {
        return digraphAdjacencyList;
    }

    /**
     * Reads the file and stores the data into a List
     * @return a list of userIds
     * @throws IOException In case the file doesn't exist
     */
    public List<String> readFile(String fileName) throws IOException {
        return FileParser.getLines(fileName, FILES_PATH);
    }

    public Digraph<User, Relation> getGraph(){
        return this.digraphAdjacencyList;
    }

    public void restoreInteractiveGraph(DigraphAdjacencyList<User, Relation> graph, SmartGraphPanel<User, Relation> graphView){
        for (Vertex<User>vertex: graph.vertices()){
            String userType = vertex.element().getUserType();

            if(userType.equals("Utilizador Adicionado")) {
                this.addElement(graphView, vertex.element().getId());
            }
        }
    }

    /**
     * Populates de Digraph with data regarding UserIds and each of its relations
     * @param usersIds List of UserIds
     */
    public void populateDigraph(List<String> usersIds) {
        //Vertex and Relations
        for (String userIds: usersIds) {
            String[] ids = userIds.replaceAll("\\uFEFF", "").split(";");

            //checks if user already exits
            int rootUserId = Integer.parseInt(ids[0]);
            Vertex<User> rootVertex = this.getDigraphVertex(rootUserId);

            if(rootVertex == null) {
                rootVertex = this.insertVertex(rootUserId, new UserAdded());
            } else {
                rootVertex.element().setUserType(new UserAdded());
            }

            //Adicionar utilizadores relacionados se ainda não existirem
            for (String id: ids){
                int relationUserId = Integer.parseInt(id);

                if(rootUserId == relationUserId) continue;

                //checks if user already exits
                Vertex<User> relationVertex = this.getDigraphVertex(relationUserId);
                if(relationVertex == null) {
                    relationVertex = insertVertex(relationUserId, new UserIncluded());
                }

                Relation rel = this.getRelation(rootUserId, relationUserId, rootVertex, relationVertex);

                Logger.getInstance().writeToLog(" | Added User: " + rootUserId
                        + "| Existing User: " + relationUserId
                        + "| Number of Shared Interests: " + rel.getNumberOfInterests());

                digraphAdjacencyList.insertEdge(rootVertex, relationVertex, rel);

                //logger info
                rootVertex.element().addToNumberOfRelations();
            }
        }
    }

    public static String getUserNameById(int userId) {
        try {
            List<String> lines = FileParser.getLines(FILE_USERNAMES, FILES_PATH);
            for (String line : lines) {
                String[] names = line.replaceAll("\\uFEFF", "").split(";");
                if (Integer.parseInt(names[0]) == userId) return names[1];
            }
            return null;
        } catch (IOException e) {
            return null;
        }
    }


    private Relation getRelation(Integer rootUserId, Integer relationUserId, Vertex<User> rootVertex, Vertex<User> relationVertex){
        Relation rel = new Relation("relation: " + rootUserId + "->" + relationUserId);

        //Relações diretas com partilha de interesse
        List<Interest> rootRelationInterests = interestManager.getCommonInterests(rootVertex.element(), relationVertex.element());

        if (rootRelationInterests != null && rootRelationInterests.size() > 0) {
            rel.addCommonInterests(rootRelationInterests);
            rel.setRelationStrategy(new DirectWithInterestsStrategy());
        }

        return rel;
    }

    private Vertex<User> insertVertex(Integer rootUserId, UserStrategy userType){
        User u = new User(rootUserId, getUserNameById(rootUserId));
        u.setUserType(userType);

        interestManager.addInterests(u);

        Logger.getInstance().writeToLog(" | UserId: " + u.getId() + " | N. of Relations: " +
                u.getNumberOfRelations() + " | Interests: " + u.getNumberOfInterests());

        return digraphAdjacencyList.insertVertex(u);
    }

    /**
     * @param id id of User
     * @return returns a specific vertex
     */
    public Vertex<User> getDigraphVertex(int id){
        for (Vertex<User> user: digraphAdjacencyList.vertices()) {
            int userId = user.element().getId();

            if(userId == id){
                return user;
            }
        }

        return null;
    }

    public Vertex<User> getInteractiveDigraphVertex(int id){
        for (Vertex<User> user: interactiveDigraphAdjacencyList.vertices()) {
            int userId = user.element().getId();

            if(userId == id){
                return user;
            }
        }

        return null;
    }

    public ArrayList<Vertex<User>> getIndirectRelationships(int userId) {
        //Relações indiretas só se aplicam a utilizadores adicionados
        Vertex<User> user1 = getInteractiveDigraphVertex(userId);

        ArrayList<Vertex<User>> sharedInterests = new ArrayList<>();

        for (Vertex<User> user2 : interactiveDigraphAdjacencyList.vertices()) {
            if (user1 == user2 || interactiveDigraphAdjacencyList.areAdjacent(user1, user2)) continue;
            for (Interest i : user1.element().getInterestList()) {
                Relation checkRelationDirect = this.getRelationEdge(userId, user2.element().getId());
                if (user2.element().hasInterest(i) && checkRelationDirect == null) {
                    sharedInterests.add(user2);
                    break;
                }


            }
        }
        if (sharedInterests.isEmpty()) return null;

        return sharedInterests;
    }

    /**
     * @param id id of User
     * @return returns a specific user
     */
    public User getDigraphUser(int id){
        for (Vertex<User> user: digraphAdjacencyList.vertices()) {
            int userId = user.element().getId();

            if(userId == id){
                return user.element();
            }
        }

        return null;
    }

    /**
     * @param userId id of User
     * @return returns a list of User
     */
    public List<User> getUserRelations(int userId){
        Vertex<User> user = null;
        for (Vertex<User> u: digraphAdjacencyList.vertices()){
           if(u.element().getId() == userId){
               user = u;
               break;
           }
        }

        List<User> relations = new ArrayList<>();
        for (Edge<Relation, User> edge: digraphAdjacencyList.outboundEdges(user)){
            relations.add(digraphAdjacencyList.opposite(user, edge).element());
        }

        return relations;
    }
    /**
     * @param rootUserId, relationUserId
     * @return returns a list of User
     */
    public Relation getRelationEdge(int rootUserId, int relationUserId){
        Vertex<User> user = null;
        for (Vertex<User> u: digraphAdjacencyList.vertices()){
            if(u.element().getId() == rootUserId){
                user = u;
                break;
            }
        }
        for (Edge<Relation, User> edge: digraphAdjacencyList.outboundEdges(user)){
            if(digraphAdjacencyList.opposite(user, edge).element().getId() == relationUserId){
                return edge.element();
            }
        }

        return null;
    }

    /**
     * Mainly for testing purposes.
     * @return the vertices
     */
    public Collection<Vertex<User>> getVertices() {
        return digraphAdjacencyList.vertices();
    }

    /**
     * Mainly for testing purposes.
     * @return the edges
     */
    public Collection<Edge<Relation, User>> getEdges() {
        return digraphAdjacencyList.edges();
    }

    public DigraphAdjacencyList<User, Relation> getInteractiveDigraphAdjacencyList(){
        return interactiveDigraphAdjacencyList;
    }

    public void addElement(SmartGraphPanel<User, Relation> graphView, int userId) {
        Runnable r;
        r = () -> {
            Vertex<User> rootUser = checkUserExists(this.interactiveDigraphAdjacencyList, userId);

            if(rootUser != null && rootUser.element().getUserType().equals("Utilizador Adicionado")){
                return;
            }

            if(rootUser != null) {
                this.interactiveDigraphAdjacencyList.removeVertex(rootUser);
            }

            User user = this.getDigraphUser(userId);
            if(user == null){
                return;
            }

            user.setUserType(new UserAdded());

            rootUser = this.interactiveDigraphAdjacencyList.insertVertex(user);

            List<User> relations = this.getUserRelations(userId);

            for (User relationUser: relations){
                Vertex<User> relationVertex = checkUserExists(this.interactiveDigraphAdjacencyList, relationUser.getId());

                if(relationVertex == null){
                    relationUser.setUserType(new UserIncluded());
                    relationVertex = this.interactiveDigraphAdjacencyList.insertVertex(relationUser);
                }

                Relation relation = this.getRelationEdge(userId, relationUser.getId());
                this.interactiveDigraphAdjacencyList.insertEdge(rootUser, relationVertex, relation);

                graphView.updateAndWait();

                this.updateGraphViewNewVerticesStyle(graphView, relationVertex, relationUser, relation);
            }

            this.updateGraphViewAddedVertexStyle(graphView, rootUser);
        };

        new Thread(r).start();
    }

    private void updateGraphViewAddedVertexStyle(SmartGraphPanel<User, Relation> graphView, Vertex<User> rootUser){
        SmartStylableNode stylableVertex = graphView.getStylableVertex(rootUser);
        if(stylableVertex != null) {
            stylableVertex.setStyle("-fx-fill: #5DADE2; -fx-stroke:  #1B4F72;");//blue
        }
    }

    private void updateGraphViewNewVerticesStyle(SmartGraphPanel<User, Relation> graphView, Vertex<User> relationVertex, User relationUser, Relation relation){
        //color new vertices
        SmartStylableNode stylableVertex = graphView.getStylableVertex(relationVertex);

        if(stylableVertex != null && !relationUser.getUserType().equals("Utilizador Adicionado")) {
            stylableVertex.setStyle("-fx-fill: #52BE80; -fx-stroke: #145A32;");//green
        }

        SmartStylableNode stylableEdge = graphView.getStylableEdge(relation);
        if(stylableEdge != null && relation.hasCommonInterest()){
            stylableEdge.addStyleClass("commonInterests");
        }
        if(stylableEdge != null && relation.getRelationType().equals("Indirect Relation")){
            stylableEdge.removeStyleClass("arrow");
            stylableEdge.addStyleClass("indirectRelation");
        }
    }

    public void addIndirectRelationships(SmartGraphPanel<User, Relation> graphView, int userId) {
        Runnable r;
        r = () -> {
            Vertex<User> rootUser = checkUserExists(this.interactiveDigraphAdjacencyList, userId);

            if(rootUser == null || !rootUser.element().getUserType().equals("Utilizador Adicionado")){
                return;
            }

            //Obter utilizadores sem relação com partilha de interesse
            List<Vertex<User>> indirectUsers = getIndirectRelationships(userId);
            if (indirectUsers == null) {
                return;
            }

            for (Vertex<User> relationVertex : indirectUsers) {
                Relation relation = this.createIndirectRelation(userId, relationVertex, rootUser);

                this.interactiveDigraphAdjacencyList.insertEdge(rootUser, relationVertex, relation);

                graphView.updateAndWait();

                this.updateGraphViewIndirectRelationStyle(graphView, relation);
            }
        };

        new Thread(r).start();
    }

    private void updateGraphViewIndirectRelationStyle(SmartGraphPanel<User, Relation> graphView, Relation relation){
        SmartStylableNode stylableEdge = graphView.getStylableEdge(relation);
        if (stylableEdge != null) {
            stylableEdge.setStyleClass("indirectRelation");
        }
    }

    private Relation createIndirectRelation(Integer userId, Vertex<User> relationVertex, Vertex<User> rootUser){
        Relation relation = new Relation(new IndirectRelationStrategy(),
                "relation: " + userId + "-" + relationVertex.element().getId());
        relation.addCommonInterests(interestManager.getCommonInterests(rootUser.element(), relationVertex.element()));

        Logger.getInstance().writeToLog(" | Added User: " + userId
                + "| Existing User: " + relationVertex.element().getId()
                + "| Interests: " + relation.getCommonInterests());

        return relation;
    }


    private Vertex<User> checkUserExists(Graph<User, Relation> graph, int userId){
        for(Vertex<User> user: graph.vertices()){
            if(user.element().getId() == userId){
                return user;
            }
        }

        return null;
    }

    @Override
    public Memento createMemento() {
        return new SocialNetworkMemento(this);
    }

    @Override
    public void setMemento(Memento savedState) {
        List<User> users = new ArrayList<>();

        for(Vertex<User> v : savedState.getState().vertices()){
            users.add(v.element());
        }
        for(Vertex<User> v : getGraph().vertices()){
            if(!users.contains(v.element())){
                getGraph().removeVertex(v);
            }
        }
    }
}
