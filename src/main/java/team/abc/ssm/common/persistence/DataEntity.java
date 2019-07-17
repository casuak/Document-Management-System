package team.abc.ssm.common.persistence;

import team.abc.ssm.common.utils.IdGen;
import team.abc.ssm.common.utils.UserUtils;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.MappedSuperclass;
import javax.persistence.Transient;
import java.util.Date;

/**
 * 所有表格的对应实体类的基类
 * 提供了基础的通用属性
 */
@MappedSuperclass
public class DataEntity<T> {

    @Id
    @Column(name = "id")
    private String id;
    @Column(name = "remarks")
    private String remarks;         // 备注
    @Column(name = "create_user_id")
    private String createUserId;    // 创建者id
    @Column(name = "modify_user_id")
    private String modifyUserId;    // 最后修改者id
    @Column(name = "create_date")
    private Date createDate;        // 创建日期
    @Column(name = "modify_date")
    private Date modifyDate;        // 最后修改日期
    @Column(name = "del_flag")
    private boolean delFlag;        // 是否被删除

    @Transient
    private Page<T> page; // 分页对象

    public DataEntity() {

    }

    /**
     * 插入之前手动调用
     */
    public void preInsert() {
        id = IdGen.uuid();
        remarks = "";
        createUserId = UserUtils.getCurrentUser().getId();
        modifyUserId = createUserId;
        createDate = new Date();
        modifyDate = createDate;
        delFlag = false;
    }

    /**
     * 更新之前手动调用
     */
    public void preUpdate() {
        modifyUserId = UserUtils.getCurrentUser().getId();
        modifyDate = new Date();
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Page<T> getPage() {
        return page;
    }

    public void setPage(Page<T> page) {
        this.page = page;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public boolean isDelFlag() {
        return delFlag;
    }

    public void setDelFlag(boolean delFlag) {
        this.delFlag = delFlag;
    }

    public String getCreateUserId() {
        return createUserId;
    }

    public void setCreateUserId(String createUserId) {
        this.createUserId = createUserId;
    }

    public String getModifyUserId() {
        return modifyUserId;
    }

    public void setModifyUserId(String modifyUserId) {
        this.modifyUserId = modifyUserId;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public Date getModifyDate() {
        return modifyDate;
    }

    public void setModifyDate(Date modifyDate) {
        this.modifyDate = modifyDate;
    }
}
