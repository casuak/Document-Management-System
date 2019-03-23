package team.abc.ssm.modules.tools.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.common.utils.excel.TableColumn;
import team.abc.ssm.modules.tools.dao.DatabaseDao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DatabaseService {

    @Autowired
    private DatabaseDao databaseDao;

    public List<String> showTables() {
        return databaseDao.showTables();
    }

    public List<TableColumn> selectColumnsInTable(String tableName) {
        Map<String, Object> params = new HashMap<>();
        params.put("tableName", tableName);
        return databaseDao.selectColumnsInTable(params);
    }

    public boolean insert(Map<String, Object> params) {
        databaseDao.insert(params);
        return true;
    }

    public Map<String, String> select2ColumnInTable(TableColumn tableColumn) {
        List<Map<String, Object>> list = databaseDao.select2ColumnInTable(tableColumn);
        Map<String, String> map = new HashMap<>();
        for (int i = 0; i < list.size(); i++) {
            Map two = list.get(i);
            String originalField = (String) two.get(tableColumn.getFkOriginalField());
            String replaceField = (String) two.get(tableColumn.getFkReplaceField());
            map.put(originalField, replaceField);
        }
        return map;
    }
}
