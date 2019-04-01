package team.abc.ssm.modules.tool.entity.normal;


/**
 * 该信息直接从excel文件中获取(要求第一行为列名)
 */
public class ExcelColumn {
    private String columnName;      // 列名
    private int columnIndex;     // 列序号

    public String getColumnName() {
        return columnName;
    }

    public void setColumnName(String columnName) {
        this.columnName = columnName;
    }

    public int getColumnIndex() {
        return columnIndex;
    }

    public void setColumnIndex(int columnIndex) {
        this.columnIndex = columnIndex;
    }
}
