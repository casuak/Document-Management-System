package team.abc.ssm.modules.author.entity;

import java.util.Date;
import lombok.Data;

@Data
public class SysUser {
    private String id;

    /**
    * 用户类型:用于区分学生(student)、导师(teacher)、博士后(doctor)
    */
    private String userType;

    /**
    * 用户名
    */
    private String username;

    /**
    * 密码
    */
    private String password;

    /**
    * 真名
    */
    private String realName;

    /**
    * 别名列表，以分号做分割
    */
    private String nicknames;

    /**
    * 工号/学号
    */
    private String workId;

    /**
    * 性别 from 字典表
    */
    private String sexId;

    /**
    * 所属学院
    */
    private String school;

    /**
    * 学生所属专业
    */
    private String major;

    /**
    * 学生导师的职工号（目前学生导师唯一）
    */
    private String tutorWorkId;

    /**
    * 博士后合作导师（可能有多个）
    */
    private String tutors;

    /**
    * 入职/入学日期
    */
    private Date hireDate;

    /**
    * 教师职称
    */
    private String title;

    /**
    * 职务
    */
    private String duty;

    /**
    * 手机号
    */
    private String mobile;

    /**
    * 座机
    */
    private String phone;

    /**
    * 邮箱
    */
    private String email;

    /**
    * 政治面貌
    */
    private String politicalStatus;

    /**
    * 健康状况
    */
    private String healthy;

    /**
    * 出生地
    */
    private String birthplace;

    /**
    * 出生日期
    */
    private Date birthday;

    /**
    * 身份证号
    */
    private String idNumber;

    /**
    * 备注
    */
    private String remarks;

    /**
    * 创建者id
    */
    private String createUserId;

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

    /**
    * 最后修改者id
    */
    private String modifyUserId;

    /**
    * 导师类别（硕士生导师、博士生导师、博士和硕士导师）
    */
    private String tutorType;

    /**
    * 学生培养层次（博士、硕士）
    */
    private String studentTrainLevel;

    /**
    * 学生学位类型（学术型、专业学位）
    */
    private String studentDegreeType;
}