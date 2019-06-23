package team.abc.ssm.modules.patent.entity;

import java.util.Date;
import lombok.Data;

@Data
public class MapUserPatent {
    private String id;

    /**
     * 用户id
     */
    private String userId;

    /**
     * 专利 from 专利表
     */
    private String patentId;

    /**
     * 作者类型:1是第一作者，2是第二作者，3是其他作者
     */
    private Integer authorType;

    /**
     * 备注
     */
    private String remarks;

    /**
     * 创建者id
     */
    private String createUserId;

    /**
     * 最后修改者id
     */
    private String modifyUserId;

    /**
     * 创建日期
     */
    private Date createDate;

    /**
     * 最后修改日期
     */
    private Date modifyDate;

    /**
     * 是否被删除
     */
    private Boolean delFlag;
}