package team.abc.ssm.modules.tool.entity;

import team.abc.ssm.common.persistence.DataEntity;
import team.abc.ssm.modules.tool.entity.normal.TableField;

/**
 * 可视为对tableField的拓展
 * 导入分三种情况：1、值导入。2、外值替换。3、固定值填充
 * excel中的列映射到table中的字段
 * tip(避免列映射失效):
 * 1、模板：。。。
 * 2、table：字段名和表名不可被修改
 * 3、fk：要求列中的所有值在fkFieldCurrent是唯一的，如不唯一，可用提示信息替换
 * 4、fk：目前仅支持fkFieldCurrent和fkFieldReplace均为字符串类型
 * 5、fixed：类型有varchar、int、boolean
 */
public class ColumnMapField extends DataEntity<ColumnMapField> {
    // 所属模板
    private String templateId;
    // 字段信息
    private String fieldName;       // 字段名
    // 列信息
    private String columnName;      // 列名
    private int columnIndex;        // 列序号(如果为-1代表不填入excel中数据)

    private boolean fk;             // 是否外键
    private String fkTableName;     // 外键所在表的名字
    private String fkCurrentField;  // 当前值来自的字段(要求必须为字符串类型)
    private String fkReplaceField;  // 被同一行的另一字段中的值替换
    private String fkMessage;       // 重复时的填充信息(类型根据fieldType确定)

    private boolean fixed;          // 是否固定值填充(与是否外键二者存一)
    private String fixedContent;    // 填充的固定值(类型根据fieldType确定)

    // 从所属模板中获取
    private String tableName;       // 字段所属表名
    // 从相应表中字段获取
    private String fieldComment;    // 字段注释
    private String fieldType;       // 字段类型(varchar - String)

    public ColumnMapField() {

    }

    public ColumnMapField(TableField tableField) {
        fieldName = tableField.getFieldName();
        fieldType = tableField.getFieldType();
        fieldComment = tableField.getFieldComment();
        columnIndex = -1;
        fk = false;
        fixed = false;
    }

    public String getTemplateId() {
        return templateId;
    }

    public void setTemplateId(String templateId) {
        this.templateId = templateId;
    }

    public String getFieldName() {
        return fieldName;
    }

    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }

    public String getColumnName() {
        return columnName;
    }

    public void setColumnName(String columnName) {
        this.columnName = columnName;
    }

    public boolean isFk() {
        return fk;
    }

    public void setFk(boolean fk) {
        this.fk = fk;
    }

    public String getFkTableName() {
        return fkTableName;
    }

    public void setFkTableName(String fkTableName) {
        this.fkTableName = fkTableName;
    }

    public String getFkMessage() {
        return fkMessage;
    }

    public void setFkMessage(String fkMessage) {
        this.fkMessage = fkMessage;
    }

    public boolean isFixed() {
        return fixed;
    }

    public void setFixed(boolean fixed) {
        this.fixed = fixed;
    }

    public String getFixedContent() {
        return fixedContent;
    }

    public void setFixedContent(String fixedContent) {
        this.fixedContent = fixedContent;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public String getFieldComment() {
        return fieldComment;
    }

    public void setFieldComment(String fieldComment) {
        this.fieldComment = fieldComment;
    }

    public String getFieldType() {
        return fieldType;
    }

    public void setFieldType(String fieldType) {
        this.fieldType = fieldType;
    }

    public String getFkCurrentField() {
        return fkCurrentField;
    }

    public void setFkCurrentField(String fkCurrentField) {
        this.fkCurrentField = fkCurrentField;
    }

    public String getFkReplaceField() {
        return fkReplaceField;
    }

    public void setFkReplaceField(String fkReplaceField) {
        this.fkReplaceField = fkReplaceField;
    }

    public int getColumnIndex() {
        return columnIndex;
    }

    public void setColumnIndex(int columnIndex) {
        this.columnIndex = columnIndex;
    }
}
