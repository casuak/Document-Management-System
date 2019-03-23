package team.abc.ssm.modules.tools.dao;

import team.abc.ssm.common.utils.excel.TableColumn;

import java.util.List;
import java.util.Map;

public interface DatabaseDao {

    List<String> showTables();

    List<TableColumn> selectColumnsInTable(Map params);

    int insert(Map<String, Object> params);

    List<Map<String, Object>> select2ColumnInTable(TableColumn tableColumn);
}
