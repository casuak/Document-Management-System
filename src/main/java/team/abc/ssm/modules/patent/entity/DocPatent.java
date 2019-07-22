package team.abc.ssm.modules.patent.entity;

import java.util.Date;
import java.util.List;

import lombok.Data;
import team.abc.ssm.common.persistence.DataEntity;
import team.abc.ssm.common.web.FirstAuMatchType;
import team.abc.ssm.common.web.PatentMatchType;
import team.abc.ssm.common.web.SecondAuMatchType;
import team.abc.ssm.modules.author.entity.SysUser;

import javax.persistence.Transient;

@Data
public class DocPatent extends DataEntity<DocPatent> {
    private String id;

    /**
    * 专利名
    */
    private String patentName;

    /**
    * 专利类型
    */
    private String patentType;

    /**
     * 类型值
     * */
    private String patentTypeValue;

    /**
    * 专利权人
    */
    private String patentRightPerson;

    /**
    * 专利号
    */
    private String patentNumber;

    /**
    * 专利授权公告日
    */
    private Date patentAuthorizationDate;

    /**
    * 专利授权公告日(字符串格式)
    */
    private String patentAuthorizationDateString;

    /**
    * 专利所属学院
    */
    private String institute;

    /**
    * 专利发明人列表
    */
    private String authorList;

    /**
    * 第一作者名字
    */
    private String firstAuthorName;

    /**
     * 第一作者id
     */
    private String firstAuthorId;

    /**
     * 第一作者工号
     */
    private String firstAuthorWorkId;

    /**
     * 第一作者type
     * */
    private String firstAuthorType;

    /**
    * 第二作者名字
    */
    private String secondAuthorName;

    /**
    * 第二作者id
    */
    private String secondAuthorId;

    /**
     * 第二作者工号
     */
    private String secondAuthorWorkId;

    /**
     * 第二作者type
     * */
    private String secondAuthorType;

    /**
    * 专利备注
    */
    private String remarks;

    /**
    * 创建人Id
    */
    private String createUserId;

    /**
    * 创建日期
    */
    private Date createDate;

    /**
    * 最后修改人Id
    */
    private String modifyUserId;

    /**
    * 最后修改日期
    */
    private Date modifyDate;

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
    * 是否被删除
    * 基类 DataEntity 已经覆盖该字段
    * DataEntity已经有本字段
     * private Boolean delFlag
    */


    /**
     * 保存根据firstAuthorName查询出的第一作者(列表)
     **/
    @Transient
    private List<SysUser> firstAuthorList;

    /**
     * 保存根据secondAuthorName查询出的第二作者(列表)
     **/
    @Transient
    private List<SysUser> secondAuthorList;

    /**
     * 保存专利的第一作者
     **/
    @Transient
    private SysUser firstAuthor;

    /**
     * 保存专利的第二作者
     **/
    @Transient
    private SysUser secondAuthor;

    /**
     * @author zm
     * @date 2019/6/28 15:49
     * @params [status, status1, status2]
     * @return: void
     * @Description //设置专利的3个状态
     **/
    public void setStatuses(PatentMatchType status,FirstAuMatchType status1,SecondAuMatchType status2){
        if (status != null){
            this.status = status.toString();
        }
        if(status1 != null){
            this.status1 = status1.toString();
        }
        if(status2 != null){
            this.status2 = status2.toString();
        }
    }
}