package team.abc.ssm.modules.tool.api;

import org.apache.commons.io.FilenameUtils;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import team.abc.ssm.common.utils.FileUtils;
import team.abc.ssm.common.utils.SystemPath;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;

/**
 * uploadTempFile         上传文件到临时文件夹
 */
@Controller
@RequestMapping("api/tool/file")
public class FileApi extends BaseApi {

    /**
     * 上传文件到临时文件夹
     *
     * @return 保存在的本地的临时文件名
     */
    @RequestMapping(value = "uploadTempFile", method = RequestMethod.POST)
    @ResponseBody
    public Object uploadTempFile(@RequestParam MultipartFile file) {
        try {
            String saveName = FileUtils.saveUploadFileToTempDir(file);
            return retMsg.Set(MsgType.SUCCESS, saveName);
        } catch (IOException e) {
            e.printStackTrace();
            return retMsg.Set(MsgType.ERROR);
        }
    }

    @RequestMapping(value = "downloadExcelTemplate", method = RequestMethod.GET)
    @ResponseBody
    public ResponseEntity<byte[]> downloadExcelTemplate(
            @RequestParam("excelName") String excelName,
            @RequestParam("downloadName") String downloadName) throws UnsupportedEncodingException {
        File excelTemplate = new File(SystemPath.getRootPath() + SystemPath.getExcelTemplatePath() + excelName);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
        downloadName = new String((downloadName + "." + FilenameUtils.getExtension(excelName)).
                getBytes("UTF-8"), "iso-8859-1");
        headers.setContentDispositionFormData("attachment", downloadName);
        try {
            return new ResponseEntity<>(org.apache.commons.io.FileUtils.readFileToByteArray(excelTemplate), headers, HttpStatus.OK);
        } catch (IOException e) {
            return new ResponseEntity<>(HttpStatus.EXPECTATION_FAILED);
        }
    }
}
