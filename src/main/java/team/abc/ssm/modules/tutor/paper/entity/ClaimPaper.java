package team.abc.ssm.modules.tutor.paper.entity;

import lombok.Data;
import lombok.EqualsAndHashCode;
import team.abc.ssm.common.persistence.DataEntity;
import java.util.List;

@EqualsAndHashCode(callSuper = true)
@Data
public class ClaimPaper extends DataEntity<ClaimPaper> {

    /** 认领的论文wosid **/
    private String paperWosId;
    /**认领论文在doc_paper中的实体**/
    private List<TutorPaper> tutorPaper;

    /** 认领的论文w名称**/
    private String paperName;

    /** 认领老师工号 **/
    private String ownerWorkId;
    /** 认领老师姓名 **/
    private String ownerName;

    /** 一作姓名 **/
    private String firstAuthorName;
    /** 二作姓名 **/
    private String secondAuthorName;


    /** 一作工号 **/
    private String firstAuthorWorkId;
    /** 二作工号 **/
    private String secondAuthorWorkId;

    /** 一作学院 **/
    private String firstAuthorSchool;
    /** 二作学院 **/
    private String secondAuthorSchool;

    /** 一作类型 **/
    private String firstAuthorType;
    /** 而坐类型 **/
    private String secondAuthorType;

    /** 认领状态 **/
    private Integer status;
}
