package team.abc.ssm.common.web;

/**
 * @ClassName PatentMatchType
 * @Description 专利匹配状态枚举类
 * @Author zm
 * @Date 2019/6/25 15:50
 * @Version 1.0
 **/
public enum PatentMatchType {
    IMPORT_REPEAT("-4", "重复专利导入"),
    AUTHOR_MISSED("-3", "作者信息缺失"),
    FILTRATED("-2", "单位不在北理被过滤"),
    UNINITIALIZED("-1", "未初始化"),
    UNMATCHED("0", "未匹配(已初始化)"),
    MATCH_ERROR("1", "匹配出错"),
    MATCH_SUCCESS("2", "匹配成功"),
    JUDGE_NEEDED("3", "需要人工判断"),
    MATCH_FINISHED("4", "匹配完成");

    private String code;

    private String msg;

    PatentMatchType(String code, String msg) {
        this.code = code;
        this.msg = msg;
    }

    @Override
    public String toString() {
        return code;
    }
}
