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

import java.io.File;
import java.io.IOException;

@Service
public class ExcelTemplateService {

    @Autowired
    private ExcelTemplateDao excelTemplateDao;

    @Autowired
    private ColumnMapFieldDao columnMapFieldDao;

    /**
     * @param excelTemplate include all info
     * @return is successful
     * @apiNote 1st: copy the file in temp dir to excelTemplate dir
     * 2nd: insert ExcelTemplate
     * 3rd: insert ColumnMapFieldList
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
        // 2nd step: insert ExcelTemplate
        excelTemplate.preInsert();
        excelTemplateDao.insert(excelTemplate);
        // 3rd step: insert ColumnMapFieldList
        for (ColumnMapField columnMapField : excelTemplate.getColumnMapFieldList()) {
            columnMapField.preInsert();
            columnMapField.setTemplateId(excelTemplate.getId());
        }
        if (excelTemplate.getColumnMapFieldList().size() > 0)
            columnMapFieldDao.insertList(excelTemplate.getColumnMapFieldList());
        return true;
    }
}
