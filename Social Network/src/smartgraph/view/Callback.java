package smartgraph.view;

import com.pa.proj2020.model.SocialNetwork;

public interface Callback {
    void callOnAddUser(String value);
    void callOnUndoUser();
    void callOnAddIndirectRelationships(String value);
    void callOnRestoreSerialization(SocialNetwork value);


}
