package team.abc.ssm.common.utils.excel;

public class TableColumn {

    private String name;
    private String comment;
    private String type;
    private Integer excelColumnIndex; // excel表格中对应列

    private boolean fk; // 是否是外键
    private String fkTable; // 外键指向的表
    private String fkOriginalField; // 原字段
    private String fkReplaceField; // 替换字段

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

    public String getFkTable() {
        return fkTable;
    }

    public void setFkTable(String fkTable) {
        this.fkTable = fkTable;
    }

    public boolean isFk() {
        return fk;
    }

    public void setFk(boolean fk) {
        this.fk = fk;
    }

    public String getFkOriginalField() {
        return fkOriginalField;
    }

    public void setFkOriginalField(String fkOriginalField) {
        this.fkOriginalField = fkOriginalField;
    }

    public String getFkReplaceField() {
        return fkReplaceField;
    }

    public void setFkReplaceField(String fkReplaceField) {
        this.fkReplaceField = fkReplaceField;
    }
}
