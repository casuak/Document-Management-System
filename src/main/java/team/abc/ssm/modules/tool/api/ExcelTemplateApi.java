package team.abc.ssm.modules.tool.api;

import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.common.utils.SystemPath;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.tool.entity.ExcelTemplate;
import team.abc.ssm.modules.tool.service.ExcelTemplateService;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.util.List;

@Controller
@RequestMapping("api/tool/excelTemplate")
public class ExcelTemplateApi extends BaseApi {

    @Autowired
    private ExcelTemplateService excelTemplateService;

    /**
     * insert or update self and columnMapField
     *
     * @param excelTemplate include all info to create a new template
     * @return is create successful
     */
    @RequestMapping(value = "insertOrUpdate", method = RequestMethod.POST)
    @ResponseBody
    public Object insertOrUpdate(@RequestBody ExcelTemplate excelTemplate) {
        if (excelTemplate.getId() == null)
            excelTemplateService.insert(excelTemplate);
        else
            excelTemplateService.update(excelTemplate);
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "updateSelf", method = RequestMethod.POST)
    @ResponseBody
    public Object updateSelf(@RequestBody ExcelTemplate excelTemplate) {
        excelTemplateService.updateSelf(excelTemplate);
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

    @RequestMapping(value = "selectAll", method = RequestMethod.POST)
    @ResponseBody
    public Object selectAll(@RequestBody ExcelTemplate conditions) {
        List<ExcelTemplate> excelTemplateList = excelTemplateService.selectAll(conditions);
        return retMsg.Set(MsgType.SUCCESS, excelTemplateList);
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

    @RequestMapping(value = "downloadExcelTemplate", method = RequestMethod.GET)
    public ResponseEntity downloadExcelTemplate(
            @RequestParam("excelName") String excelName,
            @RequestParam("downloadName") String downloadName,
            HttpServletResponse response) throws IOException {
        File excelTemplate = new File(SystemPath.getRootPath() + SystemPath.getExcelTemplatePath() + excelName);
        downloadName = new String((downloadName + "." + FilenameUtils.getExtension(excelName)).
                getBytes("UTF-8"), "iso-8859-1");
        HttpHeaders headers = new HttpHeaders();
        byte[] returnFile;
        try {
            returnFile = org.apache.commons.io.FileUtils.readFileToByteArray(excelTemplate);
        } catch (IOException e) {
            response.sendRedirect("/404");
            return new ResponseEntity(HttpStatus.NOT_FOUND);
        }
        headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
        headers.setContentDispositionFormData("attachment", downloadName);
        return new ResponseEntity<>(returnFile, headers, HttpStatus.OK);
    }
}
