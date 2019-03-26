package team.abc.ssm.modules.tools.api;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import team.abc.ssm.common.utils.IdGen;
import team.abc.ssm.common.utils.UserUtils;
import team.abc.ssm.common.utils.excel.ExcelColumn;
import team.abc.ssm.common.utils.excel.ExcelToTable;
import team.abc.ssm.common.utils.excel.ExcelUtils;
import team.abc.ssm.common.utils.excel.TableColumn;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.tools.service.DatabaseService;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping("api/tools/importExcel")
public class ImportExcelApi extends BaseApi {

    @Autowired
    private DatabaseService databaseService;

    @RequestMapping(value = "getColumnsInTableAndExcel", method = RequestMethod.POST)
    @ResponseBody
    public Object getColumnsInTableAndExcel(
            @RequestParam("tableName") String tableName,
            @RequestParam("excelFileName") String excelFileName) throws IOException {
        // 只取第一个sheet
        Sheet sheet = ExcelUtils.getSheet(excelFileName, 0);
        Row firstRow = sheet.getRow(0);
        List<ExcelColumn> excelColumnList = new ArrayList<>();
        for (int colIndex = 0; colIndex <= firstRow.getLastCellNum(); colIndex++) {
            Cell cell = firstRow.getCell(colIndex);
            if (cell == null) continue;
            ExcelColumn col = new ExcelColumn();
            col.setColIndex(colIndex);
            col.setName(cell.getStringCellValue());
            excelColumnList.add(col);
        }
        Map<String, Object> result = new HashMap<>();
        List<TableColumn> _tableColumnList = databaseService.selectColumnsInTable(tableName);
        // delete 7 properties whose name in (id, remarks, create_user_id, create_date,
        // modify_user_id, modify_date, del_flag)
        List<TableColumn> tableColumnList = new ArrayList<>();
        for (TableColumn tableColumn : _tableColumnList) {
            if (isColumnUseful(tableColumn.getName()))
                tableColumnList.add(tableColumn);
        }
        result.put("excelColumnList", excelColumnList);
        result.put("tableColumnList", tableColumnList);
        return retMsg.Set(MsgType.SUCCESS, result);
    }

    private boolean isColumnUseful(String columnName) {
        String[] excludeColumns = new String[]{"id", "remarks", "create_user_id", "create_date", "modify_user_id", "modify_date", "del_flag"};
        for (String s : excludeColumns) {
            if (s.equals(columnName))
                return false;
        }
        return true;
    }

    @RequestMapping(value = "excelToTable", method = RequestMethod.POST)
    @ResponseBody
    public Object excelToTable(@RequestBody ExcelToTable excelToTable) throws IOException {
        String excelName = excelToTable.getExcelName();
        String tableName = excelToTable.getTableName();
        List<TableColumn> tableColumnList = excelToTable.getTableColumnList();
        Map<String, Object> params = new HashMap<>();
        params.put("tableName", tableName);
        List<String> columnList = new ArrayList<>();
        columnList.add("id");
        columnList.add("create_user_id");
        columnList.add("create_date");
        columnList.add("modify_user_id");
        columnList.add("modify_date");
        for (TableColumn tableColumn : tableColumnList) {
            if (tableColumn.getExcelColumnIndex() == -1) continue;
            columnList.add(tableColumn.getName());
        }
        params.put("columnList", columnList);
        Sheet sheet = ExcelUtils.getSheet(excelName, 0);
        List<List<Object>> data = new ArrayList<>();
        // 初始化mappingList（外键映射）
        List<Map<String, String>> mappingList = new ArrayList<>();
        for (TableColumn tableColumn : tableColumnList) {
            Map<String, String> map;
            if (!tableColumn.isFk()) {
                map = new HashMap<>();
            } else {
                map = databaseService.select2ColumnInTable(tableColumn);
            }
            mappingList.add(map);
        }
        String userId = UserUtils.getCurrentUser().getId();
        Date now = new Date();
        for (int rowIndex = 1; rowIndex <= sheet.getLastRowNum(); rowIndex++) {
            List<Object> row = new ArrayList<>();
            row.add(IdGen.uuid());
            row.add(userId);
            row.add(now);
            row.add(userId);
            row.add(now);
            Row excelRow = sheet.getRow(rowIndex);
            for (int i = 0; i < tableColumnList.size(); i++) {
                TableColumn tableColumn = tableColumnList.get(i);
                if (tableColumn.getExcelColumnIndex() == -1) continue;
                Cell cell = excelRow.getCell(tableColumn.getExcelColumnIndex());
                switch (tableColumn.getType()) {
                    case "varchar":
                        if (cell.getCellType() != Cell.CELL_TYPE_STRING) {
                            row.add(null);
                            break;
                        }
                        if (tableColumn.isFk()) { // 外键替换
                            String key = cell.getStringCellValue();
                            String value = mappingList.get(i).get(key);
                            if (value == null) value = key;
                            row.add(value);
                        } else {
                            row.add(cell.getStringCellValue());
                        }
                        break;
                    case "int":
                        if (cell.getCellType() != Cell.CELL_TYPE_NUMERIC)
                            row.add((int) cell.getNumericCellValue());
                        break;
                    case "datetime":
                        int type = cell.getCellType();
                        if (type == XSSFCell.CELL_TYPE_NUMERIC) {
                            double value = cell.getNumericCellValue();
                            Date date = DateUtil.getJavaDate(value);
                            row.add(date);
                        } else if (type == XSSFCell.CELL_TYPE_STRING) {
                            try {
                                double value = DateUtil.convertTime(cell.getStringCellValue());
                                Date date = DateUtil.getJavaDate(value);
                                row.add(date);
                            } catch (IllegalArgumentException e) {
                                row.add(null);
                            }
                        }
                        break;
                }
            }
            data.add(row);
        }
        params.put("data", data);
        databaseService.insert(params);
        return retMsg.Set(MsgType.SUCCESS, params);
    }
}
