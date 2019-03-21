package team.abc.ssm.common.utils.excel;


public class ExcelColumn {
    private String name; // excel列名
    private int colIndex; // excel中第几列

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getColIndex() {
        return colIndex;
    }

    public void setColIndex(int colIndex) {
        this.colIndex = colIndex;
    }
}
