package team.abc.ssm.common.utils;


public class SystemPath {

    /**
     *
     * @return 项目根路径
     */
    public static String getRootPath(){
        String root = Thread.currentThread().getContextClassLoader().getResource("").toString();
        root = root.substring(6, root.length() - 16);
        return root;
    }

    /**
     *
     * @return 临时文件存放文件夹路径
     */
    public static String getTempDirPath() {
        String root = getRootPath();
        return root + "WEB-INF/temp/";
    }
}
