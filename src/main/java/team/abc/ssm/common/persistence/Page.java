package team.abc.ssm.common.persistence;

import java.util.List;

/**
 * 分页类
 */
public class Page<T> {
    private int pageIndex;      // 当前页码
    private int pageSize;       // 单页容量
    private int pageStart;      // 开始于第几条记录（sql查询中用到）（没有设置值的函数）
    private String searchKey;   // 搜索关键词（模糊查询）
    private int total;          // 查询结果的总条数
    private List<T> resultList; // 结果列表
    private String orderBy;     // 排序列名

    public int getPageIndex() {
        return pageIndex;
    }

    public void setPageIndex(int pageIndex) {
        this.pageIndex = pageIndex;
    }

    public int getPageStart() {
        return (pageIndex - 1) * pageSize;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public String getSearchKey() {
        return searchKey;
    }

    public void setSearchKey(String searchKey) {
        this.searchKey = searchKey;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public List<T> getResultList() {
        return resultList;
    }

    public void setResultList(List<T> resultList) {
        this.resultList = resultList;
    }

    public String getOrderBy() {
        return orderBy;
    }

    public void setOrderBy(String orderBy) {
        this.orderBy = orderBy;
    }
}
