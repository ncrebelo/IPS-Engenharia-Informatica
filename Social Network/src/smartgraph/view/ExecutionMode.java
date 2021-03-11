package smartgraph.view;

import java.io.IOException;

public interface ExecutionMode {
    void callInteractiveMode() throws IOException;
    void callAutomaticMode() throws IOException;
}
