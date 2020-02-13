package team.abc.ssm.modules.tutor.paper.entity;

import lombok.Data;
import team.abc.ssm.common.persistence.DataEntity;

import javax.persistence.Transient;
import java.util.Date;

@Data
public class TutorPaper extends DataEntity<TutorPaper> {
    private String id;

    /**
    * 全体作者名列表
    */
    private String authorList;

    /**
    * 第一作者名字（从列表中分割出来，再和用户表匹配）
    */
    private String firstAuthorName;

    /**
    * 第二作者名字（同上）
    */
    private String secondAuthorName;

    /**
    * 第一作者 from 用户表
    */
    private String firstAuthorId;

    /**
    * 第二作者 from 用户表
    */
    private String secondAuthorId;


    /**
    * 论文名
    */
    private String paperName;

    /**
    * 国际标准期刊号(期刊表中唯一)
    */
    private String issn;

    /**
    * 入藏号
    */
    private String storeNum;

    /**
    * 论文种类
    */
    private String docType;

    /**
    * 出版日期
    */
    private Date publishDate;

    /**
    * 从署名单位中提取出的单位别名表的中文单位名称
    */
    private String danweiCn;

    /**
    * 单位名称
    */
    private String danwei;

    /**
    * 月、日
    */
    private Date pd;

    /**
    * 年
    */
    private Integer py;

    /**
     * 1.doc_paper表中不存在字段
     * 2.在查询制定用户的所有论文List的时候使用到
     */
    @Transient
    private String theAuthorWorkId;

    /**
     * 第一作者类型
     */
    private String firstAuthorType;
    private String firstAuthorCname;
    private String firstAuthorSchool;

    /**
     * 第二作者类型
     */
    private String secondAuthorType;
    private String secondAuthorCname;
    private String secondAuthorSchool;

    /**
     * 论文所属学科
     */
    private String subject;

    /**
     * 论文分区
     */
    private String journalDivision;

    /**
     * 论文分区
     */
    private Date journalYear;

    /**
     * 影响因子
     */
    private Double impactFactor;

}