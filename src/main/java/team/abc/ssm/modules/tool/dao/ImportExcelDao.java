package team.abc.ssm.modules.tool.dao;

import org.apache.ibatis.annotations.Param;
import team.abc.ssm.modules.tool.entity.ColumnMapField;
import team.abc.ssm.modules.tool.entity.ExcelTemplate;
import team.abc.ssm.modules.tool.entity.normal.DynamicInsertParam;
import team.abc.ssm.modules.tool.entity.normal.TableField;

import java.util.List;
import java.util.Map;

public interface ImportExcelDao {

    // 获取所有表名
    List<String> showTables();

    // 获取指定表中的所有列信息
    List<TableField> selectFieldListByTableName(@Param("tableName") String tableName);

    // 动态插入语句
    int dynamicInsert(DynamicInsertParam dynamicInsertParam);

    // 获取table中的某2列的所有行的数据(用于形成键值映射)
    // tableName(String), fkCurrentField(String), fkReplaceField(String)
    List<Map<String, Object>> selectListByTwoField(ColumnMapField columnMapField);
}
