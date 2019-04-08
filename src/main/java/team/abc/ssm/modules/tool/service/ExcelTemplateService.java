package team.abc.ssm.modules.tool.service;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import team.abc.ssm.common.utils.SystemPath;
import team.abc.ssm.modules.tool.dao.ColumnMapFieldDao;
import team.abc.ssm.modules.tool.dao.ExcelTemplateDao;
import team.abc.ssm.modules.tool.entity.ColumnMapField;
import team.abc.ssm.modules.tool.entity.ExcelTemplate;
import team.abc.ssm.modules.tool.entity.normal.ExcelColumn;
import team.abc.ssm.modules.tool.entity.normal.TableField;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Service
public class ExcelTemplateService {

    @Autowired
    private ExcelTemplateDao excelTemplateDao;

    @Autowired
    private ColumnMapFieldDao columnMapFieldDao;

    @Autowired
    private ImportExcelService importExcelService;

    /**
     * @param excelTemplate include all info
     * @return is successful
     * @apiNote 1st: copy the file in temp dir to excelTemplate dir
     * 2nd: insertOrUpdate ExcelTemplate
     * 3rd: insertOrUpdate ColumnMapFieldList
     */
    @Transactional
    public boolean insert(ExcelTemplate excelTemplate) {
        // 1st step: copy the file in temp dir to excelTemplate dir
        File srcFile = new File(SystemPath.getRootPath() + SystemPath.getTempDirPath() + excelTemplate.getExcelName());
        File targetDir = new File(SystemPath.getRootPath() + SystemPath.getExcelTemplatePath());
        try {
            FileUtils.copyFileToDirectory(srcFile, targetDir);
        } catch (IOException e) {
            e.printStackTrace();
        }
        // 2nd step: insertOrUpdate ExcelTemplate
        excelTemplate.preInsert();
        excelTemplateDao.insertOrUpdate(excelTemplate);
        // 3rd step: insertOrUpdate ColumnMapFieldList
        for (ColumnMapField columnMapField : excelTemplate.getColumnMapFieldList()) {
            columnMapField.preInsert();
            columnMapField.setTemplateId(excelTemplate.getId());
        }
        if (excelTemplate.getColumnMapFieldList().size() > 0)
            columnMapFieldDao.insertList(excelTemplate.getColumnMapFieldList());
        return true;
    }

    @Transactional
    public boolean update(ExcelTemplate excelTemplate) {
        // 1st step: update ExcelTemplate
        excelTemplate.preUpdate();
        excelTemplateDao.insertOrUpdate(excelTemplate);
        // 2nd step: delete and insertOrUpdate ColumnMapFieldList
        columnMapFieldDao.deleteByTemplateId(excelTemplate.getId());
        for (ColumnMapField columnMapField : excelTemplate.getColumnMapFieldList()) {
            columnMapField.preInsert();
            columnMapField.setTemplateId(excelTemplate.getId());
        }
        if (excelTemplate.getColumnMapFieldList().size() > 0)
            columnMapFieldDao.insertList(excelTemplate.getColumnMapFieldList());
        return true;
    }

    /**
     * @return the complete info of ExcelTemplate
     */
    public ExcelTemplate selectById(String id) {
        ExcelTemplate excelTemplate = excelTemplateDao.selectById(id);
        String excelName = excelTemplate.getExcelName();
        String tableName = excelTemplate.getTableName();
        List<ExcelColumn> excelColumnList = importExcelService.getExcelColumnList(excelName, false);
        List<ColumnMapField> _columnMapFieldList = columnMapFieldDao.selectByTemplateId(id);
        // add info from table field and reorder
        List<TableField> tableFieldList = importExcelService.getTableFieldList(tableName, false);
        List<ColumnMapField> columnMapFieldList = new ArrayList<>();
        for (TableField tableField : tableFieldList) {
            for (ColumnMapField columnMapField : _columnMapFieldList) {
                if (tableField.getFieldName().equals(columnMapField.getFieldName())) {
                    columnMapField.setFieldType(tableField.getFieldType());
                    columnMapField.setFieldComment(tableField.getFieldComment());
                    columnMapField.setTableName(tableName);
                    columnMapFieldList.add(columnMapField);
                    break;
                }
            }
        }
        // end
        excelTemplate.setExcelColumnList(excelColumnList);
        excelTemplate.setColumnMapFieldList(columnMapFieldList);
        return excelTemplate;
    }

    public List<ExcelTemplate> selectListByPage(ExcelTemplate excelTemplate) {
        return excelTemplateDao.selectListByPage(excelTemplate);
    }

    public int selectSearchCount(ExcelTemplate excelTemplate) {
        return excelTemplateDao.selectSearchCount(excelTemplate);
    }

    public boolean deleteListByIds(List<ExcelTemplate> excelTemplateList) {
        excelTemplateDao.deleteListByIds(excelTemplateList);
        return true;
    }
}
