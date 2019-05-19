package team.abc.ssm.modules.sys.entity;

import lombok.ToString;
import team.abc.ssm.common.persistence.DataEntity;

import java.util.Date;
import java.util.List;

@ToString
public class User extends DataEntity<User> {

    private String userType;    // 用户类型：teacher, student, (其他随意)
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
    private String school; // 所属学院
    private String major; // 学生专业（博士后一级学科）
    private String tutors; // 导师们（博士生用到）
    private String tutorWorkId; // 学生导师工号（只有学生有）
    private String tutorType; // 导师类别（硕士生导师、博士生导师、博士和硕士导师）
    private String tutorName; // 导师姓名
    private String tutorNicknames; // 导师别名列表
    private String studentTrainLevel; // 学生培养层次（博士、硕士）
    private String studentDegreeType; // 学生学位类型（学术型、专业学位）

    private User tutor; // 学生导师的详细信息
    private List<Role> roleList; // 相关角色列表

    public String getTutorNicknames() {
        return tutorNicknames;
    }

    public void setTutorNicknames(String tutorNicknames) {
        this.tutorNicknames = tutorNicknames;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public List<Role> getRoleList() {
        return roleList;
    }

    public void setRoleList(List<Role> roleList) {
        this.roleList = roleList;
    }

    public String getUserType() {
        return userType;
    }

    public void setUserType(String userType) {
        this.userType = userType;
    }

    public String getSexId() {
        return sexId;
    }

    public void setSexId(String sexId) {
        this.sexId = sexId;
    }

    public String getWorkId() {
        return workId;
    }

    public void setWorkId(String workId) {
        this.workId = workId;
    }

    public String getRealName() {
        return realName;
    }

    public void setRealName(String realName) {
        this.realName = realName;
    }

    public String getIdNumber() {
        return idNumber;
    }

    public void setIdNumber(String idNumber) {
        this.idNumber = idNumber;
    }

    public String getDuty() {
        return duty;
    }

    public void setDuty(String duty) {
        this.duty = duty;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPoliticalStatus() {
        return politicalStatus;
    }

    public void setPoliticalStatus(String politicalStatus) {
        this.politicalStatus = politicalStatus;
    }

    public String getHealthy() {
        return healthy;
    }

    public void setHealthy(String healthy) {
        this.healthy = healthy;
    }

    public String getBirthplace() {
        return birthplace;
    }

    public void setBirthplace(String birthplace) {
        this.birthplace = birthplace;
    }

    public Date getBirthday() {
        return birthday;
    }

    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }

    public Date getHireDate() {
        return hireDate;
    }

    public void setHireDate(Date hireDate) {
        this.hireDate = hireDate;
    }

    public String getNicknames() {
        return nicknames;
    }

    public void setNicknames(String nicknames) {
        this.nicknames = nicknames;
    }

    public String getPinyinName() {
        return pinyinName;
    }

    public void setPinyinName(String pinyinName) {
        this.pinyinName = pinyinName;
    }

    public String getSchool() {
        return school;
    }

    public void setSchool(String school) {
        this.school = school;
    }

    public String getMajor() {
        return major;
    }

    public void setMajor(String major) {
        this.major = major;
    }

    public String getTutorWorkId() {
        return tutorWorkId;
    }

    public void setTutorWorkId(String tutorWorkId) {
        this.tutorWorkId = tutorWorkId;
    }

    public User getTutor() {
        return tutor;
    }

    public void setTutor(User tutor) {
        this.tutor = tutor;
    }

    public String getTutors() {
        return tutors;
    }

    public void setTutors(String tutors) {
        this.tutors = tutors;
    }

    public String getTutorType() {
        return tutorType;
    }

    public void setTutorType(String tutorType) {
        this.tutorType = tutorType;
    }

    public String getStudentTrainLevel() {
        return studentTrainLevel;
    }

    public void setStudentTrainLevel(String studentTrainLevel) {
        this.studentTrainLevel = studentTrainLevel;
    }

    public String getStudentDegreeType() {
        return studentDegreeType;
    }

    public void setStudentDegreeType(String studentDegreeType) {
        this.studentDegreeType = studentDegreeType;
    }

    public String getTutorName() {
        return tutorName;
    }

    public void setTutorName(String tutorName) {
        this.tutorName = tutorName;
    }
}
