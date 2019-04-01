package team.abc.ssm.modules.tool.service;

import org.apache.commons.io.FileUtils;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import team.abc.ssm.common.utils.ExcelUtils;
import team.abc.ssm.common.utils.SystemPath;
import team.abc.ssm.modules.tool.dao.ImportExcelDao;
import team.abc.ssm.modules.tool.entity.ColumnMapField;
import team.abc.ssm.modules.tool.entity.ExcelTemplate;
import team.abc.ssm.modules.tool.entity.normal.DynamicInsertParam;
import team.abc.ssm.modules.tool.entity.normal.ExcelColumn;
import team.abc.ssm.modules.tool.entity.normal.TableField;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class ImportExcelService {

    @Autowired
    private ImportExcelDao importExcelDao;

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

    /**
     * @param excelTemplate include all info
     * @return is successful
     * @apiNote 1st: copy the file in temp dir to excelTemplate dir
     * 2nd: insert ExcelTemplate
     * 3rd: insert ColumnMapFieldList
     */
    @Transactional
    public boolean insertExcelTemplate(ExcelTemplate excelTemplate) {
        // 1st step: copy the file in temp dir to excelTemplate dir
        File srcFile = new File(SystemPath.getRootPath() + SystemPath.getTempDirPath() + excelTemplate.getExcelName());
        File targetDir = new File(SystemPath.getRootPath() + SystemPath.getExcelTemplatePath());
        try {
            FileUtils.copyFileToDirectory(srcFile, targetDir);
        } catch (IOException e) {
            e.printStackTrace();
        }
        // 2nd step: insert ExcelTemplate
        excelTemplate.preInsert();
        importExcelDao.insertExcelTemplate(excelTemplate);
        // 3rd step: insert ColumnMapFieldList
        for (ColumnMapField columnMapField : excelTemplate.getColumnMapFieldList()) {
            columnMapField.preInsert();
            columnMapField.setTemplateId(excelTemplate.getId());
        }
        if (excelTemplate.getColumnMapFieldList().size() > 0)
            importExcelDao.insertColumnMapFieldList(excelTemplate.getColumnMapFieldList());
        return true;
    }
}
