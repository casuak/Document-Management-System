package team.abc.ssm.modules.tool.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.tool.entity.ExcelTemplate;
import team.abc.ssm.modules.tool.service.ExcelTemplateService;

import java.util.List;

@Controller
@RequestMapping("api/tool/excelTemplate")
public class ExcelTemplateApi extends BaseApi {

    @Autowired
    private ExcelTemplateService excelTemplateService;

    /**
     * @param excelTemplate include all info to create a new template
     * @return is create successful
     */
    @RequestMapping(value = "insertOrUpdate", method = RequestMethod.POST)
    @ResponseBody
    public Object insert(@RequestBody ExcelTemplate excelTemplate) {
        if (excelTemplate.getId() == null)
            excelTemplateService.insert(excelTemplate);
        else
            excelTemplateService.update(excelTemplate);
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "selectListByPage", method = RequestMethod.POST)
    @ResponseBody
    public Object selectListByPage(@RequestBody ExcelTemplate excelTemplate) {
        Page<ExcelTemplate> page = new Page<>();
        page.setResultList(excelTemplateService.selectListByPage(excelTemplate));
        page.setTotal(excelTemplateService.selectSearchCount(excelTemplate));
        return retMsg.Set(MsgType.SUCCESS, page);
    }

    @RequestMapping(value = "deleteListByIds", method = RequestMethod.POST)
    @ResponseBody
    public Object deleteListByIds(@RequestBody List<ExcelTemplate> excelTemplateList) {
        excelTemplateService.deleteListByIds(excelTemplateList);
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "selectById", method = RequestMethod.POST)
    @ResponseBody
    public Object selectById(@RequestParam("templateId") String templateId) {
        return retMsg.Set(MsgType.SUCCESS, excelTemplateService.selectById(templateId));
    }
}
