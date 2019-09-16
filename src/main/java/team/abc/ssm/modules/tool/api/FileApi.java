package team.abc.ssm.modules.tool.api;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import team.abc.ssm.common.utils.FileUtils;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;

import java.io.IOException;

/**
 * uploadTempFile         上传文件到临时文件夹
 */
@Controller
@RequestMapping("api/tool/file")
public class FileApi extends BaseApi {
    
    
       /**
            * @param file Excel模板文件
            *
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
    

}
