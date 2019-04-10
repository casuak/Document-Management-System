package team.abc.ssm.modules.tool.dao;

import team.abc.ssm.modules.tool.entity.ExcelTemplate;

import java.util.List;

public interface ExcelTemplateDao {

    int insertOrUpdate(ExcelTemplate excelTemplate);

    ExcelTemplate selectById(String id);

    List<ExcelTemplate> selectListByPage(ExcelTemplate excelTemplate);

    int selectSearchCount(ExcelTemplate excelTemplate);

    int deleteListByIds(List<ExcelTemplate> excelTemplateList);

    List<ExcelTemplate> selectAll(ExcelTemplate condition);
}
