package team.abc.ssm.modules.doc.entity;

import lombok.Data;

import java.util.Date;

@Data
public class Patent {
    private String id;

    private String patentName;

    private String remarks;

    private String createUserId;

    private String modifyUserId;

    private Date createDate;

    private Date modifyDate;

    private Byte delFlag;
}