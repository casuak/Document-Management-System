package team.abc.ssm.common.web;

/**
 * @ClassName FirstAuMatchType
 * @Description 第一作者匹配状态
 * @Author zm
 * @Date 2019/6/25 16:05
 * @Version 1.0
 **/
public enum  FirstAuMatchType {
    NO_MATCHED("-2","无匹配"),
    UNMATCHED("-1","未匹配"),
    MATCH_SUCCESS("0","成功"),
    MATCH_REPEATED("1","重名"),
    NO_FIRST_AUTHOR("2","无第一作者"),
    JUDGE_NEEDED("3","需人工判断");

    private String code;

    private String msg;

    FirstAuMatchType(String code, String msg) {
        this.code = code;
        this.msg = msg;
    }

    @Override
    public String toString() {
        return code;
    }
}
