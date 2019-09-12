package team.abc.ssm.modules.author.entity;

import java.util.List;
import lombok.Data;
import team.abc.ssm.common.persistence.DataEntity;

import java.beans.IntrospectionException;

@Data
public class AuthorStatistics extends DataEntity<AuthorStatistics> {

    String realName; //姓名
    String workId; //工号
    String school;//学院
    String major;//学科

    List<String> stuList; //老师名下学生列表

    Integer tutorQ1;//导师Q1论文数量
    Integer tutorQ2;//导师Q2论文数量
    Integer tutorQ3;//导师Q3论文数量
    Integer tutorQ4;//导师Q4论文数量
    Integer tutorPaperSum;//导师论文数量

    Integer stuQ1;//学生Q1论文数量
    Integer stuQ2;//学生Q2论文数量
    Integer stuQ3;//学生Q3论文数量
    Integer stuQ4;//学生Q4论文数量
    Integer stuPaperSum;//学生论文数量

    Integer tutorPatent;//老师专利数量
    Integer stuPatent;//学生专利数量

    Integer nationFocus;//基金数量  国家重点研发计划
    Integer nsfcZDYF;//基金数量  NSFC重大研发计划
    Integer nationInstrument;//基金数量 国家重大科研仪器研制项目
    Integer nsfcKXZX;//基金数量  NSFC科学中心项目
    Integer nsfcZDAXM;//基金数量  NSFC重大项目
    Integer nsfcZDIANXM;//基金数量  NSFC重点项目
    Integer nsfcMSXM;//基金数量  NSFC面上项目
    Integer nsfcQNXM;//基金数量  NSFC青年项目
    Integer nssfcZDAXM;//基金数量  NSSFC重大项目
    Integer nssfcZDIANXM;//基金数量  NSSFC重点项目
    Integer nssfcYBXM;//基金数量  NSSFC一般项目
    Integer nssfcQNXM; //基金数量 NSSFC青年项目


    Integer fundSum;  //基金总数量
}
