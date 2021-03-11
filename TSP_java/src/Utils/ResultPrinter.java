package Utils;

import java.util.ArrayList;

public class ResultPrinter {

    private int rowCount;

    private final ArrayList<Column> columns;

    public ResultPrinter() {
        rowCount = 0;
        columns = new ArrayList<>();
    }

    public void addColumn(String name) {
        columns.add(new Column(name));
    }

    public void addEntry(int column, String entry) {
        int r = columns.get(column).addData(entry);
        if (r > rowCount)
            rowCount = r;
    }

    public String render() {
        StringBuilder sb = new StringBuilder();

        // First separator
        sb.append("+");
        for (int i = 0; i < columns.size(); ++i) {
            for (int x = 0; x < columns.get(i).maxWidth + 1; ++x)
                sb.append('-');
            sb.append("-+");
        }
        sb.append("\n");

        // Header
        sb.append("| ");
        for (Column c : columns) {
            int wleft = c.maxWidth - c.header.length();
            sb.append(c.header);
            while (wleft-- > 0)
                sb.append(' ');
            sb.append(" | ");
        }
        sb.append("\n");


        // Second separator
        sb.append("+");
        for (int i = 0; i < columns.size(); ++i) {
            for (int x = 0; x < columns.get(i).maxWidth + 1; ++x)
                sb.append('-');
            sb.append("-+");
        }
        sb.append("\n");


        // Data
        for (int r = 0; r < rowCount; ++r) {
            sb.append("| ");
            for (Column c : columns) {
                if (r < c.entries.size()) {
                    int wleft = c.maxWidth - c.entries.get(r).length();
                    sb.append(c.entries.get(r));
                    while (wleft-- > 0)
                        sb.append(' ');
                } else {
                    for (int w = 0; w < c.maxWidth; ++w)
                        sb.append(' ');
                }
                sb.append(" | ");
            }
            sb.append("\n");
        }


        // Bottom
        sb.append("+");
        for (int i = 0; i < columns.size(); ++i) {
            for (int x = 0; x < columns.get(i).maxWidth + 1; ++x)
                sb.append('-');
            sb.append("-+");
        }
        sb.append("\n");

        return sb.toString();
    }

    static private class Column {
        public String header;
        public ArrayList<String> entries;
        public int maxWidth;

        public Column(String header) {
            entries = new ArrayList<>();
            maxWidth = header.length();
            this.header = header;
        }

        public int addData(String data) {
            entries.add(data);
            if (data.length() > maxWidth)
                maxWidth = data.length();
            return entries.size();
        }
    }
}
