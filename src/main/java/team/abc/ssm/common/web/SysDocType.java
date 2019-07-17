package team.abc.ssm.common.web;

/**
 * @ClassName DocType
 * @Description 文献类型
 * @Author zm
 * @Date 2019/7/16 18:47
 * @Version 1.0
 **/
public enum SysDocType {
    PAPER("paper"),
    PATENT("patent");

    private String value;

    SysDocType(String value) {
        this.value = value;
    }

    @Override
    public String toString() {
        return value;
    }
}
