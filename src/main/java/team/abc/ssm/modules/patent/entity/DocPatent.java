package team.abc.ssm.modules.patent.entity;

import java.util.Date;
import lombok.Data;

@Data
public class DocPatent {
    private String id;

    /**
    * 专利名
    */
    private String patentName;

    /**
    * 专利类型
    */
    private String patentType;

    /**
     * 类型值
     * */
    private String patentTypeValue;

    /**
    * 专利权人
    */
    private String patentRightPerson;

    /**
    * 专利号
    */
    private String patentNumber;

    /**
    * 专利授权公告日
    */
    private Date patentAuthorizationDate;

    /**
    * 专利授权公告日(字符串格式)
    */
    private String patentAuthorizationDateString;

    /**
    * 专利所属学院
    */
    private String institute;

    /**
    * 专利发明人列表
    */
    private String authorList;

    /**
    * 第一作者名字
    */
    private String firstAuthorName;

    /**
     * 第一作者id
     */
    private String firstAuthorId;

    /**
     * 第一作者type
     * */
    private String firstAuthorType;

    /**
    * 第二作者名字
    */
    private String secondAuthorName;

    /**
    * 第二作者id
    */
    private String secondAuthorId;

    /**
     * 第二作者type
     * */
    private String secondAuthorType;

    /**
    * 专利备注
    */
    private String remarks;

    /**
    * 创建人Id
    */
    private String createUserId;

    /**
    * 创建日期
    */
    private Date createDate;

    /**
    * 最后修改人Id
    */
    private String modifyUserId;

    /**
    * 最后修改日期
    */
    private Date modifyDate;

    /**
    * 总体匹配状态: -1:未初始化;0:未匹配;1:匹配出错;2:匹配成功;3:匹配完成;-2:因单位不在北理被过滤
    */
    private String status;

    /**
    * 第一作者匹配状态: 0:成功;1:重名;2:无匹配
    */
    private String status1;

    /**
    * 第二作者匹配状态: 0:成功;1:重名;2:无匹配
    */
    private String status2;

    /**
    * 是否被删除
    */
    private Byte delFlag;
}