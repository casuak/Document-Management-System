package team.abc.ssm.modules.patent.entity;

import java.util.Date;
import java.util.UUID;

import lombok.Data;

@Data
public class MapUserPatent {
    private String id;

    /**
     * 专利 from 专利表
     */
    private String patentId;

    /**
     * 作者类型
     * student
     * teacher
     * doctor
     */
    private String authorType;

    /**
     * 用户id
     */
    private String userId;

    /**
     * 作者工号
     */
    private String userWorkId;

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

    public MapUserPatent() {
        this.id = UUID.randomUUID().toString();
    }
}