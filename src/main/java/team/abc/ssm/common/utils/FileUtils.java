package team.abc.ssm.common.utils;

import org.apache.commons.io.FilenameUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;

public class FileUtils {

    /**
     * 保存上传文件到临时文件夹
     * 并将名字改为随机的名字 + 原来的后缀
     *
     * @return 文件保存在服务器上的名字
     */
    public static String saveUploadFileToTempDir(MultipartFile file) throws IOException {
        String fileType = FilenameUtils.getExtension(file.getOriginalFilename());
        String saveName = IdGen.uuid() + "." + fileType;
        String savePath = SystemPath.getRootPath() + SystemPath.getTempDirPath();
        File tempDir = new File(savePath);
        if (!tempDir.exists()) {
            tempDir.mkdirs();
        }
        File localFile = new File(savePath + saveName);
        org.apache.commons.io.FileUtils.copyInputStreamToFile(file.getInputStream(), localFile);
        return saveName;
    }

    /**
     * @param originalPath include file name
     * @param targetPath not include new file name
     */
    public static void copy(String originalPath, String targetPath) {
        File file = new File(originalPath);
        File targetFile = new File(targetPath, FilenameUtils.getName(originalPath));
        try {
            InputStream is = new FileInputStream(file);
            org.apache.commons.io.FileUtils.copyInputStreamToFile(is, targetFile);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
