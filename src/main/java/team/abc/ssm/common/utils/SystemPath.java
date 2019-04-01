package team.abc.ssm.common.utils;

/**
 * 存放各种系统路径
 */
public class SystemPath {

    /**
     * @return 项目根路径
     */
    public static String getRootPath() {
        String root = Thread.currentThread().getContextClassLoader().getResource("").toString();
        return root.substring(6, root.length() - 16);
    }

    /**
     * @return 临时文件存储路径
     */
    public static String getTempDirPath() {
        return "/WEB-INF/temp/";
    }

    /**
     * @return excel导入模板存储路径
     */
    public static String getExcelTemplatePath(){
        return "/WEB-INF/excelTemplate/";
    }
}
