package team.abc.ssm.modules.author.entity;

import io.swagger.models.auth.In;
import lombok.Data;
import team.abc.ssm.common.persistence.DataEntity;
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
    private String userType;    // 用户类型：teacher, student, doctor
    private String sexId;       // 性别(存储的是字典表id)
    private String username;
    private String password;
    private String workId;      // 工号或学号
    private String realName;    // 真名(中文)
    private String nicknames;   // 别名列表(以分号做分割)(拼音,匹配时使用)
    private String pinyinName;  // 真名的拼音(非数据库)
    private String idNumber;    // 身份证号
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
    private List<Role> roleList; // 相关角色列表

    /*new add*/
    private String subjectId;
    private String subjectName;
    private String organizationId;
    private String organizationName;
    private Integer paperAmount;
    private Integer patentAmount;
    private Integer copyrightAmount;

}
