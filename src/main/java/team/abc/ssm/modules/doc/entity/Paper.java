package team.abc.ssm.modules.doc.entity;

import team.abc.ssm.common.persistence.DataEntity;

import java.util.Date;

public class Paper extends DataEntity<Paper> {
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
	* 总体匹配状态:0:未匹配;1:匹配出错;2:匹配成功;3:匹配完成
	*/
    private String status;

    /**
	* 第一作者匹配状态:0:成功;1:重名;2:无匹配
	*/
    private String status1;

    /**
	* 第二作者匹配状态:0:成功;1:重名;2:无匹配
	*/
    private String status2;

    /**
	* 论文名
	*/
    private String paperName;

    /**
	* 入藏号
	*/
    private String storeNum;

    /**
	* 文献类型
	*/
    private String docType;

    /**
	* 出版日期
	*/
    private Date publishDate;

    /**
	* 所属期刊 from 期刊表
	*/
    private String ISSN;

    public String getAuthorList() {
        return authorList;
    }

    public void setAuthorList(String authorList) {
        this.authorList = authorList;
    }

    public String getFirstAuthorName() {
        return firstAuthorName;
    }

    public void setFirstAuthorName(String firstAuthorName) {
        this.firstAuthorName = firstAuthorName;
    }

    public String getSecondAuthorName() {
        return secondAuthorName;
    }

    public void setSecondAuthorName(String secondAuthorName) {
        this.secondAuthorName = secondAuthorName;
    }

    public String getFirstAuthorId() {
        return firstAuthorId;
    }

    public void setFirstAuthorId(String firstAuthorId) {
        this.firstAuthorId = firstAuthorId;
    }

    public String getSecondAuthorId() {
        return secondAuthorId;
    }

    public void setSecondAuthorId(String secondAuthorId) {
        this.secondAuthorId = secondAuthorId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStatus1() {
        return status1;
    }

    public void setStatus1(String status1) {
        this.status1 = status1;
    }

    public String getStatus2() {
        return status2;
    }

    public void setStatus2(String status2) {
        this.status2 = status2;
    }

    public String getPaperName() {
        return paperName;
    }

    public void setPaperName(String paperName) {
        this.paperName = paperName;
    }

    public String getStoreNum() {
        return storeNum;
    }

    public void setStoreNum(String storeNum) {
        this.storeNum = storeNum;
    }

    public String getDocType() {
        return docType;
    }

    public void setDocType(String docType) {
        this.docType = docType;
    }

    public Date getPublishDate() {
        return publishDate;
    }

    public void setPublishDate(Date publishDate) {
        this.publishDate = publishDate;
    }

    public String getISSN() {
        return ISSN;
    }

    public void setISSN(String ISSN) {
        this.ISSN = ISSN;
    }
}