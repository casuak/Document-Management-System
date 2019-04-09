package team.abc.ssm.modules.tool.service;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.common.utils.ExcelUtils;
import team.abc.ssm.common.utils.IdGen;
import team.abc.ssm.common.utils.SystemPath;
import team.abc.ssm.common.utils.UserUtils;
import team.abc.ssm.modules.tool.dao.ColumnMapFieldDao;
import team.abc.ssm.modules.tool.dao.ExcelTemplateDao;
import team.abc.ssm.modules.tool.dao.ImportExcelDao;
import team.abc.ssm.modules.tool.entity.ColumnMapField;
import team.abc.ssm.modules.tool.entity.ExcelTemplate;
import team.abc.ssm.modules.tool.entity.normal.DynamicInsertParam;
import team.abc.ssm.modules.tool.entity.normal.ExcelColumn;
import team.abc.ssm.modules.tool.entity.normal.TableField;

import java.io.File;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class ImportExcelService {

    @Autowired
    private ImportExcelDao importExcelDao;

    @Autowired
    private ExcelTemplateService excelTemplateService;

    /**
     * @param excelName excel template file's name
     * @param isTemp    is file in temp dir (or in excelTemplate dir)
     * @return get all columns' info in template (need to be stored in first row)
     */
    public List<ExcelColumn> getExcelColumnList(String excelName, boolean isTemp) {
        Sheet sheet;
        try {
            String fullPath = SystemPath.getRootPath();
            if (isTemp)
                fullPath += SystemPath.getTempDirPath();
            else
                fullPath += SystemPath.getExcelTemplatePath();
            fullPath += excelName;
            sheet = ExcelUtils.getSheet(new File(fullPath), 0);
        } catch (IOException e) {
            return null;
        }
        Row firstRow = sheet.getRow(0);
        List<ExcelColumn> excelColumnList = new ArrayList<>();
        for (int colIndex = 0; colIndex <= firstRow.getLastCellNum(); colIndex++) {
            Cell cell = firstRow.getCell(colIndex);
            if (cell == null) continue; // 略过列名为空的项
            ExcelColumn excelColumn = new ExcelColumn();
            excelColumn.setColumnIndex(colIndex);
            excelColumn.setColumnName(cell.getStringCellValue());
            excelColumnList.add(excelColumn);
        }
        return excelColumnList;
    }

    /**
     * @param tableName table's name in database
     * @return all fields' info except 6 automatic field
     */
    public List<TableField> getTableFieldList(String tableName, boolean isAll) {
        List<TableField> tableFieldList = importExcelDao.selectFieldListByTableName(tableName);
        if (isAll)
            return tableFieldList;
        return tableFieldList.stream()
                .filter(columnMapField -> isFieldRetained(columnMapField.getFieldName()))
                .collect(Collectors.toList());
    }

    /**
     * @return is field retained
     */
    private boolean isFieldRetained(String fieldName) {
        String[] excludeColumns = new String[]{"id", "create_user_id", "create_date",
                "modify_user_id", "modify_date", "del_flag"};
        for (String s : excludeColumns) {
            if (s.equals(fieldName))
                return false;
        }
        return true;
    }

    /**
     * @return all tables'name in database
     */
    public List<String> showTables() {
        return importExcelDao.showTables();
    }

    /**
     * @param dynamicInsertParam include dynamic tableName, fieldName, data
     */
    public boolean dynamicInsert(DynamicInsertParam dynamicInsertParam) {
        try {
            importExcelDao.dynamicInsert(dynamicInsertParam);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * @param columnMapField make currentField as key, replaceField as value (the duplicated keys will be cover)
     * @return mapping list
     */
    public Map<String, String> getFieldMappingList(ColumnMapField columnMapField) {
        List<Map<String, Object>> list = importExcelDao.selectListByTwoField(columnMapField);
        Map<String, String> map = new HashMap<>();
        for (Map twoColumn : list) {
            String currentField = (String) twoColumn.get(columnMapField.getFkCurrentField());
            String replaceField = (String) twoColumn.get(columnMapField.getFkReplaceField());
            map.put(currentField, replaceField);
        }
        return map;
    }

    public boolean importExcelToTable(ExcelTemplate _excelTemplate) throws IOException {
        ExcelTemplate excelTemplate = excelTemplateService.selectById(_excelTemplate.getId());
        String tableName = excelTemplate.getTableName();
        String excelDataName = SystemPath.getRootPath() + SystemPath.getTempDirPath() +
                _excelTemplate.getExcelDataName();
        List<ColumnMapField> columnMapFieldList = excelTemplate.getColumnMapFieldList();

        DynamicInsertParam dynamicInsertParam = new DynamicInsertParam();
        // 设置插入目标表名
        dynamicInsertParam.setTableName(tableName);
        // 设置插入字段列表(前5个字段固定)
        List<String> fieldList = new ArrayList<>();
        fieldList.add("id");
        fieldList.add("create_user_id");
        fieldList.add("create_date");
        fieldList.add("modify_user_id");
        fieldList.add("modify_date");
        for (ColumnMapField columnMapField : columnMapFieldList) {
            fieldList.add(columnMapField.getFieldName());
        }
        dynamicInsertParam.setFieldList(fieldList);
        // 设置插入数据(与字段顺序一致)
        List<List<Object>> data = new ArrayList<>();
        // 1.准备额外的数据(来自于excel表格之外)
        Sheet sheet = ExcelUtils.getSheet(new File(excelDataName), 0);      // excel中的数据
        String userId = UserUtils.getCurrentUser().getId();                                     // 当前操作用户id
        Date now = new Date();                                                                  // 当前时间
        List<Map<String, Object>> mappingList = new ArrayList<>();                              // 外键：值替换
        for (ColumnMapField columnMapField : columnMapFieldList) {
            Map map = new HashMap();
            if (columnMapField.isFk()) {
                map = getFieldMappingList(columnMapField);
            }
            mappingList.add(map);
        }
        // 2.开始准备插入数据(忽略excel中的第一行)
        for (int rowIndex = 1; rowIndex <= sheet.getLastRowNum(); rowIndex++) {
            Row excelRow = sheet.getRow(rowIndex);
            List<Object> row = new ArrayList<>();
            // 前5个值固定
            row.add(IdGen.uuid());
            row.add(userId);
            row.add(now);
            row.add(userId);
            row.add(now);
            for (int i = 0; i < columnMapFieldList.size(); i++) {
                ColumnMapField columnMapField = columnMapFieldList.get(i);
                Object cellValue = null;
                if (columnMapField.isFixed()) {
                    cellValue = columnMapField.getFixedContent();
                } else if (columnMapField.isFk()) {
                    Cell cell = excelRow.getCell(columnMapField.getColumnIndex());
                    String key = cell.getStringCellValue();
                    Object value = mappingList.get(i).get(key);
                    // 如果替换的value为空，则使用key填充
                    if (value == null) value = key + "!!!外键匹配为空";
                    cellValue = value;
                } else if (columnMapField.getColumnIndex() != -1) {
                    Cell cell = excelRow.getCell(columnMapField.getColumnIndex());
                    cellValue = ExcelUtils.getCellValueByFieldType(cell, columnMapField.getFieldType());
                } else {
                    // 此时填入的为null
                }
                row.add(cellValue);
            }
            data.add(row);
        }
        dynamicInsertParam.setData(data);
        // 3.进行插入，并返回是否成功
        return importExcelDao.dynamicInsert(dynamicInsertParam) == dynamicInsertParam.getData().size();
    }
}
