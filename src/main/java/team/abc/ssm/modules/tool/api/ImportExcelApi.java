package team.abc.ssm.modules.tool.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.tool.entity.ColumnMapField;
import team.abc.ssm.modules.tool.entity.ExcelTemplate;
import team.abc.ssm.modules.tool.entity.normal.ExcelColumn;
import team.abc.ssm.modules.tool.entity.normal.TableField;
import team.abc.ssm.modules.tool.service.ImportExcelService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * showTables                       获取所有表名列表
 * getFieldsInfo                    获取指定表中所有字段的信息
 * getColumnsInTableAndExcel        获取table和excel中的所有列信息
 */
@Controller
@RequestMapping("api/tool/importExcel")
public class ImportExcelApi extends BaseApi {

    @Autowired
    private ImportExcelService importExcelService;

    /**
     * @return all tables' name in current database
     */
    @RequestMapping(value = "showTables", method = RequestMethod.POST)
    @ResponseBody
    public Object showTables() {
        List<String> tableList = importExcelService.showTables();
        return retMsg.Set(MsgType.SUCCESS, tableList);
    }

    /**
     * @param tableName table name in database
     * @param excelName excel name in dir
     * @return table's field list (except for 6 automatic field) and excel's column list
     */
    @RequestMapping(value = "getColumnsInTableAndExcel", method = RequestMethod.POST)
    @ResponseBody
    public Object getColumnsInTableAndExcel(
            @RequestParam("tableName") String tableName,
            @RequestParam("excelName") String excelName
    ) {
        List<ExcelColumn> excelColumnList = importExcelService.getExcelColumnList(excelName, true);
        List<TableField> tableFieldList = importExcelService.getTableFieldList(tableName, false);
        // convert TableField to ColumnMapField, simplify the later work
        List<ColumnMapField> columnMapFieldList = new ArrayList<>();
        for (TableField tableField : tableFieldList) {
            columnMapFieldList.add(new ColumnMapField(tableField));
        }
        Map<String, Object> data = new HashMap<>();
        data.put("excelColumnList", excelColumnList);
        data.put("columnMapFieldList", columnMapFieldList);
        return retMsg.Set(MsgType.SUCCESS, data);
    }

    /**
     * @param tableName target table
     * @return all fields' info in table
     */
    @RequestMapping(value = "getAllColumnsInTable", method = RequestMethod.POST)
    @ResponseBody
    public Object getColumnsInTable(@RequestParam("tableName") String tableName) {
        return retMsg.Set(MsgType.SUCCESS, importExcelService.getTableFieldList(tableName, true));
    }

    /**
     * @param excelTemplate include all info to create a new template
     * @return is create successful
     */
    @RequestMapping(value = "insertExcelTemplate", method = RequestMethod.POST)
    @ResponseBody
    public Object insertExcelTemplate(@RequestBody ExcelTemplate excelTemplate) {
        importExcelService.insertExcelTemplate(excelTemplate);
        return retMsg.Set(MsgType.SUCCESS);
    }
}
