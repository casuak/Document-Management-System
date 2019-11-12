package team.abc.ssm.modules.author.entity;

import java.util.List;
import lombok.Data;
import team.abc.ssm.common.persistence.DataEntity;
import team.abc.ssm.modules.sys.entity.User;

import java.beans.IntrospectionException;

@Data
public class AuthorStatistics extends DataEntity<AuthorStatistics> {

    String realName; //姓名
    String workId; //工号
    String school;//学院
    String major;//学科
    String type; //博导 硕导
    Integer isMaster; //是否为硕导
    Integer isDoctor; //是否为博导

    List<String> stuList; //老师名下学生列表

    Integer tutorQ1;//导师Q1论文数量
    Integer tutorQ2;//导师Q2论文数量
    Integer tutorQ3;//导师Q3论文数量
    Integer tutorQ4;//导师Q4论文数量
    Integer tutorOther;//导师其他论文数量
    double tutorAverage;//导师论文人均
    Integer tutorPaperSum;//导师论文数量

    Integer stuQ1;//学生Q1论文数量
    Integer stuQ2;//学生Q2论文数量
    Integer stuQ3;//学生Q3论文数量
    Integer stuQ4;//学生Q4论文数量
    Integer stuOther;//学生其他论文数量
    double stuAverage;//学生论文人均
    Integer stuPaperSum;//学生论文数量

    Integer tutorPatent;//老师专利数量
    double  tutorPatentAverage;//老师专利人均
    Integer stuPatent;//学生专利数量
    double stuPatentAverage;//学生专利人均

    Integer nationFocus;//基金数量  国家重点研发计划
    Integer nsfcZDYF;//基金数量  NSFC重大研发计划
    Integer nationInstrument;//基金数量 国家重大科研仪器研制项目
    Integer nsfcKXZX;//基金数量  NSFC科学中心项目
    Integer nsfcZDAXM;//基金数量  NSFC重大项目
    Integer nationResearch;//基金数量 国际（地区）合作研究与交流项目
    Integer nsfcZDIANXM;//基金数量  NSFC重点项目
    Integer nsfcMSXM;//基金数量  NSFC面上项目
    Integer nsfcQNXM;//基金数量  NSFC青年项目
    Integer nssfcZDAXM;//基金数量  NSSFC重大项目
    Integer nssfcZDIANXM;//基金数量  NSSFC重点项目
    Integer nssfcYBXM;//基金数量  NSSFC一般项目
    Integer nssfcQNXM; //基金数量 NSSFC青年项目


    Integer fundSum;  //基金总数量

    Integer totalNum; //符合条件人的数量
    Integer startYear;//查询起始时间
    Integer endYear;//查询结束时间

    public AuthorStatistics(User user){
        this.setRealName(user.getRealName());
        this.setWorkId(user.getWorkId());
        this.setMajor(user.getMajor());
        this.setSchool(user.getSchool());
        this.setType(user.getTutorType());
        this.setIsDoctor(user.getIsDoctor());
        this.setIsMaster(user.getIsDoctor());

        this.setTutorQ1(0);
        this.setTutorQ2(0);
        this.setTutorQ3(0);
        this.setTutorQ4(0);
        this.setTutorOther(0);
        this.setTutorPaperSum(0);
        this.setTutorAverage(0);

        this.setStuQ1(0);
        this.setStuQ2(0);
        this.setStuQ3(0);
        this.setStuQ4(0);
        this.setStuOther(0);
        this.setStuAverage(0);
        this.setStuPaperSum(0);

        this.setStuPatent(0);
        this.setStuPatentAverage(0);
        this.setTutorPatent(0);
        this.setTutorPatentAverage(0);

        this.setFundSum(0);
        this.setNationInstrument(0);
        this.setNationFocus(0);
        this.setNationResearch(0);
        this.setNsfcQNXM(0);
        this.setNsfcMSXM(0);
        this.setNsfcZDIANXM(0);
        this.setNsfcZDAXM(0);
        this.setNsfcKXZX(0);
        this.setNsfcZDYF(0);
        this.setNssfcZDIANXM(0);
        this.setNssfcQNXM(0);
        this.setNssfcZDAXM(0);
        this.setNssfcYBXM(0);
    }

    public  AuthorStatistics(){}
}
