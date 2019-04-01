package team.abc.ssm.modules.tool.entity.normal;

import java.util.List;

/**
 * 用于动态插入语句的参数
 */
public class DynamicInsertParam {

    private String tableName;
    private List<String> fieldList;
    private List<List<Object>> data;

    public List<List<Object>> getData() {
        return data;
    }

    public void setData(List<List<Object>> data) {
        this.data = data;
    }

    public List<String> getFieldList() {
        return fieldList;
    }

    public void setFieldList(List<String> fieldList) {
        this.fieldList = fieldList;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }
}
