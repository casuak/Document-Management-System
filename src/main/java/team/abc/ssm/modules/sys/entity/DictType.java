package team.abc.ssm.modules.sys.entity;

import team.abc.ssm.common.persistence.DataEntity;

public class DictType extends DataEntity<DictType> {

    private String parentId;
    private String nameCn;
    private String nameEn;
    private int sort;

    // 关联查询
    private String parentNameCn;
    private String parentNameEn;

    public String getParentId() {
        return parentId;
    }

    public void setParentId(String parentId) {
        this.parentId = parentId;
    }

    public String getNameEn() {
        return nameEn;
    }

    public void setNameEn(String nameEn) {
        this.nameEn = nameEn;
    }

    public String getNameCn() {
        return nameCn;
    }

    public void setNameCn(String nameCn) {
        this.nameCn = nameCn;
    }

    public String getParentNameEn() {
        return parentNameEn;
    }

    public void setParentNameEn(String parentNameEn) {
        this.parentNameEn = parentNameEn;
    }

    public String getParentNameCn() {
        return parentNameCn;
    }

    public void setParentNameCn(String parentNameCn) {
        this.parentNameCn = parentNameCn;
    }

    public int getSort() {
        return sort;
    }

    public void setSort(int sort) {
        this.sort = sort;
    }
}
