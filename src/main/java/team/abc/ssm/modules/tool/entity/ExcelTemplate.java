package team.abc.ssm.modules.tool.entity;

import team.abc.ssm.common.persistence.DataEntity;
import team.abc.ssm.modules.tool.entity.normal.ExcelColumn;

import java.util.List;

/**
 * 如果映射目标表的结构发生改变
 * 最好重新制作模板
 * （因为旧模板中还保留着旧的字段信息）
 */
public class ExcelTemplate extends DataEntity<ExcelTemplate> {

    private String templateName;    // 模板名（导入方案名）
    private String tableName;       // 目标表名
    private String excelName;       // excel模板文件的名字(默认存放/WEB-INF/excelTemplate)
    private boolean enable;         // 是否启用，创建时为false，后单独修改

    // 此为临时数据，不存在表中，而是来自客户端
    private String excelDataName;   // 存放数据的excel文件的名字(默认存放在/WEB-INF/temp)

    // 多表查询
    private List<ColumnMapField> columnMapFieldList;     // excel列到table字段的映射(以field为基准)
    private List<ExcelColumn> excelColumnList;           // 模板文件中的所有列

    public String getTemplateName() {
        return templateName;
    }

    public void setTemplateName(String templateName) {
        this.templateName = templateName;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public List<ColumnMapField> getColumnMapFieldList() {
        return columnMapFieldList;
    }

    public void setColumnMapFieldList(List<ColumnMapField> columnMapFieldList) {
        this.columnMapFieldList = columnMapFieldList;
    }

    public String getExcelDataName() {
        return excelDataName;
    }

    public void setExcelDataName(String excelDataName) {
        this.excelDataName = excelDataName;
    }

    public String getExcelName() {
        return excelName;
    }

    public void setExcelName(String excelName) {
        this.excelName = excelName;
    }

    public List<ExcelColumn> getExcelColumnList() {
        return excelColumnList;
    }

    public void setExcelColumnList(List<ExcelColumn> excelColumnList) {
        this.excelColumnList = excelColumnList;
    }

    public boolean isEnable() {
        return enable;
    }

    public void setEnable(boolean enable) {
        this.enable = enable;
    }
}
