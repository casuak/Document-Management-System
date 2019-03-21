package team.abc.ssm.common.utils.excel;

public class TableColumn {

    private String name;
    private String comment;
    private String type;
    private Integer excelColumnIndex; // excel表格中对应列

    private boolean isFK; // 是否是外键
    private String fkTable; // 外键指向的表
    private String fkFiled; // 外键指向的表的字段

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Integer getExcelColumnIndex() {
        return excelColumnIndex;
    }

    public void setExcelColumnIndex(int excelColumnIndex) {
        this.excelColumnIndex = excelColumnIndex;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public boolean isFK() {
        return isFK;
    }

    public void setFK(boolean FK) {
        isFK = FK;
    }

    public String getFkTable() {
        return fkTable;
    }

    public void setFkTable(String fkTable) {
        this.fkTable = fkTable;
    }

    public String getFkFiled() {
        return fkFiled;
    }

    public void setFkFiled(String fkFiled) {
        this.fkFiled = fkFiled;
    }
}
