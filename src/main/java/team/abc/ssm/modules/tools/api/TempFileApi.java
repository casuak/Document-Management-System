package team.abc.ssm.modules.tools.api;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import team.abc.ssm.common.utils.IdGen;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;

@Controller
@RequestMapping("api/tools/tempFile")
public class TempFileApi extends BaseApi {

    @RequestMapping(value = "upload", method = RequestMethod.POST)
    @ResponseBody
    public Object upload(@RequestParam MultipartFile file, HttpServletRequest request) {
        String fileType = FilenameUtils.getExtension(file.getOriginalFilename());
        String localFileName = IdGen.uuid() + "." + fileType;
        try {
            File dir = new File(request.getSession().getServletContext().getRealPath("WEB-INF/temp"));
            if(!dir.exists()){
                dir.mkdirs();
            }
            File localFile = new File(dir, localFileName);
            FileUtils.copyInputStreamToFile(file.getInputStream(), localFile);
            return retMsg.Set(MsgType.SUCCESS, localFileName);
        } catch (IOException e) {
            e.printStackTrace();
            return retMsg.Set(MsgType.ERROR);
        }
    }

    /*下载论文模板*/
    @RequestMapping(value = "download",method = RequestMethod.GET)
    @ResponseBody
    public ResponseEntity<byte[]> download(
            HttpServletRequest request
    ) throws IOException {
        String absoluteDirectory = request.getSession().getServletContext().getRealPath("/static");
        System.out.println("abPath: "+absoluteDirectory);

        String basePath = request.getSession().getServletContext().getRealPath("");
        System.out.println("basePath: "+basePath);

        String fileName = new String("论文导入模板".getBytes("UTF-8"),"iso-8859-1");
        String fileType = "xlsx";

        File file = new File(basePath+"static\\document\\论文导入模板.xlsx");

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
        headers.setContentDispositionFormData("attachment", fileName + "." + fileType);

        return new ResponseEntity<>(FileUtils.readFileToByteArray(file), headers, HttpStatus.OK);
    }
}
