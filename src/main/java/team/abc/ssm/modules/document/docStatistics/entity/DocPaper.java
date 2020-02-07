package team.abc.ssm.modules.document.docStatistics.entity;

import java.util.Date;
import lombok.Data;
import team.abc.ssm.common.persistence.DataEntity;

import javax.persistence.Transient;

@Data
public class DocPaper extends DataEntity<DocPaper> {
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
    * 总体匹配状态: -1:未初始化;0:未匹配;1:匹配出错;2:匹配成功;3:匹配完成;-2:因单位不在北理被过滤
    */
    private String status;

    /**
    * 第一作者匹配状态: 0:成功;1:重名;2:无匹配
    */
    private String status1;

    /**
    * 第二作者匹配状态: 0:成功;1:重名;2:无匹配
    */
    private String status2;

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

    /**
     * 第二作者类型
     */
    private String secondAuthorType;
    private String secondAuthorCname;

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