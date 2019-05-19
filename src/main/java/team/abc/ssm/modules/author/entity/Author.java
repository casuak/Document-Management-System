package team.abc.ssm.modules.author.entity;

import io.swagger.models.auth.In;
import lombok.Data;
import team.abc.ssm.common.persistence.DataEntity;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.modules.doc.entity.Copyright;
import team.abc.ssm.modules.doc.entity.Paper;
import team.abc.ssm.modules.doc.entity.Patent;
import team.abc.ssm.modules.sys.entity.Role;

import java.util.Date;
import java.util.List;

/**
 * @author zm
 * @description 作者查询返回实体
 * @data 2019/4/2
 */
@Data
public class Author extends DataEntity<Author> {
    private String id;
    /** 用户类型：teacher, student, doctor*/
    private String userType;
    /** 性别(存储的是字典表id)*/
    private String sexId;
    private String username;
    private String password;
    /** 工号或学号*/
    private String workId;
    /** 真名(中文)*/
    private String realName;
    /** 别名列表(以分号做分割)(拼音,匹配时使用)*/
    private String nicknames;
    /** 真名的拼音(非数据库)*/
    private String pinyinName;
    /** 身份证号*/
    private String idNumber;
    private String duty;
    private String title;
    private String mobile;
    private String phone;
    private String email;
    private String politicalStatus;
    private String healthy;
    private String birthplace;
    private Date birthday;
    private Date hireDate;
    /** 相关角色列表*/
    private List<Role> roleList;

    /** new add*/
    private String subjectId;
    private String subjectName;
    private String organizationId;
    private String organizationName;
    private Integer paperAmount;
    private Integer patentAmount;
    private Integer copyrightAmount;

    private Page<Paper> myPaperPage;
    private Page<Patent> myPatentPage;
    private Page<Copyright> myCopyrightPage;

    private String school;
    private String major;

}
