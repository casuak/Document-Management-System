package team.abc.ssm.modules.tool.dao;

import team.abc.ssm.modules.tool.entity.ExcelTemplate;

import java.util.List;

public interface ExcelTemplateDao {

    int insert(ExcelTemplate excelTemplate);

    List<ExcelTemplate> selectListByPage(ExcelTemplate excelTemplate);

    int selectSearchCount(ExcelTemplate excelTemplate);

    int deleteListByIds(List<ExcelTemplate> excelTemplateList);
}
