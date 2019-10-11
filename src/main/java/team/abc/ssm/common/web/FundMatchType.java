package team.abc.ssm.common.web;

public enum FundMatchType {
    UNINITIALIZED("-1", "未初始化"),
    UNMATCHED("0", "未匹配"),
    MATCH_FAILED("1", "匹配失败"),
    MATCH_SUCCEEDED("2", "匹配成功"),
    FINISHED("3", "完成");

    private String code;
    private String msg;

    FundMatchType(String code, String msg) {
        this.code = code;
        this.msg = msg;
    }

    @Override
    public String toString() {
        return code;
    }
}
