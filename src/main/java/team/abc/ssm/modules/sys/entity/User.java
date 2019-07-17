package team.abc.ssm.modules.sys.entity;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import team.abc.ssm.common.persistence.DataEntity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Transient;
import java.util.Date;
import java.util.List;

@ToString
@EqualsAndHashCode(callSuper = true)
@Data
@Entity
@Table(name = "sys_user")
public class User extends DataEntity<User> {

    @Column(name = "user_type")
    private String userType;    // 用户类型：teacher, student, (其他随意)
    @Column(name = "sex_id")
    private String sexId;       // 性别(存储的是字典表id)
    @Column(name = "username")
    private String username;
    @Column(name = "password")
    private String password;
    @Column(name = "work_id")
    private String workId;      // 工号或学号
    @Column(name = "real_name")
    private String realName;    // 真名(中文)
    @Column(name = "nicknames")
    private String nicknames;   // 别名列表(以分号做分割)(拼音,匹配时使用)
    @Transient
    private String pinyinName;  // 真名的拼音(非数据库)
    @Column(name = "id_number")
    private String idNumber;    // 身份证号
    @Column(name = "duty")
    private String duty;
    @Column(name = "title")
    private String title;
    @Column(name = "mobile")
    private String mobile;
    @Column(name = "phone")
    private String phone;
    @Column(name = "email")
    private String email;
    @Column(name = "political_status")
    private String politicalStatus;
    @Column(name = "healthy")
    private String healthy;
    @Column(name = "birthplace")
    private String birthplace;
    @Column(name = "birthday")
    private Date birthday;
    @Column(name = "hire_date")
    private Date hireDate;
    @Column(name = "school")
    private String school; // 所属学院
    @Column(name = "major")
    private String major; // 学生专业（博士后一级学科）
    @Column(name = "tutors")
    private String tutors; // 导师们（博士生用到）
    @Column(name = "tutor_work_id")
    private String tutorWorkId; // 学生导师工号（只有学生有）
    @Column(name = "tutor_type")
    private String tutorType; // 导师类别（硕士生导师、博士生导师、博士和硕士导师）
    @Column(name = "tutor_name")
    private String tutorName; // 导师姓名
    @Column(name = "tutor_nicknames")
    private String tutorNicknames; // 导师别名列表
    @Column(name = "student_train_level")
    private String studentTrainLevel; // 学生培养层次（博士、硕士）
    @Column(name = "student_degree_type")
    private String studentDegreeType; // 学生学位类型（学术型、专业学位）
    @Column(name = "status")
    private String status; // 状态 0 - 未初始化，1 - 初始化完成

    @Transient
    private User tutor; // 学生导师的详细信息
    @Transient
    private List<Role> roleList; // 相关角色列表
}
