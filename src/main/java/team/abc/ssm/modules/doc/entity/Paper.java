package team.abc.ssm.modules.doc.entity;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import team.abc.ssm.common.persistence.DataEntity;
import team.abc.ssm.modules.sys.entity.User;

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

    private User firstAuthor;
    private User secondAuthor;

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
	* 文献类型 字典id
	*/
    private String docType;

    // 值
    private String docTypeValue;

    /**
	* 出版日期
	*/
    private Date publishDate;

    private Date _PD;
    private int _PY;

    private String danwei; // 单位名称
    private String danweiCN; // 单位中文名（只包含学院名称）

    private double impactFactor; // 所属期刊的影响因子

    /**
	* 所属期刊 from 期刊表
	*/
    @JsonProperty(value = "ISSN")
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

    @JsonProperty("ISSN")
    public String getISSN() {
        return ISSN;
    }

    public void setISSN(String ISSN) {
        this.ISSN = ISSN;
    }

    public Date get_PD() {
        return _PD;
    }

    public void set_PD(Date _PD) {
        this._PD = _PD;
    }

    public int get_PY() {
        return _PY;
    }

    public void set_PY(int _PY) {
        this._PY = _PY;
    }

    @Override
    public String toString() {
        return "Paper{" +
                "authorList='" + authorList + '\'' +
                ", firstAuthorName='" + firstAuthorName + '\'' +
                ", secondAuthorName='" + secondAuthorName + '\'' +
                ", firstAuthorId='" + firstAuthorId + '\'' +
                ", secondAuthorId='" + secondAuthorId + '\'' +
                ", status='" + status + '\'' +
                ", status1='" + status1 + '\'' +
                ", status2='" + status2 + '\'' +
                ", paperName='" + paperName + '\'' +
                ", storeNum='" + storeNum + '\'' +
                ", docType='" + docType + '\'' +
                ", publishDate=" + publishDate +
                ", _PD=" + _PD +
                ", _PY=" + _PY +
                ", ISSN='" + ISSN + '\'' +
                '}';
    }

    public String getDocTypeValue() {
        return docTypeValue;
    }

    public void setDocTypeValue(String docTypeValue) {
        this.docTypeValue = docTypeValue;
    }

    public String getDanwei() {
        return danwei;
    }

    public void setDanwei(String danwei) {
        this.danwei = danwei;
    }

    public User getFirstAuthor() {
        return firstAuthor;
    }

    public void setFirstAuthor(User firstAuthor) {
        this.firstAuthor = firstAuthor;
    }

    public User getSecondAuthor() {
        return secondAuthor;
    }

    public void setSecondAuthor(User secondAuthor) {
        this.secondAuthor = secondAuthor;
    }

    public String getDanweiCN() {
        return danweiCN;
    }

    public void setDanweiCN(String danweiCN) {
        this.danweiCN = danweiCN;
    }

    public double getImpactFactor() {
        return impactFactor;
    }

    public void setImpactFactor(double impactFactor) {
        this.impactFactor = impactFactor;
    }
}