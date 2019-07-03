package team.abc.ssm.common.web;

/**
 * @ClassName SecondAuMatchType
 * @Description 第二作者匹配状态
 * @Author zm
 * @Date 2019/6/25 16:05
 * @Version 1.0
 **/
public enum  SecondAuMatchType {
    NO_MATCHED("-2","无匹配"),
    UNMATCHED("-1","未匹配"),
    MATCH_SUCCESS("0","成功"),
    MATCH_REPEATED("1","重名"),
    ONLY_FIRST_AUTHOR("2","无第二作者，只有一个作者"),
    JUDGE_NEEDED("3","需人工判断");

    private String code;

    private String msg;

    SecondAuMatchType(String code, String msg) {
        this.code = code;
        this.msg = msg;
    }

    @Override
    public String toString() {
        return code;
    }
}
