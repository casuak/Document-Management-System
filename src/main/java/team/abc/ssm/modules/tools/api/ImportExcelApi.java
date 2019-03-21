package team.abc.ssm.modules.tools.api;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import team.abc.ssm.common.utils.IdGen;
import team.abc.ssm.common.utils.excel.ExcelColumn;
import team.abc.ssm.common.utils.excel.ExcelToTable;
import team.abc.ssm.common.utils.excel.ExcelUtils;
import team.abc.ssm.common.utils.excel.TableColumn;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.tools.service.DatabaseService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
        for (int colIndex = 0; colIndex < firstRow.getLastCellNum(); colIndex++) {
            Cell cell = firstRow.getCell(colIndex);
            if (cell == null) continue;
            ExcelColumn col = new ExcelColumn();
            col.setColIndex(colIndex);
            col.setName(cell.getStringCellValue());
            excelColumnList.add(col);
        }
        Map<String, Object> result = new HashMap<>();
        List<TableColumn> tableColumnList = databaseService.getTableColumns(tableName);
        tableColumnList = tableColumnList.subList(0, tableColumnList.size() - 7); // 去掉后面7个属性
        result.put("excelColumnList", excelColumnList);
        result.put("tableColumnList", tableColumnList);
        return retMsg.Set(MsgType.SUCCESS, result);
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
        for (int i = 0; i < tableColumnList.size(); i++) {
            TableColumn tableColumn = tableColumnList.get(i);
            if (tableColumn.getExcelColumnIndex() == -1) continue;
            columnList.add(tableColumn.getName());
        }
        params.put("columnList", columnList);
        Sheet sheet = ExcelUtils.getSheet(excelName, 0);
        List<List<Object>> data = new ArrayList<>();
        for (int rowIndex = 1; rowIndex < sheet.getLastRowNum(); rowIndex++) {
            List<Object> row = new ArrayList<>();
            row.add(IdGen.uuid());
            Row excelRow = sheet.getRow(rowIndex);
            for (int i = 0; i < tableColumnList.size(); i++) {
                TableColumn tableColumn = tableColumnList.get(i);
                if (tableColumn.getExcelColumnIndex() == -1) continue;
                Cell cell = excelRow.getCell(tableColumn.getExcelColumnIndex());
                if (tableColumn.getType().equals("varchar")) {
                    row.add(cell.getStringCellValue());
                } else if (tableColumn.getType().equals("int")) {
                    row.add((int) cell.getNumericCellValue());
                } else if (tableColumn.getType().equals("datetime")) {
                    row.add(cell.getDateCellValue());
                }
            }
            data.add(row);
        }
        params.put("data", data);
        databaseService.insert(params);
        return retMsg.Set(MsgType.SUCCESS, params);
    }
}
